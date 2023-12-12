import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_dialog_outer_shadow_painter.dart';
import 'cdk_dialog_popover_clipper.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

// `CDKDialogModal` is a Flutter widget representing a modal dialog.
/// It allows customization of animation, translucency, and provides a callback
/// when hidden. The appearance of the dialog is responsive to screen dimensions
/// and is centered by default.
///
/// Example Usage:
///
/// ```dart
/// CDKDialogModal(
///   isAnimated: true,
///   isTranslucent: false,
///   onHide: () {
///     // Your callback logic here
///   },
///   child: YourDialogContentWidget(),
/// )
/// ```
///
/// The dialog automatically adjusts its size and position based on screen dimensions.
/// It supports animations and shadow effects, providing a clean and responsive UI.

class CDKDialogModal extends StatefulWidget {
  // Constructor parameters for the CDKDialogModal widget
  final bool isAnimated;
  final bool isTranslucent;
  final Function? onHide;
  final Widget child;

  const CDKDialogModal({
    Key? key,
    this.isAnimated = false,
    this.isTranslucent = false,
    this.onHide,
    required this.child,
  }) : super(key: key);

  @override
  CDKDialogModalState createState() => CDKDialogModalState();
}

// State class for CDKDialogModal
class CDKDialogModalState extends State<CDKDialogModal>
    with SingleTickerProviderStateMixin {
  // Instance variables
  OverlayEntry? overlayEntry;
  final int _animationMillis = 200;
  AnimationController? animationController;
  Animation<double>? scaleAnimation;
  double? width;
  double? height;
  bool isSizeDetermined = false;
  GlobalKey childKey = GlobalKey();
  Offset position = const Offset(-10000000, -10000000); // Out of view until size is determined
  Path pathContour = Path();
  Path pathClip = Path();

  @override
  void initState() {
    super.initState();
    // Initialization logic when the widget is inserted into the tree
    if (widget.isAnimated) {
      // Setup animation controller if animation is enabled
      animationController = AnimationController(
        duration: Duration(milliseconds: _animationMillis),
        vsync: this,
      );

      // Apply bounce effect to the animation
      scaleAnimation = CurvedAnimation(
        parent: animationController!,
        curve: Curves.easeOutBack,
      );
    }

    // Execute code after the first frame is rendered
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (mounted && childKey.currentContext != null) {
        final RenderBox childRenderBox =
            childKey.currentContext!.findRenderObject() as RenderBox;
        final childSize = childRenderBox.size;

        setState(() {
          // Determine size and position of the dialog based on screen dimensions
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
    // Dispose of animation controller when the state is disposed
    animationController?.dispose();
    super.dispose();
  }

  // Method to hide the dialog
  void hide() {
    widget.onHide?.call();
  }

  @override
  Widget build(BuildContext context) {
    // Obtain theme information
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    // Determine background color based on transparency
    Color backgroundColor = !widget.isTranslucent
        ? theme.background
        : theme.isLight
            ? theme.background.withOpacity(0.25)
            : theme.background.withOpacity(0.5);

    // Create dialog contents widget
    Widget dialogContents = Container(
      key: childKey,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: widget.child,
    );

    // Construct the final widget tree with decorations
    Widget dialogWithDecorations = !isSizeDetermined
        ? Container()
        : Stack(
            children: [
              // Paint outer shadow
              CustomPaint(
                painter: CDKDialogOuterShadowPainter(
                    pathContour: pathContour,
                    colorBackground: backgroundColor,
                    isLightTheme: theme.isLight),
                child: Container(),
              ),
              // Position the dialog contents with clipping and blur for translucent dialogs
              Positioned(
                  top: 8,
                  left: 8,
                  child: !widget.isTranslucent
                      ? dialogContents
                      : ClipPath(
                          clipper: CDKPopoverClipper(
                              pathClip), // Apply the clip here
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 7.5,
                                sigmaY: 7.5), // Apply blur effect
                            child: dialogContents,
                          ),
                        ))
            ],
          );

    // Return the final widget tree
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
