import 'package:flutter/material.dart';
import '../app_utils.dart';

String _appTheme = "lightCode";
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get workSans {
    return copyWith(
      fontFamily: 'Work Sans',
    );
  }

  TextStyle get leagueSpartan {
    return copyWith(
      fontFamily: 'League Spartan',
    );
  }

  TextStyle get tTCommons {
    return copyWith(
      fontFamily: 'TT Commons',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }

  TextStyle get signika {
    return copyWith(
      fontFamily: 'Signika',
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static TextStyle get bodyLargeBlack900 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w300,
      );
  static TextStyle get bodyLargeBlack900ExtraLight =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w200,
      );
  static TextStyle get bodyLargeBlack900_1 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
      );
  static TextStyle get bodyLargeBluegray700 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray700,
      );
  static TextStyle get bodyLargeBluegray70001 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray70001,
      );
  static TextStyle get bodyLargeBluegray700_1 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray700,
      );
  static TextStyle get bodyLargeInterBlack900 =>
      theme.textTheme.bodyLarge!.inter.copyWith(
        color: appTheme.black900,
      );
  static TextStyle get bodyLargeInterPrimary =>
      theme.textTheme.bodyLarge!.inter.copyWith(
        color: theme.colorScheme.primary,
      );
  static TextStyle get bodyLargeInterWhiteA700 =>
      theme.textTheme.bodyLarge!.inter.copyWith(
        color: appTheme.whiteA700,
      );
  static get bodyLargePoppins => theme.textTheme.bodyLarge!.poppins;
  static TextStyle get bodyLargeWhiteA700 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.whiteA700,
      );
  static TextStyle get bodyMediumGray60001 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray60001,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodyMediumGray60001ExtraLight =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray60001,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w200,
      );
  static TextStyle get bodyMediumLight => theme.textTheme.bodyMedium!.copyWith(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w300,
      );
  static TextStyle get bodyMediumPoppins =>
      theme.textTheme.bodyMedium!.poppins.copyWith(
        fontSize: 13.fSize,
        fontWeight: FontWeight.w300,
      );
  static TextStyle get bodyMediumPoppinsBluegray70001 =>
      theme.textTheme.bodyMedium!.poppins.copyWith(
        color: appTheme.blueGray70001,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodyMediumPoppinsGray60001 =>
      theme.textTheme.bodyMedium!.poppins.copyWith(
        color: appTheme.gray60001,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodyMediumRegular =>
      theme.textTheme.bodyMedium!.copyWith(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodyMediumTTCommons =>
      theme.textTheme.bodyMedium!.tTCommons.copyWith(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodyMediumWorkSans =>
      theme.textTheme.bodyMedium!.workSans.copyWith(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodyMediumWorkSansBluegray700 =>
      theme.textTheme.bodyMedium!.workSans.copyWith(
        color: appTheme.blueGray700,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodyMediumWorkSansBluegray70001 =>
      theme.textTheme.bodyMedium!.workSans.copyWith(
        color: appTheme.blueGray70001,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w200,
      );
  static TextStyle get bodyMediumWorkSansBluegray70001Regular =>
      theme.textTheme.bodyMedium!.workSans.copyWith(
        color: appTheme.blueGray70001,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodyMediumWorkSansBluegray700Regular =>
      theme.textTheme.bodyMedium!.workSans.copyWith(
        color: appTheme.blueGray700,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodyMediumWorkSansExtraLight =>
      theme.textTheme.bodyMedium!.workSans.copyWith(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w200,
      );
  static TextStyle get bodySmallExtraLight =>
      theme.textTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.w200,
      );
  static TextStyle get bodySmallGray60001 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray60001,
        fontWeight: FontWeight.w300,
      );
  static TextStyle get bodySmallGray60001_1 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray60001,
      );
  static TextStyle get bodySmallGreen600 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.green600,
        fontWeight: FontWeight.w200,
      );
  static TextStyle get bodySmallRed500 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.red500,
      );
  static get bodySmallWorkSans => theme.textTheme.bodySmall!.workSans;
  static TextStyle get bodySmallWorkSansBlack900 =>
      theme.textTheme.bodySmall!.workSans.copyWith(
        color: appTheme.black900.withValues(
          alpha: 0.7,
        ),
        fontSize: 10.fSize,
        fontWeight: FontWeight.w300,
      );
// Display text style
  static TextStyle get displayLargeBlack900 =>
      theme.textTheme.displayLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get displayLargeRegular =>
      theme.textTheme.displayLarge!.copyWith(
        fontWeight: FontWeight.w400,
      );
  static TextStyle get displayLargeWorkSansBlack900 =>
      theme.textTheme.displayLarge!.workSans.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w700,
      );
  static get displayMediumWorkSans => theme.textTheme.displayMedium!.workSans;
  static TextStyle get displaySmallBlack900 =>
      theme.textTheme.displaySmall!.copyWith(
        color: appTheme.black900.withValues(
          alpha: 0.65,
        ),
        fontSize: 35.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get displaySmallWorkSansBlack900 =>
      theme.textTheme.displaySmall!.workSans.copyWith(
        color: appTheme.black900.withValues(
          alpha: 0.65,
        ),
        fontSize: 35.fSize,
        fontWeight: FontWeight.w700,
      );
// Headline text style
  static TextStyle get headlineLargeOnPrimary =>
      theme.textTheme.headlineLarge!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 30.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get headlineSmallBold =>
      theme.textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get headlineSmallPoppins =>
      theme.textTheme.headlineSmall!.poppins.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get headlineSmallPoppinsBlack900 =>
      theme.textTheme.headlineSmall!.poppins.copyWith(
        color: appTheme.black900.withValues(
          alpha: 0.45,
        ),
        fontSize: 25.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get headlineSmallPoppinsPrimary =>
      theme.textTheme.headlineSmall!.poppins.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get headlineSmallPoppinsPrimary_1 =>
      theme.textTheme.headlineSmall!.poppins.copyWith(
        color: theme.colorScheme.primary,
      );
  static TextStyle get headlineSmallPoppinsWhiteA700 =>
      theme.textTheme.headlineSmall!.poppins.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w400,
      );
  static get headlineSmallPoppins_1 => theme.textTheme.headlineSmall!.poppins;
  static TextStyle get headlineSmallPrimary =>
      theme.textTheme.headlineSmall!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get headlineSmallSignika =>
      theme.textTheme.headlineSmall!.signika.copyWith(
        fontSize: 25.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get headlineSmallWhiteA700 =>
      theme.textTheme.headlineSmall!.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w400,
      );
  static get headlineSmallWorkSans => theme.textTheme.headlineSmall!.workSans;
  static TextStyle get headlineSmallWorkSansBlack900 =>
      theme.textTheme.headlineSmall!.workSans.copyWith(
        color: appTheme.black900.withValues(
          alpha: 0.45,
        ),
        fontSize: 25.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get headlineSmallWorkSansBold =>
      theme.textTheme.headlineSmall!.workSans.copyWith(
        fontSize: 25.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get headlineSmallWorkSansSemiBold =>
      theme.textTheme.headlineSmall!.workSans.copyWith(
        fontWeight: FontWeight.w600,
      );
// Label text style
  static TextStyle get labelMediumInterBluegray70001 =>
      theme.textTheme.labelMedium!.inter.copyWith(
        color: appTheme.blueGray70001,
        fontSize: 11.fSize,
      );
// Title text style
  static TextStyle get titleLargeBold => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleLargeExtraLight =>
      theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w200,
      );
  static TextStyle get titleLargeInter =>
      theme.textTheme.titleLarge!.inter.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleLargeInterBluegray70001 =>
      theme.textTheme.titleLarge!.inter.copyWith(
        color: appTheme.blueGray70001,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleLargeInterGray60001 =>
      theme.textTheme.titleLarge!.inter.copyWith(
        color: appTheme.gray60001,
        fontWeight: FontWeight.w300,
      );
  static TextStyle get titleLargeInterMedium =>
      theme.textTheme.titleLarge!.inter.copyWith(
        fontWeight: FontWeight.w500,
      );
  static TextStyle get titleLargeInterRed500 =>
      theme.textTheme.titleLarge!.inter.copyWith(
        color: appTheme.red500,
        fontWeight: FontWeight.w300,
      );
  static TextStyle get titleLargeInterWhiteA700 =>
      theme.textTheme.titleLarge!.inter.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w300,
      );
  static TextStyle get titleLargeInterWhiteA700SemiBold =>
      theme.textTheme.titleLarge!.inter.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleLargeLight => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w300,
      );
  static TextStyle get titleLargePoppins =>
      theme.textTheme.titleLarge!.poppins.copyWith(
        fontWeight: FontWeight.w500,
      );
  static TextStyle get titleLargePoppinsBlack900 =>
      theme.textTheme.titleLarge!.poppins.copyWith(
        color: appTheme.black900.withValues(
          alpha: 0.65,
        ),
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleLargePoppinsPrimary =>
      theme.textTheme.titleLarge!.poppins.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get titleLargeTTCommonsWhiteA700 =>
      theme.textTheme.titleLarge!.tTCommons.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleLargeWhiteA700 =>
      theme.textTheme.titleLarge!.copyWith(
        color: appTheme.whiteA700,
      );
  static TextStyle get titleMediumMedium =>
      theme.textTheme.titleMedium!.copyWith(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get titleMediumOrangeA70001 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.orangeA70001,
        fontSize: 16.fSize,
      );
  static TextStyle get titleMediumPoppinsPrimary =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get titleMediumTTCommonsPrimary =>
      theme.textTheme.titleMedium!.tTCommons.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get titleMediumWorkSansOnPrimary =>
      theme.textTheme.titleMedium!.workSans.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallInter => theme.textTheme.titleSmall!.inter;
  static TextStyle get titleSmallInterBluegray70001 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.blueGray70001,
      );
  static TextStyle get titleSmallInterGray60001 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.gray60001.withValues(
          alpha: 0.75,
        ),
      );
  static TextStyle get titleSmallInterWhiteA700 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.whiteA700,
      );
  static TextStyle get titleSmallLeagueSpartanPrimary =>
      theme.textTheme.titleSmall!.leagueSpartan.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallSemiBold =>
      theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallWorkSansOnPrimary =>
      theme.textTheme.titleSmall!.workSans.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallWorkSansPrimary =>
      theme.textTheme.titleSmall!.workSans.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleSmallWorkSansPrimaryBold =>
      theme.textTheme.titleSmall!.workSans.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleSmallWorkSansWhiteA700 =>
      theme.textTheme.titleSmall!.workSans.copyWith(
        color: appTheme.whiteA700,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w600,
      );
}

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

