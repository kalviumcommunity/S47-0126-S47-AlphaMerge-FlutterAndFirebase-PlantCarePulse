# Firebase Storage Upload Flow - PlantCarePulse

## 📋 Project Overview

This implementation demonstrates Firebase Storage integration in the PlantCarePulse app, enabling users to upload, display, and manage images. This feature is essential for allowing users to capture and store photos of their plants, track growth progress, and share plant care activities.

---

## 🎯 Features Implemented

### 1. **Firebase Storage Service**
- Centralized service for all storage operations
- Image picker integration (gallery & camera)
- Upload with progress tracking
- Download URL retrieval
- File deletion capabilities
- Organized folder structure

### 2. **Image Upload Flow**
- Select images from gallery or camera
- Real-time upload progress indicator
- Automatic file naming with timestamps
- Metadata attachment
- Error handling and user feedback

### 3. **Storage Demo Screen**
- Interactive UI for testing uploads
- Image preview before upload
- Multiple upload options (general & profile picture)
- Display uploaded images from URLs
- Delete functionality

---

## 🔧 Dependencies Added

```yaml
dependencies:
  firebase_storage: ^13.0.6  # Firebase Storage SDK
  image_picker: ^1.0.0       # Image selection from gallery/camera
```

---

## 📁 File Structure

```
lib/
├── services/
│   └── firebase_storage_service.dart    # Storage operations service
└── screens/
    └── storage_demo_screen.dart         # Demo UI for testing uploads
```

---

## 💻 Code Implementation

### 1. Firebase Storage Service

The `FirebaseStorageService` provides a clean API for all storage operations:

```dart
class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<XFile?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    return image;
  }

  // Upload image to Firebase Storage
  Future<String> uploadImage({
    required File file,
    required String folder,
    String? fileName,
  }) async {
    final String uploadFileName = fileName ?? 
        '${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    final Reference storageRef = _storage.ref().child('$folder/$uploadFileName');
    
    final SettableMetadata metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {
        'uploadedAt': DateTime.now().toIso8601String(),
      },
    );
    
    final UploadTask uploadTask = storageRef.putFile(file, metadata);
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadURL = await snapshot.ref.getDownloadURL();
    
    return downloadURL;
  }
}
```

### 2. Image Picker Integration

```dart
// Show source selection dialog
Future<void> _showImageSourceDialog() async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      );
    },
  );
}

// Pick and display image
Future<void> _pickImage(ImageSource source) async {
  final XFile? pickedFile = await _storageService.pickImage(source: source);
  
  if (pickedFile != null) {
    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }
}
```

### 3. Upload with Progress Tracking

```dart
Future<void> _uploadImage() async {
  final uploadStream = _storageService.uploadWithProgress(
    file: _selectedImage!,
    folder: 'users/${_currentUser!.uid}/demo',
  );

  await for (var snapshot in uploadStream) {
    setState(() {
      _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
    });

    if (snapshot.state == TaskState.success) {
      final downloadURL = await snapshot.ref.getDownloadURL();
      setState(() {
        _uploadedImageURL = downloadURL;
      });
    }
  }
}
```

### 4. Display Uploaded Images

```dart
Image.network(
  _uploadedImageURL!,
  height: 200,
  width: double.infinity,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return CircularProgressIndicator(
      value: loadingProgress.expectedTotalBytes != null
          ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
          : null,
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.error, size: 50, color: Colors.red);
  },
)
```

### 5. Delete Files

```dart
Future<void> _deleteImage() async {
  await _storageService.deleteFileByURL(_uploadedImageURL!);
  setState(() {
    _uploadedImageURL = null;
  });
}
```

---

## 🗂️ Storage Organization

Files are organized in a hierarchical structure:

```
storage/
├── users/
│   └── {userId}/
│       ├── profile/
│       │   └── profile_picture.jpg
│       ├── plants/
│       │   └── {plantId}/
│       │       ├── {timestamp1}.jpg
│       │       ├── {timestamp2}.jpg
│       │       └── activities/
│       │           ├── {timestamp1}.jpg
│       │           └── {timestamp2}.jpg
│       └── demo/
│           └── {timestamp}.jpg
```

