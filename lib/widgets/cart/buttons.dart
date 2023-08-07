import 'package:flutter/material.dart';

import '../../variables/images.dart';

Widget add({required BuildContext context}) => Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          Images.PLUS,
          width: 35,
          height: 35,
        )
      ],
    );

Widget remove({required BuildContext context}) => Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          Images.MINUS,
          width: 35,
          height: 35,
        )
      ],
    );
