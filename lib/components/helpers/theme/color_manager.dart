import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/enums/theme_types.dart';
import 'package:flutter/material.dart';

class ColorManager {
  static Color getBackgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkBackgroundColor;
      case EThemeTypes.eLight:
      return lightBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getForegroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkForegroundColor;
      case EThemeTypes.eLight:
      return lightForegroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getIdentityColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkIdentityColor;
      case EThemeTypes.eLight:
      return lightIdentityColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getLayerBackgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkLayerBackgroundColor;
      case EThemeTypes.eLight:
      return lightLayerBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getWidgetBackgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkWidgetBackgroundColor;
      case EThemeTypes.eLight:
      return lightWidgetBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getIdentityMouseOverColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkIdentityMouseOverColor;
      case EThemeTypes.eLight:
      return lightIdentityMouseOverColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getTitleBarButtonIconColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkTitleBarButtonIconColor;
      case EThemeTypes.eLight:
      return lightTitleBarButtonIconColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getTitleBarButtonIconMouseOverColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkTitleBarButtonIconMouseOverColor;
      case EThemeTypes.eLight:
      return lightTitleBarButtonIconMouseOverColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getTitleBarButtonMouseOverBackgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkTitleBarButtonMouseOverBackgroundColor;
      case EThemeTypes.eLight:
      return lightTitleBarButtonMouseOverBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getTitleBarButtonMouseDownBackgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkTitleBarButtonMouseDownBackgroundColor;
      case EThemeTypes.eLight:
      return lightTitleBarButtonMouseDownBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getTitleBarCloseButtonMouseOverBackgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkTitleBarCloseButtonMouseOverBackgroundColor;
      case EThemeTypes.eLight:
      return lightTitleBarCloseButtonMouseOverBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getTitleBarCloseButtonMouseDownBackgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkTitleBarCloseButtonMouseDownBackgroundColor;
      case EThemeTypes.eLight:
      return lightTitleBarCloseButtonMouseDownBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getPreferenceBackgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkPreferenceBackgroundColor;
      case EThemeTypes.eLight:
      return lightPreferenceBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getPreferenceUnderlineBakcgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkPreferenceUnderlineBakcgroundColor;
      case EThemeTypes.eLight:
      return lightPreferenceUnderlineBakcgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getTextFormFieldUnderlineColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkTextFormFieldUnderlineColor;
      case EThemeTypes.eLight:
      return lightTextFormFieldUnderlineColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getTextFormFieldUnderlineFocusedColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkTextFormFieldUnderlineFocusedColor;
      case EThemeTypes.eLight:
      return lightTextFormFieldUnderlineFocusedColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getTextFormFieldUnderlineInvalidColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkTextFormFieldUnderlineInvalidColor;
      case EThemeTypes.eLight:
      return lightTextFormFieldUnderlineInvalidColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getHintTextColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkHintTextColor;
      case EThemeTypes.eLight:
      return lightHintTextColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getLogoutButtonBackgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkLogoutButtonBackgroundColor;
      case EThemeTypes.eLight:
      return lightLogoutButtonBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getLogoutButtonBackgroundMouseOverColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkLogoutButtonBackgroundMouseOverColor;
      case EThemeTypes.eLight:
      return lightLogoutButtonBackgroundMouseOverColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getTooltipForegroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkTooltipForegroundColor;
      case EThemeTypes.eLight:
      return lightTooltipForegroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getTooltipBackgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkTooltipBackgroundColor;
      case EThemeTypes.eLight:
      return lightTooltipBackgroundColor;
      default:
      return Colors.transparent;
    }
  }
}