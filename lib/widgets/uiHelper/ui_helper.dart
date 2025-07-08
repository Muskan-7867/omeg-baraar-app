import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UiHelper {
  static customImage({required String image}) {
    return Image.asset("assets/images/$image");
}

  static svgRenderer({required String svg}) {
    return SvgPicture.asset("assets/icons/$svg");
}
}
