import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';

class LayoutDialogs extends StatefulWidget {
  const LayoutDialogs(
      {super.key});

  @override
  State<LayoutDialogs> createState() => _LayoutDialogsState();
}

class _LayoutDialogsState extends State<LayoutDialogs> {
  // Used to tell the popover where to show up
  final GlobalKey<DSKDialogPopoverState> _anchorPopover0 = GlobalKey();
  final GlobalKey<DSKDialogPopoverState> _anchorPopover1 = GlobalKey();
  final GlobalKey<DSKDialogPopoverState> _anchorPopover2 = GlobalKey();
  final GlobalKey<DSKDialogPopoverState> _anchorPopover3 = GlobalKey();
  final GlobalKey<DSKDialogPopoverState> _anchorDraggable0 = GlobalKey();
  final GlobalKey<DSKDialogPopoverState> _anchorDraggable1 = GlobalKey();
  final GlobalKey<DSKDialogPopoverState> _anchorDraggable2 = GlobalKey();
  final GlobalKey<DSKDialogPopoverState> _anchorDraggable3 = GlobalKey();
  final GlobalKey<DSKDialogPopoverState> _anchorArrowed0 = GlobalKey();
  final GlobalKey<DSKDialogPopoverState> _anchorArrowed1 = GlobalKey();
  final GlobalKey<DSKDialogPopoverState> _anchorArrowed2 = GlobalKey();
  final GlobalKey<DSKDialogPopoverState> _anchorArrowed3 = GlobalKey();

  _showPopover(BuildContext context, GlobalKey anchorKey, bool centered,
      bool animated, bool translucent) {
    final GlobalKey<DSKDialogPopoverState> key = GlobalKey();
    DSKDialogsManager.showPopover(
      key: key,
      context: context,
      anchorKey: anchorKey,
      type: centered ? DSKDialogPopoverType.center : DSKDialogPopoverType.down,
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
                  style: TextStyle(fontSize: 12, color: DSKColors.accent)),
            ),
          ],
        ),
      ),
    );
  }

  _showModal(BuildContext context, bool animated, bool translucent) {
    final GlobalKey<DSKDialogModalState> key = GlobalKey();
    DSKDialogsManager.showModal(
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
                  style: TextStyle(fontSize: 12, color: DSKColors.accent)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDraggable(BuildContext context, GlobalKey anchorKey, bool animated,
      bool translucent) {
    final GlobalKey<DSKDialogDraggableState> key = GlobalKey();
    DSKDialogsManager.showDraggable(
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
                    child: DSKButtonsBar(
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
                  style: TextStyle(fontSize: 12, color: DSKColors.accent)),
            ),
          ],
        ),
      ),
    );
  }

  _showPopoverArrowed(BuildContext context, GlobalKey anchorKey, bool animated,
      bool translucent) {
    final GlobalKey<DSKDialogPopoverArrowedState> key = GlobalKey();
    DSKDialogsManager.showPopoverArrowed(
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
                  style: TextStyle(fontSize: 12, color: DSKColors.accent)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            color: DSKColors.background,
            child: ListView(children: [
              const SizedBox(height: 8),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, color: DSKColors.text),
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
                  padding: EdgeInsets.all(8), child: Text('DSKDialogPopover:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      key: _anchorPopover0,
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showPopover(
                            context, _anchorPopover0, false, false, false);
                      },
                      child: const Text('Popover'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      key: _anchorPopover1,
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showPopover(
                            context, _anchorPopover1, true, false, true);
                      },
                      child: const Text('Centered translucent'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      key: _anchorPopover2,
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showPopover(
                            context, _anchorPopover2, true, true, false);
                      },
                      child: const Text('With animation'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      key: _anchorPopover3,
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showPopover(
                            context, _anchorPopover3, true, true, true);
                      },
                      child: const Text('Translucent with animation'),
                    )),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKDialogModal:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showModal(context, false, false);
                      },
                      child: const Text('Modal'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showModal(context, true, false);
                      },
                      child: const Text('With animation'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showModal(context, false, true);
                      },
                      child: const Text('Translucent'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showModal(context, true, true);
                      },
                      child: const Text('Translucent with animation'),
                    )),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('DSKDialogDraggable:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      key: _anchorDraggable0,
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showDraggable(
                            context, _anchorDraggable0, false, false);
                      },
                      child: const Text('Draggable'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      key: _anchorDraggable1,
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showDraggable(context, _anchorDraggable1, true, false);
                      },
                      child: const Text('With animation'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      key: _anchorDraggable2,
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showDraggable(context, _anchorDraggable2, false, true);
                      },
                      child: const Text('Translucent'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      key: _anchorDraggable3,
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showDraggable(context, _anchorDraggable3, true, true);
                      },
                      child: const Text('Translucent with animation'),
                    )),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKDialogArrow:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      key: _anchorArrowed0,
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showPopoverArrowed(
                            context, _anchorArrowed0, false, false);
                      },
                      child: const Text('Arrowed'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      key: _anchorArrowed1,
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showPopoverArrowed(
                            context, _anchorArrowed1, true, false);
                      },
                      child: const Text('With animation'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      key: _anchorArrowed2,
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showPopoverArrowed(
                            context, _anchorArrowed2, false, true);
                      },
                      child: const Text('Translucent'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      key: _anchorArrowed3,
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {
                        _showPopoverArrowed(
                            context, _anchorArrowed3, true, true);
                      },
                      child: const Text('Translucent with animation'),
                    )),
              ]),
              const SizedBox(height: 50),
            ]));
  }
}
