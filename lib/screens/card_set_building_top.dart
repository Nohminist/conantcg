// screens/card_set_building_top.dart
import 'package:conantcg/widgets/hover_card.dart';
import 'package:flutter/material.dart';
import '../widgets/card_display_setting.dart';
import '../widgets/editing_cardset.dart';
import '../widgets/card_grid.dart';

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

class VerticalLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CardGrid(extraScroll:80),
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


