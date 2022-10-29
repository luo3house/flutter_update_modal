import 'package:flutter/widgets.dart';

class UpdateModalContentStyle {
  static final defaultStyle = dark;
  static final light = UpdateModalContentStyle()
    ..bgColor = const Color(0xFFFFFFFF)
    ..titleSize = 18.0
    ..titleColor = const Color(0xFF000000)
    ..infoSize = 14.0
    ..infoColor = const Color(0xFF8D8D8D)
    ..descriptionSize = 14.0
    ..descriptionColor = const Color(0xFF000000)
    ..buttonTextSize = 16.0
    ..buttonBgColor = const Color(0xFFFFFFFF)
    ..buttonTextColor = const Color(0xFF000000)
    ..maskColor = const Color(0x98000000)
    ..borderColor = const Color(0xFFDEDEDE);
  static final dark = UpdateModalContentStyle()
    ..bgColor = const Color(0xFF454545)
    ..titleSize = 18.0
    ..titleColor = const Color(0xFFFFFFFF)
    ..infoSize = 14.0
    ..infoColor = const Color(0xFFDDDDDD)
    ..descriptionSize = 14.0
    ..descriptionColor = const Color(0xFFFFFFFF)
    ..buttonTextSize = 16.0
    ..buttonBgColor = const Color(0xFF454545)
    ..buttonTextColor = const Color(0xFFFFFFFF)
    ..maskColor = const Color(0x98000000)
    ..borderColor = const Color(0xFFDEDEDE);

  Color? bgColor;
  double? titleSize;
  Color? titleColor;
  double? infoSize;
  Color? infoColor;
  double? descriptionSize;
  Color? descriptionColor;
  double? buttonTextSize;
  Color? buttonBgColor;
  Color? buttonTextColor;
  Color? maskColor;
  Color? borderColor;
}