// A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.h),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsetsDirectional.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          side: BorderSide(
            width: 1.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsetsDirectional.zero,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.black900.withValues(
          alpha: 0.8,
        ),
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: appTheme.blueGray900,
          fontSize: 16.fSize,
          fontFamily: 'Work Sans',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 15.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w100,
        ),
        bodySmall: TextStyle(
          color: appTheme.black900,
          fontSize: 12.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        displayLarge: TextStyle(
          color: colorScheme.primary,
          fontSize: 64.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        displayMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 40.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
        displaySmall: TextStyle(
          color: colorScheme.primary,
          fontSize: 36.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 32.fSize,
          fontFamily: 'Work Sans',
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: appTheme.black900,
          fontSize: 24.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: appTheme.whiteA700,
          fontSize: 10.fSize,
          fontFamily: 'Work Sans',
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 20.fSize,
          fontFamily: 'Work Sans',
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 18.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          color: appTheme.black900,
          fontSize: 14.fSize,
          fontFamily: 'TT Commons',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFFF97316),
    secondaryContainer: Color(0XFF909090),
    onPrimary: Color(0XFF27272A),
    onPrimaryContainer: Color(0XFFD9D9D9),
  );
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {
  // Black
  Color get black900 => Color(0XFF000000);
// BlueGray
  Color get blueGray100 => Color(0XFFD4D4D8);
  Color get blueGray10001 => Color(0XFFD1D6D6);
  Color get blueGray50 => Color(0XFFF1F1F1);
  Color get blueGray700 => Color(0XFF52525B);
  Color get blueGray70001 => Color(0XFF4B5563);
  Color get blueGray70066 => Color(0X66505862);
  Color get blueGray900 => Color(0XFF1F2937);
// DeepOrange
  Color get deepOrange50 => Color(0XFFFEE2E2);
  Color get deepOrange500 => Color(0XFFFF6B21);
// Gray
  Color get gray100 => Color(0XFFF3F4F6);
  Color get gray200 => Color(0XFFE5E7EB);
  Color get gray300 => Color(0XFFE4E4E7);
  Color get gray400 => Color(0XFFC4C4C4);
  Color get gray50 => Color(0XFFFAFAFA);
  Color get gray500 => Color(0XFFA1A1AA);
  Color get gray600 => Color(0XFF71717A);
  Color get gray60001 => Color(0XFF6B7280);
// Green
  Color get green600 => Color(0XFF28A745);
// Orange
  Color get orange50 => Color(0XFFFFEDD5);
  Color get orange900 => Color(0XFFCC5B09);
  Color get orangeA700 => Color(0XFFFD5703);
  Color get orangeA70001 => Color(0XFFFF6B00);
// Red
  Color get red500 => Color(0XFFEF4444);
// White
  Color get whiteA700 => Color(0XFFFFFFFF);
}

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray50,
      );
  static BoxDecoration get fillBluegray10001 => BoxDecoration(
        color: appTheme.blueGray10001,
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray400,
      );
  static BoxDecoration get fillGray100 => BoxDecoration(
        color: appTheme.gray100,
      );
  static BoxDecoration get fillOnPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer,
      );
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
      );
  static BoxDecoration get fillPrimary1 => BoxDecoration(
        color: theme.colorScheme.primary.withValues(
          alpha: 0.72,
        ),
      );
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );
// Gray decorations
  static BoxDecoration get gray5 => BoxDecoration(
        color: appTheme.gray50,
        border: Border.all(
          color: appTheme.gray300,
          width: 1.h,
        ),
      );
