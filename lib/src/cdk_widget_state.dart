import 'package:flutter/widgets.dart';

Set<WidgetState> cdkWidgetStates({
  required bool enabled,
  bool focused = false,
  bool hovered = false,
  bool pressed = false,
  bool selected = false,
}) {
  final states = <WidgetState>{};
  if (!enabled) {
    states.add(WidgetState.disabled);
  }
  if (focused) {
    states.add(WidgetState.focused);
  }
  if (hovered) {
    states.add(WidgetState.hovered);
  }
  if (pressed) {
    states.add(WidgetState.pressed);
  }
  if (selected) {
    states.add(WidgetState.selected);
  }
  return states;
}
