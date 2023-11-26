import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop/ck_widgets.dart';

class LayoutProgress extends StatefulWidget {
  const LayoutProgress({super.key});

  @override
  State<LayoutProgress> createState() => _LayoutProgressState();
}

class _LayoutProgressState extends State<LayoutProgress> {
  double _progressL = 0.0;
  bool _isRunningL = false;
  double _progressC = 0.0;
  bool _isRunningC = false;

  void _toggleIndeterminateL() {
    setState(() {
      _isRunningL = !_isRunningL;
    });
  }

  void _increaseProgressL() {
    setState(() {
      _progressL = (_progressL + 0.1);
      if (_progressL > 1) {
        _progressL = 0.0;
      }
    });
  }

  void _toggleIndeterminateC() {
    setState(() {
      _isRunningC = !_isRunningC;
    });
  }

  void _increaseProgressC() {
    setState(() {
      _progressC = (_progressC + 0.1);
      if (_progressC > 1) {
        _progressC = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const SizedBox(height: 8),
      const Padding(padding: EdgeInsets.all(8), child: Text('CKProgressBar:')),
      Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                    width: 250,
                    child: CKProgressBar(
                      value: _progressL,
                    ))),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_progressL.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 12)),
            ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: CKButton(
                  style: CKButtonStyle.normal,
                  onPressed: () {
                    _increaseProgressL();
                  },
                  child: const Text('Increase'),
                )),
          ]),
      Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                    width: 250,
                    child: CKProgressBar(
                      value: _progressL,
                      isIndeterminate: true,
                      isRunning: _isRunningL,
                    ))),
            Padding(
                padding: const EdgeInsets.all(8),
                child: CKButton(
                  style: CKButtonStyle.normal,
                  onPressed: () {
                    _toggleIndeterminateL();
                  },
                  child: const Text('Toggle running'),
                )),
          ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CKProgressCircular:')),
      Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                    width: 250,
                    child: CKProgressCircular(
                      value: _progressC,
                    ))),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_progressC.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 12)),
            ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: CKButton(
                  style: CKButtonStyle.normal,
                  onPressed: () {
                    _increaseProgressC();
                  },
                  child: const Text('Increase'),
                )),
          ]),
      Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                    width: 250,
                    child: CKProgressCircular(
                      value: _progressC,
                      isIndeterminate: true,
                      isRunning: _isRunningC,
                    ))),
            Padding(
                padding: const EdgeInsets.all(8),
                child: CKButton(
                  style: CKButtonStyle.normal,
                  onPressed: () {
                    _toggleIndeterminateC();
                  },
                  child: const Text('Toggle running'),
                )),
          ]),
      const SizedBox(height: 50),
    ]);
  }
}
