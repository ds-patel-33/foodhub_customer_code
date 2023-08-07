import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../variables/images.dart';

class CustomImage extends StatelessWidget {
  final String imgURL;
  final String placeholderImg;
  final double? height;
  final double? width;
  final BoxFit fit;

  CustomImage({
    required this.imgURL,
    this.height,
    this.width,
    this.placeholderImg = Images.NO_IMAGE,
    this.fit = BoxFit.cover,
  });

  Widget _buildCacheImage() {
    return imgURL.isEmpty
        ? Container(
            color: Color(0xFFEEF0F2),
            child: Image.asset(
              placeholderImg,
              fit: BoxFit.cover,
            ),
          )
        : CachedNetworkImage(
            imageUrl: imgURL,
            placeholder: (context, url) => Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: LoadingIndicator(
                      color: Theme.of(context).primaryColor,
                      indicatorType: Indicator.values[12],
                    ),
                  ),
                )
              ],
            ),
            errorWidget: (context, url, error) => Image.asset(
              placeholderImg,
              fit: BoxFit.cover,
              height: height,
              width: width,
            ),
            fit: fit,
            height: height,
            width: width,
          );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCacheImage();
  }
}
