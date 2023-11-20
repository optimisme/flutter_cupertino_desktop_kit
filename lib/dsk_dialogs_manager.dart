import 'package:flutter/cupertino.dart';
import 'dsk_dialog_draggable.dart';
import 'dsk_dialog_modal.dart';
import 'dsk_dialog_popover.dart';
import 'dsk_dialog_popover_arrowed.dart';

class DSKDialogsManager {
  static final Map<GlobalKey, GlobalKey> _activePopoverKeys = {};
  static GlobalKey? _activeModalKey;
  static final Map<GlobalKey, GlobalKey> _activeDraggableKeys = {};
  static final Map<GlobalKey, OverlayEntry> _activeDraggableEntries = {};

  static void _defaultFunction() {}

  static void showPopover({
    required GlobalKey key,
    required BuildContext context,
    required GlobalKey anchorKey,
    DSKDialogPopoverType type = DSKDialogPopoverType.center,
    bool isAnimated = false,
    bool isTranslucent = false,
    Function onHide = _defaultFunction,
    required Widget child,
  }) {
    if (_activePopoverKeys.containsKey(anchorKey)) {
      moveDraggableToTop(context, anchorKey);
      return;
    }
    _activePopoverKeys[anchorKey] = key;

    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => DSKDialogPopover(
        key: key,
        isAnimated: isAnimated,
        type: type,
        isTranslucent: isTranslucent,
        anchorKey: anchorKey,
        onHide: () {
          onHide();
          overlayEntry?.remove();
          _activePopoverKeys.remove(anchorKey);
          // Close all other popovers
          while (_activePopoverKeys.isNotEmpty) {
            var refKey = _activePopoverKeys.values.first;
            var state = refKey.currentState as DSKDialogPopoverState;
            state.hide();
          }
        },
        child: child,
      ),
    );

    // Insereix l'OverlayEntry en l'overlay
    Overlay.of(context).insert(overlayEntry);
  }

  static void showModal({
    required GlobalKey key,
    required BuildContext context,
    bool isAnimated = false,
    bool isTranslucent = false,
    Function onHide = _defaultFunction,
    required Widget child,
  }) {
    if (_activeModalKey is DSKDialogModalState) {
      var refKey = _activeModalKey as GlobalKey<DSKDialogModalState>;
      refKey.currentState?.hide();
    }
    _activeModalKey = key;

    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => DSKDialogModal(
        key: key,
        isAnimated: isAnimated,
        isTranslucent: isTranslucent,
        onHide: () {
          onHide();
          overlayEntry?.remove();
          _activeModalKey = null;
        },
        child: child,
      ),
    );

    // Insereix l'OverlayEntry en l'overlay
    Overlay.of(context).insert(overlayEntry);
  }

  static void showDraggable({
    required GlobalKey key,
    required BuildContext context,
    required GlobalKey anchorKey,
    bool isAnimated = false,
    bool isTranslucent = false,
    Function onHide = _defaultFunction,
    required Widget child,
  }) {
    if (_activeDraggableKeys.containsKey(anchorKey)) {
      moveDraggableToTop(context, anchorKey);
      return;
    }

    _activeDraggableKeys[anchorKey] = key;

    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => DSKDialogDraggable(
        key: key,
        anchorKey: anchorKey,
        isAnimated: isAnimated,
        isTranslucent: isTranslucent,
        onHide: () {
          onHide();
          overlayEntry?.remove();
          _activeDraggableKeys.remove(anchorKey);
        },
        child: child,
      ),
    );

    _activeDraggableEntries[anchorKey] = overlayEntry;

    // Insereix l'OverlayEntry en l'overlay
    Overlay.of(context).insert(overlayEntry);
  }

  static void moveDraggableToTop(BuildContext context, GlobalKey anchorKey) {
    OverlayEntry entry = _activeDraggableEntries[anchorKey]!;
    entry.remove();
    Overlay.of(context).insert(entry, above: null);
  }

  static void showPopoverArrowed({
    required GlobalKey key,
    required BuildContext context,
    required GlobalKey anchorKey,
    bool isAnimated = false,
    bool isTranslucent = false,
    Function onHide = _defaultFunction,
    required Widget child,
  }) {
    if (_activeDraggableKeys.containsKey(anchorKey)) {
      moveDraggableToTop(context, anchorKey);
      return;
    }

    _activeDraggableKeys[anchorKey] = key;

    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => DSKDialogPopoverArrowed(
        key: key,
        anchorKey: anchorKey,
        isAnimated: isAnimated,
        isTranslucent: isTranslucent,
        onHide: () {
          onHide();
          overlayEntry?.remove();
          _activeDraggableKeys.remove(anchorKey);
        },
        child: child,
      ),
    );

    _activeDraggableEntries[anchorKey] = overlayEntry;

    // Insereix l'OverlayEntry en l'overlay
    Overlay.of(context).insert(overlayEntry);
  }
}
