import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop/ck_widgets.dart';

class LayoutDialogs extends StatefulWidget {
  const LayoutDialogs({super.key});

  @override
  State<LayoutDialogs> createState() => _LayoutDialogsState();
}

class _LayoutDialogsState extends State<LayoutDialogs> {
  // Used to tell the popover where to show up
  final GlobalKey<CKDialogPopoverState> _anchorPopover0 = GlobalKey();
  final GlobalKey<CKDialogPopoverState> _anchorPopover1 = GlobalKey();
  final GlobalKey<CKDialogPopoverState> _anchorPopover2 = GlobalKey();
  final GlobalKey<CKDialogPopoverState> _anchorPopover3 = GlobalKey();
  final GlobalKey<CKDialogPopoverState> _anchorDraggable0 = GlobalKey();
  final GlobalKey<CKDialogPopoverState> _anchorDraggable1 = GlobalKey();
  final GlobalKey<CKDialogPopoverState> _anchorDraggable2 = GlobalKey();
  final GlobalKey<CKDialogPopoverState> _anchorDraggable3 = GlobalKey();
  final GlobalKey<CKDialogPopoverState> _anchorArrowed0 = GlobalKey();
  final GlobalKey<CKDialogPopoverState> _anchorArrowed1 = GlobalKey();
  final GlobalKey<CKDialogPopoverState> _anchorArrowed2 = GlobalKey();
  final GlobalKey<CKDialogPopoverState> _anchorArrowed3 = GlobalKey();

