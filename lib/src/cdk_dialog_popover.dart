import 'dart:ui';
import 'package:flutter/cupertino.dart';

import 'cdk_dialog_adaptive_popover.dart';
import 'cdk_dialog_outer_shadow_painter.dart';
import 'cdk_dialog_popover_clipper.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

enum CDKDialogPopoverType { down, center, side }
// TODO 'side' type

class CDKDialogPopover extends StatefulWidget {
  final GlobalKey anchorKey;
  final CDKDialogPopoverType type;
  final bool isAnimated;
  final bool animateContentResize;
  final bool isTranslucent;
  final VoidCallback? onHide;
  final Widget child;

  const CDKDialogPopover({
    super.key,
    required this.anchorKey,
    this.type = CDKDialogPopoverType.center,
    this.isAnimated = false,
    this.animateContentResize = true,
    this.isTranslucent = false,
    this.onHide,
    required this.child,
  });

  @override
  State<CDKDialogPopover> createState() => _CDKDialogPopoverState();
}

class _CDKDialogPopoverState extends State<CDKDialogPopover> {
  static const double _chromePadding = 8.0;

  CDKAdaptivePopoverGeometry _resolveGeometry({
    required Size childSize,
    required Rect anchorRect,
    required Size screenSize,
    required double screenPadding,
  }) {
    var width = childSize.width;
    var height = childSize.height;

    final maxHeight = screenSize.height - (2 * screenPadding);
    final maxWidth = screenSize.width - (2 * screenPadding);
    if (height > maxHeight) {
      height = maxHeight;
    }
    if (width > maxWidth) {
      width = maxWidth;
    }

    var leftPosition = anchorRect.left;
    var topPosition = anchorRect.bottom;

    if (widget.type == CDKDialogPopoverType.center) {
      leftPosition = anchorRect.center.dx - (width / 2);
      topPosition = anchorRect.center.dy - (height / 2);
    }

    final maxLeft = screenSize.width - width - screenPadding;
    final maxTop = screenSize.height - height - screenPadding;
    leftPosition = leftPosition.clamp(screenPadding, maxLeft).toDouble();
    topPosition = topPosition.clamp(screenPadding, maxTop).toDouble();

    return CDKAdaptivePopoverGeometry(
      left: leftPosition,
      top: topPosition,
      width: width,
      height: height,
    );
  }

  Widget _buildSurface({
    required BuildContext context,
    required Widget dialogContents,
    required CDKAdaptivePopoverGeometry geometry,
    required Rect anchorRect,
    required Color backgroundColor,
    required bool isLightTheme,
    required bool isTranslucent,
  }) {
    final rectContour = Rect.fromLTWH(
      _chromePadding,
      _chromePadding,
      geometry.width,
      geometry.height,
    );
    final pathContour = CDKDialogOuterShadowPainter.createContourPath(
      rectContour,
    );
    final rectClip = Rect.fromLTWH(
      0,
      0,
      geometry.width,
      geometry.height,
    );
    final pathClip = CDKDialogOuterShadowPainter.createContourPath(rectClip);

    return Stack(
      children: [
        CustomPaint(
          painter: CDKDialogOuterShadowPainter(
            pathContour: pathContour,
            colorBackground: backgroundColor,
            isLightTheme: isLightTheme,
          ),
          child: Container(),
        ),
        Positioned(
          top: _chromePadding,
          left: _chromePadding,
          child: !isTranslucent
              ? dialogContents
              : ClipPath(
                  clipper: CDKPopoverClipper(pathClip),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                    child: dialogContents,
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CDKAdaptivePopoverContainer(
      anchorKey: widget.anchorKey,
      isAnimated: widget.isAnimated,
      animateContentResize: widget.animateContentResize,
      isTranslucent: widget.isTranslucent,
      onHide: widget.onHide,
      geometryResolver: _resolveGeometry,
      surfaceBuilder: _buildSurface,
      child: widget.child,
    );
  }
}
