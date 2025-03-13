import 'dart:ui';
import 'package:my_portfolio_analytics/utils/app_exports.dart';

class BackStackWidget extends StatelessWidget {
  const BackStackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.only(top: 0.h,bottom: 0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 200,
                width: 200,
                color: AppColors.primaryColor,
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 200,
                  width: 200,
                  color: AppColors.primaryColor,
                ),
              )
            ],
          ),
        ),

        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 65.0, sigmaY: 65.0),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
        ),
      ],
    );
  }
}
