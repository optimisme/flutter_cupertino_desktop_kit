import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'cdk_theme.dart';

class CDKUtilShaderGrid extends CustomPainter {
  int size = 0;
  static final List<ui.ImageShader> _shaders = [];
  static final List<double> _sizes = [];
  static bool _isInitializing = false;
  static bool _initialized = false;

  CDKUtilShaderGrid(this.size);

  static initShaders() async {
    if (_isInitializing) {
      return;
    }
    _isInitializing = true;
    for (int i = 0; i < 5; i++) {
      double size = 5.0 + i;
      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas imageCanvas = Canvas(recorder);
      final paint = Paint()..color = CDKTheme.grey50;
      imageCanvas.drawRect(Rect.fromLTWH(0, 0, size, size), paint);
      imageCanvas.drawRect(Rect.fromLTWH(size, size, size, size), paint);
      paint.color = CDKTheme.grey100;
      imageCanvas.drawRect(Rect.fromLTWH(size, 0, size, size), paint);
      imageCanvas.drawRect(Rect.fromLTWH(0, size, size, size), paint);
      int s = (size * 2).toInt();

      _sizes.add(size);

      ui.Image? gridImage = await recorder.endRecording().toImage(s, s);
      _shaders.add(ui.ImageShader(
        gridImage,
        TileMode.repeated,
        TileMode.repeated,
        // ignore: flutter_format_ignore
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
      ));
    }

    _isInitializing = false;
    _initialized = true;
  }

  @override
  void paint(Canvas canvas, Size size) async {
    if (!_initialized && !_isInitializing) {
      await initShaders();
      return;
    }

    final paint = Paint();
    paint.shader = _shaders[this.size % 5];
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CDKUtilShaderGrid oldDelegate) {
    return oldDelegate.size != size;
  }
}
