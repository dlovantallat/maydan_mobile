import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:maydan/screens/my_ads/my_items_item_list.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import 'my_items_obj.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({Key? key}) : super(key: key);

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<MyItemsObj> myItems;
  bool isLoading = false;

  @override
  void initState() {
    getMyItems();
    super.initState();
  }

  getMyItems() async {
    setState(() {
      isLoading = true;
    });

    myItems = await service.getMyItems(
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5ODA4OWZiOS1iMTE2LTQ2NzUtOTIyZi05MWQ2OTNlZWQyMDEiLCJqdGkiOiI0NTBhZGZkYjk2ZDZjMmQ2NjAwYjFlMGYzZGRlZTY1ZDgxOTUzNjVkNzdhZDliMzk2NDlhMDIyYWMzNzI4ODA2ZDM5ZmE5MTdmODdjZjlhMSIsImlhdCI6MTY3MjE0NTM4My4xMzMwMzcwOTAzMDE1MTM2NzE4NzUsIm5iZiI6MTY3MjE0NTM4My4xMzMwMzg5OTc2NTAxNDY0ODQzNzUsImV4cCI6MTcwMzY4MTM4My4xMzAwMDQ4ODI4MTI1LCJzdWIiOiI5ODA4YjEzOC0yOTYyLTQyY2ItOTUxMy04YTQyMGRhM2M5OWMiLCJzY29wZXMiOltdfQ.M0ixtjVIHHefN-k57JoLz-EIY9OioJILw_qul9Ih7-1T9kB9SfzTEjHy4aQaT9ZpOXoVSXlh73HIlshnKfr4mZiaQwUE_drcSmKxrhvLYc9qpc15DXHYPdYRODHeBzzwH_ppGkKX5ZJ-xPVHbVUIPnXYcbb5eUA4KmrZxpsA9qdTMPs0vfUsSGCkKxTANKp_NXNpp6aPpfDxiW7FiGfz9Jep5qid4rqe3jnQGTiPq0-X4rxVe09pzM-hWQcbUr01xhRKk__NCxDd8YDQlEip7LLdiN8wVouf3ScGJ-fSgoukSBxpToNL1w66RyGDXRBrUbuzJSA4UEpsqkTrX3cKDdXLpM2h39KLXp2Q8mHK4KHZnb2Gzwd03Xecbct0DRvgymq1_KZQ3M-t0GAgU7hVzHda1m6MXwGcLZKtVJ4Lg-F-RwqR_UBqHsNfrqVaf68yQYw5LgnSmszKM-JQot0o100iYSvCYz-bLOwm395BxOo6YqEnUQk19OpM315u5WiggFxdyAm_sCzZfe6uoyvIZKVqH281tDnkFC-11LP2Vt6zLkIlMRixKQc4kpSYWeX73X5oMJo2b8ZlVE1tm8Yo_thNTHZ4jxygoaEwnhohnDHZ1XzTFseMk544BGIpMZJyvQWLryIi8FiNUaOkA_uSosnedffDZYCqfKoYUQUqw4Q");

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Ads"),
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (myItems.requestStatus) {
          return Center(
            child: Text(myItems.errorMessage),
          );
        }

        if (myItems.data!.data.isEmpty) {
          return const Center(
            child: Text("Empty"),
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) => MyItemsItemList(
            data: myItems.data!.data[index],
          ),
          itemCount: myItems.data!.data.length,
        );
      }),
    );
  }
}
