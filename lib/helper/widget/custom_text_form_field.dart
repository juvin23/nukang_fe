import 'package:flutter/material.dart';
import 'package:nukang_fe/helper/size_utils.dart';
import 'package:nukang_fe/themes/app_theme.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {this.padding,
      this.shape,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.width,
      this.margin,
      this.controller,
      this.focusNode,
      this.isObscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.validator,
      this.isDisabled});
  bool? isDisabled = false;

  TextFormFieldPadding? padding;

  TextFormFieldShape? shape;

  TextFormFieldVariant? variant;

  TextFormFieldFontStyle? fontStyle;

  Alignment? alignment;

  double? width;

  EdgeInsetsGeometry? margin;

  TextEditingController? controller;

  FocusNode? focusNode;

  bool? isObscureText;

  TextInputAction? textInputAction;

  TextInputType? textInputType;

  int? maxLines;

  String? hintText;

  Widget? prefix;

  BoxConstraints? prefixConstraints;

  Widget? suffix;

  BoxConstraints? suffixConstraints;

  FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: width ?? double.maxFinite,
      margin: margin,
      child: TextFormField(
        readOnly: isDisabled ?? false,
        controller: controller,
        focusNode: focusNode,
        style: _setFontStyle(),
        obscureText: isObscureText!,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: _buildDecoration(),
        validator: validator,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      fillColor: AppTheme.nearlyWhite,
      hintText: hintText ?? "",
      hintStyle: _setFontStyle(),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    if (isDisabled != null) {
      return TextStyle(
        color: AppTheme.disableText,
        fontSize: getFontSize(
          16,
        ),
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        height: getVerticalSize(
          1.56,
        ),
      );
    }

    switch (fontStyle) {
      case TextFormFieldFontStyle.PoppinsRegular16:
        return TextStyle(
          color: AppTheme.lightText,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.56,
          ),
        );
      case TextFormFieldFontStyle.PoppinsItalic10:
        return TextStyle(
          color: AppTheme.lighterGrey,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.50,
          ),
        );
      case TextFormFieldFontStyle.RobotoMedium14:
        return TextStyle(
          color: AppTheme.lighterGrey,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.21,
          ),
        );
      case TextFormFieldFontStyle.PoppinsMediumItalic14:
        return TextStyle(
          color: AppTheme.dark_grey,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.50,
          ),
        );
      case TextFormFieldFontStyle.PoppinsMediumItalic14Black900:
        return TextStyle(
          color: AppTheme.darkText,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.50,
          ),
        );
      case TextFormFieldFontStyle.PoppinsMedium13:
        return TextStyle(
          color: AppTheme.darkText,
          fontSize: getFontSize(
            13,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.54,
          ),
        );
      default:
        return TextStyle(
          color: AppTheme.darkText,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.56,
          ),
        );
    }
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      case TextFormFieldShape.RoundedBorder15:
        return BorderRadius.circular(
          getHorizontalSize(
            15.00,
          ),
        );
      case TextFormFieldShape.RoundedBorder6:
        return BorderRadius.circular(
          getHorizontalSize(
            6.00,
          ),
        );
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            10.00,
          ),
        );
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case TextFormFieldVariant.FillWhiteA700:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.FillGray200:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.FillGray5001:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.OutlineBlack900_1:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: AppTheme.darkText,
            width: 1,
          ),
        );
      case TextFormFieldVariant.OutlineBlack900_2:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: AppTheme.darkText,
            width: 1,
          ),
        );
      case TextFormFieldVariant.OutlineBlack900_3:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: AppTheme.darkText,
            width: 1,
          ),
        );
      case TextFormFieldVariant.OutlineBlack900_4:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: AppTheme.darkText,
            width: 1,
          ),
        );
      case TextFormFieldVariant.OutlineBlack900_5:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: AppTheme.darkText,
            width: 1,
          ),
        );
      case TextFormFieldVariant.OutlineBlack200:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: AppTheme.notWhite,
            width: 1,
          ),
        );
      case TextFormFieldVariant.None:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: AppTheme.darkText,
            width: 1,
          ),
        );
    }
  }

  _setFillColor() {
    return AppTheme.notWhite;
  }

  _setFilled() {
    switch (variant) {
      case TextFormFieldVariant.FillWhiteA700:
        return true;
      case TextFormFieldVariant.FillGray200:
        return true;
      case TextFormFieldVariant.FillGray5001:
        return true;
      case TextFormFieldVariant.OutlineBlack900_1:
        return true;
      case TextFormFieldVariant.OutlineBlack900_2:
        return true;
      case TextFormFieldVariant.OutlineBlack900_3:
        return true;
      case TextFormFieldVariant.OutlineBlack900_4:
        return true;
      case TextFormFieldVariant.OutlineBlack900_5:
        return false;
      case TextFormFieldVariant.None:
        return false;
      default:
        return true;
    }
  }

  _setPadding() {
    switch (padding) {
      case TextFormFieldPadding.PaddingT9:
        return getPadding(
          left: 9,
          top: 9,
          bottom: 9,
        );
      case TextFormFieldPadding.PaddingT78:
        return getPadding(
          left: 11,
          top: 78,
          right: 11,
          bottom: 78,
        );
      case TextFormFieldPadding.PaddingT62:
        return getPadding(
          left: 7,
          top: 62,
          right: 7,
          bottom: 62,
        );
      case TextFormFieldPadding.PaddingT62_1:
        return getPadding(
          left: 16,
          top: 62,
          right: 16,
          bottom: 62,
        );
      case TextFormFieldPadding.PaddingT18:
        return getPadding(
          left: 14,
          top: 18,
          right: 14,
          bottom: 18,
        );
      case TextFormFieldPadding.PaddingAll18:
        return getPadding(
          all: 18,
        );
      default:
        return getPadding(
          all: 9,
        );
    }
  }
}

enum TextFormFieldPadding {
  PaddingAll9,
  PaddingT9,
  PaddingT78,
  PaddingT62,
  PaddingT62_1,
  PaddingT18,
  PaddingAll18,
}

enum TextFormFieldShape {
  RoundedBorder10,
  RoundedBorder15,
  RoundedBorder6,
}

enum TextFormFieldVariant {
  None,
  OutlineBlack900,
  FillWhiteA700,
  FillGray200,
  FillGray5001,
  OutlineBlack900_1,
  OutlineBlack900_2,
  OutlineBlack900_3,
  OutlineBlack900_4,
  OutlineBlack900_5,
  OutlineBlack200,
}

enum TextFormFieldFontStyle {
  PoppinsRegular16Black900,
  PoppinsRegular16,
  PoppinsItalic10,
  RobotoMedium14,
  PoppinsMediumItalic14,
  PoppinsMediumItalic14Black900,
  PoppinsMedium13,
}
