import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Function tap;
  final Color color;
  final double size;

  RoundIconButton({this.icon, this.tap, this.color, @required this.size});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        icon,
        size: size * 0.75,
      ),
      onPressed: tap,
      elevation: 6,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      shape: CircleBorder(),
      fillColor: Colors.deepOrange,
    );
  }
}
