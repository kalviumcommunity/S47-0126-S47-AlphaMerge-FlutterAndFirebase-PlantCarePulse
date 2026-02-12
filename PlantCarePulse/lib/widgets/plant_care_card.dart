import 'package:flutter/material.dart';
import 'like_button.dart';

/// A specialized card widget for plant care information
/// that combines multiple reusable components
class PlantCareCard extends StatelessWidget {
  final String plantName;
  final String careInstructions;
  final String imageUrl;
  final bool isLiked;
  final VoidCallback? onTap;
  final Function(bool)? onLikeChanged;

  const PlantCareCard({
    super.key,
    required this.plantName,
    required this.careInstructions,
    required this.imageUrl,
    this.isLiked = false,
    this.onTap,
    this.onLikeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Image Section
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green[300]!,
                    Colors.green[600]!,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.local_florist,
                      size: 80,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: LikeButton(
                        initialLiked: isLiked,
                        onLikeChanged: onLikeChanged,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Plant Information Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plantName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    careInstructions,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.water_drop,
                        size: 16,
                        color: Colors.blue[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Water regularly',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.wb_sunny,
                        size: 16,
                        color: Colors.orange[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Bright light',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
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