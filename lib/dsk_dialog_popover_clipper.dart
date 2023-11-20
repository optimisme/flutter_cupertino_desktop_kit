import 'package:flutter/cupertino.dart';

class DSKPopoverClipper extends CustomClipper<Path> {
  final Path pathClip;

  DSKPopoverClipper(this.pathClip);

  @override
  Path getClip(Size size) {
    return pathClip;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
