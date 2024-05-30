// screens/card_set_building_top.dart
import 'package:conantcg/widgets/hover_card.dart';
import 'package:flutter/material.dart';
import '../widgets/card_display_setting.dart';
import '../widgets/editing_cardset.dart';
import '../widgets/card_grid.dart';
import 'package:flutter/widgets.dart'; // 追加
import 'package:flutter/gestures.dart'; // 追加
import 'package:flutter/rendering.dart';

class CardSetBuildingTop extends StatefulWidget {
  @override
  _CardSetBuildingTopState createState() => _CardSetBuildingTopState();
}

class _CardSetBuildingTopState extends State<CardSetBuildingTop> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > constraints.maxHeight) {
          // 横長の場合
          return Stack(
            children: [
              HorizontalLayout(),
              HoverCard(),
            ],
          );
        } else {
          // 縦長の場合
          return VerticalLayout();
        }
      },
    );
  }
}

class HorizontalLayout extends StatelessWidget {
  const HorizontalLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: EditingCardSet(),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              HorizontalCardDisplaySetting(),
              Expanded(
                child: CardGrid(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VerticalLayout extends StatefulWidget {
  @override
  _VerticalLayoutState createState() => _VerticalLayoutState();
}

class _VerticalLayoutState extends State<VerticalLayout> {
  late ScrollController _scrollController;
  bool _showEditingCardSet = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_showEditingCardSet == true) {
            setState(() {
              _showEditingCardSet = false;
            });
          }
        }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_showEditingCardSet == false) {
            setState(() {
              _showEditingCardSet = true;
            });
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    double _editingCardSetHeight = MediaQuery.of(context).size.height / 2; // 画面の高さの50%を取得

    return Stack(
      children: [
        Positioned.fill(
          child: CardGrid(extraScroll: 80, scrollController: _scrollController),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: _showEditingCardSet ? _editingCardSetHeight : 0.0,
          color: Colors.blueGrey, // 背景色を設定
          child: EditingCardSet(),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CardDisplaySettingOptions();
                },
              );
            },
            child: Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}
