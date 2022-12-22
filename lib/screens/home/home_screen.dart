import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maydan/screens/home/home_item.dart';

import '../../utilities/app_utilities.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130.0),
        child: Column(
          children: [
            AppBar(
              title: SvgPicture.asset(
                homeLogoSvg,
                semanticsLabel: '',
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsetsDirectional.only(start: 8, end: 8, top: 8),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "What are you looking for?",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColor, width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => HomeItem(
          index: index,
        ),
        itemCount: 5,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: appColor),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(top: 8, bottom: 32),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsetsDirectional.only(end: 16),
                            height: 40,
                            width: 40,
                            color: const Color(0x49000000),
                          ),
                          const Text(
                            'My Profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Kurdish',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Arabic',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'English',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 16, end: 16),
              child: Column(
                children: [
                  ListTile(
                    shape: const Border(
                      bottom: BorderSide(color: Color(0x5E000000)),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('About Us'),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    shape: const Border(
                      bottom: BorderSide(color: Color(0x5E000000)),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Company accounts'),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    shape: const Border(
                      bottom: BorderSide(color: Color(0x5E000000)),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('My Ads'),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    shape: const Border(
                      bottom: BorderSide(color: Color(0x5E000000)),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('My favourites'),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    shape: const Border(
                      bottom: BorderSide(color: Color(0x5E000000)),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Help'),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    shape: const Border(
                      bottom: BorderSide(color: Color(0x5E000000)),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('FAQ'),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    shape: const Border(
                      bottom: BorderSide(color: Color(0x5E000000)),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Logout'),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    shape: const Border(
                      bottom: BorderSide(color: Color(0x5E000000)),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Term & Conditions'),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Privacy Policy'),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
