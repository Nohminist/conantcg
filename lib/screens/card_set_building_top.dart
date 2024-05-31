// screens/card_set_building_top.dart
import 'package:conantcg/utils/color.dart';
import 'package:conantcg/widgets/card_set_save_button.dart';
import 'package:conantcg/widgets/cardset_operations2.dart';
import 'package:conantcg/widgets/hover_card.dart';
import 'package:flutter/material.dart';
import '../widgets/card_display_setting.dart';
import '../widgets/card_set_edit.dart';
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
          child: CardSetEdit(),
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
  bool _showAppBar = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_showAppBar == true) {
            setState(() {
              _showAppBar = false;
            });
          }
        }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_showAppBar == false) {
            setState(() {
              _showAppBar = true;
            });
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CardGridGroup(
          scrollController: _scrollController,
          showAppBar: _showAppBar,
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

class CardGridGroup extends StatelessWidget {
  final ScrollController scrollController;
  final bool showAppBar;

  CardGridGroup({required this.scrollController, required this.showAppBar});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCrossFade(
          duration: Duration(milliseconds: 200),
          firstChild: Container(),
          secondChild: CardSetEdit2(),
          crossFadeState: showAppBar
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
        Expanded(
          child: CardGrid(extraScroll: 80, scrollController: scrollController),
        ),
      ],
    );
  }
}

//オーバーレイにしたかったが、高さを取得するのが面倒で却下
// class CardGridGroup extends StatelessWidget {
//   final ScrollController scrollController;
//   final bool showAppBar;

//   CardGridGroup({required this.scrollController, required this.showAppBar});

//   @override
//   Widget build(BuildContext context) {
//     // 画面の高さを取得
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     // 画面の高さの75%を計算
//     final topExtraScroll = screenHeight * 0.75;

//     return Stack(
//       children: [
//         CardGrid(
//           topExtraScroll: topExtraScroll,
//           extraScroll: 80,
//           scrollController: scrollController,
//         ),
//         Positioned(
//           top: 0,
//           left: 0,
//           right: 0,
//           child: AnimatedCrossFade(
//             duration: Duration(milliseconds: 200),
//             firstChild: Container(),
//             secondChild: CardSetEdit2(),
//             crossFadeState: showAppBar
//                 ? CrossFadeState.showSecond
//                 : CrossFadeState.showFirst,
//           ),
//         ),
//       ],
//     );
//   }
// }
