import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utilities/app_utilities.dart';

class DeleteProfileScreen extends StatefulWidget {
  const DeleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<DeleteProfileScreen> createState() => _DeleteProfileScreenState();
}

class _DeleteProfileScreenState extends State<DeleteProfileScreen> {
  deletePopup() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(""),
            content: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(top: 8, bottom: 16),
                      child: Text(
                        AppLocalizations.of(context)!.delete_desc,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 8, end: 8),
                            child: OutlinedButton(
                              style: ButtonStyle(
                                minimumSize:
                                    MaterialStateProperty.resolveWith<Size>(
                                  (Set<MaterialState> states) {
                                    return const Size(
                                      double.infinity,
                                      40,
                                    );
                                  },
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .delete_post_no
                                  .toUpperCase()),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              //TODO call api
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                appColor,
                              ),
                              minimumSize:
                                  MaterialStateProperty.resolveWith<Size>(
                                (Set<MaterialState> states) {
                                  return const Size(
                                    double.infinity,
                                    40,
                                  );
                                },
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!
                                .delete_post_yes
                                .toUpperCase()),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        },
        barrierDismissible: true);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.delete_account_title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding:
            EdgeInsetsDirectional.only(start: 16, end: 16, top: height / 6),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: const BoxDecoration(
                color: Color(0xFFF1F1F1),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.only(start: 16, top: 16, end: 16),
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.account_delete_first_line,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top: 16),
                        child: Text(
                          AppLocalizations.of(context)!
                              .account_delete_second_line,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.account_delete_third_line,
                        style: const TextStyle(fontSize: 12),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top: 16),
                        child: Text(
                          AppLocalizations.of(context)!
                              .account_delete_point_one,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.account_delete_point_two,
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .account_delete_point_three,
                        style: const TextStyle(fontSize: 12),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 16, bottom: 16),
                        child: Text(
                          AppLocalizations.of(context)!
                              .account_delete_last_line,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 16),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.resolveWith<Size>(
                                (Set<MaterialState> states) {
                                  return const Size(double.infinity, 40);
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            onPressed: deletePopup,
                            child: Text(AppLocalizations.of(context)!
                                .delete_understand_btn)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
