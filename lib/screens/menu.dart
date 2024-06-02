// screens/menu.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/menu_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/color.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/card_sets_csv_import.dart';

class MainTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var menuProvider = Provider.of<MenuProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: MenuBar(menuProvider: menuProvider),
      ),
      body: menuProvider.selectedItem.content,
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
    return AppBar(
      title: Text('コナンTCGツール',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          )),
      backgroundColor: getRelativeColor(context, 0.2),
      actions: [
        // actionsプロパティを使用
        PopupMenuButton<int>(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(menuProvider.selectedItem.title),
          ), // 選択されたアイテムのタイトルを表示
          onSelected: (index) => menuProvider.selectItem(index),
          itemBuilder: (context) => [
            for (var i = 0; i < menuProvider.items.length; i++)
              PopupMenuItem(
                value: i,
                child: Text(menuProvider.items[i].title),
              ),
          ],
        ),
ElevatedButton(
  onPressed: () {
    selectFiles(context);
  },
  child: Text('Load CSV Data'),
),

        SizedBox(width: 10),
        ListMenuButton(),
        SizedBox(width: 10),
      ],
    );
  }
}

class ListMenuButton extends StatefulWidget {
  const ListMenuButton({Key? key}) : super(key: key);

  @override
  _ListMenuButtonState createState() => _ListMenuButtonState();
}

class _ListMenuButtonState extends State<ListMenuButton> {
  @override
  Widget build(BuildContext context) {
    var themeModeProvider = Provider.of<ThemeModeProvider>(context);
    return PopupMenuButton<int>(
      icon: Icon(Icons.list),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            leading: Icon(Icons.brightness_5),
            title: Text('ライトモードにする'),
            onTap: () {
              if (themeModeProvider.isDarkMode) {
                themeModeProvider.toggleMode();
              }
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: ListTile(
            leading: Icon(Icons.brightness_2),
            title: Text('ダークモードにする'),
            onTap: () {
              if (!themeModeProvider.isDarkMode) {
                themeModeProvider.toggleMode();
              }
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('プライバシーポリシー'),
            onTap: () => launch('https://nohminist.github.io/privacy-policy/'),
          ),
        ),
        PopupMenuItem<int>(
          value: 4,
          child: ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text('お問い合わせ'),
            onTap: () => launch('https://x.com/nohminism'),
          ),
        ),
      ],
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
