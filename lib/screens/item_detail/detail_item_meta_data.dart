import 'package:flutter/material.dart';

class DetailItemMetaData extends StatelessWidget {
  const DetailItemMetaData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                border: BorderDirectional(
                  end: BorderSide(color: Colors.black),
                ),
              ),
              height: 40,
              child: const Padding(
                padding: EdgeInsetsDirectional.only(start: 8, top: 8),
                child: Text(
                  "Duration",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: SizedBox(
              height: 40,
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 16, top: 8),
                child: Text(
                  "widget.data.duration widget",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
