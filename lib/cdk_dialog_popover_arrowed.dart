import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_dialog_outer_shadow_painter.dart';
import 'cdk_dialog_popover_clipper.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKDialogPopoverArrowed extends StatefulWidget {
  final GlobalKey anchorKey;
  final bool isAnimated;
  final bool isTranslucent;
  final Function? onHide;
  final Widget child;

  const CDKDialogPopoverArrowed({
    super.key,
    required this.anchorKey,
    this.isAnimated = false,
    this.isTranslucent = true,
    this.onHide,
    required this.child,
  });

  @override
  CDKDialogPopoverArrowedState createState() => CDKDialogPopoverArrowedState();
}

class CDKDialogPopoverArrowedState extends State<CDKDialogPopoverArrowed>
    with SingleTickerProviderStateMixin {
  OverlayEntry? overlayEntry;
  final int _animationMillis = 200;
  AnimationController? animationController;
  Animation<double>? scaleAnimation;
  double? width;
  double? height;
  bool isSizeDetermined = false;
  GlobalKey childKey = GlobalKey();
  Size? screenSize;
  double screenPadding = 10.0;
  Offset position = const Offset(
      -10000000, -10000000); // Out of view until size is determined
  Path pathContour = Path();
  Path pathClip = Path();

  @override
  void initState() {
    super.initState();

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
        setState(() {
          final RenderBox anchorRenderBox =
              widget.anchorKey.currentContext!.findRenderObject() as RenderBox;
          widget.anchorKey.currentContext!.findRenderObject() as RenderBox;
          final anchorPosition = anchorRenderBox.localToGlobal(Offset.zero);

          final anchorSize = anchorRenderBox.size;
          final RenderBox childRenderBox =
              childKey.currentContext!.findRenderObject() as RenderBox;
          final childSize = childRenderBox.size;

          width = childSize.width;
          height =
              childSize.height + 8; // 8 To give space for the shadow if at top

          screenSize = MediaQuery.of(context).size;

          double maxHeight = screenSize!.height - 2 * screenPadding;
          double maxWidth = screenSize!.width - 2 * screenPadding;
          if (height! > maxHeight) {
            height = maxHeight;
          }

          if (width! > maxWidth) {
            width = maxWidth;
          }

          double leftPosition =
              anchorPosition.dx + (anchorSize.width / 2) - width! / 2;
          double topPosition = anchorPosition.dy + anchorSize.height + 4;
          double arrowDiff = 0.0;
          bool arrowAtBottom = true;

          if (leftPosition + width! > screenSize!.width - screenPadding) {
            var tmp = screenSize!.width - width! - screenPadding;
            arrowDiff = leftPosition - tmp;
            leftPosition = tmp;
          }
          if (leftPosition < screenPadding) {
            var tmp = screenPadding;
            arrowDiff = leftPosition - tmp;
            leftPosition = screenPadding;
          }

          if (topPosition + height! > screenSize!.height - screenPadding) {
            topPosition = topPosition - height! - anchorSize.height - 8;
            arrowAtBottom = false;
          }

          if (topPosition < screenPadding) {
            topPosition = screenPadding;
          }

          if (!arrowAtBottom) {
            topPosition = topPosition + 8;
          }

          position = Offset(leftPosition, topPosition);
          final rectContour = Rect.fromLTWH(8, 8, width!,
              height! - 8); // -8 To give space for the shadow if at top
          pathContour = CDKDialogOuterShadowPainter.createContourPathArrowed(
              rectContour, arrowDiff, arrowAtBottom);
          final rectClip = Rect.fromLTWH(0, 0, width!,
              height! - 8); // -8 To give space for the shadow if at top
          pathClip = CDKDialogOuterShadowPainter.createContourPathArrowed(
              rectClip, arrowDiff, arrowAtBottom);

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
    super.dispose();
  }

  void hide() {
    overlayEntry?.remove();
    overlayEntry = null;
    widget.onHide?.call();
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    Color backgroundColor = !widget.isTranslucent
        ? theme.background
        : theme.isLight
            ? theme.background.withOpacity(0.25)
            : theme.background.withOpacity(0.5);

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
                painter: CDKDialogOuterShadowPainter(
                    pathContour: pathContour,
                    colorBackground: backgroundColor,
                    isLightTheme: theme.isLight),
                child: Container(),
              ),
              Positioned(
                  top: 8,
                  left: 8,
                  child: !widget.isTranslucent
                      ? dialogContents
                      : ClipPath(
                          clipper: CDKPopoverClipper(
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
              GestureDetector(
                onPanDown: (details) {
                  hide();
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  color: CDKTheme.transparent,
                  width: screenSize!.width,
                  height: screenSize!.height,
                ),
              ),
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
