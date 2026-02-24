import 'dart:ui' show Tristate;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_desktop_kit/flutter_cupertino_desktop_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _testHost({
  required List<GlobalKey> anchors,
  bool disableAnimations = false,
}) {
  final theme = CDKTheme()..setAccentColour('systemBlue');

  return CDKThemeNotifier(
    changeNotifier: theme,
    child: CupertinoApp(
      builder: (context, child) {
        if (child == null) {
          return const SizedBox.shrink();
        }
        if (!disableAnimations) {
          return child;
        }
        final data = MediaQuery.maybeOf(context);
        if (data == null) {
          return child;
        }
        return MediaQuery(
          data: data.copyWith(disableAnimations: true),
          child: child,
        );
      },
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

Widget _positionedAnchorHost({
  required GlobalKey anchor,
  required Offset anchorOffset,
  bool disableAnimations = false,
}) {
  final theme = CDKTheme()..setAccentColour('systemBlue');

  return CDKThemeNotifier(
    changeNotifier: theme,
    child: CupertinoApp(
      builder: (context, child) {
        if (child == null || !disableAnimations) {
          return child ?? const SizedBox.shrink();
        }
        final data = MediaQuery.maybeOf(context);
        if (data == null) {
          return child;
        }
        return MediaQuery(
          data: data.copyWith(disableAnimations: true),
          child: child,
        );
      },
      home: CupertinoPageScaffold(
        child: Stack(
          children: [
            const Positioned.fill(child: SizedBox.expand()),
            Positioned(
              left: anchorOffset.dx,
              top: anchorOffset.dy,
              child: SizedBox(
                key: anchor,
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

Finder _findDialogShade() {
  return find.byWidgetPredicate(
    (widget) =>
        widget is ColoredBox &&
        widget.color == const Color.fromRGBO(96, 96, 96, 0.28),
  );
}

Rect _findPromptDialogRect(
  WidgetTester tester, {
  required String title,
  required String cancelLabel,
  required String confirmLabel,
}) {
  final titleCenter = tester.getRect(find.text(title)).center;
  final cancelCenter =
      tester.getRect(find.widgetWithText(CDKButton, cancelLabel)).center;
  final confirmCenter =
      tester.getRect(find.widgetWithText(CDKButton, confirmLabel)).center;

  List<Rect> findCandidateRects(Finder finder) {
    final rects = <Rect>[];
    for (final element in finder.evaluate()) {
      final renderObject = element.renderObject;
      if (renderObject is! RenderBox || !renderObject.hasSize) {
        continue;
      }
      final rect = renderObject.localToGlobal(Offset.zero) & renderObject.size;
      if (rect.contains(titleCenter) &&
          rect.contains(cancelCenter) &&
          rect.contains(confirmCenter)) {
        rects.add(rect);
      }
    }
    rects.sort((a, b) => (a.width * a.height).compareTo(b.width * b.height));
    return rects;
  }

  final animatedSizeRects = findCandidateRects(find.byType(AnimatedSize));
  if (animatedSizeRects.isNotEmpty) {
    return animatedSizeRects.first;
  }

  final customPaintRects = findCandidateRects(find.byType(CustomPaint));
  expect(customPaintRects, isNotEmpty);
  return customPaintRects.first;
}

void _expectPromptButtonsInsideDialogBounds(
  WidgetTester tester,
  Rect dialogRect, {
  String cancelLabel = 'Cancel',
  String confirmLabel = 'Confirm',
}) {
  final cancelRect =
      tester.getRect(find.widgetWithText(CDKButton, cancelLabel));
  final confirmRect =
      tester.getRect(find.widgetWithText(CDKButton, confirmLabel));
  const epsilon = 0.01;

  expect(cancelRect.left, greaterThanOrEqualTo(dialogRect.left - epsilon));
  expect(cancelRect.right, lessThanOrEqualTo(dialogRect.right + epsilon));
  expect(cancelRect.top, greaterThanOrEqualTo(dialogRect.top - epsilon));
  expect(cancelRect.bottom, lessThanOrEqualTo(dialogRect.bottom + epsilon));

  expect(confirmRect.left, greaterThanOrEqualTo(dialogRect.left - epsilon));
  expect(confirmRect.right, lessThanOrEqualTo(dialogRect.right + epsilon));
  expect(confirmRect.top, greaterThanOrEqualTo(dialogRect.top - epsilon));
  expect(confirmRect.bottom, lessThanOrEqualTo(dialogRect.bottom + epsilon));
}

Rect _findDialogRectContaining(WidgetTester tester, Finder widgetFinder) {
  final center = tester.getCenter(widgetFinder);
  final candidateRects = <Rect>[];

  for (final element in find.byType(CustomPaint).evaluate()) {
    final renderObject = element.renderObject;
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      continue;
    }
    final rect = renderObject.localToGlobal(Offset.zero) & renderObject.size;
    if (rect.contains(center)) {
      candidateRects.add(rect);
    }
  }

  expect(candidateRects, isNotEmpty);
  candidateRects.sort(
    (a, b) => (a.width * a.height).compareTo(b.width * b.height),
  );
  return candidateRects.first;
}

void _expectWidgetInsideRect(
  WidgetTester tester,
  Finder widgetFinder,
  Rect containerRect,
) {
  final rect = tester.getRect(widgetFinder);
  const epsilon = 0.01;
  expect(rect.left, greaterThanOrEqualTo(containerRect.left - epsilon));
  expect(rect.right, lessThanOrEqualTo(containerRect.right + epsilon));
  expect(rect.top, greaterThanOrEqualTo(containerRect.top - epsilon));
  expect(rect.bottom, lessThanOrEqualTo(containerRect.bottom + epsilon));
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

  testWidgets('Popover adapts and animates geometry when content resizes',
      (WidgetTester tester) async {
    final anchorKey = GlobalKey();
    final expanded = ValueNotifier<bool>(false);

    await tester.pumpWidget(_testHost(anchors: [anchorKey]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    CDKDialogsManager.showPopover(
      context: context,
      anchorKey: anchorKey,
      child: ValueListenableBuilder<bool>(
        valueListenable: expanded,
        builder: (context, isExpanded, child) {
          return SizedBox(
            width: 180,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(key: Key('popover-header'), height: 40),
                if (isExpanded)
                  const SizedBox(key: Key('popover-extra'), height: 72),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    final initialRect = _findDialogRectContaining(
      tester,
      find.byKey(const Key('popover-header')),
    );

    expanded.value = true;
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 90));
    final midRect = _findDialogRectContaining(
      tester,
      find.byKey(const Key('popover-header')),
    );
    await tester.pumpAndSettle();
    final expandedRect = _findDialogRectContaining(
      tester,
      find.byKey(const Key('popover-header')),
    );

    expect(expandedRect.height, greaterThan(initialRect.height + 30));
    expect(midRect.height, greaterThan(initialRect.height));
    expect(midRect.height, lessThan(expandedRect.height));
    _expectWidgetInsideRect(
      tester,
      find.byKey(const Key('popover-extra')),
      expandedRect,
    );
  });

  testWidgets('Arrowed popover keeps anchor alignment while resizing',
      (WidgetTester tester) async {
    final anchorKey = GlobalKey();
    final expanded = ValueNotifier<bool>(false);

    await tester.pumpWidget(
      _positionedAnchorHost(
        anchor: anchorKey,
        anchorOffset: const Offset(760, 24),
      ),
    );
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    CDKDialogsManager.showPopoverArrowed(
      context: context,
      anchorKey: anchorKey,
      child: ValueListenableBuilder<bool>(
        valueListenable: expanded,
        builder: (context, isExpanded, child) {
          return SizedBox(
            width: isExpanded ? 260 : 140,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(key: Key('arrowed-header'), height: 40),
                if (isExpanded)
                  const SizedBox(key: Key('arrowed-extra'), height: 72),
                const SizedBox(height: 18),
              ],
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    final initialRect = _findDialogRectContaining(
      tester,
      find.byKey(const Key('arrowed-header')),
    );

    expanded.value = true;
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 90));
    final midRect = _findDialogRectContaining(
      tester,
      find.byKey(const Key('arrowed-header')),
    );
    await tester.pumpAndSettle();
    final expandedRect = _findDialogRectContaining(
      tester,
      find.byKey(const Key('arrowed-header')),
    );

    expect(expandedRect.width, greaterThan(initialRect.width + 30));
    expect(midRect.width, greaterThan(initialRect.width));
    expect(midRect.width, lessThan(expandedRect.width));
    expect(expandedRect.left, lessThanOrEqualTo(initialRect.left));

    final anchorRect = tester.getRect(find.byKey(anchorKey));
    expect(anchorRect.center.dx, greaterThanOrEqualTo(expandedRect.left));
    expect(anchorRect.center.dx, lessThanOrEqualTo(expandedRect.right));

    _expectWidgetInsideRect(
      tester,
      find.byKey(const Key('arrowed-extra')),
      expandedRect,
    );
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

  testWidgets('Popover and modal default to no shade',
      (WidgetTester tester) async {
    final anchorKey = GlobalKey();
    await tester.pumpWidget(_testHost(anchors: [anchorKey]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    final popoverController = CDKDialogController();
    final modalController = CDKDialogController();

    CDKDialogsManager.showPopover(
      context: context,
      anchorKey: anchorKey,
      controller: popoverController,
      child: const SizedBox(width: 100, height: 60),
    );
    await tester.pump();
    expect(_findDialogShade(), findsNothing);

    popoverController.close();
    await tester.pump();

    CDKDialogsManager.showModal(
      context: context,
      controller: modalController,
      child: const SizedBox(width: 120, height: 80),
    );
    await tester.pump();
    expect(_findDialogShade(), findsNothing);

    modalController.close();
    await tester.pump();
  });

  testWidgets('Confirm and prompt use shade by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testHost(anchors: [GlobalKey()]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));

    final confirmFuture = CDKDialogsManager.showConfirm(
      context: context,
      message: 'Confirm this action?',
    );
    await tester.pump();
    expect(_findDialogShade(), findsOneWidget);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await confirmFuture;

    final promptFuture = CDKDialogsManager.showPrompt(
      context: context,
      title: 'Rename',
      confirmLabel: 'Save',
      cancelLabel: 'Dismiss',
    );
    await tester.pump();
    expect(_findDialogShade(), findsOneWidget);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await promptFuture;
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
    final typography =
        material.Theme.of(context).extension<CDKThemeTypographyTokens>();

    expect(colors, isNotNull);
    expect(runtime, isNotNull);
    expect(radii, isNotNull);
    expect(typography, isNotNull);
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
    expect(switchNode.flagsCollection.isButton, isTrue);
    expect(switchNode.flagsCollection.isEnabled != Tristate.none, isTrue);

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

  testWidgets(
      'Prompt modal keeps actions inside bounds while validation toggles',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testHost(anchors: [GlobalKey()]));
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    final future = CDKDialogsManager.showPrompt(
      context: context,
      title: 'Rename',
      initialValue: 'Layer name',
      validator: (value) {
        if (value.trim().length < 3) {
          return 'Must be at least 3 characters';
        }
        return null;
      },
    );
    await tester.pump();

    final initialRect = _findPromptDialogRect(
      tester,
      title: 'Rename',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm',
    );
    _expectPromptButtonsInsideDialogBounds(tester, initialRect);
    expect(find.text('Must be at least 3 characters'), findsNothing);

    await tester.enterText(find.byType(CupertinoTextField), 'ab');
    await tester.pump();

    final expandedStartRect = _findPromptDialogRect(
      tester,
      title: 'Rename',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm',
    );
    _expectPromptButtonsInsideDialogBounds(tester, expandedStartRect);
    expect(find.text('Must be at least 3 characters'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 80));
    final expandedMidRect = _findPromptDialogRect(
      tester,
      title: 'Rename',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm',
    );
    _expectPromptButtonsInsideDialogBounds(tester, expandedMidRect);

    await tester.pumpAndSettle();
    final expandedEndRect = _findPromptDialogRect(
      tester,
      title: 'Rename',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm',
    );
    _expectPromptButtonsInsideDialogBounds(tester, expandedEndRect);
    expect(expandedEndRect.height, greaterThan(initialRect.height));
    expect(expandedMidRect.height, greaterThan(initialRect.height));
    expect(expandedMidRect.height, lessThan(expandedEndRect.height));

    await tester.enterText(find.byType(CupertinoTextField), 'Layer name');
    await tester.pump();
    expect(find.text('Must be at least 3 characters'), findsNothing);

    final collapsedStartRect = _findPromptDialogRect(
      tester,
      title: 'Rename',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm',
    );
    _expectPromptButtonsInsideDialogBounds(tester, collapsedStartRect);

    await tester.pump(const Duration(milliseconds: 80));
    final collapsedMidRect = _findPromptDialogRect(
      tester,
      title: 'Rename',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm',
    );
    _expectPromptButtonsInsideDialogBounds(tester, collapsedMidRect);

    await tester.pumpAndSettle();
    final collapsedEndRect = _findPromptDialogRect(
      tester,
      title: 'Rename',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm',
    );
    _expectPromptButtonsInsideDialogBounds(tester, collapsedEndRect);
    expect(collapsedEndRect.height, lessThan(expandedEndRect.height));
    expect(collapsedMidRect.height, greaterThan(collapsedEndRect.height));
    expect(collapsedMidRect.height, lessThan(expandedEndRect.height));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(await future, isNull);
  });

  testWidgets('Prompt modal resize animation respects reduced motion',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _testHost(
        anchors: [GlobalKey()],
        disableAnimations: true,
      ),
    );
    await tester.pump();

    final context = tester.element(find.byType(CupertinoPageScaffold));
    final future = CDKDialogsManager.showPrompt(
      context: context,
      title: 'Rename',
      initialValue: 'Layer name',
      validator: (value) {
        if (value.trim().length < 3) {
          return 'Must be at least 3 characters';
        }
        return null;
      },
    );
    await tester.pump();

    final initialRect = _findPromptDialogRect(
      tester,
      title: 'Rename',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm',
    );

    await tester.enterText(find.byType(CupertinoTextField), 'ab');
    await tester.pump();
    final expandedRect = _findPromptDialogRect(
      tester,
      title: 'Rename',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm',
    );
    expect(expandedRect.height, greaterThan(initialRect.height));

    await tester.pump(const Duration(milliseconds: 80));
    final expandedAfterDelayRect = _findPromptDialogRect(
      tester,
      title: 'Rename',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm',
    );
    expect(
      expandedAfterDelayRect.height,
      closeTo(expandedRect.height, 0.001),
    );

    await tester.enterText(find.byType(CupertinoTextField), 'Layer name');
    await tester.pump();
    final collapsedRect = _findPromptDialogRect(
      tester,
      title: 'Rename',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm',
    );
    expect(collapsedRect.height, lessThan(expandedRect.height));

    await tester.pump(const Duration(milliseconds: 80));
    final collapsedAfterDelayRect = _findPromptDialogRect(
      tester,
      title: 'Rename',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm',
    );
    expect(
      collapsedAfterDelayRect.height,
      closeTo(collapsedRect.height, 0.001),
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(await future, isNull);
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
