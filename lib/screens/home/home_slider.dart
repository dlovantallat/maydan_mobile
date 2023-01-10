import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:maydan/screens/item_detail/image_view_screen.dart';

import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import 'home.dart';

Swiper homeSlider(context,
    {List<HomeBanner>? images, List<ItemPhotos>? itemPhotos}) {
  return Swiper(
    autoplay: true,
    itemBuilder: (BuildContext context, int index) {
      return InkWell(
        onTap: () {
          if (itemPhotos != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ImageViewScreen(itemPhotos: itemPhotos)));
          }
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0x0fffffff),
              width: 1,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Image.network(
            imageLoader(images != null
                ? images[index].urlImg
                : itemPhotos![index].filePath),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Image(
              image: AssetImage(imageHolder),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    },
    itemCount: images != null ? images.length : itemPhotos!.length,
    scale: 0.9,
    pagination: const SwiperPagination(
      builder: DotSwiperPaginationBuilder(
        activeColor: appColor,
      ),
    ),
    loop: true,
  );
}
