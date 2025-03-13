import 'package:my_portfolio_analytics/utils/app_exports.dart';

class CustomTextWidget extends StatelessWidget {
  final String title;
  final Color color;
  final Color? decorationColor;
  final double? fontSize;
  final int? maxLines;
  final double? height;
  final double? letterSpacing;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final List<Shadow>? shadows;
  final String? fontFamily;

  const CustomTextWidget({
    super.key,
    required this.title,
    this.color = Colors.black,
    this.decorationColor,
    this.fontSize,
    this.maxLines,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.textDecoration = TextDecoration.none,
    this.shadows,
    this.height,
    this.letterSpacing,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      softWrap: true,
      textHeightBehavior: TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      style: TextStyle(wordSpacing: 0,
        letterSpacing: letterSpacing,
        height: height,
        decorationColor: decorationColor?? AppColors.greyTextColor,
          fontFamily: fontFamily?? AppConstants.fontFamily,
          decoration: textDecoration,
          color: color,
          fontSize: fontSize?? 16.sp,
          fontWeight: fontWeight,
          shadows: shadows,
      ),
    );
  }
}