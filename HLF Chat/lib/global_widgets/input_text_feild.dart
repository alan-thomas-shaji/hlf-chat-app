import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputTextFormField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? tController;
  final Color? hintTextColor;
  final Color? contentTextColor;
  final Color? textFieldColor;
  final double? width;
  final bool? isEnabled;
  final bool? obscureText;
  final String? Function(String?)? validator;
  InputTextFormField({
    Key? key,
    @required this.hintText,
    this.tController,
    this.hintTextColor,
    this.contentTextColor,
    this.textFieldColor,
    this.width,
    this.isEnabled,
    this.validator,
    this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Get.size;
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: textFieldColor ?? Color(0xffeeeeee),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        textCapitalization: TextCapitalization.sentences,
        controller: tController,
        enabled: isEnabled,
        obscureText: obscureText!,
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        // style: kSub2HeadTextStyle.copyWith(
        //     color: contentTextColor ?? Color(0xff3a4750), fontSize: 16),
        cursorHeight: 18,
        decoration: InputDecoration(
          hintText: hintText,
          // hintStyle: kSub2HeadTextStyle.copyWith(
          //   fontSize: 16,
          //   color: hintTextColor ?? Color(0xff8E8E8E),
          // ),
          errorStyle: TextStyle(color: Colors.red),
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
