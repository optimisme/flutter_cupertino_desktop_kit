import 'package:flutter/material.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class UtilTabViews extends StatefulWidget {
  final List<Widget> views;
  final List<Widget> options;
  final bool isAccent;

  const UtilTabViews({
    Key? key,
    required this.views,
    required this.options,
    this.isAccent = false,
  })  : assert(views.length == options.length,
            'The number of views and tab texts must be the same.'),
        super(key: key);

  @override
  UtilTabViewsState createState() => UtilTabViewsState();
}

class UtilTabViewsState extends State<UtilTabViews> {
  int _selectedIndex = 0;
  final List<ScrollController> _scrollControllers = [];

  @override
  void initState() {
    super.initState();
    _scrollControllers.addAll(
      List.generate(widget.views.length, (_) => ScrollController()),
    );
  }

  void _onTabSelected(int index) {
    _scrollControllers[_selectedIndex].jumpTo(0);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget segmented = CDKPickerButtonsSegmented(
      options: widget.options,
      selectedIndex: _selectedIndex,
      onSelected: _onTabSelected,
      isAccent: widget.isAccent,
    );

    BoxDecoration lineDecoration = const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: CDKTheme.grey80,
          width: 1.0,
        ),
      ),
    );

    return Column(
      children: [
        if (!widget.isAccent)
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            decoration: lineDecoration,
            child: segmented,
          )
        else
          Container(
            decoration: lineDecoration,
            child: segmented,
          ),
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: widget.views.asMap().entries.map((entry) {
              int idx = entry.key;
              Widget view = entry.value;
              return SingleChildScrollView(
                key: ValueKey(idx),
                controller: _scrollControllers[idx],
                child: view,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
