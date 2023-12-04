/*
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'util_tab_views.dart';

class LayoutSidebarRight extends StatefulWidget {
  const LayoutSidebarRight({super.key});

  @override
  State<LayoutSidebarRight> createState() => LayoutButtonsState();
}

class LayoutButtonsState extends State<LayoutSidebarRight> {
  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;
    Color backgroundColor =
        theme.isLight ? const Color(0xFFFAFAFA) : const Color(0xFF555555);
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        color: backgroundColor,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              height: screenHeight - 45,
              color: backgroundColor,
              child: UtilTabViews(isAccent: true, options: const [
                Text('Document'),
                Text('Format'),
                Text('Layers')
              ], views: [
                SizedBox(
                  width: double.infinity, // Estira el widget horitzontalment
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    child: const Text('Text 0'),
                  ),
                ),
                SizedBox(
                  width: double.infinity, // Estira el widget horitzontalment
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Text 1'),
                        Text('Text 2'),
                        Text('Text 3'),
                        Text('Text 4'),
                        Text('Text 5'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity, // Estira el widget horitzontalment
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    child: const Column(
                      children: [
                        Text('Text A'),
                        Text('Text B'),
                        Text('Text C'),
                        Text('Text D'),
                        Text('Text E'),
                        Text('Text F'),
                        Text('Text C'),
                        Text('Text D'),
                        Text('Text E'),
                        Text('Text F'),
                        Text('Text C'),
                        Text('Text D'),
                        Text('Text E'),
                        Text('Text F'),
                        Text('Text C'),
                        Text('Text D'),
                        Text('Text E'),
                        Text('Text F'),
                        Text('Text C'),
                        Text('Text D'),
                        Text('Text E'),
                        Text('Text F'),
                        Text('Text C'),
                        Text('Text D'),
                        Text('Text E'),
                        Text('Text F'),
                      ],
                    ),
                  ),
                ),
              ]),
            )
          ],
        ));
  }
}
*/