  _showPopover(BuildContext context, GlobalKey anchorKey, CKTheme theme,
      bool centered, bool animated, bool translucent) {
    final GlobalKey<CKDialogPopoverState> key = GlobalKey();
    CKDialogsManager.showPopover(
      key: key,
      context: context,
      anchorKey: anchorKey,
      type: centered ? CKDialogPopoverType.center : CKDialogPopoverType.down,
      isAnimated: animated,
      isTranslucent: translucent,
      onHide: () {
        // ignore: avoid_print
        print("hide popover $key");
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Popover:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                key.currentState?.hide();
              },
              child: Text('Close popover',
                  style: TextStyle(fontSize: 12, color: theme.accent)),
            ),
          ],
        ),
      ),
    );
  }

  _showModal(
      BuildContext context, CKTheme theme, bool animated, bool translucent) {
    final GlobalKey<CKDialogModalState> key = GlobalKey();
    CKDialogsManager.showModal(
      key: key,
      context: context,
      isAnimated: animated,
      isTranslucent: translucent,
      onHide: () {
        // ignore: avoid_print
        print("hide modal $key");
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Modal:", style: TextStyle(fontSize: 16)),
            const SizedBox(width: 300, height: 300),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                key.currentState?.hide();
              },
              child: Text('Close modal',
                  style: TextStyle(fontSize: 12, color: theme.accent)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDraggable(BuildContext context, GlobalKey anchorKey, CKTheme theme,
      bool animated, bool translucent) {
    final GlobalKey<CKDialogDraggableState> key = GlobalKey();
    CKDialogsManager.showDraggable(
      key: key,
      context: context,
      anchorKey: anchorKey,
      isAnimated: animated,
      isTranslucent: translucent,
      onHide: () {
        // ignore: avoid_print
        print("hide draggable $key");
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Draggable:", style: TextStyle(fontSize: 16)),
            const SizedBox(width: 400, height: 250),
            const SizedBox(height: 10),
            SizedBox(
                width: 100,
                child: GestureDetector(
                    onTapDown: (details) {}, // prevent dragging
                    onPanUpdate: (details) {}, // prevent dragging
                    child: CKPickerButtonsBar(
                      options: const [
                        {"widget": Icon(CupertinoIcons.bold), "value": true},
                        {"widget": Icon(CupertinoIcons.italic), "value": false},
                        {
                          "widget": Icon(CupertinoIcons.underline),
                          "value": true
                        },
                        {
                          "widget": Icon(CupertinoIcons.strikethrough),
                          "value": false
                        }
                      ],
                      allowsMultipleSelection: true,
                      onChanged: (List<bool> options) {
                        // ignore: avoid_print
                        print("XX Segmented: $options");
                      },
                    ))),
            GestureDetector(
              onPanUpdate: (details) {}, // prevent dragging
              onTap: () {
                key.currentState?.hide();
              },
              child: Text('Close draggable',
                  style: TextStyle(fontSize: 12, color: theme.accent)),
            ),
          ],
        ),
      ),
    );
  }

  _showPopoverArrowed(BuildContext context, GlobalKey anchorKey, CKTheme theme,
      bool animated, bool translucent) {
    final GlobalKey<CKDialogPopoverArrowedState> key = GlobalKey();
    CKDialogsManager.showPopoverArrowed(
      key: key,
      context: context,
      anchorKey: anchorKey,
      isAnimated: animated,
      isTranslucent: translucent,
      onHide: () {
        // ignore: avoid_print
        print("hide arrowed $key");
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Arrowed:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                key.currentState?.hide();
              },
              child: Text('Close arrowed',
                  style: TextStyle(fontSize: 12, color: theme.accent)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CKTheme theme = CKThemeNotifier.of(context)!.changeNotifier;

    return ListView(children: [
      const SizedBox(height: 8),
      Padding(
          padding: const EdgeInsets.all(8),
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: theme.colorText),
              children: const <TextSpan>[
                TextSpan(
                    text: '*Important! ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'The shadow of translucent dialogs is not drawn properly on the web.'),
              ],
            ),
          )),
      const SizedBox(height: 8),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CKDialogPopover:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              key: _anchorPopover0,
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopover(
                    context, _anchorPopover0, theme, false, false, false);
              },
              child: const Text('Popover'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              key: _anchorPopover1,
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopover(
                    context, _anchorPopover1, theme, true, false, true);
              },
              child: const Text('Centered translucent'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              key: _anchorPopover2,
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopover(
                    context, _anchorPopover2, theme, true, true, false);
              },
              child: const Text('With animation'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              key: _anchorPopover3,
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopover(context, _anchorPopover3, theme, true, true, true);
              },
              child: const Text('Translucent with animation'),
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CKDialogModal:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showModal(context, theme, false, false);
              },
              child: const Text('Modal'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showModal(context, theme, true, false);
              },
              child: const Text('With animation'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showModal(context, theme, false, true);
              },
              child: const Text('Translucent'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showModal(context, theme, true, true);
              },
              child: const Text('Translucent with animation'),
            )),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CKDialogDraggable:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              key: _anchorDraggable0,
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showDraggable(context, _anchorDraggable0, theme, false, false);
              },
              child: const Text('Draggable'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              key: _anchorDraggable1,
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showDraggable(context, _anchorDraggable1, theme, true, false);
              },
              child: const Text('With animation'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              key: _anchorDraggable2,
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showDraggable(context, _anchorDraggable2, theme, false, true);
              },
              child: const Text('Translucent'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              key: _anchorDraggable3,
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showDraggable(context, _anchorDraggable3, theme, true, true);
              },
              child: const Text('Translucent with animation'),
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CKDialogArrow:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              key: _anchorArrowed0,
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopoverArrowed(
                    context, _anchorArrowed0, theme, false, false);
              },
              child: const Text('Arrowed'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              key: _anchorArrowed1,
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopoverArrowed(
                    context, _anchorArrowed1, theme, true, false);
              },
              child: const Text('With animation'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              key: _anchorArrowed2,
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopoverArrowed(
                    context, _anchorArrowed2, theme, false, true);
              },
              child: const Text('Translucent'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              key: _anchorArrowed3,
              style: CKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopoverArrowed(
                    context, _anchorArrowed3, theme, true, true);
              },
              child: const Text('Translucent with animation'),
            )),
      ]),
      const SizedBox(height: 50),
    ]);
  }
}
