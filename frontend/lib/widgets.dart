// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/gradient_borders.dart';
import '../app_theme.dart';
import '../app_utils.dart';

extension DropDownStyleHelper on CustomDropDown {
  static OutlineInputBorder get fillOnPrimaryContainer => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.h),
        borderSide: BorderSide.none,
      );
}

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );
  static BoxDecoration get fillOnPrimaryContainerTL74 => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(74.h),
      );
  static BoxDecoration get fillOrange => BoxDecoration(
        color: appTheme.orange50,
        borderRadius: BorderRadius.circular(24.h),
      );
  static BoxDecoration get none => BoxDecoration();
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

extension TextFormFieldStyleHelper on CustomTextFormField {
  static OutlineInputBorder get outlineBlueGray => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.h),
        borderSide: BorderSide(
          color: appTheme.blueGray100,
          width: 1,
        ),
      );
  static OutlineInputBorder get outlineGray => OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.h),
        borderSide: BorderSide(
          color: appTheme.gray300,
          width: 1,
        ),
      );
  static UnderlineInputBorder get underLineBlack => UnderlineInputBorder(
        borderSide: BorderSide(
          color: appTheme.black900,
        ),
      );
  static OutlineInputBorder get fillOnPrimaryContainerTL20 =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.h),
        borderSide: BorderSide.none,
      );
  static OutlineInputBorder get fillOnPrimaryContainerTL201 =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.h),
        borderSide: BorderSide.none,
      );
}

enum ImageType { svg, png, network, file, unknown }

enum Style { bgFillOnPrimaryContainer, bgOutlineGray100 }

enum BottomBarEnum {
  Home,
  Maximize,
  Medicaliconinutrition,
  Calendar,
  Lockgray600
}

class BaseButton extends StatelessWidget {
  const BaseButton(
      {super.key,
      required this.text,
      this.onPressed,
      this.buttonStyle,
      this.buttonTextStyle,
      this.isDisabled,
      this.height,
      this.width,
      this.margin,
      this.alignment});

  final String text;

  final VoidCallback? onPressed;

  final ButtonStyle? buttonStyle;

  final TextStyle? buttonTextStyle;

  final bool? isDisabled;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? margin;

  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillBlueGray => ElevatedButton.styleFrom(
        backgroundColor: appTheme.blueGray50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.h),
        ),
        elevation: 0,
        padding: EdgeInsetsDirectional.zero,
      );
  static ButtonStyle get fillDeepOrange => ElevatedButton.styleFrom(
        backgroundColor: appTheme.deepOrange50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
        elevation: 0,
        padding: EdgeInsetsDirectional.zero,
      );
  static ButtonStyle get fillDeepOrangeTL6 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.deepOrange500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.h),
        ),
        elevation: 0,
        padding: EdgeInsetsDirectional.zero,
      );
  static ButtonStyle get fillGray => ElevatedButton.styleFrom(
        backgroundColor: appTheme.gray200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
        elevation: 0,
        padding: EdgeInsetsDirectional.zero,
      );
  static ButtonStyle get fillOnPrimaryContainer => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.h),
        ),
        elevation: 0,
        padding: EdgeInsetsDirectional.zero,
      );
  static ButtonStyle get fillOrangeA => ElevatedButton.styleFrom(
        backgroundColor: appTheme.orangeA70001,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
        elevation: 0,
        padding: EdgeInsetsDirectional.zero,
      );
  static ButtonStyle get fillPrimaryTL16 => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.h),
        ),
        elevation: 0,
        padding: EdgeInsetsDirectional.zero,
      );
// Outline button style
  static BoxDecoration get outlineDecoration => BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(4.h),
        border: GradientBoxBorder(
          width: 1.h,
          gradient: LinearGradient(
            begin: Alignment(-0.29, 1),
            end: Alignment(1.0, 0),
            colors: [appTheme.whiteA700, appTheme.orange900],
          ),
        ),
      );
  static BoxDecoration get outlineTL8Decoration => BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(8.h),
        border: GradientBoxBorder(
          width: 1.h,
          gradient: LinearGradient(
            begin: Alignment(-0.29, 1),
            end: Alignment(1.0, 0),
            colors: [appTheme.whiteA700, appTheme.orange900],
          ),
        ),
      );
// text button style
  static ButtonStyle get none => ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
      elevation: WidgetStateProperty.all<double>(0),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsetsDirectional.zero),
      side: WidgetStateProperty.all<BorderSide>(
        BorderSide(color: Colors.transparent),
      ));
}

class CustomDropDown extends StatelessWidget {
  const CustomDropDown(
      {super.key,
      this.alignment,
      this.width,
      this.boxDecoration,
      this.focusNode,
      this.icon,
      this.iconSize,
      this.autofocus = false,
      this.textStyle,
      this.hintText,
      this.hintStyle,
      this.items,
      this.prefix,
      this.prefixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = false,
      this.validator,
      this.onChanged});

