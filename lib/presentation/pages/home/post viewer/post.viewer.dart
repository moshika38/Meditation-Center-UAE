import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/services/download.services.dart';

class PostViewer extends StatefulWidget {
  final List<String> imagesList;

  const PostViewer({
    super.key,
    required this.imagesList,
  });

  @override
  State<PostViewer> createState() => _PostViewerState();
}

class _PostViewerState extends State<PostViewer> {
  int index = 0;

  void _next() {
    if (index < widget.imagesList.length - 1) {
      setState(() {
        index++;
      });
    }
  }

  void _previous() {
    if (index > 0) {
      setState(() {
        index--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.pureBlack,
      body: SafeArea(
        child: Column(
          children: [
             
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                PopupMenuButton<int>(
                  icon: const Icon(
                    Icons.more_vert_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                  color: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) async {
                    if (value == 1) {
                      DownloadServices().saveGif(
                        widget.imagesList[index],
                        "image_${DateTime.now()}",
                        context,
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.download, color: Colors.white),
                          SizedBox(width: 8),
                          Text("Download",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ------------ Image Area (SAFE HEIGHT) ------------
            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    _next();
                  } else if (details.primaryVelocity! > 0) {
                    _previous();
                  }
                },
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.imagesList[index],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Icon(
                      Icons.downloading_rounded,
                      color: Colors.white,
                      size: 35,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
