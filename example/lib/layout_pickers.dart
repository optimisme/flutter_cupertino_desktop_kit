import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';

class LayoutPickers extends StatefulWidget {
  final Function? toogleLeftSidebar;
  const LayoutPickers({super.key, this.toogleLeftSidebar});

  @override
  State<LayoutPickers> createState() => _LayoutPickersState();
}

class _LayoutPickersState extends State<LayoutPickers> {
  bool _isRunning = false;
  double _progress = 0.0;

  void _toggleIndeterminate() {
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _increaseProgress() {
    setState(() {
      _progress = (_progress + 0.1);
      if (_progress > 1) {
        _progress = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: DSKColors.backgroundSecondary0.withOpacity(0.5),
          middle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                DSKButtonIcon(
                    icon: CupertinoIcons.sidebar_left,
                    onPressed: () {
                      widget.toogleLeftSidebar!();
                    }),
                const Text("Pickers"),
                const SizedBox(width: 24, height: 8),
              ]),
        ),
        child: Container(
            color: DSKColors.background,
            child: ListView(children: [
              const SizedBox(height: 8),
              const Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKProgressBar:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                        width: 250,
                        child: DSKProgressBar(
                          progress: _progress,
                        ))),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.normal,
                      onPressed: () {
                        _increaseProgress();
                      },
                      child: const Text('Increase'),
                    )),
              ]),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                        width: 250,
                        child: DSKProgressBar(
                          progress: _progress,
                          isIndeterminate: true,
                          isRunning: _isRunning,
                        ))),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.normal,
                      onPressed: () {
                        _toggleIndeterminate();
                      },
                      child: const Text('Toggle running'),
                    )),
              ]),
              const SizedBox(height: 50),
            ])));
  }
}
