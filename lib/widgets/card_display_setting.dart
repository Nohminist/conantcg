// widget/card_display_setting.dart
import 'package:conantcg/widgets/common_text_field.dart';
import 'package:conantcg/widgets/rotating_arrow_drop_icon.dart';
import 'package:conantcg/widgets/transparent_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/filter_provider.dart';
import '../utils/color.dart';
import 'dart:math';
import 'dart:math' as math;

class HorizontalCardDisplaySetting extends StatefulWidget {
  @override
  _HorizontalCardDisplaySettingState createState() =>
      _HorizontalCardDisplaySettingState();
}

class _HorizontalCardDisplaySettingState
    extends State<HorizontalCardDisplaySetting> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getRelativeColor(context, 0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
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
                  Icon(Icons.search),
                  SizedBox(width: 10),
                  RotatingArrowDropIcon(isExpanded: _isExpanded),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: Duration(milliseconds: 200),
            firstChild: Container(),
            secondChild: CardDisplaySettingOptions(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
    );
  }
}

class CardDisplaySettingOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var filterState = Provider.of<FilterState>(context);

    return SingleChildScrollView(
      // この行を追加
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(), // この行を追加
              ElevatedButton(
                onPressed: () {
                  filterState.initializeFilters();
                },
                child: const Text('初期化'),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {
                  filterState.clearFilters();
                },
                child: const Text('クリア'),
              ),
            ],
          ),
          const SizedBox(height: 5),
          SortButtons(filterState: filterState),
          FilterTextField(filterState: filterState),
          const SizedBox(height: 5),
          const Text('色'),
          FilterToggleButtonGroup(
            values: filterState.colorValues,
            toggleFunction: filterState.toggleColor,
            isSelected: filterState.isSelectedColor,
          ),
          const SizedBox(height: 5),
          const Text('種類'),
          FilterToggleButtonGroup(
            values: filterState.typeValues,
            toggleFunction: filterState.toggleType,
            isSelected: filterState.isSelectedType,
          ),
          const SizedBox(height: 5),
          const Text('レアリティ'),
          FilterToggleButtonGroup(
            values: filterState.rarityValues,
            toggleFunction: filterState.toggleRarity,
            isSelected: filterState.isSelectedRarity,
          ),
          const SizedBox(height: 5),
          const Text('レベル'), // 追加
          FilterToggleButtonGroup(
            values: filterState.levelValues
                .map((e) => e.toString())
                .toList(), // intをStringに変換
            toggleFunction: filterState.toggleLevel,
            isSelected: filterState.isSelectedLevel,
          ),
          const SizedBox(height: 5),
          const Text('AP'), // 追加
          FilterToggleButtonGroup(
            values: filterState.apValues
                .map((e) => e.toString())
                .toList(), // intをStringに変換
            toggleFunction: filterState.toggleAp,
            isSelected: filterState.isSelectedAp,
          ),
          const SizedBox(height: 5),
          const Text('LP'), // 追加
          FilterToggleButtonGroup(
            values: filterState.lpValues
                .map((e) => e.toString())
                .toList(), // intをStringに変換
            toggleFunction: filterState.toggleLp,
            isSelected: filterState.isSelectedLp,
          ),
          const SizedBox(height: 5),
          const Text('カテゴリ（特徴）'),
          FilterToggleButtonGroup(
            values: filterState.labelValues,
            toggleFunction: filterState.toggleLabel,
            isSelected: filterState.isSelectedLabel,
          ),
        ],
      ),
    );
  }
}

class FilterTextField extends StatefulWidget {
  final FilterState filterState;

  FilterTextField({required this.filterState});

  @override
  _FilterTextFieldState createState() => _FilterTextFieldState();
}

class _FilterTextFieldState extends State<FilterTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.filterState.inputText);

    // FilterStateのinputTextが更新されたときにTextFieldの表示を更新する
    widget.filterState.addListener(_updateText);
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.filterState.removeListener(_updateText);
    super.dispose();
  }

  void _updateText() {
    _controller.text = widget.filterState.inputText;
  }

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      prefixIcon: Icons.search,
      labelText: 'フリーワード',
      controller: _controller,
      onSubmitted: (value) {
        widget.filterState.updateInputText(value);
      },
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
        SizedBox(
          height: 34.0,
          child: ToggleButtons(
            onPressed: (int index) {
              if ((index == 0 && filterState.isAscending) ||
                  (index == 1 && !filterState.isAscending)) {
                return;
              }
              filterState.toggleSortOrder();
            },
            isSelected: [filterState.isAscending, !filterState.isAscending],
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(math.pi),
                      child: const Icon(Icons.sort),
                    ),
                    const Text('昇順'),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Icon(Icons.sort),
                    Text('降順'),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 5),
        DropdownButton<String>(
          value: filterState.sortKey,
          items: filterState.sortKeys.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value == 'Lv.' ? 'レベル' : value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              filterState.updateSortKey(newValue);
            }
          },
        ),

        // IconButton(
        //   icon: filterState.isAscending
        //       ? Transform(
        //           alignment: Alignment.center,
        //           transform: Matrix4.rotationX(math.pi),
        //           child: Icon(Icons.sort),
        //         )
        //       : Icon(Icons.sort),
        //   onPressed: () {
        //     filterState.toggleSortOrder();
        //   },
        // ),
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
    Color textColor = isDarkMode ? Colors.grey[200]! : Colors.grey[800]!;
    Color borderColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color fillColor = getRelativeColor(context, 0.1);

    return Wrap(
      children: List.generate(values.length, (index) {
        return Padding(
          padding: EdgeInsets.all(2),
          child: OutlinedButton(
            onPressed: () => toggleFunction(index),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: borderColor, width: 1),
              backgroundColor: isSelected[index] ? textColor : fillColor,
              foregroundColor: isSelected[index] ? fillColor : textColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), // 角丸の半径を調整します
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            child: Text(values[index]),
          ),
        );
      }),
    );
  }
}

// class FilterToggleButtonGroup extends StatelessWidget {
//   final List<String> values;
//   final Function(int) toggleFunction;
//   final List<bool> isSelected;

//   FilterToggleButtonGroup({
//     required this.values,
//     required this.toggleFunction,
//     required this.isSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     Color textColor = isDarkMode ? Colors.white : Colors.black;
//     Color borderColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
//     Color fillColor = getRelativeColor(context, 0.3);
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5),
//         border: Border.all(
//           color: borderColor,
//           width: 1,
//         ),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(7),
//         child: ToggleButtons(
//           children: values
//               .map((value) => Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       value,
//                       style: TextStyle(
//                           // fontWeight: FontWeight.bold,
//                           color: textColor),
//                     ),
//                   ))
//               .toList(),
//           onPressed: toggleFunction,
//           isSelected: isSelected,
//           borderColor: borderColor,
//           selectedBorderColor: borderColor,
//           color: textColor,
//           fillColor: fillColor,
//         ),
//       ),
//     );
//   }
// }
