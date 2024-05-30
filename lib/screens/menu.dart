// screens/menu.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/menu_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/color.dart';

class MainTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var menuProvider = Provider.of<MenuProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          MenuBar(menuProvider: menuProvider),
          Expanded(child: menuProvider.selectedItem.content),
        ],
      ),
    );
  }
}

class MenuBar extends StatelessWidget {
  const MenuBar({
    super.key,
    required this.menuProvider,
  });

  final MenuProvider menuProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: getRelativeColor(context, 0.2),
      child: Material(
        color: Colors.transparent,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var i = 0; i < menuProvider.items.length; i++)
              Container(
                width: 200,
                child: InkWell(
                  onTap: () => menuProvider.selectItem(i),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(menuProvider.items[i].title),
                  ),
                ),
              ),
            // ダークモードの切り替えスイッチ
            // DarkModeSwitch(),
          ],
        ),
      ),
    );
  }
}



class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeModeProvider = Provider.of<ThemeModeProvider>(context);
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(Icons.brightness_5),
          Switch(
            value: themeModeProvider.isDarkMode,
            onChanged: (value) {
              themeModeProvider.toggleMode();
            },
          ),
          Icon(Icons.brightness_2),
        ],
      ),
    );
  }
}
