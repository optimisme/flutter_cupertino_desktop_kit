import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/flutter_cupertino_desktop_kit.dart';

class LayoutDialogs extends StatefulWidget {
  const LayoutDialogs({super.key});

  @override
  State<LayoutDialogs> createState() => _LayoutDialogsState();
}

class _LayoutDialogsState extends State<LayoutDialogs> {
  // Used to tell the popover where to show up
  final GlobalKey _anchorPopoverSlider = GlobalKey();
  final GlobalKey _anchorPopover0 = GlobalKey();
  final GlobalKey _anchorPopover1 = GlobalKey();
  final GlobalKey _anchorPopover2 = GlobalKey();
  final GlobalKey _anchorPopover3 = GlobalKey();
  final GlobalKey _anchorDraggable0 = GlobalKey();
  final GlobalKey _anchorDraggable1 = GlobalKey();
  final GlobalKey _anchorDraggable2 = GlobalKey();
  final GlobalKey _anchorDraggable3 = GlobalKey();
  final GlobalKey _anchorArrowed0 = GlobalKey();
  final GlobalKey _anchorArrowed1 = GlobalKey();
  final GlobalKey _anchorArrowed2 = GlobalKey();
  final GlobalKey _anchorArrowed3 = GlobalKey();
  final ValueNotifier<double> _sliderValueNotifier = ValueNotifier(0.5);
  String _dialogResult = 'Result: none';

