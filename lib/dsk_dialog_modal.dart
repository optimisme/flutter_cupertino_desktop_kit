import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'dsk_dialog_outer_shadow_painter.dart';
import 'dsk_dialog_popover_clipper.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class DSKDialogModal extends StatefulWidget {
  final bool isAnimated;
  final bool isTranslucent;
  final Function? onHide;
  final Widget child;

  const DSKDialogModal({
    Key? key,
    this.isAnimated = false,
    this.isTranslucent = false,
    this.onHide,
    required this.child,
  }) : super(key: key);

  @override
  DSKDialogModalState createState() => DSKDialogModalState();
}

class DSKDialogModalState extends State<DSKDialogModal>
    with SingleTickerProviderStateMixin {
  OverlayEntry? overlayEntry;
  final int _animationMillis = 200;
  AnimationController? animationController;
  Animation<double>? scaleAnimation;
  double? width;
  double? height;
  bool isSizeDetermined = false;
  GlobalKey childKey = GlobalKey();
  Offset position = const Offset(
      -10000000, -10000000); // Out of view until size is determined
  Path pathContour = Path();
  Path pathClip = Path();

  @override
  void initState() {
    super.initState();
    DSKThemeManager().addListener(_update);

    if (widget.isAnimated) {
      animationController = AnimationController(
        duration: Duration(milliseconds: _animationMillis),
        vsync: this,
      );

      // Efecte de rebot
      scaleAnimation = CurvedAnimation(
        parent: animationController!,
        curve: Curves.easeOutBack,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && childKey.currentContext != null) {
        final RenderBox childRenderBox =
            childKey.currentContext!.findRenderObject() as RenderBox;
        final childSize = childRenderBox.size;

        setState(() {
          width = childSize.width;
          height = childSize.height;
          isSizeDetermined = true;

          final screenSize = MediaQuery.of(context).size;
          const screenPadding = 10.0;

          double maxHeight = screenSize.height - 2 * screenPadding;
          double maxWidth = screenSize.width - 2 * screenPadding;

          if (height! > maxHeight) {
            height = maxHeight;
          }

          if (width! > maxWidth) {
            width = maxWidth;
          }

          var left = (screenSize.width / 2) - (width! / 2);
          var top = (screenSize.height / 2) - (height! / 2);
          position = Offset(left, top);

          final rectContour = Rect.fromLTWH(8, 8, width!, height!);
          pathContour =
              DSKDialogOuterShadowPainter.createContourPath(rectContour);
          final rectClip = Rect.fromLTWH(0, 0, width!, height!);
          pathClip = DSKDialogOuterShadowPainter.createContourPath(rectClip);

          isSizeDetermined = true;
        });

        if (widget.isAnimated) {
          animationController!.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    DSKThemeManager().removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

  void hide() {
    widget.onHide?.call();
  }

  @override
  Widget build(BuildContext context) {
    DSKThemeManager themeManager = DSKThemeManager();

    Color backgroundColor = !widget.isTranslucent
        ? DSKColors.backgroundSecondary0
        : themeManager.isLight
            ? DSKColors.backgroundSecondary0.withOpacity(0.25)
            : DSKColors.backgroundSecondary0.withOpacity(0.5);

    Widget dialogContents = Container(
      key: childKey,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: widget.child,
    );

    Widget dialogWithDecorations = !isSizeDetermined
        ? Container()
        : Stack(
            children: [
              CustomPaint(
                painter: DSKDialogOuterShadowPainter(
                    pathContour: pathContour,
                    backgroundColor: backgroundColor,
                    isLightTheme: themeManager.isLight),
                child: Container(),
              ),
              Positioned(
                  top: 8,
                  left: 8,
                  child: !widget.isTranslucent
                      ? dialogContents
                      : ClipPath(
                          clipper: DSKPopoverClipper(
                              pathClip), // Aplica el clip aquí
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 7.5,
                                sigmaY: 7.5), // Efecte de difuminat
                            child: dialogContents,
                          ),
                        ))
            ],
          );

    return !isSizeDetermined
        ? Positioned(left: position.dx, top: position.dy, child: dialogContents)
        : Stack(
            children: [
              Positioned(
                  left: position.dx - 8,
                  top: position.dy - 8,
                  height: height! + 16,
                  width: width! + 16,
                  child: widget.isAnimated && scaleAnimation != null
                      ? ScaleTransition(
                          scale: scaleAnimation!,
                          child: dialogWithDecorations,
                        )
                      : dialogWithDecorations)
            ],
          );
  }
}
