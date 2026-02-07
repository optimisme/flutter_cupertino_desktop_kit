import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Public API exports only CDK-prefixed symbols', () async {
    final entrypoint = File('lib/flutter_cupertino_desktop_kit.dart');
    final contents = await entrypoint.readAsString();

    final exportPattern = RegExp(r"export\s+'[^']+'\s+show\s+([^;]+);");
    final symbols = <String>{};

    for (final match in exportPattern.allMatches(contents)) {
      final rawSymbols = match.group(1)!;
      for (final symbol in rawSymbols.split(',')) {
        final trimmed = symbol.trim();
        if (trimmed.isNotEmpty) {
          symbols.add(trimmed);
        }
      }
    }

    expect(symbols, isNotEmpty);
    for (final symbol in symbols) {
      expect(
        symbol.startsWith('CDK'),
        isTrue,
        reason: 'Public symbol "$symbol" must start with CDK.',
      );
    }

    final managers = symbols.where((symbol) => symbol.contains('Manager'));
    expect(
      managers,
      everyElement(equals('CDKDialogsManager')),
      reason: 'Only global/static orchestration types should use Manager.',
    );
  });
}
