// screens/card_set_building_top.dart
import 'package:conantcg/widgets/card_set_name_edit.dart';
import 'package:conantcg/widgets/hover_card.dart';
import 'package:conantcg/widgets/rotating_arrow_drop_icon.dart';
import 'package:conantcg/widgets/transparent_button.dart';
import 'package:flutter/material.dart';
import '../widgets/card_display_setting.dart';
import '../widgets/card_set_edit.dart';
import '../widgets/card_grid.dart';
import 'package:flutter/gestures.dart'; // 追加
import 'package:flutter/rendering.dart';

class CardSetBuildingTop extends StatefulWidget {
  @override
  _CardSetBuildingTopState createState() => _CardSetBuildingTopState();
}

class _CardSetBuildingTopState extends State<CardSetBuildingTop> {
  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > (constraints.maxHeight + keyboardHeight)) {
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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VerticalScreen(),
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

class VerticalScreen extends StatelessWidget {
  const VerticalScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandableEditingCardSet(),
        CardSetNameEdit(),
        Expanded(
          child: CardGrid(extraScroll: 80),
        ),
      ],
    );
  }
}

// class ExpandableEditingCardSet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         children: [
//           TransparentButton(
//             onTap: () {
//               // ここで何も行わない
//             },
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('デッキ'),
//                   SizedBox(width: 10),
//                   // 常に同じ状態のアイコンを表示する
//                   RotatingArrowDropIcon(isExpanded: true),
//                 ],
//               ),
//             ),
//           ),
//           // 常にCardSetEdit2を表示する
//           CardSetEdit2(),
//         ],
//     );
//   }
// }



class ExpandableEditingCardSet extends StatefulWidget {
  @override
  _ExpandableEditingCardSetState createState() =>
      _ExpandableEditingCardSetState();
}

// class _ExpandableEditingCardSetState extends State<ExpandableEditingCardSet> {
//   bool _isExpanded = true;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         children: [
//           TransparentButton(
//             onTap: () {
//               setState(() {
//                 _isExpanded = !_isExpanded;
//               });
//             },
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('デッキ'),
//                   SizedBox(width: 10),
//                   RotatingArrowDropIcon(isExpanded: _isExpanded),
//                 ],
//               ),
//             ),
//           ),
//           // アニメーションを無効にするために、AnimatedCrossFadeを削除し、
//           // 単純な条件付きレンダリングに置き換えます。
//           if (_isExpanded)
//             CardSetEdit2(),
//         ],
//     );
//   }
// }


class _ExpandableEditingCardSetState extends State<ExpandableEditingCardSet> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          AnimatedCrossFade(
            duration: Duration(milliseconds: 200),
            firstChild: Container(),
            secondChild: CardSetEdit2(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
    );
  }
}

































//スクロールを検出するのは状態管理でおかしくなる
// class VerticalLayout extends StatefulWidget {
//   @override
//   _VerticalLayoutState createState() => _VerticalLayoutState();
// }

// class _VerticalLayoutState extends State<VerticalLayout> {
//   late ScrollController _scrollController;
//   bool _showAppBar = true;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController()
//       ..addListener(() {
//         if (_scrollController.position.userScrollDirection ==
//             ScrollDirection.reverse) {
//           if (_showAppBar == true) {
//             setState(() {
//               _showAppBar = false;
//             });
//           }
//         }
//         if (_scrollController.position.userScrollDirection ==
//             ScrollDirection.forward) {
//           if (_showAppBar == false) {
//             setState(() {
//               _showAppBar = true;
//             });
//           }
//         }
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         CardGridGroup(
//           scrollController: _scrollController,
//           showAppBar: _showAppBar,
//         ),
//         Positioned(
//           bottom: 16.0,
//           right: 16.0,
//           child: FloatingActionButton(
//             onPressed: () {
//               showModalBottomSheet(
//                 context: context,
//                 builder: (context) {
//                   return CardDisplaySettingOptions();
//                 },
//               );
//             },
//             child: Icon(Icons.search),
//           ),
//         ),
//       ],
//     );
//   }
// }


// class CardGridGroup extends StatelessWidget {
//   final ScrollController scrollController;
//   final bool showAppBar;

//   CardGridGroup({required this.scrollController, required this.showAppBar});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         AnimatedCrossFade(
//           duration: Duration(milliseconds: 200),
//           firstChild: Container(),
//           secondChild: CardSetEdit2(),
//           crossFadeState: showAppBar
//               ? CrossFadeState.showSecond
//               : CrossFadeState.showFirst,
//         ),
//         Expanded(
//           child: CardGrid(extraScroll: 80, scrollController: scrollController),
//         ),
//       ],
//     );
//   }
// }






//スクロールでオーバーレイにしたかったが、高さを取得するのが面倒で却下
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
