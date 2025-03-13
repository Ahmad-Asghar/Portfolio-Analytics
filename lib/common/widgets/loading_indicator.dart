import 'package:my_portfolio_analytics/utils/app_exports.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final  Color? color;
  final  double? size;
  const CustomLoadingIndicator({super.key,this.color,this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size??3.h,
      width: size??3.h,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color:color?? AppColors.white,
        ),
      ),
    );
  }
}
