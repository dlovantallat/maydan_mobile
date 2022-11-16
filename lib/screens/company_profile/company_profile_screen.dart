import 'package:flutter/material.dart';

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
    );
  }
}
