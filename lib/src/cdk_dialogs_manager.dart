import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'cdk_dialog_draggable.dart';
import 'cdk_dialog_confirm.dart';
import 'cdk_dialog_modal.dart';
import 'cdk_dialog_popover.dart';
import 'cdk_dialog_popover_arrowed.dart';
import 'cdk_dialog_prompt.dart';

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
    bool showBackgroundShade = false,
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
      showBackgroundShade: showBackgroundShade,
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
    bool showBackgroundShade = false,
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
      showBackgroundShade: showBackgroundShade,
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

  static Future<bool?> showConfirm({
    Key? key,
    required BuildContext context,
    String? title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
    bool isAnimated = false,
    bool isTranslucent = false,
    bool dismissOnOutsideTap = false,
    bool showBackgroundShade = true,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    if (Overlay.maybeOf(context) == null) {
      return Future<bool?>.value(null);
    }

    final controller = CDKDialogController();
    final completer = Completer<bool?>();
    bool? result;

    showModal(
      key: key,
      context: context,
      isAnimated: isAnimated,
      isTranslucent: isTranslucent,
      dismissOnEscape: true,
      dismissOnOutsideTap: dismissOnOutsideTap,
      showBackgroundShade: showBackgroundShade,
      controller: controller,
      onHide: () {
        if (result == null) {
          result = false;
          onCancel?.call();
        }
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      },
      child: CDKDialogConfirm(
        onRequestClose: controller.close,
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        onConfirm: () {
          result = true;
          onConfirm?.call();
        },
        onCancel: () {
          result = false;
          onCancel?.call();
        },
      ),
    );

    return completer.future;
  }

  static Future<String?> showPrompt({
    Key? key,
    required BuildContext context,
    String? title,
    String? message,
    String? placeholder,
    String? initialValue,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    CDKPromptValidator? validator,
    bool isDestructiveConfirm = false,
    bool isAnimated = false,
    bool isTranslucent = false,
    bool dismissOnOutsideTap = false,
    bool showBackgroundShade = true,
    ValueChanged<String>? onConfirm,
    VoidCallback? onCancel,
  }) {
    if (Overlay.maybeOf(context) == null) {
      return Future<String?>.value(null);
    }

    final controller = CDKDialogController();
    final completer = Completer<String?>();
    String? result;

    showModal(
      key: key,
      context: context,
      isAnimated: isAnimated,
      isTranslucent: isTranslucent,
      dismissOnEscape: true,
      dismissOnOutsideTap: dismissOnOutsideTap,
      showBackgroundShade: showBackgroundShade,
      controller: controller,
      onHide: () {
        if (result == null) {
          onCancel?.call();
        }
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      },
      child: CDKDialogPrompt(
        onRequestClose: controller.close,
        title: title,
        message: message,
        placeholder: placeholder,
        initialValue: initialValue,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        validator: validator,
        isDestructiveConfirm: isDestructiveConfirm,
        onConfirm: (value) {
          result = value;
          onConfirm?.call(value);
        },
        onCancel: onCancel,
      ),
    );

    return completer.future;
  }

  static void showDraggable({
    Key? key,
    required BuildContext context,
    required GlobalKey anchorKey,
    bool isAnimated = false,
    bool isTranslucent = false,
    bool dismissOnEscape = true,
    bool dismissOnOutsideTap = false,
    bool showBackgroundShade = false,
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
      showBackgroundShade: showBackgroundShade,
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
    bool showBackgroundShade = false,
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
      showBackgroundShade: showBackgroundShade,
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
    required bool showBackgroundShade,
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
        showBackgroundShade: showBackgroundShade,
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
    required this.showBackgroundShade,
    required this.isTopMost,
    required this.onRequestClose,
    required this.child,
  });

  final String dialogId;
  final bool dismissOnEscape;
  final bool dismissOnOutsideTap;
  final bool captureOutsidePointers;
  final bool showBackgroundShade;
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
  static const Map<ShortcutActivator, Intent> _shortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
  };

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

  Object? _handleDismissIntent(DismissIntent intent) {
    if (widget.dismissOnEscape && widget.isTopMost(widget.dialogId)) {
      widget.onRequestClose();
    }
    return null;
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
    final shouldBuildBarrier =
        widget.captureOutsidePointers || widget.showBackgroundShade;
    if (shouldBuildBarrier) {
      outsideLayer = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => _handleOutsidePointerDown(),
        child: ColoredBox(
          color: widget.showBackgroundShade
              ? const Color.fromRGBO(96, 96, 96, 0.28)
              : const Color(0x00000000),
          child: const SizedBox.expand(),
        ),
      );
    }

    return Positioned.fill(
      child: FocusScope(
        node: _focusScopeNode,
        autofocus: true,
        child: FocusTraversalGroup(
          policy: ReadingOrderTraversalPolicy(),
          child: Shortcuts(
            shortcuts: _shortcuts,
            child: Actions(
              actions: <Type, Action<Intent>>{
                DismissIntent: CallbackAction<DismissIntent>(
                  onInvoke: _handleDismissIntent,
                ),
              },
              child: Focus(
                autofocus: true,
                child: Stack(
                  children: [
                    if (outsideLayer != null) outsideLayer,
                    widget.child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
