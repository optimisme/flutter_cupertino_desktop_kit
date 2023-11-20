import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'dsk_dialog_outer_shadow_painter.dart';
import 'dsk_dialog_popover_clipper.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

class DSKDialogPopoverArrowed extends StatefulWidget {
  final GlobalKey anchorKey;
  final bool isAnimated;
  final bool isTranslucent;
  final Function? onHide;
  final Widget child;

  const DSKDialogPopoverArrowed({
    Key? key,
    required this.anchorKey,
    this.isAnimated = false,
    this.isTranslucent = true,
    this.onHide,
    required this.child,
  }) : super(key: key);

  @override
  DSKDialogPopoverArrowedState createState() => DSKDialogPopoverArrowedState();
}

class DSKDialogPopoverArrowedState extends State<DSKDialogPopoverArrowed>
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

          var leftPosition =
              anchorPosition.dx + (anchorSize.width / 2) - width! / 2;
          var topPosition = anchorPosition.dy + anchorSize.height + 4;

          if (leftPosition + width! > screenSize!.width - screenPadding) {
            leftPosition = screenSize!.width - width! - screenPadding;
          }
          if (leftPosition < screenPadding) {
            leftPosition = screenPadding;
          }

          if (topPosition + height! > screenSize!.height - screenPadding) {
            topPosition = screenSize!.height - height! - screenPadding;
          }

          if (topPosition < screenPadding) {
            topPosition = screenPadding;
          }

          position = Offset(leftPosition, topPosition);
          /* TODO position arrow properly
          Offset arrowCenter = Offset(
              (anchorPosition.dx + anchorSize.width / 2) - position.dx,
              (anchorPosition.dy + anchorSize.height / 2) - position.dy);
          */
          final rectContour = Rect.fromLTWH(8, 8, width!, height!);
          pathContour =
              DSKDialogOuterShadowPainter.createContourPathArrowed(rectContour);
          final rectClip = Rect.fromLTWH(0, 0, width!, height!);
          pathClip =
              DSKDialogOuterShadowPainter.createContourPathArrowed(rectClip);

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
    if (widget.onHide != null) {
      widget.onHide!();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = !widget.isTranslucent
        ? DSKColors.backgroundSecondary0
        : DSKThemeManager.isLight
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
                    pathContour: pathContour, backgroundColor: backgroundColor),
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
              GestureDetector(
                onTap: () {
                  hide();
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  color: DSKColors.transparent,
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