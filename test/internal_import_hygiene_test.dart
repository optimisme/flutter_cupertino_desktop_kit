import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Internal library files avoid package barrel imports', () {
    final srcDir = Directory('lib/src');
    final dartFiles = srcDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    final violations = <String>[];
    final forbiddenPatterns = <RegExp>[
      RegExp(r"^import\s+'cdk\.dart';", multiLine: true),
      RegExp(
        r"^import\s+'package:flutter_cupertino_desktop_kit/flutter_cupertino_desktop_kit\.dart';",
        multiLine: true,
      ),
      RegExp(
        r'^import\s+"package:flutter_cupertino_desktop_kit/flutter_cupertino_desktop_kit\.dart";',
        multiLine: true,
      ),
    ];

    for (final file in dartFiles) {
      final contents = file.readAsStringSync();
      for (final pattern in forbiddenPatterns) {
        if (pattern.hasMatch(contents)) {
          violations.add(file.path);
          break;
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use direct local imports inside lib/src to avoid barrel-coupling.',
    );
  });
}
