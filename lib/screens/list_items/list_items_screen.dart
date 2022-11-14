import 'package:flutter/material.dart';

import 'items_item.dart';

class ListItemsScreen extends StatefulWidget {
  const ListItemsScreen({Key? key}) : super(key: key);

  @override
  State<ListItemsScreen> createState() => _ListItemsScreenState();
}

class _ListItemsScreenState extends State<ListItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "title",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 4, end: 4),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisExtent: 220),
          itemBuilder: (BuildContext context, int index) => const ItemsItem(),
          itemCount: 30,
        ),
      ),
    );
  }
}
