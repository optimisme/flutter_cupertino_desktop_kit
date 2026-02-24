import 'package:flutter/cupertino.dart';

import 'cdk_theme_notifier.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

enum CDKTextRole {
  caption,
  body,
  bodyStrong,
  title,
  button,
}

class CDKText extends StatelessWidget {
  const CDKText(
    this.data, {
    super.key,
    this.role = CDKTextRole.body,
    this.style,
    this.color,
    this.secondary = false,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final CDKTextRole role;
  final TextStyle? style;
  final Color? color;
  final bool secondary;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final colors = CDKThemeNotifier.colorTokensOf(context);
    final typography = CDKThemeNotifier.typographyTokensOf(context);

    final roleStyle = switch (role) {
      CDKTextRole.caption => typography.caption,
      CDKTextRole.body => typography.body,
      CDKTextRole.bodyStrong => typography.bodyStrong,
      CDKTextRole.title => typography.title,
      CDKTextRole.button => typography.button,
    };

    final resolvedColor =
        color ?? (secondary ? colors.colorTextSecondary : colors.colorText);

    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: roleStyle.copyWith(color: resolvedColor).merge(style),
    );
  }
}
