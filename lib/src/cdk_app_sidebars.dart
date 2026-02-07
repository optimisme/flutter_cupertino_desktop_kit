import 'package:flutter/cupertino.dart';
import 'cdk_theme.dart';
import 'cdk_theme_notifier.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKAppSidebarsController extends ChangeNotifier {
  ValueChanged<bool>? _setSidebarLeftVisibility;
  ValueChanged<bool>? _setSidebarRightVisibility;
  bool _isSidebarLeftVisible = false;
  bool _isSidebarRightVisible = false;

  bool get isSidebarLeftVisible => _isSidebarLeftVisible;
  bool get isSidebarRightVisible => _isSidebarRightVisible;

  void setSidebarLeftVisibility(bool isVisible) {
    _setSidebarLeftVisibility?.call(isVisible);
  }

  void setSidebarRightVisibility(bool isVisible) {
    _setSidebarRightVisibility?.call(isVisible);
  }

  void _bind({
    required ValueChanged<bool> setSidebarLeftVisibility,
    required ValueChanged<bool> setSidebarRightVisibility,
  }) {
    _setSidebarLeftVisibility = setSidebarLeftVisibility;
    _setSidebarRightVisibility = setSidebarRightVisibility;
  }

  void _unbind() {
    _setSidebarLeftVisibility = null;
    _setSidebarRightVisibility = null;
  }

  void _update({
    required bool isSidebarLeftVisible,
    required bool isSidebarRightVisible,
  }) {
    final changed = _isSidebarLeftVisible != isSidebarLeftVisible ||
        _isSidebarRightVisible != isSidebarRightVisible;

    _isSidebarLeftVisible = isSidebarLeftVisible;
    _isSidebarRightVisible = isSidebarRightVisible;

    if (changed) {
      notifyListeners();
    }
  }
}

class CDKAppSidebars extends StatefulWidget {
  final Widget central;
  final bool sidebarLeftIsResizable;
  final bool sidebarLeftDefaultsVisible;
  final double sidebarLeftMinWidth;
  final double sidebarLeftMaxWidth;
  final Widget? sidebarLeft;
  final bool sidebarRightDefaultsVisible;
  final double sidebarRightWidth;
  final Widget? sidebarRight;
  final CDKAppSidebarsController? controller;

  const CDKAppSidebars({
    super.key,
    required this.central,
    this.sidebarLeftIsResizable = true,
    this.sidebarLeftDefaultsVisible = false,
    this.sidebarLeftMinWidth = 100.0,
    this.sidebarLeftMaxWidth = 200.0,
    this.sidebarLeft,
    this.sidebarRightDefaultsVisible = false,
    this.sidebarRightWidth = 200.0,
    this.sidebarRight,
    this.controller,
  });

  @override
  State<CDKAppSidebars> createState() => _CDKAppSidebarsState();
}

class _CDKAppSidebarsState extends State<CDKAppSidebars> {
  MouseCursor _cursor = SystemMouseCursors.basic;
  int _animationMillis = 200;
  double _sidebarLeftWidth = 0.0;
  bool _sidebarLeftDragging = false;
  double _sidebarLeftOriginX = 0.0;
  double _sidebarLeftDragX = 0.0;
  bool _sidebarLeftIsVisible = false;
  bool _sidebarRightIsVisible = false;
  void setSidebarLeftVisibility(bool isVisible) {
    setState(() {
      _sidebarLeftIsVisible = isVisible;
      _syncControllerVisibility();
    });
  }

  void setSidebarRightVisibility(bool isVisible) {
    setState(() {
      _sidebarRightIsVisible = isVisible;
      _syncControllerVisibility();
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
                color: CDKTheme.transparent,
              )),
        ));
  }

  @override
  void initState() {
    super.initState();
    _sidebarLeftWidth = widget.sidebarLeftMaxWidth;
    _sidebarLeftIsVisible = widget.sidebarLeftDefaultsVisible;
    _sidebarRightIsVisible = widget.sidebarRightDefaultsVisible;
    _bindController();
    _syncControllerVisibility();
  }

  @override
  void didUpdateWidget(covariant CDKAppSidebars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._unbind();
      _bindController();
      _syncControllerVisibility();
    }
  }

  @override
  void dispose() {
    widget.controller?._unbind();
    super.dispose();
  }

  void _bindController() {
    widget.controller?._bind(
      setSidebarLeftVisibility: setSidebarLeftVisibility,
      setSidebarRightVisibility: setSidebarRightVisibility,
    );
  }

  void _syncControllerVisibility() {
    widget.controller?._update(
      isSidebarLeftVisible: _sidebarLeftIsVisible,
      isSidebarRightVisible: _sidebarRightIsVisible,
    );
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    if (widget.sidebarLeft == null) {
      _sidebarLeftIsVisible = false;
    }

    if (widget.sidebarRight == null) {
      _sidebarRightIsVisible = false;
    }

    _syncControllerVisibility();

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
                child: Container(
                  color: theme.backgroundSecondary1,
                  child: widget.sidebarLeft != null
                      ? widget.sidebarLeft!
                      : Container(),
                )),
            // Right Sidebar limit
            Positioned(
                right: widget.sidebarRightWidth - 1,
                top: 0,
                bottom: 0,
                width: 1,
                child: Container(color: CDKTheme.grey60)),
            // Right Sidebar1
            Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: widget.sidebarRightWidth - 0.75,
                child: Container(
                  color: theme.backgroundSecondary1,
                  child: widget.sidebarRight != null
                      ? widget.sidebarRight!
                      : Container(),
                )),
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
              right: _sidebarRightIsVisible ? widget.sidebarRightWidth : 0,
              top: 0,
              bottom: 0,
              child: Container(
                  decoration: BoxDecoration(
                    color: theme.background,
                    boxShadow: [
                      BoxShadow(
                        color: CDKTheme.grey500.withValues(alpha: 0.3),
                        spreadRadius: 0,
                        blurRadius: 0.75,
                        offset: const Offset(-1, 1),
                      ),
                    ],
                  ),
                  child: widget.central),
            ),
          ],
        ));
  }
}
