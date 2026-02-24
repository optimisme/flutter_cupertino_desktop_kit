import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/cupertino.dart';

import 'cdk_dialog_adaptive_popover.dart';
import 'cdk_dialog_outer_shadow_painter.dart';
import 'cdk_dialog_popover_clipper.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKDialogPopoverArrowed extends StatefulWidget {
  final GlobalKey anchorKey;
  final bool isAnimated;
  final bool animateContentResize;
  final bool isTranslucent;
  final VoidCallback? onHide;
  final Widget child;

  const CDKDialogPopoverArrowed({
    super.key,
    required this.anchorKey,
    this.isAnimated = false,
    this.animateContentResize = true,
    this.isTranslucent = true,
    this.onHide,
    required this.child,
  });

  @override
  State<CDKDialogPopoverArrowed> createState() =>
      _CDKDialogPopoverArrowedState();
}

class _CDKDialogPopoverArrowedState extends State<CDKDialogPopoverArrowed> {
  static const double _chromePadding = 8.0;
  static const double _arrowInsetFromCorners = 16.0;

  CDKAdaptivePopoverGeometry _resolveGeometry({
    required Size childSize,
    required Rect anchorRect,
    required Size screenSize,
    required double screenPadding,
  }) {
    var width = childSize.width;
    var height = childSize.height + 8;

    final maxHeight = screenSize.height - (2 * screenPadding);
    final maxWidth = screenSize.width - (2 * screenPadding);
    if (height > maxHeight) {
      height = maxHeight;
    }
    if (width > maxWidth) {
      width = maxWidth;
    }

    var leftPosition = anchorRect.center.dx - (width / 2);
    final maxLeft = screenSize.width - width - screenPadding;
    leftPosition = leftPosition.clamp(screenPadding, maxLeft).toDouble();

    final topIfBelow = anchorRect.bottom + 4;
    final topIfAbove = anchorRect.top - height + 4;
    var topPosition = topIfBelow;
    if ((topPosition + height) > (screenSize.height - screenPadding)) {
      topPosition = topIfAbove;
    }
    final maxTop = screenSize.height - height - screenPadding;
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
    final anchorCenterX = anchorRect.center.dx;
    final dialogCenterX = geometry.left + (geometry.width / 2);
    final maxArrowDiff =
        math.max(0.0, (geometry.width / 2) - _arrowInsetFromCorners);
    final arrowDiff = (anchorCenterX - dialogCenterX)
        .clamp(-maxArrowDiff, maxArrowDiff)
        .toDouble();
    final arrowAtTop = anchorRect.center.dy <= (geometry.top + geometry.height);

    final contourHeight = math.max(0.0, geometry.height - 8);
    final rectContour = Rect.fromLTWH(
      _chromePadding,
      _chromePadding,
      geometry.width,
      contourHeight,
    );
    final pathContour = CDKDialogOuterShadowPainter.createContourPathArrowed(
      rectContour,
      arrowDiff,
      arrowAtTop,
    );
    final rectClip = Rect.fromLTWH(
      0,
      0,
      geometry.width,
      contourHeight,
    );
    final pathClip = CDKDialogOuterShadowPainter.createContourPathArrowed(
      rectClip,
      arrowDiff,
      arrowAtTop,
    );

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