---

## 🔒 Security Rules

Configure Firebase Storage security rules in the Firebase Console:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can only access their own files
    match /users/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Validate file types and sizes
    match /users/{userId}/profile/profile_picture.jpg {
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024  // 5MB limit
                   && request.resource.contentType.matches('image/.*');
    }
  }
}
```

---

## 🚀 How to Use

### 1. Install Dependencies

```bash
cd PlantCarePulse
flutter pub get
```

### 2. Run the App

```bash
flutter run
```

### 3. Test the Upload Flow

1. Login to the app
2. Navigate to Home screen
3. Tap "Firebase Storage Upload Demo" button
4. Select "Select Image" button
5. Choose Gallery or Camera
6. Select/capture an image
7. Tap "Upload to Storage" or "Upload as Profile Picture"
8. View the uploaded image with its download URL
9. Test deletion by tapping the delete icon

---

## 📸 Screenshots

### Storage Demo Screen
![Storage Demo](docs/screenshots/storage-demo.png)

### Image Selection
![Image Selection](docs/screenshots/image-picker.png)

### Upload Progress
![Upload Progress](docs/screenshots/upload-progress.png)

### Firebase Console
![Firebase Console](docs/screenshots/firebase-storage-console.png)

---

## 🎓 Use Cases in PlantCarePulse

### 1. **User Profile Pictures**
```dart
final downloadURL = await _storageService.uploadUserProfilePicture(
  userId: currentUser.uid,
  file: selectedImage,
);
// Store URL in Firestore user document
await FirestoreService().updateUserProfile(currentUser.uid, {
  'profilePictureUrl': downloadURL,
});
```

### 2. **Plant Photos**
```dart
final downloadURL = await _storageService.uploadPlantImage(
  userId: currentUser.uid,
  plantId: plant.id,
  file: plantPhoto,
);
// Store URL in Firestore plant document
```

### 3. **Care Activity Images**
```dart
final downloadURL = await _storageService.uploadCareActivityImage(
  userId: currentUser.uid,
  plantId: plant.id,
  file: activityPhoto,
);
// Attach to care activity document
```

---

## 🔍 Key Features

### Image Optimization
- **Max dimensions**: 1920x1080 pixels
- **Quality**: 85% compression
- **Format**: JPEG for smaller file sizes

### Progress Tracking
- Real-time upload progress
- Visual progress bar
- Percentage display

### Error Handling
- Network error handling
- Permission error handling
- File size validation
- User-friendly error messages

### Metadata
- Upload timestamp
- Content type
- Custom metadata support

---

## 🐛 Common Issues & Solutions

### Issue 1: Permission Denied
**Solution**: Ensure user is authenticated and security rules allow access

### Issue 2: Image Not Displaying
**Solution**: Check download URL is valid and network connection is stable

### Issue 3: Upload Fails
**Solution**: Verify file size is within limits and format is supported

### Issue 4: Camera Not Working
**Solution**: Add camera permissions to AndroidManifest.xml and Info.plist

---

## 📱 Platform-Specific Configuration

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS (ios/Runner/Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take plant photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select plant images</string>
```

---

## 💡 Best Practices

1. **Always compress images** before upload to save bandwidth and storage costs
2. **Use unique filenames** (timestamps) to avoid conflicts
3. **Implement proper error handling** for better user experience
4. **Show upload progress** for large files
5. **Validate file types and sizes** before upload
6. **Delete old files** when updating to manage storage costs
7. **Use appropriate folder structure** for organization
8. **Cache download URLs** in Firestore for faster access

---

## 🎯 Future Enhancements

- [ ] Multiple image upload at once
- [ ] Image cropping before upload
- [ ] Thumbnail generation
- [ ] Offline upload queue
- [ ] Image filters and editing
- [ ] Video upload support
- [ ] Cloud Functions for image processing
- [ ] CDN integration for faster delivery

