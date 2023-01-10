import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';

class ImageViewScreen extends StatefulWidget {
  final List<ItemPhotos> itemPhotos;

  const ImageViewScreen({Key? key, required this.itemPhotos}) : super(key: key);

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(
                    imageLoader(
                      widget.itemPhotos[index].filePath,
                    ),
                  ),
                  initialScale: PhotoViewComputedScale.contained * 1,
                );
              },
              itemCount: widget.itemPhotos.length,
              loadingBuilder: (context, event) => const Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}
