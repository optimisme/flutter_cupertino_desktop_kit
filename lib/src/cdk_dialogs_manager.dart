import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'cdk_dialog_draggable.dart';
import 'cdk_dialog_modal.dart';
import 'cdk_dialog_popover.dart';
import 'cdk_dialog_popover_arrowed.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

typedef _ManagedDialogClose = void Function({bool cascade});

enum _CDKDialogKind { popover, popoverArrowed, modal, draggable }

class CDKDialogController extends ChangeNotifier {
  _ManagedDialogClose? _close;
  String? _dialogId;
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  void close() {
    _close?.call(cascade: true);
  }

  void _attach(String dialogId, _ManagedDialogClose close) {
    _dialogId = dialogId;
    _close = close;
    if (!_isOpen) {
      _isOpen = true;
      notifyListeners();
    }
  }

  void _detach(String dialogId, _ManagedDialogClose close) {
    if (_dialogId != dialogId || !identical(_close, close)) {
      return;
    }
    _dialogId = null;
    _close = null;
    if (_isOpen) {
      _isOpen = false;
      notifyListeners();
    }
  }
}

class _CDKDialogEntry {
  const _CDKDialogEntry({
    required this.id,
    required this.kind,
    required this.overlayEntry,
    required this.close,
    this.anchorKey,
  });

  final String id;
  final _CDKDialogKind kind;
  final OverlayEntry overlayEntry;
  final _ManagedDialogClose close;
  final GlobalKey? anchorKey;
}

class CDKDialogsManager {
  static final Map<String, _CDKDialogEntry> _entriesById =
      <String, _CDKDialogEntry>{};
  static final List<String> _stackOrder = <String>[];
  static final Map<GlobalKey, String> _popoverIdsByAnchor =
      <GlobalKey, String>{};
  static final Map<GlobalKey, String> _draggableIdsByAnchor =
      <GlobalKey, String>{};
  static int _nextId = 0;

  static void showPopover({
    Key? key,
    required BuildContext context,
    required GlobalKey anchorKey,
    CDKDialogPopoverType type = CDKDialogPopoverType.center,
    bool isAnimated = false,
    bool isTranslucent = false,
    bool dismissOnEscape = true,
    bool dismissOnOutsideTap = true,
    VoidCallback? onHide,
    CDKDialogController? controller,
    required Widget child,
  }) {
    final activeId = _popoverIdsByAnchor[anchorKey];
    if (activeId != null) {
      _moveDialogToTopById(context, activeId);
      return;
    }

    _showDialog(
      context: context,
      kind: _CDKDialogKind.popover,
      anchorKey: anchorKey,
      dismissOnEscape: dismissOnEscape,
      dismissOnOutsideTap: dismissOnOutsideTap,
      captureOutsidePointers: true,
      onHide: onHide,
      controller: controller,
      builder: (requestClose) => CDKDialogPopover(
        key: key,
        isAnimated: isAnimated,
        type: type,
        isTranslucent: isTranslucent,
        anchorKey: anchorKey,
        onHide: requestClose,
        child: child,
      ),
    );
  }

  static void showModal({
    Key? key,
    required BuildContext context,
    bool isAnimated = false,
    bool isTranslucent = false,
    bool dismissOnEscape = true,
    bool dismissOnOutsideTap = false,
    VoidCallback? onHide,
    CDKDialogController? controller,
    required Widget child,
  }) {
    _showDialog(
      context: context,
      kind: _CDKDialogKind.modal,
      dismissOnEscape: dismissOnEscape,
      dismissOnOutsideTap: dismissOnOutsideTap,
      captureOutsidePointers: true,
      closeExistingOfKind: true,
      onHide: onHide,
      controller: controller,
      builder: (requestClose) => CDKDialogModal(
        key: key,
        isAnimated: isAnimated,
        isTranslucent: isTranslucent,
        onHide: requestClose,
        child: child,
      ),
    );
  }

