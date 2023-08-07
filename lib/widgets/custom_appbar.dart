import 'package:flutter/material.dart';

Widget customAppbar(
    {required BuildContext context,
    Widget? leading,
    Widget? title,
    Color? bgColor,
    List<Widget>? actions,
    TabBar? bottom,
    double? titleSpacing,
    bool? centerTitle = false,
    double? elevation = 0}) {
  return AppBar(
    backgroundColor: bgColor ?? Colors.white,
    elevation: elevation,
    titleSpacing: titleSpacing ?? 12,
    leading: leading != null ? leading : null,
    actions: actions ?? actions,
    centerTitle: centerTitle,
    title: title ?? title,
    bottom: bottom ?? bottom,
  );
}
