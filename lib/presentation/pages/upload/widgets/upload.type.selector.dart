import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart'; // ඔබගේ AppColors භාවිතයෙන්

class UploadTypeSelector {
  static void showSelector(
    BuildContext context,
    VoidCallback selectVideo,
    VoidCallback selectImages,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext dialogContext) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  Title/Header
              Text(
                "Select Content Type",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,  
                    ),
              ),
              const SizedBox(height: 20),

              //  Short Video Option
              _buildOptionTile(
                context,
                icon: Icons.video_collection_outlined,
                title: "Short Video (1 File)",
                subtitle: "Upload a single video clip.",
                onTap: () {
                   
                  Navigator.pop(dialogContext); 
                  selectVideo();
                },
              ),
              const SizedBox(height: 10),
              
              const Divider(height: 0, color: Colors.black12),  

              //   Images List Option
              _buildOptionTile(
                context,
                icon: Icons.photo_library_outlined,
                title: "Images List (Multiple Files)",
                subtitle: "Upload multiple photos for a post.",
                onTap: () {
                   
                  Navigator.pop(dialogContext); 
                  selectImages();
                },
              ),
              const SizedBox(height: 10), 

               
            ],
          ),
        );
      },
    );
  }

  // Helper method for creating stylish ListTiles
  static Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: AppColors.primaryColor),  
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}