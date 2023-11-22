import 'package:flutter/cupertino.dart';
import 'dsk_theme_colors.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// Creates a layout with two sidebars and a central content area.
///
/// The sidebars can be resized and hidden, and the central content area can be
/// animated to slide in and out when the sidebars are toggled.
class DSKAppSidebars extends StatefulWidget {
  /// The central content widget.
  final Widget central;

  /// Whether the left sidebar is resizable.
  final bool sidebarLeftIsResizable;

  /// Whether the left sidebar is visible by default.
  final bool sidebarLeftDefaultsVisible;

  /// The minimum width of the left sidebar.
  final double sidebarLeftMinWidth;

  /// The maximum width of the left sidebar.
  final double sidebarLeftMaxWidth;

  /// The widget to display in the left sidebar.
  final Widget? sidebarLeft;

  /// Whether the right sidebar is visible by default.
  final bool sidebarRightDefaultsVisible;

  /// The width of the right sidebar.
  final double sidebarRightWidth;

  /// The widget to display in the right sidebar.
  final Widget? sidebarRight;

  /// The state of the `DSKAppSidebars` widget.
  ///
  /// This class manages the state of the sidebars, including their visibility
  /// and width.
  const DSKAppSidebars({
    Key? key,
    required this.central,
    this.sidebarLeftIsResizable = true,
    this.sidebarLeftDefaultsVisible = false,
    this.sidebarLeftMinWidth = 100.0,
    this.sidebarLeftMaxWidth = 200.0,
    this.sidebarLeft,
    this.sidebarRightDefaultsVisible = false,
    this.sidebarRightWidth = 200.0,
    this.sidebarRight,
  }) : super(key: key);

  @override
  DSKAppSidebarsState createState() => DSKAppSidebarsState();
}

/// The state of the `DSKAppSidebars` widget.
///
/// This class manages the state of the sidebars, including their visibility
/// and width.
class DSKAppSidebarsState extends State<DSKAppSidebars> {
  /// The current cursor for the mouse.
  MouseCursor _cursor = SystemMouseCursors.basic;

  /// The duration of the sidebar animation.
  int _animationMillis = 200;

  /// The width of the left sidebar.
  double _sidebarLeftWidth = 0.0;

  /// Whether the left sidebar is currently being dragged.
  bool _sidebarLeftDragging = false;

  /// The original position of the left sidebar during dragging.
  double _sidebarLeftOriginX = 0.0;

  /// The current position of the mouse during dragging.
  double _sidebarLeftDragX = 0.0;

  /// Whether the left sidebar is visible.
  bool _sidebarLeftIsVisible = false;

  /// The width of the right sidebar.
  double _sidebarRightWidth = 0.0;

  /// Whether the right sidebar is visible.
  bool _sidebarRightIsVisible = false;

  /// Determines whether the left sidebar is visible.
  bool get isSidebarLeftVisible => _sidebarLeftIsVisible;

  /// Determines whether the right sidebar is visible.
  bool get isSidebarRightVisible => _sidebarRightIsVisible;

  /// Sets the visibility of the left sidebar.
  ///
  /// @param isVisible The new visibility state of the left sidebar.
  set isSidebarLeftVisible(bool isVisible) {
    setState(() {
      _sidebarLeftIsVisible = isVisible;
    });
  }

  /// Sets the visibility of the right sidebar.
  ///
  /// @param isVisible The new visibility state of the right sidebar.
  set isSidebarRightVisible(bool isVisible) {
    setState(() {
      _sidebarRightIsVisible = isVisible;
    });
  }

  /// Controls the visibility of the left sidebar.
  ///
  /// @param isVisible The new visibility state of the left sidebar.
  void setSidebarLeftVisibility(bool isVisible) {
    setState(() {
      _sidebarLeftIsVisible = isVisible;
    });
  }

  /// Controls the visibility of the right sidebar.
  ///
  /// @param isVisible The new visibility state of the right sidebar.
  void setSidebarRightVisibility(bool isVisible) {
    setState(() {
      _sidebarRightIsVisible = isVisible;
    });
  }

