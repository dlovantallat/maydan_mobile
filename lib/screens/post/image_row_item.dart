import 'dart:io';
import 'package:flutter/material.dart';

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
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            SizedBox(
              height: 70,
              width: double.infinity,
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            ),
            IconButton(
              onPressed: () {
                listener.onDelete(index);
              },
              icon: const Icon(Icons.delete),
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
