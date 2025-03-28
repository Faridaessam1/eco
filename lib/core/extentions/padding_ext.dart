import 'package:flutter/cupertino.dart';

extension PaddingToWidget on Widget {
  Widget setHorizontalPadding(BuildContext context, double value,
      {bool enableMediaQuery = true}) {
    var mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: enableMediaQuery ? mediaQuery.size.width * value : value),
      child: this,
    );
  }

  Widget setVerticalPadding(BuildContext context, double value,
      {bool enableMediaQuery = true}) {
    var mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: enableMediaQuery ? mediaQuery.size.height * value : value),
      child: this,
    );
  }

  Widget setPadding(BuildContext context,
      {double horizontal = 0.0,
      double vertical = 0.0,
      bool enableMediaQuery = true}) {
    var mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            enableMediaQuery ? mediaQuery.size.width * horizontal : horizontal,
        vertical:
            enableMediaQuery ? mediaQuery.size.height * vertical : vertical,
      ),
      child: this,
    );
  }

  Widget setOnlyPadding(BuildContext context, double top, double bottom,
      double right, double left,
      {bool enableMediaQuery = true}) {
    var mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: enableMediaQuery ? mediaQuery.size.height * top : top,
        bottom: enableMediaQuery ? mediaQuery.size.height * bottom : bottom,
        right: enableMediaQuery ? mediaQuery.size.width * right : right,
        left: enableMediaQuery ? mediaQuery.size.width * left : left,
      ),
      child: this,
    );
  }
}
