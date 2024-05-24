// providers/menu_provider.dart
import 'package:flutter/material.dart';
import '../screens/deck_building.dart';
import '../screens/single_player_simulator_screen.dart';


class MenuItem {
  final String title;
  final IconData icon;
  final Widget content;

  MenuItem({required this.title, required this.icon, required this.content});
}

class MenuProvider with ChangeNotifier {
  List<MenuItem> _items = [
    MenuItem(
      title: 'デッキ作成',
      icon: Icons.deck,
      content: DeckBuildingScreen(),
    ),
    // MenuItem(
    //   title: '1人回しシミュ',
    //   icon: Icons.person,
    //   content: SinglePlayerSimulatorScreen(),
    // ),
  ];

  int _selectedIndex = 0;

  List<MenuItem> get items => _items;

  MenuItem get selectedItem => _items[_selectedIndex];

  int get selectedIndex => _selectedIndex;

  void selectItem(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
