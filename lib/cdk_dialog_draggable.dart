import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_dialog_outer_shadow_painter.dart';
import 'cdk_dialog_popover_clipper.dart';
import 'cdk_dialogs_manager.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKDialogDraggable extends StatefulWidget {
  final GlobalKey anchorKey;
  final bool isAnimated;
  final bool isTranslucent;
  final Function? onHide;
  final Widget child;

  const CDKDialogDraggable({
    super.key,
    required this.anchorKey,
    this.isAnimated = false,
    this.isTranslucent = false,
    this.onHide,
    required this.child,
  });

  @override
  CDKDialogDraggableState createState() => CDKDialogDraggableState();
}

class CDKDialogDraggableState extends State<CDKDialogDraggable>
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
          final RenderBox childRenderBox =
              childKey.currentContext!.findRenderObject() as RenderBox;
          final childSize = childRenderBox.size;
          final RenderBox renderBox =
              widget.anchorKey.currentContext!.findRenderObject() as RenderBox;
          final anchorPosition = renderBox.localToGlobal(Offset.zero);
          final anchorCenterX = anchorPosition.dx + renderBox.size.width / 2;
          final anchorCenterY = anchorPosition.dy + renderBox.size.height / 2;

          var leftPosition = anchorCenterX - childSize.width / 2;
          var topPosition = anchorCenterY - childSize.height / 2;
          position = Offset(leftPosition, topPosition);
          width = childSize.width;
          height = childSize.height;

          screenSize = MediaQuery.of(context).size;

          double maxHeight = screenSize!.height - 2 * screenPadding;
          double maxWidth = screenSize!.width - 2 * screenPadding;

          if (height! > maxHeight) {
            height = maxHeight;
          }

          if (width! > maxWidth) {
            width = maxWidth;
          }

          final rectContour = Rect.fromLTWH(8, 8, width!, height!);
          pathContour =
              CDKDialogOuterShadowPainter.createContourPath(rectContour);
          final rectClip = Rect.fromLTWH(0, 0, width!, height!);
          pathClip = CDKDialogOuterShadowPainter.createContourPath(rectClip);

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

    if (isSizeDetermined) {
      var leftPosition = position.dx;
      var topPosition = position.dy;
      if (position.dx < screenPadding) {
        leftPosition = screenPadding;
      }

      if (position.dy < screenPadding) {
        topPosition = screenPadding;
      }

      if (position.dx + width! > screenSize!.width - screenPadding) {
        leftPosition = screenSize!.width - screenPadding - width!;
      }

      if (position.dy + height! > screenSize!.height - screenPadding) {
        topPosition = screenSize!.height - screenPadding - height!;
      }

      position = Offset(leftPosition, topPosition);
    }

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
        : Stack(children: [
            Positioned(
                left: position.dx - 8,
                top: position.dy - 8,
                height: height! + 16,
                width: width! + 16,
                child: GestureDetector(
                    onTapDown: (details) {
                      CDKDialogsManager.moveDraggableToTop(
                          context, widget.anchorKey);
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        position += details.delta;
                      });
                    },
                    child: widget.isAnimated && scaleAnimation != null
                        ? ScaleTransition(
                            scale: scaleAnimation!,
                            child: dialogWithDecorations,
                          )
                        : dialogWithDecorations)),
          ]);
  }
}