  final AlignmentGeometry? alignment;

  final double? width;

  final BoxDecoration? boxDecoration;

  final FocusNode? focusNode;

  final Widget? icon;

  final double? iconSize;

  final bool? autofocus;

  final TextStyle? textStyle;

  final String? hintText;

  final TextStyle? hintStyle;

  final List<String>? items;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final EdgeInsetsGeometry? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? AlignmentDirectional.center,
            child: dropDownWidget)
        : dropDownWidget;
  }

  Widget get dropDownWidget => Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: DropdownButtonFormField(
          focusNode: focusNode,
          icon: icon,
          iconSize: iconSize ?? 24,
          autofocus: autofocus!,
          isExpanded: true,
          style: textStyle ?? theme.textTheme.bodyLarge,
          hint: Text(
            hintText ?? "",
            style: hintStyle ?? theme.textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
          items: items?.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: hintStyle ?? theme.textTheme.bodyLarge,
              ),
            );
          }).toList(),
          decoration: decoration,
          validator: validator,
          onChanged: (value) {
            onChanged!(value.toString());
          },
        ),
      );
  InputDecoration get decoration => InputDecoration(
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsetsDirectional.fromSTEB(12.h, 14.h, 6.h, 14.h),
        fillColor: fillColor,
        filled: filled,
        border: borderDecoration ??
            UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.black900,
              ),
            ),
        enabledBorder: borderDecoration ??
            UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.black900,
              ),
            ),
        focusedBorder: (borderDecoration ?? UnderlineInputBorder()).copyWith(
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1,
          ),
        ),
      );
}

class CustomElevatedButton extends BaseButton {
  const CustomElevatedButton(
      {super.key,
      this.decoration,
      this.leftIcon,
      this.rightIcon,
      super.margin,
      super.onPressed,
      super.buttonStyle,
      super.alignment,
      super.buttonTextStyle,
      super.isDisabled,
      super.height,
      super.width,
      required super.text});

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? AlignmentDirectional.center,
            child: buildElevatedButtonWidget)
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
        height: height ?? 20.h,
        width: width ?? double.maxFinite,
        margin: margin,
        decoration: decoration,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon ?? const SizedBox.shrink(),
              Text(
                text,
                style: buttonTextStyle ?? theme.textTheme.labelMedium,
              ),
              rightIcon ?? const SizedBox.shrink()
            ],
          ),
        ),
      );
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      this.alignment,
      this.height,
      this.width,
      this.decoration,
      this.padding,
      this.onTap,
      this.child});

  final AlignmentGeometry? alignment;

  final double? height;

  final double? width;

  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onTap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? AlignmentDirectional.center,
            child: iconButtonWidget)
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: DecoratedBox(
          decoration: decoration ??
              BoxDecoration(
                color: theme.colorScheme.onPrimaryContainer,
                borderRadius: BorderRadius.circular(24.h),
              ),
          child: IconButton(
            padding: padding ?? EdgeInsetsDirectional.zero,
            onPressed: onTap,
            icon: child ?? Container(),
          ),
        ),
      );
}

class CustomImageView extends StatelessWidget {
  const CustomImageView(
      {super.key,
      this.imagePath,
      this.height,
      this.width,
      this.color,
      this.fit,
      this.alignment,
      this.onTap,
      this.radius,
      this.margin,
      this.border,
      this.placeHolder = 'assets/images/image_not_found.png'});

  ///[imagePath] is required parameter for showing image
  final String? imagePath;

  final double? height;

  final double? width;

  final Color? color;

  final BoxFit? fit;

  final String placeHolder;

  final AlignmentGeometry? alignment;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry? margin;

  final BorderRadius? radius;

  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsetsDirectional.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadiusDirectional.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath != null) {
      try {
        switch (imagePath!.imageType) {
          case ImageType.svg:
            return SizedBox(
              height: height,
              width: width,
              child: SvgPicture.asset(
                imagePath!,
                height: height,
                width: width,
                fit: fit ?? BoxFit.contain,
                placeholderBuilder: (context) => _buildPlaceholder(),
                colorFilter: color != null
                    ? ColorFilter.mode(
                        color ?? Colors.transparent, BlendMode.srcIn)
                    : null,
              ),
            );
          case ImageType.file:
            return Image.file(
              File(imagePath!),
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
              color: color,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
            );
          case ImageType.network:
            return CachedNetworkImage(
              height: height,
              width: width,
              fit: fit,
              imageUrl: imagePath!,
              color: color,
              placeholder: (context, url) => SizedBox(
                height: 30,
                width: 30,
                child: LinearProgressIndicator(
                  color: Colors.grey.shade200,
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
              errorWidget: (context, url, error) => _buildPlaceholder(),
            );
          case ImageType.png:
          default:
            return Image.asset(
              imagePath!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
              color: color,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
            );
        }
      } catch (e) {
        return _buildPlaceholder();
      }
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: radius,
      ),
      child: Icon(
        Icons.image,
        color: Colors.grey.shade400,
        size: (height ?? 24) / 2,
      ),
    );
  }
}

