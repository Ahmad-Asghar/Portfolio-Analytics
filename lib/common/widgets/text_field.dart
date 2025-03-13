import 'package:my_portfolio_analytics/utils/app_exports.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? title;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final bool? obSecureText;
  final bool? readOnly;
  final double? elevation;
  final Function()? onTap;
  final Function(String value)? onChanged;
  final TextInputType? textInputType;
  final int? maxLines;
  final Color? borderColor;

  const CustomTextField(
      {super.key,
      required this.hintText,
      this.controller,
      this.prefix,
      this.title,
      this.suffix,
      this.obSecureText,
      this.readOnly,
      this.elevation,
      this.onTap,
      this.onChanged,
      this.textInputType,
      this.maxLines,
      this.borderColor,

      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: CustomTextWidget(
                    title: title.toString(),
                    fontSize: 12,
                ),
              )
            : const SizedBox(),
        Container(
          height: maxLines!=null? maxLines!*17 : 33,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: borderColor??Colors.transparent,
              width: borderColor!=null?1:0
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(elevation??0.35),
            //     spreadRadius: 3,
            //     blurRadius: 4,
            //   ),
            // ],
          ),
          child: TextFormField(
            maxLines: maxLines??1,
            controller: controller,
            onChanged: onChanged,
            keyboardType: textInputType,
            onTap: onTap,
            readOnly: readOnly??false,
            textAlignVertical: TextAlignVertical.center,
            obscureText: obSecureText??false,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.fieldTextColor
            ),
            decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textFieldColor,
                contentPadding:  EdgeInsets.symmetric(horizontal: 15,vertical: maxLines!=null?15:0),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.greyTextColor,
                  fontWeight: FontWeight.w400
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppColors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppColors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppColors.white,
                  ),
                ),
                prefixIcon: prefix,
                suffixIcon: suffix),
          ),
        ),
      ],
    );
  }
}




class CustomSecondaryTextField extends StatelessWidget {
  final String hintText;
  String? title;
  TextEditingController? controller;
  Widget? prefix;
  Widget? suffix;
  bool? obSecureText;
  bool? readOnly;
  double? elevation;
  Function()? onTap;
  TextInputType? textInputType;
  List<TextInputFormatter>? inputFormatters;
  Function(String)? onChanged;

  CustomSecondaryTextField(
      {super.key,
        required this.hintText,
        this.controller,
        this.prefix,
        this.title,
        this.suffix,
        this.obSecureText,
        this.readOnly,
        this.elevation,
        this.onTap,
        this.textInputType,
        this.inputFormatters,
        this.onChanged,
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? CustomTextWidget(
                maxLines: 1,
                title: title.toString(),
                fontSize: 16.6.sp,
                color: AppColors.greySettingsColor,
            )
            : const SizedBox(),
        SizedBox(
          height: 4.3.h,
          child: Center(
            child: TextFormField(
              onChanged: onChanged,
              inputFormatters: inputFormatters,
              controller: controller,
              keyboardType: textInputType,
              onTap: onTap,
              readOnly: readOnly ?? false,
              textAlignVertical: TextAlignVertical.top,
              obscureText: obSecureText ?? false,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17.sp,
                color: AppColors.fieldTextColor,
              ),
              decoration: InputDecoration(
                hintMaxLines: 1,
                contentPadding: EdgeInsets.only(left: 4.w,right: 6.w,bottom: 2.h),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.7.sp,
                  color: AppColors.greyTextColor,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.greySettingsColor,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.greySettingsColor,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                  ),
                ),
                prefixIcon: prefix,
                suffixIcon: suffix,
              ),
            ),
          )

        ),
      ],
    );
  }
}



