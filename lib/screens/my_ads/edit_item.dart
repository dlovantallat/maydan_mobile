import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';

class EditItem extends StatefulWidget {
  final ItemData item;

  const EditItem({Key? key, required this.item}) : super(key: key);

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<ItemRespond> updateItemRequest;
  final List<String> _dropdownDurationDrop = ["1", "2", "3"];
  String _dropdownDurationValue = "1";

  final List<String> _dropdownPriceDrop = ["IQ", "USD"];
  String _dropdownPriceValue = "IQ";

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isPrice = false;

  @override
  void initState() {
    titleController.text = widget.item.title;
    descriptionController.text = widget.item.description;
    priceController.text = widget.item.priceAnnounced;
    setState(() {
      _dropdownDurationValue = "${widget.item.duration}";
      _dropdownPriceValue = widget.item.currencyType == "U" ? "USD" : "IQ";
    });
    super.initState();
  }

  updateItem() async {
    if (priceController.text.trim().isEmpty) {
      setState(() {
        isPrice = true;
      });
    } else {
      setState(() {
        isPrice = false;
      });
    }

    if (_formKey.currentState!.validate()) {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();
      String price = priceController.text.trim();

      String token = await getToken();

      updateItemRequest = await service.updateItem(
          token: token,
          itemId: widget.item.id,
          districtId: widget.item.districtId,
          title: title,
          description: description,
          price: price,
          currencyType: _dropdownPriceValue,
          duration: _dropdownDurationValue);
      if (!mounted) return;

      if (!updateItemRequest.requestStatus) {
        if (updateItemRequest.statusCode == 200) {
          Navigator.pop(context, "refresh_update");
        } else {
          setSnackBar(context, updateItemRequest.errorMessage);
        }
      } else {
        setSnackBar(context, updateItemRequest.errorMessage);
      }
    }
  }

  String? validateTitle(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.post_title_val;
    } else {
      return null;
    }
  }

  String? validateDescription(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.post_description_val;
    } else {
      return null;
    }
  }

  String? validatePrice(String? value) {
    if (value!.isEmpty) {
      return null;
    } else {
      return null;
    }
  }

  final oib = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1),
    borderRadius: BorderRadius.all(
      Radius.circular(16.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.item.title}"),
      ),
      body: Container(
        margin: const EdgeInsetsDirectional.only(start: 16, end: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 8, top: 20),
                child: Text(AppLocalizations.of(context)!.post_title_caption),
              ),
              TextFormField(
                controller: titleController,
                validator: validateTitle,
                decoration: InputDecoration(
                  focusedBorder: oib,
                  enabledBorder: oib,
                  errorBorder: oib,
                  focusedErrorBorder: oib,
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.only(bottom: 8, top: 20),
                child: Text("Description"),
              ),
              TextFormField(
                controller: descriptionController,
                validator: validateDescription,
                maxLines: null,
                decoration: InputDecoration(
                  focusedBorder: oib,
                  enabledBorder: oib,
                  errorBorder: oib,
                  focusedErrorBorder: oib,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 12, bottom: 4),
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
                              child: TextFormField(
                                controller: priceController,
                                validator: validatePrice,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
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
                      isPrice
                          ? Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 8, top: 8),
                              child: Text(
                                AppLocalizations.of(context)!.post_price_val,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 12, bottom: 4),
                        child: Text(AppLocalizations.of(context)!
                            .post_duration_caption),
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
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 8, end: 8),
                              child: Text(
                                AppLocalizations.of(context)!.post_week,
                                style: const TextStyle(color: appColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(end: 8),
                              child: DropdownButton(
                                  underline: const SizedBox(),
                                  items: _dropdownDurationDrop
                                      .map((value) => DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: value ==
                                                          _dropdownDurationValue
                                                      ? appColor
                                                      : Colors.black),
                                            ),
                                          ))
                                      .toList(),
                                  value: _dropdownDurationValue,
                                  onChanged: (i) {
                                    setState(() {
                                      _dropdownDurationValue = i!;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 80),
                child: ElevatedButton(
                    onPressed: updateItem,
                    child: Text(AppLocalizations.of(context)!.edit_update_btn)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
