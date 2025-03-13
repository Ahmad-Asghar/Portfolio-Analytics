import 'package:flutter/material.dart';
import 'app_routes.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

final ScrollController homeScrollController = ScrollController();

final GlobalKey servicesSectionKey = GlobalKey();
final GlobalKey contactSectionKey = GlobalKey();
final GlobalKey aboutMeSectionKey = GlobalKey();
final GlobalKey projectsSectionKey = GlobalKey();

void scrollToContainer(GlobalKey key) {
  final context = key.currentContext;
  if (context != null) {
    Scrollable.ensureVisible(
      context,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
}


class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> push(String routeName, {dynamic arguments, bool animation = false, RouteTransitionsBuilder? transitionBuilder}) {
    return navigatorKey.currentState!.push(
      _buildPageRoute(routeName, arguments: arguments, animation: animation, transitionBuilder: transitionBuilder),
    );
  }

  Future<dynamic> pushReplacement(String routeName, {dynamic arguments, bool animation = false, RouteTransitionsBuilder? transitionBuilder}) {
    return navigatorKey.currentState!.pushReplacement(
      _buildPageRoute(routeName, arguments: arguments, animation: animation, transitionBuilder: transitionBuilder),
    );
  }

  void goBack([dynamic result]) {
    navigatorKey.currentState!.pop(result);
  }

  Future<dynamic> pushAndClearStack(String routeName, {dynamic arguments, bool animation = false, RouteTransitionsBuilder? transitionBuilder}) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      _buildPageRoute(routeName, arguments: arguments, animation: animation, transitionBuilder: transitionBuilder),
          (route) => false, // This clears the entire stack
    );
  }

  PageRoute _buildPageRoute(String routeName, {dynamic arguments, bool animation = false, RouteTransitionsBuilder? transitionBuilder}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AppRoutes.routes[routeName]!(context),
      transitionsBuilder: animation
          ? (transitionBuilder ?? _defaultTransition)
          : (context, animation, secondaryAnimation, child) => child,
      transitionDuration: const Duration(milliseconds: 800),
      settings: RouteSettings(arguments: arguments),
    );
  }

  Widget _defaultTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
