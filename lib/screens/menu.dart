// screens/menu.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/menu_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/color.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > constraints.maxHeight) {
          return MainMenuOfWide();
        } else {
          return MainMenuOfNarrow();
        }
      },
    );
  }
}

class MainMenuOfWide extends StatefulWidget {
  MainMenuOfWide({Key? key}) : super(key: key);
  @override
  _MainMenuOfWideState createState() => _MainMenuOfWideState();
}

class _MainMenuOfWideState extends State<MainMenuOfWide> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    var menuProvider = Provider.of<MenuProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // メインコンテンツ
          menuProvider.selectedItem.content,
          // メニュー
          MouseRegion(
            onHover: (event) => setState(() {
              _isHovered = true;
            }),
            onExit: (event) => setState(() {
              _isHovered = false;
            }),
            child: AnimatedContainer(
              width: _isHovered ? 300 : 40,
              duration: Duration(milliseconds: 200),
              color: getRelativeColor(context, 0.1),
              child: Material(
                color: Colors.transparent, // Materialの背景色を透明に設定
                child: Column(
                  children: [
                    if (_isHovered)
                      Expanded(
                        child: ListView.builder(
                          itemCount: menuProvider.items.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: _isHovered
                                  ? Text(menuProvider.items[index].title)
                                  : null, // _isHoveredの値に基づいてタイトルを表示
                              onTap: () => menuProvider.selectItem(index),
                            );
                          },
                        ),
                      ),
                    // isHovered == false の時、メニューアイコンを表示
                    if (!_isHovered)
                      Container(
                        margin: EdgeInsets.all(5), // 均等なマージンを追加
                        child: Icon(Icons.menu),
                      ),
                    // ここに新しいウィジェットを追加します
                    if (_isHovered) DarkModeSwitch(),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class MainMenuOfNarrow extends StatelessWidget {
  MainMenuOfNarrow({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var menuProvider = Provider.of<MenuProvider>(context);
    return Scaffold(
      body: Center(
        child: Text('縦画面には未対応です…'),
      ),
    );
  }
}

// class MainMenuOfNarrow extends StatelessWidget {
//   MainMenuOfNarrow({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     var menuProvider = Provider.of<MenuProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(menuProvider.selectedItem.title),
//       ),
//       body: menuProvider.selectedItem.content,
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: menuProvider.selectedIndex,
//         items: menuProvider.items.map((item) {
//           return BottomNavigationBarItem(
//             icon: Icon(item.icon),
//             label: item.title,
//           );
//         }).toList(),
//         onTap: menuProvider.selectItem,
//       ),
//     );
//   }
// }

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
