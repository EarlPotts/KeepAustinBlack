import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData leading;
  final String title;

  MyListTile({this.leading, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              leading,
              color: Colors.deepOrange,
              size: 25,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(title),
            ),
          )
        ],
      ),
    );
  }
}
