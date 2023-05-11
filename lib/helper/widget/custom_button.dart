import 'package:flutter/material.dart';
import 'package:nukang_fe/helper/size_utils.dart';
import 'package:nukang_fe/themes/app_theme.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {this.padding,
      this.shape,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.margin,
      this.onTap,
      this.width,
      this.height,
      this.text,
      this.prefixWidget,
      this.suffixWidget});

  ButtonPadding? padding;

  ButtonShape? shape;

  ButtonVariant? variant;

  ButtonFontStyle? fontStyle;

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  VoidCallback? onTap;

  double? width;

  double? height;

  String? text;

  Widget? prefixWidget;

  Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildButtonWidget(),
          )
        : _buildButtonWidget();
  }

  _buildButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: onTap,
        style: _buildTextButtonStyle(),
        child: _buildButtonWithOrWithoutIcon(),
      ),
    );
  }

  _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefixWidget ?? SizedBox(),
          Text(
            text ?? "",
            textAlign: TextAlign.center,
            style: _setFontStyle(),
          ),
          suffixWidget ?? SizedBox(),
        ],
      );
    } else {
      return Text(
        text ?? "",
        textAlign: TextAlign.center,
        style: _setFontStyle(),
      );
    }
  }

  _buildTextButtonStyle() {
    return TextButton.styleFrom(
      fixedSize: Size(
        width ?? double.maxFinite,
        height ?? getVerticalSize(40),
      ),
      padding: _setPadding(),
      backgroundColor: _setColor(),
      side: _setTextButtonBorder(),
      shadowColor: _setTextButtonShadowColor(),
      shape: RoundedRectangleBorder(
        borderRadius: _setBorderRadius(),
      ),
    );
  }

  _setPadding() {
    switch (padding) {
      case ButtonPadding.PaddingAll6:
        return getPadding(
          all: 6,
        );
      case ButtonPadding.PaddingT5:
        return getPadding(
          left: 5,
          top: 5,
          bottom: 5,
        );
      case ButtonPadding.PaddingT11:
        return getPadding(
          left: 11,
          top: 11,
          bottom: 11,
        );
      case ButtonPadding.PaddingAll26:
        return getPadding(
          all: 26,
        );
      default:
        return getPadding(
          all: 9,
        );
    }
  }

  _setColor() {
    switch (variant) {
      case ButtonVariant.OutlineBlack900_1:
        return AppTheme.white;
      case ButtonVariant.OutlineBlack900_2:
        return AppTheme.white;
      case ButtonVariant.OutlineIndigo40070:
        return AppTheme.white;
      case ButtonVariant.OutlineWhiteA700:
        return null;

      case ButtonVariant.FillCyan400:
        return AppTheme.nearlyBlue;
      default:
        return AppTheme.white;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariant.OutlineWhiteA700:
        return BorderSide(
          color: AppTheme.white,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineBlack900_1:
        return BorderSide(
          color: AppTheme.nearlyBlack,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineBlack900_2:
        return BorderSide(
          color: AppTheme.nearlyBlack,
          width: getHorizontalSize(
            5.00,
          ),
        );
      case ButtonVariant.OutlineBlack9003f:
      case ButtonVariant.FillWhiteA700:
      case ButtonVariant.OutlineIndigo4003f:
      case ButtonVariant.FillCyan400:
        return BorderSide(
          color: AppTheme.nearlyBlack,
          width: getHorizontalSize(
            2.00,
          ),
        );
      case ButtonVariant.FillCyan40001:
      case ButtonVariant.FillCyan600:
      case ButtonVariant.OutlineIndigo40070:
        return null;
      default:
        return BorderSide(
          color: AppTheme.nearlyBlack,
          width: getHorizontalSize(
            1.00,
          ),
        );
    }
  }

  _setTextButtonShadowColor() {
    switch (variant) {
      case ButtonVariant.OutlineBlack9003f:
        return AppTheme.nearlyBlack;
      case ButtonVariant.OutlineIndigo40070:
        return AppTheme.indigo;
      default:
        return null;
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case ButtonShape.RoundedBorder3:
        return BorderRadius.circular(
          getHorizontalSize(
            3.00,
          ),
        );
      case ButtonShape.CircleBorder14:
        return BorderRadius.circular(
          getHorizontalSize(
            14.00,
          ),
        );
      case ButtonShape.RoundedBorder10:
        return BorderRadius.circular(
          getHorizontalSize(
            10.00,
          ),
        );
      case ButtonShape.Square:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            20.00,
          ),
        );
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.PoppinsRegular16:
        return TextStyle(
          color: AppTheme.white,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.56,
          ),
        );
      case ButtonFontStyle.PoppinsSemiBold12:
        return TextStyle(
          color: AppTheme.nearlyBlack,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.PoppinsMedium16:
        return TextStyle(
          color: AppTheme.white,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.PoppinsMedium12:
        return TextStyle(
          color: AppTheme.white,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.RobotoItalicMedium14:
        return TextStyle(
          color: AppTheme.white,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.21,
          ),
        );
      case ButtonFontStyle.PoppinsSemiBold16:
        return TextStyle(
          color: AppTheme.white,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.PoppinsRegular16Black900:
        return TextStyle(
          color: AppTheme.nearlyBlack,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.56,
          ),
        );
      case ButtonFontStyle.PoppinsRegular14:
        return TextStyle(
          color: AppTheme.nearlyBlack,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.PoppinsMedium14Black900:
        return TextStyle(
          color: AppTheme.nearlyBlack,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.PoppinsRegular12:
        return TextStyle(
          color: AppTheme.nearlyBlack,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.PoppinsRegular10:
        return TextStyle(
          color: AppTheme.nearlyBlack,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.50,
          ),
        );
      default:
        return TextStyle(
          color: AppTheme.nearlyBlack,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.50,
          ),
        );
    }
  }
}

enum ButtonPadding {
  PaddingAll9,
  PaddingAll6,
  PaddingT5,
  PaddingT11,
  PaddingAll26,
}

enum ButtonShape {
  Square,
  RoundedBorder3,
  CircleBorder14,
  RoundedBorder20,
  RoundedBorder10,
}

enum ButtonVariant {
  OutlineBlack900,
  OutlineBlack9003f,
  FillWhiteA700,
  OutlineIndigo4003f,
  FillCyan400,
  FillCyan40001,
  OutlineWhiteA700,
  FillCyan600,
  OutlineBlack900_1,
  OutlineBlack900_2,
  OutlineIndigo40070,
}

enum ButtonFontStyle {
  PoppinsSemiBold16Black900,
  PoppinsRegular16,
  PoppinsSemiBold12,
  PoppinsMedium16,
  PoppinsMedium12,
  RobotoItalicMedium14,
  PoppinsSemiBold16,
  PoppinsRegular16Black900,
  PoppinsRegular14,
  PoppinsMedium14Black900,
  PoppinsRegular12,
  PoppinsRegular10,
}
