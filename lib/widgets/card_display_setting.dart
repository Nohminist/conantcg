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
        borderRadius: BorderRadius.circular(10),
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

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text('並べ替え：'),
              SortButtons(filterState: filterState),
              SizedBox(width: 5),
            ],
          ),
FilterTextField(filterState: filterState),
          SizedBox(height: 5),
          Row(
            children: [
              Text('色：'),
              FilterToggleButtonGroup(
                values: filterState.colorValues,
                toggleFunction: filterState.toggleColor,
                isSelected: filterState.isSelectedColor,
              ),
            ],
          ), // グループ名を追加
          SizedBox(height: 5),
          Row(
            children: [
              Text('種類：'),
              FilterToggleButtonGroup(
                values: filterState.typeValues,
                toggleFunction: filterState.toggleType,
                isSelected: filterState.isSelectedType,
              ),
            ],
          ), // グループ名を追加
          SizedBox(height: 5),
          Row(
            children: [
              Text('レア：'),
              FilterToggleButtonGroup(
                values: filterState.rarityValues,
                toggleFunction: filterState.toggleRarity,
                isSelected: filterState.isSelectedRarity,
              ),
              SizedBox(width:5),
              FilterToggleButtonGroup(
                values: filterState.parallelValues,
                toggleFunction: filterState.toggleParallel,
                isSelected: filterState.isSelectedParallel,
              ),
            ],
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
          icon: filterState.isAscending
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationX(math.pi),
                  child: Icon(Icons.sort),
                )
              : Icon(Icons.sort),
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
                          // fontWeight: FontWeight.bold,
                           color: textColor),
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