class CustomOutlinedButton extends BaseButton {
  const CustomOutlinedButton(
      {super.key,
      this.decoration,
      this.leftIcon,
      this.rightIcon,
      this.label,
      super.onPressed,
      super.buttonStyle,
      super.buttonTextStyle,
      super.isDisabled,
      super.alignment,
      super.height,
      super.width,
      super.margin,
      required super.text});

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  final Widget? label;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? AlignmentDirectional.center,
            child: buildOutlinedButtonWidget)
        : buildOutlinedButtonWidget;
  }

  Widget get buildOutlinedButtonWidget => Container(
        height: height ?? 20.h,
        width: width ?? double.maxFinite,
        margin: margin,
        decoration: decoration ?? CustomButtonStyles.outlineDecoration,
        child: OutlinedButton(
          style: buttonStyle,
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon ?? const SizedBox.shrink(),
              Text(
                text,
                style: buttonTextStyle ?? theme.textTheme.labelMedium,
              ),
              rightIcon ?? const SizedBox.shrink()
            ],
          ),
        ),
      );
}

class CustomSearchView extends StatelessWidget {
  const CustomSearchView(
      {super.key,
      this.alignment,
      this.width,
      this.boxDecoration,
      this.scrollPadding,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.textStyle,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.hintStyle,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = true,
      this.validator,
      this.onChanged});

  final AlignmentGeometry? alignment;

  final double? width;

  final BoxDecoration? boxDecoration;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsetsGeometry? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? AlignmentDirectional.center,
            child: searchViewWidget(context))
        : searchViewWidget(context);
  }

  Widget searchViewWidget(BuildContext context) => Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode,
          onTapOutside: (event) {
            if (focusNode != null) {
              focusNode?.unfocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          autofocus: autofocus!,
          style: textStyle ?? CustomTextStyles.bodyMediumPoppins,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
          onChanged: (String value) {
            onChanged?.call(value);
          },
        ),
      );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.bodyMediumPoppins,
        prefixIcon: Padding(
          padding: EdgeInsetsDirectional.all(
            15.h,
          ),
          child: Icon(
            Icons.search,
            color: Colors.grey.shade600,
          ),
        ),
        prefixIconConstraints: prefixConstraints ??
            BoxConstraints(
              maxHeight: 32.h,
            ),
        suffixIcon: suffix ??
            Container(
              margin: EdgeInsetsDirectional.fromSTEB(16.h, 4.h, 10.h, 4.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgRewind,
                height: 24.h,
                width: 24.h,
              ),
            ),
        suffixIconConstraints: suffixConstraints ??
            BoxConstraints(
              maxHeight: 32.h,
            ),
        isDense: true,
        contentPadding: contentPadding ?? EdgeInsetsDirectional.all(4.h),
        fillColor: fillColor ?? theme.colorScheme.onPrimaryContainer,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.h),
              borderSide: BorderSide.none,
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.h),
              borderSide: BorderSide.none,
            ),
        focusedBorder: (borderDecoration ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.h),
                ))
            .copyWith(
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1,
          ),
        ),
      );
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      this.alignment,
      this.width,
      this.boxDecoration,
      this.scrollPadding,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.textStyle,
      this.obscureText = false,
      this.readOnly = false,
      this.onTap,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.hintStyle,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = true,
      this.validator});

  final AlignmentGeometry? alignment;

  final double? width;

  final BoxDecoration? boxDecoration;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final bool? obscureText;

  final bool? readOnly;

  final VoidCallback? onTap;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsetsGeometry? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? AlignmentDirectional.center,
            child: textFormFieldWidget(context))
        : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode,
          onTapOutside: (event) {
            if (focusNode != null) {
              focusNode?.unfocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          autofocus: autofocus!,
          style: textStyle ?? theme.textTheme.bodyMedium,
          obscureText: obscureText!,
          readOnly: readOnly!,
          onTap: () {
            onTap?.call();
          },
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
        ),
      );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.bodyLargeBluegray700_1,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsetsDirectional.fromSTEB(2.h, 6.h, 2.h, 2.h),
        fillColor: fillColor ??
            theme.colorScheme.onPrimaryContainer.withValues(
              alpha: 0.8,
            ),
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.h),
              borderSide: BorderSide.none,
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.h),
              borderSide: BorderSide.none,
            ),
        focusedBorder: (borderDecoration ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.h),
                ))
            .copyWith(
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1,
          ),
        ),
      );
}

