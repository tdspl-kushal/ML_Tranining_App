import 'package:flutter/material.dart';

import '../values/app_colors.dart';
import '../values/app_values.dart';
import '../values/text_styles.dart';

class DropdownPicker extends StatelessWidget {
  const DropdownPicker(
      {required this.itemNames,
      this.selectedOption,
      required this.onChanged,
      required this.hintText,
      this.labelText,
      this.verticalPadding = 5.0,
      required this.horizontalPadding});

  final List<String> itemNames;
  final String? selectedOption;
  final void Function(String?, int) onChanged;
  final double horizontalPadding;
  final double? verticalPadding;
  final String hintText;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    String hitTextString = hintText;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding!),
      child: DropdownButtonFormField(
          decoration: InputDecoration(
              fillColor: AppColors.light_gray,
              filled: true,
              enabledBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: BorderSide(color: AppColors.colorPrimary, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(AppValues.radius_12)),
              ),
              border: const OutlineInputBorder(),
              disabledBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: BorderSide(color: AppColors.textColorWhite, width: 0.0),
                borderRadius: BorderRadius.all(Radius.circular(AppValues.radius_12)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.colorPrimary, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(AppValues.radius_12)),
              ),
              labelText: labelText ?? hintText,
              hintText: hintText,
              labelStyle: cardSmallTagStyle),
          focusColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          iconEnabledColor: Colors.black,
          items: itemNames.map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: cardSmallTagStyle),
            );
          }).toList(),
          hint: Text(hintText, style: cardSmallTagStyle),
          value: selectedOption,
          onChanged: (value) {
            onChanged(value as String, itemNames.indexOf(value));
          }),
    );
  }
}
