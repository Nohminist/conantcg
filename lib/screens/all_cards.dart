// screens/all_cards.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/filter_provider.dart';
import '../utils/color.dart';
import '../widgets/card_grid.dart';
import '../utils/csv_data.dart';

class AllCards extends StatefulWidget {
  @override
  _AllCardsState createState() => _AllCardsState();
}

class _AllCardsState extends State<AllCards> {
  @override
  Widget build(BuildContext context) {
    var filterState = Provider.of<FilterState>(context);
    Map<String, Map<String, dynamic>> _data =
        context.watch<CardNoMapData>().data; // ここでデータを取得
    return Column(
      children: [
        FilterWidget(filterState: filterState),
        Expanded(
          child: CardGrid(), // _data.values.toList()でカードのデータのリストを取得
        ),
      ],
    );
  }
}

class FilterWidget extends StatefulWidget {
  final FilterState filterState;

  FilterWidget({required this.filterState});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0,
      upperBound: 0.5, // これにより、アイコンは180度だけ回転します
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getRelativeColor(context, 0.1),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                  if (_isExpanded) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                });
              },
              highlightColor: Theme.of(context).highlightColor, // テーマのハイライト色
              splashColor: Theme.of(context).splashColor, // テーマのスプラッシュ色
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  // Rowウィジェットを追加
                  mainAxisAlignment: MainAxisAlignment.center, // アイコンを中央に配置
                  children: [
                    Icon(Icons.search), // 虫眼鏡アイコンを追加
                    SizedBox(width: 10), // アイコンの間にスペースを追加
                    RotationTransition(
                      turns: _controller,
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: Duration(milliseconds: 200),
            firstChild: Container(),
            secondChild: FilterOptions(filterState: widget.filterState),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FilterOptions extends StatelessWidget {
  final FilterState filterState;

  FilterOptions({required this.filterState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              SortButtons(filterState: filterState),
              SizedBox(width: 5),
              Expanded(
                // Expandedウィジェットを追加
                child: TextField(
                  onChanged: (value) {
                    filterState.updateInputText(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text('色'), // グループ名を追加
          FilterToggleButtonGroup(
            values: filterState.colorValues,
            toggleFunction: filterState.toggleColor,
            isSelected: filterState.isSelectedColor,
          ),
          SizedBox(height: 5),
          Text('種類'), // グループ名を追加
          FilterToggleButtonGroup(
            values: filterState.typeValues,
            toggleFunction: filterState.toggleType,
            isSelected: filterState.isSelectedType,
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 中央に寄せる
            children: [
              Text('レアリティ'), // グループ名を追加
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0), // paddingXを追加
                decoration: BoxDecoration(
                  // color: getRelativeColor(context, 0.2), // 背景色を変更
                  borderRadius: BorderRadius.circular(5.0), // 背景を丸くする
                ),
                child: InkWell(
                  // InkWellを追加
                  onTap: () {
                    filterState.toggleIncludeParallel();
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: filterState.includeParallel,
                        onChanged: (bool? newValue) {
                          filterState.toggleIncludeParallel();
                        },
                      ),
                      Text('パラレルを含める'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          FilterToggleButtonGroup(
            values: filterState.rarityValues,
            toggleFunction: filterState.toggleRarity,
            isSelected: filterState.isSelectedRarity,
          ),
        ],
      ),
    );
  }
}

class SortButtons extends StatelessWidget {
  const SortButtons({
    super.key,
    required this.filterState,
  });

  final FilterState filterState;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: filterState.sortKey,
          items: filterState.sortKeys.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              filterState.updateSortKey(newValue);
            }
          },
        ),
        IconButton(
          icon: Icon(filterState.isAscending
              ? Icons.arrow_upward
              : Icons.arrow_downward),
          onPressed: () {
            filterState.toggleSortOrder();
          },
        ),
      ],
    );
  }
}

class FilterToggleButtonGroup extends StatelessWidget {
  final List<String> values;
  final Function(int) toggleFunction;
  final List<bool> isSelected;

  FilterToggleButtonGroup({
    required this.values,
    required this.toggleFunction,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color borderColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color fillColor = getRelativeColor(context, 0.3);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: ToggleButtons(
          children: values
              .map((value) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      value,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ))
              .toList(),
          onPressed: toggleFunction,
          isSelected: isSelected,
          borderColor: borderColor,
          selectedBorderColor: borderColor,
          color: textColor,
          fillColor: fillColor,
        ),
      ),
    );
  }
}
