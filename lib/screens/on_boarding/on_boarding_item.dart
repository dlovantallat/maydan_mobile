import 'package:flutter/material.dart';

class OnBoardItem extends StatelessWidget {
  final String image;

  const OnBoardItem({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      fit: BoxFit.cover,
    );
  }
}
