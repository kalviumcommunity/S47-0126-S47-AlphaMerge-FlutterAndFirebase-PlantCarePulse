import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

/// Firebase Storage Service
/// Handles all file upload, download, and deletion operations
class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // ==================== IMAGE PICKER OPERATIONS ====================

  /// Pick image from gallery
  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  /// Pick image from camera
  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      throw Exception('Failed to capture image from camera: $e');
    }
  }

  /// Show image source selection dialog
  /// Returns the picked image file
  Future<XFile?> pickImage({required ImageSource source}) async {
    try {
      if (source == ImageSource.gallery) {
        return await pickImageFromGallery();
      } else {
        return await pickImageFromCamera();
      }
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  // ==================== UPLOAD OPERATIONS ====================

  /// Upload image to Firebase Storage
  /// Returns the download URL of the uploaded file
  Future<String> uploadImage({
    required File file,
    required String folder,
    String? fileName,
  }) async {
    try {
      // Generate unique filename if not provided
      final String uploadFileName = fileName ?? 
          '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Create storage reference
      final Reference storageRef = _storage.ref().child('$folder/$uploadFileName');

      // Set metadata
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Upload file
      final UploadTask uploadTask = storageRef.putFile(file, metadata);

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Upload user profile picture
  Future<String> uploadUserProfilePicture({
    required String userId,
    required File file,
  }) async {
    try {
      return await uploadImage(
        file: file,
        folder: 'users/$userId/profile',
        fileName: 'profile_picture.jpg',
      );
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  /// Upload plant image
  Future<String> uploadPlantImage({
    required String userId,
    required String plantId,
    required File file,
  }) async {
    try {
      return await uploadImage(
        file: file,
        folder: 'users/$userId/plants/$plantId',
        fileName: '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
    } catch (e) {
      throw Exception('Failed to upload plant image: $e');
    }
  }

  /// Upload care activity image
  Future<String> uploadCareActivityImage({
    required String userId,
    required String plantId,
    required File file,
  }) async {
    try {
      return await uploadImage(
        file: file,
        folder: 'users/$userId/plants/$plantId/activities',
        fileName: '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
    } catch (e) {
      throw Exception('Failed to upload activity image: $e');
    }
  }

  // ==================== DOWNLOAD OPERATIONS ====================

  /// Get download URL for a file
  Future<String> getDownloadURL(String filePath) async {
    try {
      final Reference ref = _storage.ref().child(filePath);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  // ==================== DELETE OPERATIONS ====================

  /// Delete file from Firebase Storage
  Future<void> deleteFile(String filePath) async {
    try {
      final Reference ref = _storage.ref().child(filePath);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Delete file by URL
  Future<void> deleteFileByURL(String downloadURL) async {
    try {
      final Reference ref = _storage.refFromURL(downloadURL);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file by URL: $e');
    }
  }

  /// Delete user profile picture
  Future<void> deleteUserProfilePicture(String userId) async {
    try {
      await deleteFile('users/$userId/profile/profile_picture.jpg');
    } catch (e) {
      throw Exception('Failed to delete profile picture: $e');
    }
  }

  /// Delete all plant images
  Future<void> deletePlantImages({
    required String userId,
    required String plantId,
  }) async {
    try {
      final Reference folderRef = _storage.ref().child('users/$userId/plants/$plantId');
      final ListResult result = await folderRef.listAll();
      
      // Delete all files in the folder
      for (Reference fileRef in result.items) {
        await fileRef.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete plant images: $e');
    }
  }

  // ==================== UTILITY OPERATIONS ====================

  /// Get file metadata
  Future<FullMetadata> getFileMetadata(String filePath) async {
    try {
      final Reference ref = _storage.ref().child(filePath);
      return await ref.getMetadata();
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }

  /// List all files in a folder
  Future<List<String>> listFilesInFolder(String folderPath) async {
    try {
      final Reference folderRef = _storage.ref().child(folderPath);
      final ListResult result = await folderRef.listAll();
      
      List<String> downloadURLs = [];
      for (Reference fileRef in result.items) {
        final String url = await fileRef.getDownloadURL();
        downloadURLs.add(url);
      }
      
      return downloadURLs;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }

  /// Get upload progress stream
  Stream<TaskSnapshot> uploadWithProgress({
    required File file,
    required String folder,
    String? fileName,
  }) {
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
    
    return uploadTask.snapshotEvents;
  }
}
