import '../widgets/save_area.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import '../providers/card_provider.dart';
import 'dart:math';
import 'dart:io';
import 'package:path_provider/path_provider.dart'; // 追加
// import 'package:flutter/material.dart';
// import 'package:screenshot/screenshot.dart';
import 'package:screenshot/screenshot.dart';
// import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;




// saveImageToFile メソッドを定義

Future<File> saveImageToFile(ByteData byteData, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/$fileName';
  final file = File(path);
  await file.writeAsBytes(byteData.buffer.asUint8List());
  return file;
}

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
          ? () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // 画面サイズを取得
                  var screenSize = MediaQuery.of(context).size;
                  // 縦か横の小さい方の90%を取得
                  var size = min(screenSize.width, screenSize.height) * 0.9;

                  return Modal(globalKey: _globalKey, size: size, cardSet: cardSet);
                },
              );
            }
          : null, // 条件を
      icon: Icon(Icons.image),
      tooltip: 'モーダルを開く（条件：カードが揃っていること）',
    );
  }
}





class Modal extends StatelessWidget {
  Modal({
    Key? key,
    required GlobalKey<State<StatefulWidget>> globalKey,
    required this.size,
    required this.cardSet,
  })  : _globalKey = globalKey,
        super(key: key);

  final GlobalKey<State<StatefulWidget>> _globalKey;
  final double size;
  final CardSetNo cardSet;
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _saveScreenshot() async {
    final image = await screenshotController.capture();
    if (image != null) {
      final blob = html.Blob([image]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'screenshot.png')
        ..click();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _saveScreenshot,
                child: Text('画像で保存する'),
              ),
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
            child: Screenshot(
              controller: screenshotController,
              child: RepaintBoundary(
                key: _globalKey, // キーを設定
                child: SaveArea(
                  cardSet: cardSet,
                  size: size,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}






class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required GlobalKey<State<StatefulWidget>> globalKey,
  }) : _globalKey = globalKey;

  final GlobalKey<State<StatefulWidget>> _globalKey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        File? file; // ファイルをnull許容で定義
        try {
          // 画像変換
          final boundary = _globalKey.currentContext!
                  .findRenderObject()
              as RenderRepaintBoundary;
          final image =
              await boundary.toImage(pixelRatio: 2.0);
    
          // 画像をバイトデータに変換
          final byteData = await image.toByteData(
              format: ui.ImageByteFormat.png);
    
          // バイトデータをファイルに保存
          if (byteData != null) {
            file = await saveImageToFile(
                byteData, 'card_image.png');
          }
        } catch (error) {
          // エラー処理
          print(error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('画像の保存に失敗しました: ${error}'),
            ),
          );
        }
    
        if (file != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('画像を保存しました: ${file.path}'),
            ),
          );
        }
      },
      child: Text('変換して保存'),
    );
  }
}