import 'package:flutter/material.dart';

Widget nonVeg() => Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.crop_square_rounded,
          color: Colors.red,
          size: 20,
        ),
        Icon(Icons.circle, color: Colors.red, size: 8),
      ],
    );