  Widget _sidebarLeftHandle() {
    double maxWidth = widget.sidebarLeftMaxWidth;
    double minWidth = widget.sidebarLeftMinWidth;
    double jmpWidth = widget.sidebarLeftMinWidth - 50.0;
    return MouseRegion(
        onEnter: (event) => {
              setState(
                () => _cursor = SystemMouseCursors.resizeColumn,
              )
            },
        onExit: (event) => {
              if (!_sidebarLeftDragging)
                {
                  setState(
                    () => _cursor = SystemMouseCursors.basic,
                  )
                }
            },
        child: GestureDetector(
          onHorizontalDragStart: (details) {
            setState(() {
              _sidebarLeftOriginX = _sidebarLeftWidth;
              _sidebarLeftDragX = details.localPosition.dx;
              _cursor = SystemMouseCursors.resizeColumn;
              _sidebarLeftDragging = true;
            });
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              double diff = _sidebarLeftDragX - details.localPosition.dx;
              double tmpWidth = _sidebarLeftOriginX - diff;
              bool isVisible = true;
              if (tmpWidth > maxWidth) {
                _sidebarLeftWidth = maxWidth;
              } else if (tmpWidth < jmpWidth) {
                _sidebarLeftWidth = maxWidth;
                isVisible = false;
              } else if (tmpWidth < minWidth) {
                _sidebarLeftWidth = minWidth;
              } else {
                _sidebarLeftWidth = tmpWidth;
              }
              if (isVisible != _sidebarLeftIsVisible) {
                _sidebarLeftIsVisible = isVisible;
              }
            });
          },
          onHorizontalDragEnd: (details) {
            setState(() {
              _cursor = SystemMouseCursors.basic;
              _sidebarLeftDragging = false;
            });
          },
          child: Container(
              width: 2.5,
              decoration: const BoxDecoration(
                color: DSKColors.transparent,
              )),
        ));
  }

  @override
  void initState() {
    super.initState();
    _sidebarLeftWidth = widget.sidebarLeftMaxWidth;
    _sidebarLeftIsVisible = widget.sidebarLeftDefaultsVisible;
    _sidebarRightWidth = widget.sidebarRightWidth;
    _sidebarRightIsVisible = widget.sidebarRightDefaultsVisible;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sidebarLeft == null) {
      _sidebarLeftIsVisible = false;
    }

    if (widget.sidebarRight == null) {
      _sidebarRightIsVisible = false;
    }

    if (_sidebarLeftDragging) {
      _animationMillis = 0;
    } else {
      _animationMillis = 200;
    }

    return MouseRegion(
        cursor: _cursor,
        child: Stack(
          children: [
            // Left Sidebar
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: _sidebarLeftWidth,
              child: widget.sidebarLeft != null
                  ? widget.sidebarLeft!
                  : Container(),
            ),
            // Right Sidebar
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: widget.sidebarRightWidth,
              child: widget.sidebarRight != null
                  ? widget.sidebarRight!
                  : Container(),
            ),
            // Left resize handle (right is not resizable)
            (widget.sidebarLeft != null && widget.sidebarLeftIsResizable)
                ? AnimatedPositioned(
                    duration: Duration(milliseconds: _animationMillis),
                    left: _sidebarLeftIsVisible ? _sidebarLeftWidth - 1 : -10,
                    width: 2,
                    top: 0,
                    bottom: 0,
                    child: _sidebarLeftHandle())
                : Container(),
            // Main content
            AnimatedPositioned(
              duration: Duration(milliseconds: _animationMillis),
              left: _sidebarLeftIsVisible ? _sidebarLeftWidth : 0,
              right: _sidebarRightIsVisible ? _sidebarRightWidth : 0,
              top: 0,
              bottom: 0,
              child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: DSKColors.grey500.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: widget.central),
            ),
          ],
        ));
  }
}