  static void showDraggable({
    Key? key,
    required BuildContext context,
    required GlobalKey anchorKey,
    bool isAnimated = false,
    bool isTranslucent = false,
    bool dismissOnEscape = true,
    bool dismissOnOutsideTap = false,
    VoidCallback? onHide,
    CDKDialogController? controller,
    required Widget child,
  }) {
    final activeId = _draggableIdsByAnchor[anchorKey];
    if (activeId != null) {
      _moveDialogToTopById(context, activeId);
      return;
    }

    _showDialog(
      context: context,
      kind: _CDKDialogKind.draggable,
      anchorKey: anchorKey,
      dismissOnEscape: dismissOnEscape,
      dismissOnOutsideTap: dismissOnOutsideTap,
      captureOutsidePointers: false,
      onHide: onHide,
      controller: controller,
      builder: (requestClose) => CDKDialogDraggable(
        key: key,
        anchorKey: anchorKey,
        isAnimated: isAnimated,
        isTranslucent: isTranslucent,
        onHide: requestClose,
        child: child,
      ),
    );
  }

  static void moveDraggableToTop(BuildContext context, GlobalKey anchorKey) {
    final id = _draggableIdsByAnchor[anchorKey];
    if (id == null) {
      return;
    }
    _moveDialogToTopById(context, id);
  }

  static void movePopoverToTop(BuildContext context, GlobalKey anchorKey) {
    final id = _popoverIdsByAnchor[anchorKey];
    if (id == null) {
      return;
    }
    _moveDialogToTopById(context, id);
  }

  static void showPopoverArrowed({
    Key? key,
    required BuildContext context,
    required GlobalKey anchorKey,
    bool isAnimated = false,
    bool isTranslucent = false,
    bool dismissOnEscape = true,
    bool dismissOnOutsideTap = true,
    VoidCallback? onHide,
    CDKDialogController? controller,
    required Widget child,
  }) {
    final activeId = _popoverIdsByAnchor[anchorKey];
    if (activeId != null) {
      _moveDialogToTopById(context, activeId);
      return;
    }

    _showDialog(
      context: context,
      kind: _CDKDialogKind.popoverArrowed,
      anchorKey: anchorKey,
      dismissOnEscape: dismissOnEscape,
      dismissOnOutsideTap: dismissOnOutsideTap,
      captureOutsidePointers: true,
      onHide: onHide,
      controller: controller,
      builder: (requestClose) => CDKDialogPopoverArrowed(
        key: key,
        anchorKey: anchorKey,
        isAnimated: isAnimated,
        isTranslucent: isTranslucent,
        onHide: requestClose,
        child: child,
      ),
    );
  }

  static void _showDialog({
    required BuildContext context,
    required _CDKDialogKind kind,
    GlobalKey? anchorKey,
    required bool dismissOnEscape,
    required bool dismissOnOutsideTap,
    required bool captureOutsidePointers,
    bool closeExistingOfKind = false,
    VoidCallback? onHide,
    CDKDialogController? controller,
    required Widget Function(VoidCallback requestClose) builder,
  }) {
    if (closeExistingOfKind) {
      final idsToClose = _stackOrder
          .where((id) => _entriesById[id]?.kind == kind)
          .toList(growable: false);
      for (final id in idsToClose) {
        _entriesById[id]?.close(cascade: false);
      }
    }

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      return;
    }

    final dialogId = '${kind.name}-${_nextId++}';
    final previousFocusNode = FocusManager.instance.primaryFocus;

    OverlayEntry? overlayEntry;
    late final _ManagedDialogClose closeDialog;
    bool isClosed = false;

    closeDialog = ({bool cascade = true}) {
      if (isClosed) {
        return;
      }
      isClosed = true;

      if (overlayEntry?.mounted ?? false) {
        overlayEntry!.remove();
      }

      _unregisterDialog(dialogId, anchorKey);
      controller?._detach(dialogId, closeDialog);
      _restoreFocus(previousFocusNode);
      onHide?.call();
    };

    overlayEntry = OverlayEntry(
      builder: (BuildContext overlayContext) => _CDKDialogHost(
        dialogId: dialogId,
        dismissOnEscape: dismissOnEscape,
        dismissOnOutsideTap: dismissOnOutsideTap,
        captureOutsidePointers: captureOutsidePointers,
        isTopMost: _isTopMost,
        onRequestClose: () => closeDialog(cascade: false),
        child: builder(() => closeDialog(cascade: false)),
      ),
    );

