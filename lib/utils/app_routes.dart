import 'package:flutter/material.dart';

import '../views/home/home_screen.dart';

class AppRoutes {

  static const String landingPage = '/';

  static Map<String, WidgetBuilder> get routes => {

    landingPage: (_) =>  HomeScreen(),

  };
}
