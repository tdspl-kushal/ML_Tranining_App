import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_getx_template/app/core/ui/custom_theme.dart';

import '../values/app_colors.dart';

class  ITDropDown<T> extends StatelessWidget {
  const ITDropDown(
      {required this.dataArray,
      required this.onChanged,
      this.selectedItem,
      this.isMandatory,
      required this.hint,
      this.validator,
      this.defaultValue,this.enabled = true, this.disabledHint});

  final List<DropdownMenuItem<T>>? dataArray;
  final T? defaultValue;
  final String hint;
  final String? Function(String?)? validator;
  final ValueChanged<T?> onChanged;
  final String? selectedItem;
  final bool? isMandatory;
  final bool? enabled;
  final String? disabledHint;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(

      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      isExpanded: true,
      value: defaultValue,
      disabledHint: enabled! ? Text(disabledHint ?? '') : null,
      hint: Text(
        hint,
        // style: CustomTheme.defaultDropDownTextStyle,
      ),
      items: dataArray,
      onChanged: enabled! ? onChanged : null,
      buttonStyleData: const ButtonStyleData(
        height: 60,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
