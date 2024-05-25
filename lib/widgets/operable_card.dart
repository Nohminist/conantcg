// widgets/operable_card.dart
import 'package:conantcg/widgets/card_detail_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../widgets/card_image.dart';
import 'dart:html' as html;

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
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) {
        var userAgent = html.window.navigator.userAgent;
        var isTouchDevice = userAgent.contains('Android') ||
            userAgent.contains('iPhone') ||
            userAgent.contains('iPad');

        if (isTouchDevice) {
          // タッチデバイスではonHoverイベントを無視
          return;
        }

        var screenWidth = MediaQuery.of(context).size.width;
        var hoverPosition = _.position.dx;
        var isLeftSideSelected = hoverPosition < (screenWidth / 2 + 20);
        Provider.of<DetailCardNo>(context, listen: false)
            .selectCardNo(widget.cardNo, isLeftSideSelected);
      },
      onExit: (_) {
        Provider.of<DetailCardNo>(context, listen: false).deselectCardNo();
      },
      child: GestureDetector(
        onPanStart: (_) {
          Provider.of<DetailCardNo>(context, listen: false).startDragging();
        },
        onPanEnd: (_) {
          Provider.of<DetailCardNo>(context, listen: false).stopDragging();
        },
        onTap: () {
          Provider.of<DetailCardNo>(context, listen: false).deselectCardNo();
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
