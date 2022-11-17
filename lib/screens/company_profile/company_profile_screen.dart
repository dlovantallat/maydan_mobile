import 'package:flutter/material.dart';
import 'package:maydan/utilities/app_utilities.dart';

import '../item_detail/detail_item_meta_data.dart';
import '../list_items/items_item.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

// This is the type used by the popup menu below.
enum Menu { itemOne, itemTwo, itemThree, itemFour }

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  String _selectedMenu = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          const Chip(
            shape: StadiumBorder(
                side: BorderSide(
              width: 1,
              color: Colors.black,
            )),
            backgroundColor: Colors.white,
            label: Text("Place an Ad"),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.only(start: 8),
            child: Chip(
              shape: StadiumBorder(
                  side: BorderSide(
                width: 1,
                color: Colors.black,
              )),
              backgroundColor: Colors.white,
              label: Text("Edit"),
            ),
          ),
          // This button presents popup menu items.
          PopupMenuButton<Menu>(
              icon: const Icon(Icons.more_vert),
              onSelected: (Menu item) {
                setState(() {
                  _selectedMenu = item.name;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    const PopupMenuItem<Menu>(
                      value: Menu.itemOne,
                      child: Text('Item 1'),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.itemTwo,
                      child: Text('Item 2'),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.itemThree,
                      child: Text('Item 3'),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.itemFour,
                      child: Text('Item 4'),
                    ),
                  ]),
        ],
      ),
      body: ListView(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsetsDirectional.only(start: 8, end: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                width: double.infinity,
                'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1988&q=80',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Image(
                  image: AssetImage(mainProfileBottomNavigationSvg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(10),
                        topEnd: Radius.circular(10)),
                    color: appColor,
                  ),
                  child: const Center(
                    child: Text("Cow"),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => const DetailItemMetaData(),
                  itemCount: 3,
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Products related to X company"),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, end: 4),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 220),
              itemBuilder: (BuildContext context, int index) =>
                  const ItemsItem(),
              itemCount: 3,
            ),
          ),
        ],
      ),
    );
  }
}
