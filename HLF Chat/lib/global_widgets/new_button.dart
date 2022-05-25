import 'package:flutter/material.dart';

class NewButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? color;
  final Widget? child;
  final void Function()? onPressed;
  const NewButton({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
    this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius!),
      ),
      margin: EdgeInsets.only(bottom: 18),
      child: InkWell(
        onTap: onPressed,
        child: child,
      ),
    );
  }
}