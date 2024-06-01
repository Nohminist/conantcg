// widgets/operable_card.dart
import 'package:conantcg/widgets/card_detail_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/hover_card.dart';
import '../widgets/card_image.dart';
// import 'dart:html' as html;

class OperableCard extends StatefulWidget {
  final String cardNo;
  final Function onTap;
  final List<String> cards;

  OperableCard(
      {required this.cardNo, required this.cards, required this.onTap});

  @override
  _OperableCardState createState() => _OperableCardState();
}

class _OperableCardState extends State<OperableCard> {
  late Offset _lastHoverPosition;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        if (_lastHoverPosition == event.position) {
          return;
        }
        _lastHoverPosition = event.position;

        var screenWidth = MediaQuery.of(context).size.width;
        var hoverPosition = event.position.dx;
        var isLeftSideSelected = hoverPosition < (screenWidth / 2);
        Provider.of<HoverCardManage>(context, listen: false)
            .selectCardNo(widget.cardNo, isLeftSideSelected);
      },
      onExit: (_) {
        Provider.of<HoverCardManage>(context, listen: false).deselectCardNo();
      },
      child: GestureDetector(
        onPanStart: (_) {
          Provider.of<HoverCardManage>(context, listen: false).startDragging();
        },
        onPanEnd: (_) {
          Provider.of<HoverCardManage>(context, listen: false).stopDragging();
        },
        onTap: () {
          Provider.of<HoverCardManage>(context, listen: false).deselectCardNo();
          widget.onTap();
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CardDetailModal(
                  cards: widget.cards, initialCardNo: widget.cardNo);
            },
          );
        },
        child: CardImage9(cardNo: widget.cardNo),
      ),
    );
  }
}