  _showPopover(BuildContext context, GlobalKey anchorKey, CDKTheme theme,
      bool centered, bool animated, bool translucent) {
    final controller = CDKDialogController();
    if (anchorKey.currentContext == null) {
      // ignore: avoid_print
      print("Error: anchorKey not assigned to a widget");
      return;
    }
    CDKDialogsManager.showPopover(
      context: context,
      anchorKey: anchorKey,
      type: centered ? CDKDialogPopoverType.center : CDKDialogPopoverType.down,
      isAnimated: animated,
      isTranslucent: translucent,
      controller: controller,
      onHide: () {
        // ignore: avoid_print
        print("hide popover");
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
                controller.close();
              },
              child: Text('Close popover',
                  style: TextStyle(fontSize: 12, color: theme.accent)),
            ),
          ],
        ),
      ),
    );
  }

  _showModal(BuildContext context, CDKTheme theme, bool animated,
      bool translucent, bool shaded) {
    final controller = CDKDialogController();
    CDKDialogsManager.showModal(
      context: context,
      isAnimated: animated,
      isTranslucent: translucent,
      showBackgroundShade: shaded,
      controller: controller,
      onHide: () {
        // ignore: avoid_print
        print("hide modal");
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
                controller.close();
              },
              child: Text('Close modal',
                  style: TextStyle(fontSize: 12, color: theme.accent)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDraggable(BuildContext context, GlobalKey anchorKey, CDKTheme theme,
      bool animated, bool translucent) {
    final controller = CDKDialogController();
    if (anchorKey.currentContext == null) {
      // ignore: avoid_print
      print("Error: anchorKey not assigned to a widget");
      return;
    }
    CDKDialogsManager.showDraggable(
      context: context,
      anchorKey: anchorKey,
      isAnimated: animated,
      isTranslucent: translucent,
      controller: controller,
      onHide: () {
        // ignore: avoid_print
        print("hide draggable");
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Draggable:", style: TextStyle(fontSize: 16)),
            const SizedBox(width: 400, height: 250),
            const SizedBox(height: 10),
            GestureDetector(
              onPanUpdate: (details) {}, // prevent dragging
              onTap: () {
                controller.close();
              },
              child: Text('Close draggable',
                  style: TextStyle(fontSize: 12, color: theme.accent)),
            ),
          ],
        ),
      ),
    );
  }

  _showPopoverArrowed(BuildContext context, GlobalKey anchorKey, CDKTheme theme,
      bool animated, bool translucent) {
    final controller = CDKDialogController();
    if (anchorKey.currentContext == null) {
      // ignore: avoid_print
      print("Error: anchorKey not assigned to a widget");
      return;
    }
    CDKDialogsManager.showPopoverArrowed(
      context: context,
      anchorKey: anchorKey,
      isAnimated: animated,
      isTranslucent: translucent,
      controller: controller,
      onHide: () {
        // ignore: avoid_print
        print("hide arrowed");
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
                controller.close();
              },
              child: Text('Close arrowed',
                  style: TextStyle(fontSize: 12, color: theme.accent)),
            ),
          ],
        ),
      ),
    );
  }

  _showDialogArrowedSlider(
      BuildContext context, GlobalKey anchorKey, CDKTheme theme) {
    final controller = CDKDialogController();
    if (anchorKey.currentContext == null) {
      // ignore: avoid_print
      print("Error: anchorKey not assigned to a widget");
      return;
    }
    CDKDialogsManager.showPopoverArrowed(
      context: context,
      anchorKey: anchorKey,
      isAnimated: true,
      isTranslucent: false,
      controller: controller,
      onHide: () {
        // ignore: avoid_print
        print("hide slider");
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder<double>(
            valueListenable: _sliderValueNotifier,
            builder: (context, value, child) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Slider:", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(value.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 12)),
                    SizedBox(
                      height: 20,
                      width: 200,
                      child: CDKPickerSlider(
                        value: value,
                        onChanged: (value) {
                          _sliderValueNotifier.value = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Using a value notifier to',
                        style: TextStyle(fontSize: 12)),
                    const Text('communicate with the dialog.',
                        style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        controller.close();
                      },
                      child: Text('Close slider',
                          style: TextStyle(fontSize: 12, color: theme.accent)),
                    ),
                  ]);
            }),
      ),
    );
  }

  void _setDialogResult(String value) {
    if (!mounted) {
      return;
    }
    setState(() {
      _dialogResult = value;
    });
  }

  Future<void> _showConfirmDialog(BuildContext context,
      {required bool destructive}) async {
    final result = await CDKDialogsManager.showConfirm(
      context: context,
      title: destructive ? 'Delete File?' : 'Apply Changes?',
      message: destructive
          ? 'This action cannot be undone.'
          : 'Do you want to apply changes to this document?',
      confirmLabel: destructive ? 'Delete' : 'Apply',
      isDestructive: destructive,
      onConfirm: () {
        // ignore: avoid_print
        print('confirm accepted');
      },
      onCancel: () {
        // ignore: avoid_print
        print('confirm canceled');
      },
    );

    _setDialogResult(
        'Confirm result: $result (true=confirm, false/null=cancel)');
  }

  Future<void> _showPromptDialog(BuildContext context) async {
    final result = await CDKDialogsManager.showPrompt(
      context: context,
      title: 'Rename Layer',
      message: 'Type a name with at least 3 characters.',
      placeholder: 'Layer name',
      initialValue: 'Layer 01',
      confirmLabel: 'Save',
      validator: (value) {
        if (value.trim().length < 3) {
          return 'Name must contain at least 3 characters.';
        }
        return null;
      },
      onConfirm: (value) {
        // ignore: avoid_print
        print('prompt submitted: $value');
      },
      onCancel: () {
        // ignore: avoid_print
        print('prompt canceled');
      },
    );

    final label = result == null
        ? 'Prompt result: null (cancel)'
        : 'Prompt result: "$result"';
    _setDialogResult(label);
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    return ListView(children: [
      const SizedBox(height: 8),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorPopover0,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopover(
                    context, _anchorPopover0, theme, false, false, false);
              },
              child: const Text('Popover'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorPopover1,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopover(
                    context, _anchorPopover1, theme, true, false, true);
              },
              child: const Text('Centered translucent'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorPopover2,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopover(
                    context, _anchorPopover2, theme, true, true, false);
              },
              child: const Text('With animation'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorPopover3,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopover(context, _anchorPopover3, theme, true, true, true);
              },
              child: const Text('Translucent with animation'),
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CDKDialogModal:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showModal(context, theme, false, false, false);
              },
              child: const Text('Modal'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showModal(context, theme, true, false, false);
              },
              child: const Text('With animation'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showModal(context, theme, false, true, false);
              },
              child: const Text('Translucent'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showModal(context, theme, true, true, false);
              },
              child: const Text('Translucent with animation'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showModal(context, theme, false, false, true);
              },
              child: const Text('Modal with shade'),
            )),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CDKDialogDraggable:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorDraggable0,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showDraggable(context, _anchorDraggable0, theme, false, false);
              },
              child: const Text('Draggable'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorDraggable1,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showDraggable(context, _anchorDraggable1, theme, true, false);
              },
              child: const Text('With animation'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorDraggable2,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showDraggable(context, _anchorDraggable2, theme, false, true);
              },
              child: const Text('Translucent'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorDraggable3,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showDraggable(context, _anchorDraggable3, theme, true, true);
              },
              child: const Text('Translucent with animation'),
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CDKDialogArrow:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorArrowed0,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopoverArrowed(
                    context, _anchorArrowed0, theme, false, false);
              },
              child: const Text('Arrowed'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorArrowed1,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopoverArrowed(
                    context, _anchorArrowed1, theme, true, false);
              },
              child: const Text('With animation'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorArrowed2,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopoverArrowed(
                    context, _anchorArrowed2, theme, false, true);
              },
              child: const Text('Translucent'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorArrowed3,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showPopoverArrowed(
                    context, _anchorArrowed3, theme, true, true);
              },
              child: const Text('Translucent with animation'),
            )),
      ]),
      const SizedBox(height: 8),
      Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              key: _anchorPopoverSlider,
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () {
                _showDialogArrowedSlider(context, _anchorPopoverSlider, theme);
              },
              child: const Text('DialogArrow with slider'),
            )),
        ValueListenableBuilder<double>(
          valueListenable: _sliderValueNotifier,
          builder: (context, value, child) {
            return Text('Slider value: ${value.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 12));
          },
        )
      ]),
      const Padding(
          padding: EdgeInsets.all(8),
          child: Text('CDKDialogConfirm + CDKDialogPrompt:')),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () async {
                await _showConfirmDialog(context, destructive: false);
              },
              child: const Text('Confirm'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () async {
                await _showConfirmDialog(context, destructive: true);
              },
              child: const Text('Confirm destructive'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.normal,
              isLarge: false,
              onPressed: () async {
                await _showPromptDialog(context);
              },
              child: const Text('Prompt with validation'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(_dialogResult, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
      const SizedBox(height: 50),
    ]);
  }
}