    final entry = _CDKDialogEntry(
      id: dialogId,
      kind: kind,
      overlayEntry: overlayEntry,
      close: closeDialog,
      anchorKey: anchorKey,
    );

    _registerDialog(entry, anchorKey);
    controller?._attach(dialogId, closeDialog);
    overlay.insert(overlayEntry);
  }

  static void _moveDialogToTopById(BuildContext context, String dialogId) {
    final entry = _entriesById[dialogId];
    final overlay = Overlay.maybeOf(context);
    if (entry == null || overlay == null || !entry.overlayEntry.mounted) {
      return;
    }

    entry.overlayEntry.remove();
    overlay.insert(entry.overlayEntry);

    _stackOrder.remove(dialogId);
    _stackOrder.add(dialogId);
  }

  static bool _isTopMost(String dialogId) {
    return _stackOrder.isNotEmpty && _stackOrder.last == dialogId;
  }

  static void _registerDialog(_CDKDialogEntry entry, GlobalKey? anchorKey) {
    _entriesById[entry.id] = entry;
    _stackOrder.add(entry.id);

    if (anchorKey == null) {
      return;
    }

    if (entry.kind == _CDKDialogKind.popover ||
        entry.kind == _CDKDialogKind.popoverArrowed) {
      _popoverIdsByAnchor[anchorKey] = entry.id;
      return;
    }

    if (entry.kind == _CDKDialogKind.draggable) {
      _draggableIdsByAnchor[anchorKey] = entry.id;
    }
  }

  static void _unregisterDialog(String dialogId, GlobalKey? anchorKey) {
    final entry = _entriesById.remove(dialogId);
    _stackOrder.remove(dialogId);

    if (entry == null || anchorKey == null) {
      return;
    }

    if (entry.kind == _CDKDialogKind.popover ||
        entry.kind == _CDKDialogKind.popoverArrowed) {
      if (_popoverIdsByAnchor[anchorKey] == dialogId) {
        _popoverIdsByAnchor.remove(anchorKey);
      }
      return;
    }

    if (entry.kind == _CDKDialogKind.draggable &&
        _draggableIdsByAnchor[anchorKey] == dialogId) {
      _draggableIdsByAnchor.remove(anchorKey);
    }
  }

  static void _restoreFocus(FocusNode? node) {
    if (node == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (node.context?.mounted ?? false) {
        node.requestFocus();
      }
    });
  }
}

class _CDKDialogHost extends StatefulWidget {
  const _CDKDialogHost({
    required this.dialogId,
    required this.dismissOnEscape,
    required this.dismissOnOutsideTap,
    required this.captureOutsidePointers,
    required this.isTopMost,
    required this.onRequestClose,
    required this.child,
  });

  final String dialogId;
  final bool dismissOnEscape;
  final bool dismissOnOutsideTap;
  final bool captureOutsidePointers;
  final bool Function(String dialogId) isTopMost;
  final VoidCallback onRequestClose;
  final Widget child;

  @override
  State<_CDKDialogHost> createState() => _CDKDialogHostState();
}

class _CDKDialogHostState extends State<_CDKDialogHost> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode(
    debugLabel: 'CDKDialogHost',
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _focusScopeNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey != LogicalKeyboardKey.escape ||
        !widget.dismissOnEscape ||
        !widget.isTopMost(widget.dialogId)) {
      return KeyEventResult.ignored;
    }

    widget.onRequestClose();
    return KeyEventResult.handled;
  }

  void _handleOutsidePointerDown() {
    if (!widget.isTopMost(widget.dialogId)) {
      return;
    }

    if (widget.dismissOnOutsideTap) {
      widget.onRequestClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? outsideLayer;
    if (widget.captureOutsidePointers) {
      outsideLayer = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => _handleOutsidePointerDown(),
        child: const SizedBox.expand(),
      );
    }

    return Positioned.fill(
      child: FocusScope(
        node: _focusScopeNode,
        autofocus: true,
        child: Focus(
          autofocus: true,
          onKeyEvent: _handleKeyEvent,
          child: Stack(
            children: [
              if (outsideLayer != null) outsideLayer,
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}
