import 'package:my_portfolio_analytics/utils/app_exports.dart';

import 'loading_indicator.dart';

class CustomMainButton extends StatelessWidget {
  final Color color;
  final Widget child;
  double? borderRadius;
  final Function() onTap;
  double? height;
  double? width;
  double? elevation;
  double? loadingIndicatorSize;
  Color? borderColor;
  Color? loadingIndicatorColor;
  bool? isLoading;

  CustomMainButton({
    super.key,
    required this.color,
    this.borderRadius,
    required this.onTap,
    required this.child,
    this.height,
    this.width,
    this.elevation,
    this.loadingIndicatorSize,
    this.borderColor,
    this.loadingIndicatorColor,
    this.isLoading = false,
  }) ;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: elevation,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        side: borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none,
      ),
      color: color,
      height: height ?? 6.h,
      minWidth: width,
      onPressed: !isLoading! ? onTap : (){},
      child: isLoading! ?  CustomLoadingIndicator(color: loadingIndicatorColor,size: loadingIndicatorSize,) : child,
    );
  }
}
