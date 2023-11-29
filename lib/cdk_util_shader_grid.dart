import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'cdk_theme.dart';

class CDKUtilShaderGrid extends CustomPainter {
  static ui.Image? gridImage;

  CDKUtilShaderGrid();

  static initGridImage() async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas imageCanvas = Canvas(recorder);
    final paint = Paint()..color = CDKTheme.grey50;
    imageCanvas.drawRect(const Rect.fromLTWH(0, 0, 10, 10), paint);
    imageCanvas.drawRect(const Rect.fromLTWH(10, 10, 10, 10), paint);
    paint.color = CDKTheme.grey100;
    imageCanvas.drawRect(const Rect.fromLTWH(10, 0, 10, 10), paint);
    imageCanvas.drawRect(const Rect.fromLTWH(0, 10, 10, 10), paint);

    gridImage = await recorder.endRecording().toImage(20, 20);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (gridImage == null) {
      return;
    }

    final paint = Paint();
    final shader = ui.ImageShader(
      gridImage!,
      TileMode.repeated,
      TileMode.repeated,
      Float64List.fromList([
        1,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        1,
      ]),
    );

    paint.shader = shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
