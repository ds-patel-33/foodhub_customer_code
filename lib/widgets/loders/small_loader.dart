import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

Widget smallLoader(
    {required BuildContext context, double? height, Color? color}) {
  return Center(
    child: Container(
      height: height ?? 50,
      child: LoadingIndicator(
          indicatorType: Indicator.values[12],
          color: color ?? Theme.of(context).primaryColor),
    ),
  );
}
