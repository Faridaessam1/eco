import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void back({Object? arguments}) => Navigator.of(this).pop(arguments);

  void goToNamed(String route, {Object? arguments}) =>
      Navigator.of(this).pushNamed(route, arguments: arguments);

  void goToNamedReplaced(String route, {Object? arguments}) =>
      Navigator.of(this).pushReplacementNamed(route, arguments: arguments);

  void goBackUntil(String untilRoute) => Navigator.of(this).popUntil(
        (route) => route.settings.name == untilRoute,
      );

  void goBackUntilAndPush(String pushRoute, String untilRoute,
          {Object? arguments}) =>
      Navigator.of(this).pushNamedAndRemoveUntil(
        pushRoute,
        (route) => route.settings.name == untilRoute,
        arguments: arguments,
      );

  void removeAndPush(String pushRoute, {Object? arguments}) =>
      Navigator.of(this).pushNamedAndRemoveUntil(
        pushRoute,
        (route) => false,
        arguments: arguments,
      );
}
