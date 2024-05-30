// screens/card_set_building_top.dart
import 'package:conantcg/widgets/hover_card.dart';
import 'package:flutter/material.dart';
import '../widgets/card_display_setting.dart';
import '../widgets/editing_cardset.dart';
import '../widgets/card_grid.dart';
import 'package:conantcg/widgets/rotating_arrow_drop_icon.dart';
import 'package:conantcg/widgets/transparent_button.dart';

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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              ExpandableEditingCardSet(),
              Expanded(
                child: CardGrid(extraScroll: 80),
              ),
            ],
          ),
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

class ExpandableEditingCardSet extends StatefulWidget {
  @override
  _ExpandableEditingCardSetState createState() =>
      _ExpandableEditingCardSetState();
}

class _ExpandableEditingCardSetState extends State<ExpandableEditingCardSet> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _isExpanded ? 1 : 0,
      child: Column(
        children: [
          TransparentButton(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('デッキ'),
                  SizedBox(width: 10),
                  RotatingArrowDropIcon(isExpanded: _isExpanded),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Expanded(
              child: EditingCardSet(),
            ),
        ],
      ),
    );
  }
}
