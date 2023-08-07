import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoaderLayoutWidget extends StatefulWidget {
  Color? loaderColor;
  Color? bgColor;
  double? opacity;

  LoaderLayoutWidget({this.loaderColor, this.bgColor, this.opacity});

  @override
  _LoaderLayoutWidgetState createState() => _LoaderLayoutWidgetState();
}

class _LoaderLayoutWidgetState extends State<LoaderLayoutWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Opacity(
        opacity: widget.opacity ?? 0.6,
        child: ModalBarrier(
            dismissible: false, color: widget.bgColor ?? Colors.black),
      ),
      Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,

                /// Required, The loading type of the widget
                colors: [Colors.white],

                /// Optional, The color collections

                /// Optional, the stroke backgroundColor
              ),
            )
          ],
        ),
      ),
    ]);
  }
}
