import 'package:flutter/material.dart';

class ScreenSize {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
          MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static double getFontSize(
      BuildContext context, {
        required double mobile,
        double? tablet,
        double? desktop,
      }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile + 2;
    } else {
      return desktop ?? mobile + 4;
    }
  }
}