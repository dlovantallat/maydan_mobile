import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maydan/utilities/app_utilities.dart';

class TestImage extends StatelessWidget {
  final int index;
  final File image;
  final DeleteListener listener;

  const TestImage(
      {Key? key,
      required this.index,
      required this.image,
      required this.listener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        width: 112,
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            SizedBox(
              height: 130,
              width: double.infinity,
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            ),
            InkWell(
              onTap: () {
                listener.onDelete(index);
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  removeImageSvg,
                  semanticsLabel: "",
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class DeleteListener {
  void onDelete(int index);
}
