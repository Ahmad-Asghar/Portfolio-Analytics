import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ScreenInfo {
  final ScreenType screenType;
  final bool isExceedingMaxWidth;

  ScreenInfo(this.screenType, this.isExceedingMaxWidth);
}

ScreenInfo getCustomScreenType(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double maxWidth = 1400;

  bool isExceedingMaxWidth = screenWidth > maxWidth;

  if (isExceedingMaxWidth) {
    return ScreenInfo(ScreenType.desktop, true);
  } else if (screenWidth >= 1024) {
    return ScreenInfo(ScreenType.desktop, false);
  } else if (screenWidth >= 600) {
    return ScreenInfo(ScreenType.tablet, false);
  } else {
    return ScreenInfo(ScreenType.mobile, false);
  }
}
