import 'package:flutter/material.dart';

import '../../utilities/app_utilities.dart';
import '../profile/profile.dart';
import 'company_profile_screen.dart';

class CompanyItem extends StatelessWidget {
  final ProfileData data;

  const CompanyItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CompanyProfileScreen(
                      id: data.id,
                      title: data.name,
                    )));
      },
      child: Card(
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        color: const Color(0xFFE5E5E5),
        margin: const EdgeInsetsDirectional.only(start: 4, end: 4, bottom: 16),
        child: SizedBox(
          child: Column(children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(20), topEnd: Radius.circular(20)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 155,
                child: Image.network(
                  imageLoader(data.urlPhoto),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Image(
                    image: AssetImage(imageHolder),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(20), topEnd: Radius.circular(20)),
              ),
              height: 45,
              width: 165,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 8, top: 8),
                child: Text(
                  data.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
