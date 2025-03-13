import 'package:my_portfolio_analytics/utils/app_exports.dart';
import 'package:flutter/material.dart';

import 'back_stack_widget.dart';

class CustomScaffoldWidget extends StatelessWidget {

  final Widget body;
  final Widget? bottomNavBar;
  final Widget? bottomSheet;
  final AppBar? appBar;

  const CustomScaffoldWidget({
    super.key,
    required this.body,
    this.bottomNavBar,
    this.bottomSheet, this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomSheet: bottomSheet,
      bottomNavigationBar: bottomNavBar,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const BackStackWidget(),
          body,
        ],
      ),
    );
  }
}
