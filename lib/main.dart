// main.dart
import 'package:conantcg/widgets/hover_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/menu_provider.dart';
import 'screens/menu.dart';
import 'providers/theme_provider.dart';
import '../providers/filter_provider.dart';
import '../providers/card_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // 追加
// import '../providers/csv_data.dart'; // 追加
import '../utils/csv_data.dart'; // 追加
import '../utils/common_utils.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ローディング画面を表示
  runApp(
    MaterialApp(
      home: SplashScreen(),
    ),
  );

  // ローカルストレージからデータを読み込む
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> cardSetsData = prefs.getStringList(getStorageKey('cardSets')) ?? [];
  // List<String> cardSetsData = prefs.getStringList('conantcg-cardSets') ?? [];
  List<CardSetNo> cardSets = cardSetsData.isNotEmpty
      ? cardSetsData
          .map((data) => CardSetNo.fromJson(jsonDecode(data)))
          .toList()
      : [CardSetNo()];


  // EditingCardSetKeyの初期値を設定
  String editingDateStr = prefs.getString(getStorageKey('cardSetDate')) ?? '';
  DateTime editingDate = editingDateStr.isNotEmpty
      ? DateTime.parse(editingDateStr)
      : cardSets[0].date; // cardSets[0].dateを使用
  EditingCardSetKey editingKey = EditingCardSetKey(editingDate);

  // CardSetの状態を初期化
  CardSetNo currentCardSet = CardSetNo.copy(
    cardSets.firstWhere(
      (cardSet) => cardSet.date == editingKey.date,
      orElse: () {
        editingKey.setDate(cardSets[0].date); // editingKeyを更新
        return cardSets[0];
      },
    ),
  );

  // アプリケーションをロード
  await Future.delayed(Duration(seconds: 3));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProvider(create: (context) => FilterState()),
        ChangeNotifierProvider(create: (_) => HoverCardManage()),
        ChangeNotifierProvider(create: (_) => currentCardSet),
        ChangeNotifierProvider(create: (_) => CardSets(cardSets)),
        ChangeNotifierProvider(create: (_) => editingKey), // 更新
        ChangeNotifierProvider(create: (_) => CsvData()..load()),
        ChangeNotifierProvider(create: (_) => PreCardSet()..load()),
        ChangeNotifierProvider(create: (_) => CardNoMap()..load()),
      ],
      child: MyApp(),
    ),
  );
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<HoverCardManage>(context, listen: false).deselectCardNo();
      },
      child: MaterialApp(
        title: 'コナンTCGツール',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'NotoSansJP',
        ),
        darkTheme: ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'NotoSansJP'),
        ),
        themeMode: Provider.of<ThemeModeProvider>(context).themeMode,
        home: MainTop(),
      ),
    );
  }
}
