import 'package:flutter/material.dart';

Widget veg() => Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.crop_square_rounded,
          color: Colors.green,
          size: 20,
        ),
        Icon(Icons.circle, color: Colors.green, size: 8),
      ],
    );
