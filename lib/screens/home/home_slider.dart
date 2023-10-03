import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:maydan/common/model/category.dart';
import 'package:maydan/screens/item_detail/image_view_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../company_profile/company_profile_screen.dart';
import '../item_detail/item_detail.dart';
import '../list_items/list_items_screen.dart';
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
          } else {
            //company
            //sub-category
            //product
            final image = images![index];
            if (image.bannerableType == "company") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CompanyProfileScreen(
                      title: image.name, id: image.bannerableId),
                ),
              );
            } else if (images[index].bannerableType == "sub-category") {
              final sub = SubCategoryData(
                  id: image.bannerableId,
                  title: image.name,
                  urlImg: image.urlImg,
                  description: "",
                  categoryId: "");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return ListItemsScreen(
                    subCategory: sub,
                  );
                }),
              );
            } else if (images[index].bannerableType == "product") {
              final item = ItemData(
                  id: image.bannerableId,
                  viewCount: 0,
                  districtId: "",
                  status: "",
                  title: "",
                  description: "",
                  statusDate: "",
                  expirationDate: "",
                  currencyType: "",
                  districtName: "",
                  cityName: "",
                  sellerName: "",
                  phoneNumber: "phoneNumber",
                  favorite: false,
                  currentAmount: 0,
                  priceAnnounced: "",
                  duration: 0,
                  user: UserObj(
                      id: "", msisdn: "", name: "", email: "", usertype: ""),
                  itemPhotos: []);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return ItemDetail(
                    item: item,
                    isFav: false,
                  );
                }),
              );
            } else {
              setSnackBar(context, "Something wrong has occurred");
            }
            // _launchUrl(images[index].url);
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
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
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
    duration: 300,
    pagination: const SwiperPagination(
      builder: DotSwiperPaginationBuilder(
        activeColor: appColor,
      ),
    ),
    loop: true,
  );
}

Future<void> _launchUrl(String adsUrl) async {
  final Uri url = Uri.parse(adsUrl);

  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
