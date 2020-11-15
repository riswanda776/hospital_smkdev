import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// --------------
/// Constant color
/// --------------
Color primaryColor = const Color(0xff2784f9);
Color grayColor = const Color(0xff999999);
Color whiteBlueColor = const Color(0xffdee4f3);

/// -----------
/// Device size
/// -----------
double deviceHeight() => ScreenUtil().screenHeight;
double deviceWidth() => ScreenUtil().screenWidth;

/// ---------------------------------
/// Scaling size screen util and font
/// ---------------------------------
/// initialize screen util
void setupScreenUtil(BuildContext context) =>
    ScreenUtil.init(context, allowFontScaling: true);

getHeight(BuildContext context) => MediaQuery.of(context).size.height;

/// set height and width
double setHeight(double height) => ScreenUtil().setHeight(height);
double setWidth(double width) => ScreenUtil().setWidth(width);

/// set font size
double setFontSize(double size) =>
    ScreenUtil().setSp(size, allowFontScalingSelf: true);

/// ------------------
/// Settings Textstyle
/// ------------------
/// title TextStyle
TextStyle titleStyle =
    TextStyle(fontWeight: FontWeight.w600, fontSize: setFontSize(60));

TextStyle subTitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: setFontSize(40),
    color: Colors.black.withOpacity(0.9));

TextStyle colorStyle = TextStyle(color: grayColor);

Border newsBorder = Border.all(color: grayColor.withAlpha(350));

///
/// Alert text
