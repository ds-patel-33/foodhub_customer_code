import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loader extends StatefulWidget {
  Color? loaderColor;
  Color? bgColor;
  double? opacity;
  Loader({this.loaderColor, this.bgColor, this.opacity});
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Opacity(
        opacity: widget.opacity ?? 0.5,
        child: ModalBarrier(dismissible: false, color: widget.bgColor),
      ),
      Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 75,
              width: 75,
              child: LoadingIndicator(
                  indicatorType: Indicator.values[12],
                  color: widget.loaderColor),
            ),
          ],
        ),
      ),
    ]);
  }
}