// Outline decorations
  static BoxDecoration get outline => BoxDecoration(
        color: appTheme.whiteA700,
      );
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: appTheme.blueGray10001,
        border: Border.all(
          color: appTheme.black900,
          width: 1.h,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      );
  static BoxDecoration get outlineBlack900 => BoxDecoration(
        color: appTheme.whiteA700,
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(
              alpha: 0.1,
            ),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              2,
            ),
          )
        ],
      );
  static BoxDecoration get outlineGray => BoxDecoration(
        border: Border(
          top: BorderSide(
            color: appTheme.gray100,
            width: 1.h,
          ),
        ),
      );
  static BoxDecoration get outlineGray100 => BoxDecoration(
        border: Border.all(
          color: appTheme.gray100,
          width: 15.h,
        ),
      );
  static BoxDecoration get outlineGray1001 => BoxDecoration(
        border: Border(
          top: BorderSide(
            color: appTheme.gray100,
            width: 1.h,
          ),
        ),
      );
  static BoxDecoration get outlineOnPrimaryContainer => BoxDecoration(
        color: appTheme.whiteA700,
        border: Border.all(
          color: theme.colorScheme.onPrimaryContainer,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
        border: Border.all(
          color: appTheme.whiteA700,
          width: 1.h,
        ),
      );
  static BoxDecoration get outline1 => BoxDecoration(
        color: appTheme.gray600,
      );
  static BoxDecoration get outline2 => BoxDecoration(
        color: appTheme.blueGray50,
      );
  static BoxDecoration get outline3 => BoxDecoration(
        color: appTheme.blueGray50,
      );
  static BoxDecoration get outline4 => BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            ImageConstant.img0x0,
          ),
          fit: BoxFit.fill,
        ),
      );
// Column decorations
  static BoxDecoration get column0 => BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            ImageConstant.img,
          ),
          fit: BoxFit.fill,
        ),
      );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder100 => BorderRadius.circular(
        100.h,
      );
  static BorderRadius get circleBorder40 => BorderRadius.circular(
        40.h,
      );
  static BorderRadius get circleBorder50 => BorderRadius.circular(
        50.h,
      );
  static BorderRadius get circleBorder70 => BorderRadius.circular(
        70.h,
      );
// Rounded borders
  static BorderRadius get roundedBorder12 => BorderRadius.circular(
        12.h,
      );
  static BorderRadius get roundedBorder16 => BorderRadius.circular(
        16.h,
      );
  static BorderRadius get roundedBorder20 => BorderRadius.circular(
        20.h,
      );
  static BorderRadius get roundedBorder34 => BorderRadius.circular(
        34.h,
      );
  static BorderRadius get roundedBorder4 => BorderRadius.circular(
        4.h,
      );
  static BorderRadius get roundedBorder8 => BorderRadius.circular(
        8.h,
      );
  static BorderRadius get roundedBorder80 => BorderRadius.circular(
        80.h,
      );
}
