import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';

class LayoutPickers extends StatefulWidget {
  final Function? toogleLeftSidebar;
  const LayoutPickers({super.key, this.toogleLeftSidebar});

  @override
  State<LayoutPickers> createState() => _LayoutPickersState();
}

class _LayoutPickersState extends State<LayoutPickers> {
  double _angle = 0.0;

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
                  padding: EdgeInsets.all(8), child: Text('DSKPicker360:')),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKPicker360(
                      onChanged: (angle) {
                        _angle = angle;
                        setState(() {});
                      },
                    )),
                Text(_angle.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 12)),
              ]),
              const SizedBox(height: 8),
               Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKPickerDisclosure:')),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKPickerDisclosure(
                      sideWidget: Text('Show/Hide', style: TextStyle(fontSize: 14)),
                      bottomWidget: SizedBox(
                        width: 300, 
                        height: 150, 
                        child:Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: DSKColors.backgroundSecondary1,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child:Text('Expandible disclosure'))),
                      onChanged: (bool value) {
                        setState(() {});
                      }),
                    ),
              ]),
              Padding(
                  padding: EdgeInsets.all(8), child: Text('---')),
              const SizedBox(height: 50),
            ])));
  }
}
