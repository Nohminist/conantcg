// widgets/card_image.dart

import 'package:conantcg/widgets/card_image.dart';
import 'package:flutter/material.dart';

class FadeInImageWithoutPlaceholder extends StatefulWidget {
  final String image;
  final BoxFit fit;

  FadeInImageWithoutPlaceholder({required this.image, required this.fit});

  @override
  _FadeInImageWithoutPlaceholderState createState() =>
      _FadeInImageWithoutPlaceholderState();
}

class _FadeInImageWithoutPlaceholderState
    extends State<FadeInImageWithoutPlaceholder>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late ImageStream _imageStream;
  ImageInfo? _imageInfo;
  int _retryCount = 0;
  String? _error; // エラーメッセージを保存するための新しい変数

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadImage();
  }

  @override
  void didUpdateWidget(FadeInImageWithoutPlaceholder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _loadImage();
    }
  }

  @override
  void dispose() {
    _imageStream.removeListener(ImageStreamListener(_updateImage, onError: _retryImage));
    _controller.dispose();
    super.dispose();
  }

  void _loadImage() {
    _imageStream = AssetImage(widget.image).resolve(ImageConfiguration.empty);
    _imageStream.addListener(ImageStreamListener(_updateImage, onError: _retryImage));
  }

  void _updateImage(ImageInfo imageInfo, bool synchronousCall) {
    setState(() {
      _imageInfo = imageInfo;
      _error = null; // 画像が正常に読み込まれた場合、エラーメッセージをクリアします
    });
    _controller.forward(from: 0.0);
  }

void _retryImage(dynamic exception, StackTrace? stackTrace) {
  if (_retryCount < 3) { // 3回までリトライします
    _retryCount++;
    _imageStream.removeListener(ImageStreamListener(_updateImage, onError: _retryImage)); // リスナーを一度削除します
    _loadImage(); // 画像の読み込みを再試行します
  } else {
    setState(() {
      _error = exception.toString(); // リトライが失敗した場合、エラーメッセージを保存します
    });
  }
}


  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      // エラーメッセージが存在する場合、それを表示します
      return Text('Error: $_error');
    } else {
      return _imageInfo != null
          ? FadeTransition(
              opacity: _controller,
              child: RawImage(
                image: _imageInfo!.image,
                fit: widget.fit,
              ),
            )
          : Container();
    }
  }
}



// class _FadeInImageWithoutPlaceholderState
//     extends State<FadeInImageWithoutPlaceholder>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late ImageStream _imageStream;
//   ImageInfo? _imageInfo;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _loadImage();
//   }

//   @override
//   void didUpdateWidget(FadeInImageWithoutPlaceholder oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.image != oldWidget.image) {
//       _loadImage();
//     }
//   }

//   @override
//   void dispose() {
//     _imageStream.removeListener(ImageStreamListener(_updateImage));
//     _controller.dispose();
//     super.dispose();
//   }

//   void _loadImage() {
//     _imageStream = AssetImage(widget.image).resolve(ImageConfiguration.empty);
//     _imageStream.addListener(ImageStreamListener(_updateImage));
//   }

//   void _updateImage(ImageInfo imageInfo, bool synchronousCall) {
//     setState(() {
//       _imageInfo = imageInfo;
//     });
//     _controller.forward(from: 0.0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _imageInfo != null
//         ? FadeTransition(
//             opacity: _controller,
//             child: RawImage(
//               image: _imageInfo!.image,
//               fit: widget.fit,
//             ),
//           )
//         : Container();
//   }
// }

