import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../services/firebase_storage_service.dart';

/// Firebase Storage Demo Screen
/// Demonstrates image upload, display, and deletion functionality
class StorageDemoScreen extends StatefulWidget {
  const StorageDemoScreen({super.key});

  @override
  State<StorageDemoScreen> createState() => _StorageDemoScreenState();
}

class _StorageDemoScreenState extends State<StorageDemoScreen> {
  final FirebaseStorageService _storageService = FirebaseStorageService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  File? _selectedImage;
  String? _uploadedImageURL;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _statusMessage = '';

  // ==================== IMAGE PICKER ====================

  /// Show image source selection dialog
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
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Pick image from selected source
  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _statusMessage = 'Selecting image...';
      });

      final XFile? pickedFile = await _storageService.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _statusMessage = 'Image selected successfully!';
          _uploadedImageURL = null; // Clear previous upload
        });
      } else {
        setState(() {
          _statusMessage = 'No image selected';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error selecting image: $e';
      });
    }
  }

  // ==================== UPLOAD OPERATIONS ====================

  /// Upload selected image to Firebase Storage
  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      setState(() {
        _statusMessage = 'Please select an image first';
      });
      return;
    }

    if (_currentUser == null) {
      setState(() {
        _statusMessage = 'Please login to upload images';
      });
      return;
    }

    try {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
        _statusMessage = 'Uploading image...';
      });

      // Upload with progress tracking
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
            _statusMessage = 'Upload successful!';
            _isUploading = false;
          });
        } else if (snapshot.state == TaskState.error) {
          setState(() {
            _statusMessage = 'Upload failed';
            _isUploading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error uploading image: $e';
        _isUploading = false;
      });
    }
  }

  /// Upload as profile picture
  Future<void> _uploadAsProfilePicture() async {
    if (_selectedImage == null || _currentUser == null) {
      setState(() {
        _statusMessage = 'Please select an image and login';
      });
      return;
    }

    try {
      setState(() {
        _isUploading = true;
        _statusMessage = 'Uploading profile picture...';
      });

      final downloadURL = await _storageService.uploadUserProfilePicture(
        userId: _currentUser!.uid,
        file: _selectedImage!,
      );

      setState(() {
        _uploadedImageURL = downloadURL;
        _statusMessage = 'Profile picture uploaded!';
        _isUploading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _isUploading = false;
      });
    }
  }

  // ==================== DELETE OPERATIONS ====================

  /// Delete uploaded image
  Future<void> _deleteImage() async {
    if (_uploadedImageURL == null) {
      setState(() {
        _statusMessage = 'No uploaded image to delete';
      });
      return;
    }

    try {
      setState(() {
        _statusMessage = 'Deleting image...';
      });

      await _storageService.deleteFileByURL(_uploadedImageURL!);

      setState(() {
        _uploadedImageURL = null;
        _statusMessage = 'Image deleted successfully!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error deleting image: $e';
      });
    }
  }

  /// Clear selected image
  void _clearSelection() {
    setState(() {
      _selectedImage = null;
      _uploadedImageURL = null;
      _statusMessage = '';
      _uploadProgress = 0.0;
    });
  }

  // ==================== UI BUILD ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Storage Demo'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Firebase Storage Demo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Upload images to Firebase Storage and retrieve download URLs. '
                      'Perfect for profile pictures, plant photos, and care activity images.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Image Selection Section
            _buildImageSelectionSection(),
            const SizedBox(height: 20),

            // Upload Buttons
            if (_selectedImage != null) _buildUploadButtons(),
            const SizedBox(height: 20),

            // Upload Progress
            if (_isUploading) _buildUploadProgress(),
            const SizedBox(height: 20),

            // Status Message
            if (_statusMessage.isNotEmpty) _buildStatusMessage(),
            const SizedBox(height: 20),

            // Uploaded Image Display
            if (_uploadedImageURL != null) _buildUploadedImageSection(),
          ],
        ),
      ),
    );
  }

  /// Build image selection section
  Widget _buildImageSelectionSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_selectedImage == null)
              Column(
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No image selected',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              )
            else
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.network(
                            _selectedImage!.path,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                                ),
                              );
                            },
                          )
                        : Image.file(
                            _selectedImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Selected Image',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(Icons.photo_library),
                    label: Text(_selectedImage == null ? 'Select Image' : 'Change Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                if (_selectedImage != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _clearSelection,
                    icon: const Icon(Icons.clear),
                    color: Colors.red,
                    tooltip: 'Clear',
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build upload buttons
  Widget _buildUploadButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _uploadImage,
          icon: const Icon(Icons.cloud_upload),
          label: const Text('Upload to Storage'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _uploadAsProfilePicture,
          icon: const Icon(Icons.account_circle),
          label: const Text('Upload as Profile Picture'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  /// Build upload progress indicator
  Widget _buildUploadProgress() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _uploadProgress,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              'Uploading: ${(_uploadProgress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  /// Build status message
  Widget _buildStatusMessage() {
    final isError = _statusMessage.toLowerCase().contains('error') ||
        _statusMessage.toLowerCase().contains('failed');
    final isSuccess = _statusMessage.toLowerCase().contains('success');

    return Card(
      color: isError
          ? Colors.red.shade50
          : isSuccess
              ? Colors.green.shade50
              : Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline
                  : isSuccess
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
              color: isError
                  ? Colors.red
                  : isSuccess
                      ? Colors.green
                      : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _statusMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: isError
                      ? Colors.red.shade700
                      : isSuccess
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build uploaded image section
  Widget _buildUploadedImageSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Uploaded Image',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _deleteImage,
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  tooltip: 'Delete',
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _uploadedImageURL!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.error, size: 50, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _uploadedImageURL!,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