---

## 📚 Resources

- [Firebase Storage Documentation](https://firebase.google.com/docs/storage)
- [Image Picker Plugin](https://pub.dev/packages/image_picker)
- [Flutter File Upload Guide](https://flutter.dev/docs/cookbook/networking/upload-file)
- [Firebase Storage Security Rules](https://firebase.google.com/docs/storage/security)

---

## 🚀 Quick Reference

### Common Upload Operations

```dart
// Pick and upload image
final image = await FirebaseStorageService().pickImageFromGallery();
if (image != null) {
  final url = await FirebaseStorageService().uploadImage(
    file: File(image.path),
    folder: 'users/$userId/plants',
  );
}

// Upload with progress
final stream = FirebaseStorageService().uploadWithProgress(
  file: imageFile,
  folder: 'users/$userId/plants',
);
await for (var snapshot in stream) {
  double progress = snapshot.bytesTransferred / snapshot.totalBytes;
  // Update UI with progress
}

// Delete file
await FirebaseStorageService().deleteFileByURL(downloadURL);
```

---

## 🤔 Reflection

### Why Media Upload is Important

Media upload functionality is crucial for modern mobile applications because:

1. **Visual Documentation**: Users can document their plant growth journey with photos
2. **Enhanced Engagement**: Visual content makes the app more interactive and engaging
3. **Progress Tracking**: Before/after photos help users see plant health improvements
4. **Community Sharing**: Users can share their plant care success stories
5. **Problem Diagnosis**: Photos help identify plant health issues

### Where Firebase Storage Fits in PlantCarePulse

Firebase Storage will be used throughout the app:

1. **User Profiles**: Profile pictures for personalization
2. **Plant Library**: High-quality plant reference images
3. **My Plants**: User's plant collection photos
4. **Care Activities**: Document watering, fertilizing, pruning activities
5. **Growth Timeline**: Track plant growth over time with dated photos
6. **Community Features**: Share plant care tips with images

### Challenges Faced

1. **Permission Handling**: Managing camera and storage permissions across platforms
2. **File Size Management**: Balancing image quality with upload speed and storage costs
3. **Progress Tracking**: Implementing smooth progress indicators for uploads
4. **Error Handling**: Providing clear feedback for various failure scenarios
5. **Security Rules**: Configuring proper access control while maintaining usability

### Solutions Implemented

1. **Image Compression**: Automatic resizing and quality adjustment
2. **Progress Streams**: Real-time upload progress with StreamBuilder
3. **User Feedback**: Clear status messages and visual indicators
4. **Organized Structure**: Logical folder hierarchy for easy management
5. **Service Layer**: Clean separation of concerns with dedicated service class

---

## 👥 Team Information

**Team Name**: AlphaMerge  
**Sprint**: Sprint-2  
**Feature**: Firebase Storage Upload Flow  
**Date**: February 2026

---

## ✅ Submission Checklist

- [x] Added `firebase_storage` dependency
- [x] Added `image_picker` dependency
- [x] Created `FirebaseStorageService` class
- [x] Implemented image picker functionality
- [x] Implemented upload with progress tracking
- [x] Implemented download URL retrieval
- [x] Implemented file deletion
- [x] Created demo screen with full UI
- [x] Added navigation from home screen
- [x] Configured security rules
- [x] Added comprehensive documentation
- [x] Included code snippets
- [x] Added reflection section
- [x] Ready for screenshots

---

## 🎉 Conclusion

Firebase Storage integration is now complete in PlantCarePulse! Users can upload, view, and manage images seamlessly. This feature lays the foundation for a rich, visual plant care experience where users can document their plant journey with photos.

The implementation follows best practices with proper error handling, progress tracking, and security measures. The service layer architecture makes it easy to extend functionality and integrate storage throughout the app.

**Next Steps**: Integrate storage uploads into actual plant management screens and implement image galleries for plant growth timelines.
