// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'constant.dart';

class ButtonWidget extends GetView {
  const ButtonWidget(
      {super.key,
      this.fontSize,
      this.fontFamily,
      required this.title,
      this.buttonColor,
      this.textColor,
      required this.onTap,
      this.width,
      this.height,
      this.enable = true,
      this.borderRadius});

  final String title;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double? fontSize;
  final String? fontFamily;
  final double? borderRadius;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enable ? onTap : null,
      child: Container(
        height: height ?? 50.w,
        width: width ?? MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: enable ? buttonColor ?? blueColor : greyColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Center(
          child: TextWidget(
            text: title,
            fontSize: fontSize ?? 18.sp,
            color: textColor ?? whiteColor,
            fontFamily: fontFamily ?? 'SM',
          ),
        ),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.text,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.letterSpacing,
    this.height,
    this.fontFamily,
    this.textDecoration,
  });

  final String text;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final FontWeight? fontWeight;
  final Color? color;
  final String? fontFamily;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: true,
      style: TextStyle(
          fontSize: fontSize ?? 14.sp,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? blackColor,
          letterSpacing: letterSpacing,
          height: height,
          fontFamily: fontFamily ?? "R",
          decoration: textDecoration),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    this.hint,
    this.maxLine = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.obse = false,
    this.readonly = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onchange,
    this.pretxt,
    this.enabled,
    this.color,
    this.minLines,
    this.onSubmitted,
    this.onTap,
    this.inputFormatters,
    this.validation,
    @required this.controller,
  });

  final TextEditingController? controller;
  final String? hint;
  final Color? color;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obse;
  final bool? enabled;
  final bool? readonly;
  final int? maxLine;
  final int? minLines;
  final Function(String)? onchange;
  final void Function()? onTap;
  final Function(String?)? onSubmitted;
  final String? pretxt;
  final String? Function(String?)? validation;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onchange,
      validator: validation,
      onTap: onTap,
      controller: controller,
      maxLines: maxLine,
      autofocus: false,
      readOnly: readonly!,
      enabled: enabled,
      obscureText: obse!,
      initialValue: pretxt,
      cursorColor: color ?? Theme.of(context).textTheme.titleMedium!.color,
      cursorWidth: 1,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hint,filled: true,
        isDense: false,
        prefixStyle:  TextStyle(color: Theme.of(context).textTheme.titleMedium!.color),
        errorStyle:
            TextStyle(fontFamily: 'R', color: redColor, fontSize: 12.sp / MediaQuery.of(context).textScaleFactor, decoration: TextDecoration.none),
        hintStyle: TextStyle(
          color: greyColor,
          fontFamily: 'R',
          fontSize: 16.sp / MediaQuery.of(context).textScaleFactor,
        ),
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: greyColor, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: greyColor, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: blueColor, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
      ),
      keyboardType: textInputType,
      textInputAction: textInputAction,
      style: TextStyle(
        fontFamily: 'R',
        color: Theme.of(context).textTheme.titleMedium!.color,
        fontSize: 16.sp / MediaQuery.of(context).textScaleFactor,
      ),
    );
  }
}

class ListWidget extends GetView {
  const ListWidget({
    super.key,
    required this.title,
    required this.image,
    this.buttonColor,
    this.textColor,
    required this.onTap,
  });

  final String title;
  final String image;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52.h,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color:  isDark ? lightBlackColor : backgroundGreyColor),
        child: Row(
          children: [
            SvgPicture.asset(image),
            SizedBox(
              width: 10.w,
            ),
            TextWidget(text: title, fontFamily: 'M', fontSize: 14.sp, color: Theme.of(context).textTheme.titleMedium!.color),
            Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: greyColor),
          ],
        ),
      ),
    );
  }
}

AppBar appBarWidget(String title,BuildContext context) {
  return AppBar(
    leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: Theme.of(context).appBarTheme.iconTheme!.color)),
    title: TextWidget(text: title, fontSize: 20.sp, fontFamily: 'SM',color: Theme.of(context).textTheme.titleMedium!.color),
    centerTitle: true,
  );
}
