import 'package:flutter/cupertino.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

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
