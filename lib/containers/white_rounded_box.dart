import 'package:flutter/material.dart';

class WhiteRoundedCard extends StatelessWidget {
  final Color color;
  final Widget child;

  WhiteRoundedCard({@required this.color, this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.child,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        color: color,
      ),
    );
  }
}
