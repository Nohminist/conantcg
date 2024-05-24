import '../widgets/card_image.dart';
import '../widgets/save_area.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import '../utils/color.dart';
import '../providers/card_provider.dart';
import 'dart:math';
import 'package:intl/intl.dart'; // DateFormatを使用するために必要

class SaveImageButton extends StatelessWidget {
  GlobalKey _globalKey = GlobalKey();

  final CardSetNo cardSet;

  SaveImageButton({
    required this.cardSet,
  });

  @override
  Widget build(BuildContext context) {
    // 条件をチェック
    bool canSaveImage = cardSet.deck.length == 40 &&
        cardSet.partner != null &&
        cardSet.caseCard != null;

    return IconButton(
      onPressed: canSaveImage
          ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // 画面サイズを取得
                  var screenSize = MediaQuery.of(context).size;
                  // 縦か横の小さい方の90%を取得
                  var size = min(screenSize.width, screenSize.height) * 0.9;

                  return Dialog(
                    insetPadding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SaveImageIcon(_globalKey, cardSet),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        Container(
                          width: size,
                          height: size,
                          child: RepaintBoundary(
                            key: _globalKey,
                            child: SaveArea(
                              cardSet: cardSet,
                              size: size,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          : null, // 条件を満たさない場合はnullを設定
      icon: Icon(Icons.image),
      tooltip: '保存用の画像にする（条件：カードが揃っていること）',
    );
  }
}

class SaveImageIcon extends StatelessWidget {
  final GlobalKey _globalKey;
  final CardSetNo cardSet; // cardSetをこのクラスでも利用するために追加

  SaveImageIcon(this._globalKey, this.cardSet); // コンストラクタにcardSetを追加

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.save_alt), // 保存アイコンを使用
      onPressed: () {
        WidgetsBinding.instance!.addPostFrameCallback((_) async {
          RenderRepaintBoundary? boundary = _globalKey.currentContext
              ?.findRenderObject() as RenderRepaintBoundary?;
          if (boundary != null) {
            // 画像の目標解像度
            final targetWidth = 1080;
            final targetHeight = 1080;

            // boundaryの現在のサイズを取得
            final boundarySize = boundary.size;

            // 適切なpixelRatioを計算
            final pixelRatio = max(targetWidth / boundarySize.width,
                targetHeight / boundarySize.height);

            ui.Image? image = await boundary.toImage(pixelRatio: pixelRatio);

            if (image != null) {
              ByteData? byteData =
                  await image.toByteData(format: ui.ImageByteFormat.png);
              if (byteData != null) {
                final pngBytes = byteData.buffer.asUint8List();
                final blob = html.Blob([pngBytes]);
                final url = html.Url.createObjectUrlFromBlob(blob);
                final anchor = html.document.createElement('a')
                    as html.AnchorElement
                  ..href = url
                  ..style.display = 'none'
                  // ファイル名を指定の形式に変更
                  ..download =
                      '${cardSet.name}(${DateFormat('yyyy-MM-dd_HH-mm-ss').format(cardSet.date)}).png';
                html.document.body!.children.add(anchor);
                anchor.click();
                html.document.body!.children.remove(anchor);
                html.Url.revokeObjectUrl(url);
                print('画像が保存されました: ${anchor.download}');
              } else {
                print('ByteData is null. Failed to convert image to ByteData.');
              }
            } else {
              print(
                  'Image is null. Failed to capture image from RenderRepaintBoundary.');
            }
          } else {
            print(
                'RenderRepaintBoundary is null. Failed to find RenderRepaintBoundary.');
          }
        });
      },
    );
  }
}
