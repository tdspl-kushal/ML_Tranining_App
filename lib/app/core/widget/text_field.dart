import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../values/app_colors.dart';
import '../values/app_values.dart';
import '../values/text_styles.dart';

class CTInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final String lable;
  final int? maxLength;
  final TextInputType keyboard;
  final FocusNode? focusNode;
  final VoidCallback? onFinished;
  final bool isPassword;
  final String? regExp;
  final bool isEnabled;
  final bool isCounterOff;
  final IconData? suffixIcon;
  final TextCapitalization? textCapitalization;
  final double horizontalPadding;
  final double? verticalPadding;
  final Function? onValueChanged;
  final String? error;

  const CTInputField(
      {Key? key,
      this.controller,
      this.hint = '',
      this.maxLength,
      this.regExp,
      this.keyboard = TextInputType.text,
      this.focusNode,
      required this.lable,
      this.suffixIcon,
      this.isEnabled = true,
      this.textCapitalization = TextCapitalization.words,
      this.isCounterOff = false,
      this.onFinished,
      this.isPassword = false,
      required this.horizontalPadding,
      this.verticalPadding = 5.0,
      this.onValueChanged,
      this.error})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CTInputFieldState();
  }
}

class CTInputFieldState extends State<CTInputField> {
  String? error;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    error = widget.error;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding, vertical: widget.verticalPadding!),
      child: Column(
        children: <Widget>[
          TextField(
            enableSuggestions: false,
            autocorrect: false,
            enabled: widget.isEnabled,
            onChanged: (value) => widget.onValueChanged != null ? widget.onValueChanged!(value) ?? "" : () => {},
            maxLength: widget.maxLength,
            style: primaryColorSubtitleStyle,
            controller: widget.controller,
            focusNode: widget.focusNode,
            textCapitalization: widget.textCapitalization!,
            keyboardType: widget.keyboard,
            obscureText: widget.isPassword,
            inputFormatters: widget.regExp == null
                ? null
                : [
                    FilteringTextInputFormatter.allow(RegExp(
                      widget.regExp!,
                    ))
                  ],
            decoration: InputDecoration(
              counterText: widget.isCounterOff ? '' : null,
              isDense: false,
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
              fillColor: AppColors.light_gray,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.app_colorPrimary_light, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(AppValues.radius_12)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.appBarColor, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(AppValues.radius_12)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.appPrimary_black, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(AppValues.radius_12)),
              ),
              labelText: widget.lable,
              hintText: widget.hint,
              suffixIcon: widget.suffixIcon != null
                  ? Icon(widget.suffixIcon, size: 22, color: AppColors.appPrimary_black)
                  : isChecked
                      ? const Icon(Icons.done)
                      : null,
              labelStyle: greyDarkTextStyle,
              hintStyle: greyDarkTextStyle,
            ),
          ),
          error == null
              ? Container()
              : const Text(
                  "error",
                  style: errorTextStyle,
                )
        ],
      ),
    );
  }

// String validate() {
//   setState(() {
//     error = widget.validator(widget.controller.text);
//   });
//   return error;
// }
}
