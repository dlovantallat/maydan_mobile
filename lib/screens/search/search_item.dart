import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../item_detail/item_detail.dart';

class SearchItem extends StatelessWidget {
  final ItemData data;
  final String keyLang;

  const SearchItem({Key? key, required this.data, required this.keyLang})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ItemDetail(
                      item: data,
                      isFav: data.favorite,
                    )));
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        constraints: const BoxConstraints(minHeight: 100),
        margin: const EdgeInsetsDirectional.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.black,
            style: BorderStyle.solid,
            width: 1.0,
          ),
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsetsDirectional.all(8),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.network(
                            imageLoader(data.itemPhotos.isEmpty
                                ? ""
                                : data.itemPhotos[0].filePath),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Image(
                              image: AssetImage(imageHolder),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        data.currentAmount == 0
                            ? Image.asset(
                                keyLang == "en"
                                    ? soldOutPngEn
                                    : keyLang == "ar"
                                        ? soldOutPngAr
                                        : soldOutPngCkb,
                                height: 100,
                                width: 100,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              bottom: 0, end: 16),
                          child: Text(
                            "${data.title}\n",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        customDivider(),
                        Text(
                            "${data.priceAnnounced} ${data.currencyType == "U" ? "\$" : "IQD"}"),
                        customDivider(),
                        Text(
                            "${AppLocalizations.of(context)!.post_status} ${data.currentAmount == 0 ? AppLocalizations.of(context)!.post_sold_out : data.status == "I" ? AppLocalizations.of(context)!.post_in_review : AppLocalizations.of(context)!.post_published}"),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget customDivider() {
  return const Divider(
    thickness: 1,
    color: Colors.black,
  );
}
