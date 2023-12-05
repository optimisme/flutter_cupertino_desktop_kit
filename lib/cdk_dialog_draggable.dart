import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_dialog_outer_shadow_painter.dart';
import 'cdk_dialog_popover_clipper.dart';
import 'cdk_dialogs_manager.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

// `CDKDialogDraggable` is a Flutter widget designed to be a draggable dialog
/// anchored to a specified key. It provides options for animation, translucency,
/// and callback when hidden. The dialog's appearance is dynamically determined
/// based on the child widget and anchor key.
///
/// Example Usage:
///
/// ```dart
/// CDKDialogDraggable(
///   anchorKey: GlobalKey(),
///   isAnimated: true,
///   isTranslucent: false,
///   onHide: () {
///     // Your callback logic here
///   },
///   child: YourDialogContentWidget(),
/// )
/// ```
///
/// The dialog adjusts its position and size based on the anchor widget and
/// screen dimensions. It also handles animations and shadow effects for a polished look.


class CDKDialogDraggable extends StatefulWidget {
  // Constructor parameters for the CDKDialogDraggable widget
  final GlobalKey anchorKey;
  final bool isAnimated;
  final bool isTranslucent;
  final Function? onHide;
  final Widget child;

  const CDKDialogDraggable({
    Key? key,
    required this.anchorKey,
    this.isAnimated = false,
    this.isTranslucent = false,
    this.onHide,
    required this.child,
  }) : super(key: key);

  @override
  CDKDialogDraggableState createState() => CDKDialogDraggableState();
}

// State class for CDKDialogDraggable
class CDKDialogDraggableState extends State<CDKDialogDraggable>
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
  Size? screenSize;
  double screenPadding = 10.0;
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
        setState(() {
          // Determine size and position of the dialog based on anchor widget and screen dimensions
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

          // Create paths for contour and clip
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
    overlayEntry?.remove();
    overlayEntry = null;
    widget.onHide?.call();
  }

  @override
  Widget build(BuildContext context) {
    // Obtain theme information
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    // Adjust position to fit within screen bounds if size is determined
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
        : Stack(children: [
            Positioned(
                left: position.dx - 8,
                top: position.dy - 8,
                height: height! + 16,
                width: width! + 16,
                child: GestureDetector(
                    onTapDown: (details) {
                      // Move the draggable dialog to the top
                      CDKDialogsManager.moveDraggableToTop(
                          context, widget.anchorKey);
                    },
                    onPanUpdate: (details) {
                      // Update position during drag
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
