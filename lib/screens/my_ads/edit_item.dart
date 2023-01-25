import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:maydan/utilities/app_utilities.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/item.dart';

class EditItem extends StatefulWidget {
  final ItemData item;

  const EditItem({Key? key, required this.item}) : super(key: key);

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<ItemRespond> updateItemRequest;
  final List<String> _dropdownDurationDrop = ["7", "15", "30"];
  String _dropdownDurationValue = "7";

  final List<String> _dropdownPriceDrop = ["IQ", "USD"];
  String _dropdownPriceValue = "IQ";

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.item.title;
    descriptionController.text = widget.item.description;
    priceController.text = widget.item.priceAnnounced;
    super.initState();
  }

  updateItem() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    String price = priceController.text.trim();

    if (title.isEmpty) {
      setSnackBar(context, "title can't be empty");
      return;
    }

    if (description.isEmpty) {
      setSnackBar(context, "title can't be empty");
      return;
    }

    if (price.isEmpty) {
      setSnackBar(context, "title can't be empty");
      return;
    }

    String token = await getToken();
    print("token:$token");

    updateItemRequest = await service.updateItem(
        token: token,
        itemId: widget.item.id,
        districtId: widget.item.districtId,
        title: title,
        description: description,
        price: price,
        duration: "duration");
    if (!mounted) return;

    if (!updateItemRequest.requestStatus) {
      if (updateItemRequest.statusCode == 200) {
        print("updated");
        Navigator.pop(context, "refresh_update");
      } else {
        print(updateItemRequest.errorMessage);
        print(updateItemRequest.statusCode);
        print("no");
      }
    } else {
      print(updateItemRequest.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.item.title}"),
      ),
      body: Container(
        margin: const EdgeInsetsDirectional.only(start: 16, end: 16),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8, top: 20),
              child: Text(AppLocalizations.of(context)!.post_title_caption),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
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
            const Padding(
              padding: EdgeInsetsDirectional.only(bottom: 8, top: 20),
              child: Text("Description"),
            ),
            TextField(
              controller: descriptionController,
              maxLines: null,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(top: 12, bottom: 4),
                      child: Text(
                          AppLocalizations.of(context)!.post_price_caption),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 8, end: 8),
                            child: DropdownButton(
                                underline: const SizedBox(),
                                items: _dropdownPriceDrop
                                    .map((value) => DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        ))
                                    .toList(),
                                value: _dropdownPriceValue,
                                onChanged: (i) {
                                  setState(() {
                                    _dropdownPriceValue = i!;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(top: 12, bottom: 4),
                      child: Text(
                          AppLocalizations.of(context)!.post_duration_caption),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.only(start: 8, end: 8),
                        child: DropdownButton(
                            underline: const SizedBox(),
                            items: _dropdownDurationDrop
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            value: _dropdownDurationValue,
                            onChanged: (i) {
                              setState(() {
                                _dropdownDurationValue = i!;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 80),
              child: ElevatedButton(
                  onPressed: updateItem, child: const Text("Update")),
            )
          ],
        ),
      ),
    );
  }
}
