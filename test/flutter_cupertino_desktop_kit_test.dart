import 'dart:ui' show SemanticsFlag;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_desktop_kit/flutter_cupertino_desktop_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _testHost({required List<GlobalKey> anchors}) {
  final theme = CDKTheme()..setAccentColour('systemBlue');

  return CDKThemeNotifier(
    changeNotifier: theme,
    child: CupertinoApp(
      home: CupertinoPageScaffold(
        child: Stack(
          children: [
            const Positioned.fill(child: SizedBox.expand()),
            for (var i = 0; i < anchors.length; i++)
              Positioned(
                left: 16 + (i * 48).toDouble(),
                top: 16,
                child: SizedBox(
                  key: anchors[i],
                  width: 24,
                  height: 24,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget _toggleAnchorHost({
  required GlobalKey anchor,
  required ValueNotifier<bool> isAnchorVisible,
}) {
  final theme = CDKTheme()..setAccentColour('systemBlue');

  return CDKThemeNotifier(
    changeNotifier: theme,
    child: CupertinoApp(
      home: CupertinoPageScaffold(
        child: ValueListenableBuilder<bool>(
          valueListenable: isAnchorVisible,
          builder: (context, visible, child) {
            return Stack(
              children: [
                const Positioned.fill(child: SizedBox.expand()),
                if (visible)
                  Positioned(
                    left: 16,
                    top: 16,
                    child: SizedBox(
                      key: anchor,
                      width: 24,
                      height: 24,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

Widget _themeHost({required Widget child}) {
  final theme = CDKTheme()..setAccentColour('systemBlue');
  return CDKThemeNotifier(
    changeNotifier: theme,
    child: CupertinoApp(
      home: CupertinoPageScaffold(
        child: Center(child: child),
      ),
    ),
  );
}

void main() {
  test('Public entry point exports widgets', () {
    const widget = CDKButtonSwitch(value: true);
    expect(widget, isA<CDKButtonSwitch>());
  });

  testWidgets('Dialogs manager replaces active modal safely',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testHost(anchors: [GlobalKey()]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    final secondModalController = CDKDialogController();

    CDKDialogsManager.showModal(
      context: context,
      child: const SizedBox(width: 120, height: 80),
    );
    await tester.pump();

    CDKDialogsManager.showModal(
      context: context,
      controller: secondModalController,
      child: const SizedBox(width: 140, height: 90),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);

    secondModalController.close();
    await tester.pump();
  });

  testWidgets('Showing popover twice on same anchor does not crash',
      (WidgetTester tester) async {
    final anchorKey = GlobalKey();
    await tester.pumpWidget(_testHost(anchors: [anchorKey]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    final popoverController = CDKDialogController();

    CDKDialogsManager.showPopover(
      context: context,
      anchorKey: anchorKey,
      controller: popoverController,
      child: const SizedBox(width: 100, height: 60),
    );
    await tester.pump();

    CDKDialogsManager.showPopover(
      key: GlobalKey(),
      context: context,
      anchorKey: anchorKey,
      child: const SizedBox(width: 100, height: 60),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);

    popoverController.close();
    await tester.pump();
  });

  testWidgets('Arrowed popovers close without invalid state casts',
      (WidgetTester tester) async {
    final anchorA = GlobalKey();
    final anchorB = GlobalKey();
    await tester.pumpWidget(_testHost(anchors: [anchorA, anchorB]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    final firstArrowedController = CDKDialogController();
    final secondArrowedController = CDKDialogController();

    CDKDialogsManager.showPopoverArrowed(
      context: context,
      anchorKey: anchorA,
      controller: firstArrowedController,
      child: const SizedBox(width: 110, height: 70),
    );
    await tester.pump();

    CDKDialogsManager.showPopoverArrowed(
      context: context,
      anchorKey: anchorB,
      controller: secondArrowedController,
      child: const SizedBox(width: 120, height: 80),
    );
    await tester.pump();

    firstArrowedController.close();
    await tester.pump();

    expect(tester.takeException(), isNull);

    secondArrowedController.close();
    await tester.pump();
  });

  testWidgets('Escape closes only the top-most dismissible dialog',
      (WidgetTester tester) async {
    final anchorA = GlobalKey();
    final anchorB = GlobalKey();
    await tester.pumpWidget(_testHost(anchors: [anchorA, anchorB]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    final closeOrder = <String>[];

    CDKDialogsManager.showPopover(
      context: context,
      anchorKey: anchorA,
      onHide: () => closeOrder.add('A'),
      child: const SizedBox(width: 110, height: 70),
    );
    await tester.pump();

    CDKDialogsManager.showPopover(
      context: context,
      anchorKey: anchorB,
      onHide: () => closeOrder.add('B'),
      child: const SizedBox(width: 120, height: 80),
    );
    await tester.pump();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(closeOrder, ['B']);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(closeOrder, ['B', 'A']);
  });

  testWidgets('Outside click policy matches dialog type defaults',
      (WidgetTester tester) async {
    final anchorKey = GlobalKey();
    await tester.pumpWidget(_testHost(anchors: [anchorKey]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    final modalController = CDKDialogController();
    var popoverClosed = false;
    var modalClosed = false;
    var dismissibleModalClosed = false;

    CDKDialogsManager.showPopover(
      context: context,
      anchorKey: anchorKey,
      onHide: () => popoverClosed = true,
      child: const SizedBox(width: 100, height: 60),
    );
    await tester.pump();

    await tester.tapAt(const Offset(300, 300));
    await tester.pump();
    expect(popoverClosed, isTrue);

    CDKDialogsManager.showModal(
      context: context,
      controller: modalController,
      onHide: () => modalClosed = true,
      child: const SizedBox(width: 120, height: 80),
    );
    await tester.pump();

    await tester.tapAt(const Offset(300, 300));
    await tester.pump();
    expect(modalClosed, isFalse);

    modalController.close();
    await tester.pump();

    CDKDialogsManager.showModal(
      context: context,
      dismissOnOutsideTap: true,
      onHide: () => dismissibleModalClosed = true,
      child: const SizedBox(width: 120, height: 80),
    );
    await tester.pump();

    await tester.tapAt(const Offset(300, 300));
    await tester.pump();
    expect(dismissibleModalClosed, isTrue);
  });

  testWidgets('Re-opening an anchor brings that popover to the front',
      (WidgetTester tester) async {
    final anchorA = GlobalKey();
    final anchorB = GlobalKey();
    await tester.pumpWidget(_testHost(anchors: [anchorA, anchorB]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    final closeOrder = <String>[];

    CDKDialogsManager.showPopover(
      context: context,
      anchorKey: anchorA,
      onHide: () => closeOrder.add('A'),
      child: const SizedBox(width: 100, height: 60),
    );
    await tester.pump();

    CDKDialogsManager.showPopover(
      context: context,
      anchorKey: anchorB,
      onHide: () => closeOrder.add('B'),
      child: const SizedBox(width: 100, height: 60),
    );
    await tester.pump();

    CDKDialogsManager.showPopover(
      context: context,
      anchorKey: anchorA,
      child: const SizedBox(width: 100, height: 60),
    );
    await tester.pump();

    await tester.tapAt(const Offset(300, 300));
    await tester.pump();
    expect(closeOrder, ['A']);

    await tester.tapAt(const Offset(300, 300));
    await tester.pump();
    expect(closeOrder, ['A', 'B']);
  });

  testWidgets('Anchor disposal during post-frame positioning is safe',
      (WidgetTester tester) async {
    final anchorKey = GlobalKey();
    final isAnchorVisible = ValueNotifier<bool>(true);

    await tester.pumpWidget(
      _toggleAnchorHost(anchor: anchorKey, isAnchorVisible: isAnchorVisible),
    );
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));

    CDKDialogsManager.showPopover(
      context: context,
      anchorKey: anchorKey,
      child: const SizedBox(width: 120, height: 80),
    );

    isAnchorVisible.value = false;
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('CDKApp publishes ThemeExtension tokens',
      (WidgetTester tester) async {
    const marker = Key('theme-marker');
    await tester.pumpWidget(
      const CDKApp(
        child: SizedBox(key: marker),
      ),
    );
    await tester.pump();

    final context = tester.element(find.byKey(marker));
    final colors = material.Theme.of(context).extension<CDKThemeColorTokens>();
    final runtime =
        material.Theme.of(context).extension<CDKThemeRuntimeTokens>();
    final radii = material.Theme.of(context).extension<CDKThemeRadiusTokens>();

    expect(colors, isNotNull);
    expect(runtime, isNotNull);
    expect(radii, isNotNull);
  });

  testWidgets('Switch exposes semantics and supports keyboard activation',
      (WidgetTester tester) async {
    bool value = false;
    final semanticsHandle = tester.ensureSemantics();

    await tester.pumpWidget(
      _themeHost(
        child: CDKButtonSwitch(
          value: value,
          semanticLabel: 'Theme switch',
          onChanged: (newValue) {
            value = newValue;
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.bySemanticsLabel('Theme switch'), findsOneWidget);
    final switchNode = tester.getSemantics(find.byType(CDKButtonSwitch));
    expect(switchNode.hasFlag(SemanticsFlag.isButton), isTrue);
    expect(switchNode.hasFlag(SemanticsFlag.hasEnabledState), isTrue);

    await tester.tap(find.byType(CDKButtonSwitch));
    await tester.pump();
    expect(value, isTrue);

    await tester.tap(find.byType(CDKButtonSwitch));
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(value, isTrue);

    semanticsHandle.dispose();
  });

  testWidgets(
      'Numeric field responds to keyboard increment/decrement shortcuts',
      (WidgetTester tester) async {
    double currentValue = 2.0;

    await tester.pumpWidget(
      _themeHost(
        child: SizedBox(
          width: 220,
          child: CDKFieldNumeric(
            value: currentValue,
            increment: 1.0,
            min: 0.0,
            max: 10.0,
            onValueChanged: (value) {
              currentValue = value;
            },
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(CDKFieldText));
    await tester.pump();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(currentValue, 3.0);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(currentValue, 2.0);
  });

  testWidgets('Checklist exposes semantic items and supports keyboard activate',
      (WidgetTester tester) async {
    int selected = 0;
    final semanticsHandle = tester.ensureSemantics();

    await tester.pumpWidget(
      _themeHost(
        child: CDKPickerCheckList(
          options: const ['One', 'Two', 'Three'],
          selectedIndex: selected,
          onSelected: (index) {
            selected = index;
          },
          semanticLabel: 'Options',
        ),
      ),
    );
    await tester.pump();

    expect(find.bySemanticsLabel('Options'), findsOneWidget);
    expect(find.bySemanticsLabel('Two'), findsWidgets);

    await tester.tap(find.text('Two'));
    await tester.pump();
    expect(selected, 1);

    await tester.tap(find.text('Three'));
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(selected, 2);

    semanticsHandle.dispose();
  });

  testWidgets('showConfirm returns expected values for button actions',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testHost(anchors: [GlobalKey()]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));

    final confirmFuture = CDKDialogsManager.showConfirm(
      context: context,
      title: 'Confirm action',
      message: 'Proceed?',
      confirmLabel: 'Proceed',
    );
    await tester.pump();

    final proceedButton =
        tester.widget<CDKButton>(find.widgetWithText(CDKButton, 'Proceed'));
    proceedButton.onPressed?.call();
    await tester.pump();
    expect(await confirmFuture, isTrue);

    final cancelFuture = CDKDialogsManager.showConfirm(
      context: context,
      title: 'Confirm action',
      message: 'Proceed?',
      confirmLabel: 'Proceed',
    );
    await tester.pump();

    final cancelButton =
        tester.widget<CDKButton>(find.widgetWithText(CDKButton, 'Cancel'));
    cancelButton.onPressed?.call();
    await tester.pump();
    expect(await cancelFuture, isFalse);
  });

  testWidgets('showConfirm supports Enter and Escape keyboard shortcuts',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testHost(anchors: [GlobalKey()]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));

    final enterFuture = CDKDialogsManager.showConfirm(
      context: context,
      message: 'Press Enter',
    );
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(await enterFuture, isTrue);

    final escapeFuture = CDKDialogsManager.showConfirm(
      context: context,
      message: 'Press Escape',
    );
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(await escapeFuture, isFalse);
  });

  testWidgets('showPrompt validates input and submits only when valid',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testHost(anchors: [GlobalKey()]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));

    final future = CDKDialogsManager.showPrompt(
      context: context,
      title: 'Rename',
      initialValue: 'ab',
      validator: (value) {
        if (value.trim().length < 3) {
          return 'Must be at least 3 characters';
        }
        return null;
      },
    );
    await tester.pump();

    expect(find.text('Must be at least 3 characters'), findsOneWidget);

    final confirmButton =
        tester.widget<CDKButton>(find.widgetWithText(CDKButton, 'Confirm'));
    confirmButton.onPressed?.call();
    await tester.pump();
    expect(find.text('Rename'), findsOneWidget);

    await tester.enterText(find.byType(CupertinoTextField), 'Layer 1');
    await tester.pump();
    expect(find.text('Must be at least 3 characters'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(await future, 'Layer 1');
  });

  testWidgets('showPrompt returns null when canceled with Escape',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testHost(anchors: [GlobalKey()]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));

    final future = CDKDialogsManager.showPrompt(
      context: context,
      title: 'Rename',
      initialValue: 'Layer 1',
    );
    await tester.pump();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
    await tester.pump();

    expect(await future, isNull);
  });

  testWidgets('CDKDialogConfirm ESC runs cancel action and closes',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testHost(anchors: [GlobalKey()]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    final controller = CDKDialogController();
    var wasCanceled = false;

    CDKDialogsManager.showModal(
      context: context,
      dismissOnEscape: false,
      controller: controller,
      child: CDKDialogConfirm(
        message: 'Confirm close',
        onCancel: () => wasCanceled = true,
        onRequestClose: controller.close,
      ),
    );
    await tester.pump();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
    await tester.pump();

    expect(wasCanceled, isTrue);
    expect(find.text('Confirm close'), findsNothing);
  });

  testWidgets('CDKDialogPrompt ESC runs cancel action and closes',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testHost(anchors: [GlobalKey()]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    final controller = CDKDialogController();
    var wasCanceled = false;

    CDKDialogsManager.showModal(
      context: context,
      dismissOnEscape: false,
      controller: controller,
      child: CDKDialogPrompt(
        title: 'Rename Prompt',
        onCancel: () => wasCanceled = true,
        onRequestClose: controller.close,
      ),
    );
    await tester.pump();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
    await tester.pump();

    expect(wasCanceled, isTrue);
    expect(find.text('Rename Prompt'), findsNothing);
  });
}
