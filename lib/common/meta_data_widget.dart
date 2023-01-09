import 'package:flutter/material.dart';

Widget meteData(String title, String value) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.black),
      ),
    ),
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: const BoxDecoration(
              border: BorderDirectional(
                end: BorderSide(color: Colors.black),
              ),
            ),
            height: 40,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 8, top: 8),
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16, top: 8),
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