class AppbarLeadingImage extends StatelessWidget {
  const AppbarLeadingImage(
      {super.key,
      this.imagePath,
      this.height,
      this.width,
      this.onTap,
      this.margin});

  final double? height;

  final double? width;

  final String? imagePath;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsetsDirectional.zero,
      child: InkWell(
        onTap: () {
          onTap?.call();
        },
        child: CustomImageView(
          imagePath: imagePath!,
          height: height ?? 10.h,
          width: width ?? 6.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class AppbarSubtitle extends StatelessWidget {
  const AppbarSubtitle({super.key, required this.text, this.onTap, this.margin});

  final String text;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsetsDirectional.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Text(
          text,
          style: CustomTextStyles.headlineSmallBold.copyWith(
            color: appTheme.black900,
          ),
        ),
      ),
    );
  }
}

class AppbarSubtitleFour extends StatelessWidget {
  const AppbarSubtitleFour({super.key, required this.text, this.onTap, this.margin});

  final String text;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsetsDirectional.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Text(
          text,
          style: CustomTextStyles.titleSmallLeagueSpartanPrimary.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class AppbarSubtitleOne extends StatelessWidget {
  const AppbarSubtitleOne({super.key, required this.text, this.onTap, this.margin});

  final String text;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsetsDirectional.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Text(
          text,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: appTheme.black900,
          ),
        ),
      ),
    );
  }
}

class AppbarSubtitleThree extends StatelessWidget {
  const AppbarSubtitleThree({super.key, required this.text, this.onTap, this.margin});

  final String text;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsetsDirectional.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Text(
          text,
          style: CustomTextStyles.titleMediumMedium.copyWith(
            color: appTheme.black900,
          ),
        ),
      ),
    );
  }
}

class AppbarSubtitleTwo extends StatelessWidget {
  const AppbarSubtitleTwo({super.key, required this.text, this.onTap, this.margin});

  final String text;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsetsDirectional.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Text(
          text,
          style: CustomTextStyles.titleLargeExtraLight.copyWith(
            color: appTheme.black900,
          ),
        ),
      ),
    );
  }
}

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({super.key, required this.text, this.onTap, this.margin});

  final String text;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsetsDirectional.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Text(
          text,
          style: CustomTextStyles.headlineSmallWorkSans.copyWith(
            color: appTheme.black900,
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.height,
      this.shape,
      this.styleType,
      this.leadingWidth,
      this.leading,
      this.title,
      this.centerTitle,
      this.actions});

  final double? height;

  final ShapeBorder? shape;

  final Style? styleType;

  final double? leadingWidth;

  final Widget? leading;

  final Widget? title;

  final bool? centerTitle;

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      shape: shape,
      toolbarHeight: height ?? 50.h,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        SizeUtils.width,
        height ?? 50.h,
      );
  _getStyle() {
    switch (styleType) {
      case Style.bgFillOnPrimaryContainer:
        return Container(
          height: 102.h,
          width: 440.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        );
      case Style.bgOutlineGray100:
        return Container(
          height: 52.h,
          width: 440.h,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: appTheme.gray100,
                width: 1.h,
              ),
            ),
          ),
        );
      default:
        return null;
    }
  }
}

// ignore_for_file: must_be_immutable
class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key, this.onChanged});

  final Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgHome,
      activeIcon: ImageConstant.imgHome,
      type: BottomBarEnum.Home,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgMaximize,
      activeIcon: ImageConstant.imgMaximize,
      type: BottomBarEnum.Maximize,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgMedicalIconINutrition,
      activeIcon: ImageConstant.imgMedicalIconINutrition,
      type: BottomBarEnum.Medicaliconinutrition,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgCalendar,
      activeIcon: ImageConstant.imgCalendar,
      type: BottomBarEnum.Calendar,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgLockGray600,
      activeIcon: ImageConstant.imgLockGray600,
      type: BottomBarEnum.Lockgray600,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(
        start: 10.h,
        end: 10.h,
        bottom: 10.h,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            icon: CustomImageView(
              imagePath: bottomMenuList[index].icon,
              height: 24.h,
              width: 26.h,
              color: appTheme.gray600,
            ),
            activeIcon: CustomImageView(
              imagePath: bottomMenuList[index].activeIcon,
              height: 24.h,
              width: 26.h,
              color: theme.colorScheme.primary,
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {});
        },
      ),
    );
  }
}

class BottomMenuModel {
  BottomMenuModel(
      {required this.icon, required this.activeIcon, required this.type});

  String icon;

  String activeIcon;

  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffffffff),
      padding: EdgeInsetsDirectional.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
