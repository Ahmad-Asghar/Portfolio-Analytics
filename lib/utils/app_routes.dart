import 'package:flutter/material.dart';

import '../views/contact/contact_messages.dart';
import '../views/home/home_screen.dart';

class AppRoutes {

  static const String landingPage = '/';
  static const String contactMessagesPage = 'contactMessages';

  static Map<String, WidgetBuilder> get routes => {

    landingPage: (_) =>  HomeScreen(),
    contactMessagesPage: (_) =>  ContactMessagesScreen(),

  };
}
