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
      case EThemeTypes.ePinkBlue:
      return pinkBlueBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getBackgroundTransparentColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkBackgroundTransparentColor;
      case EThemeTypes.eLight:
      return lightBackgroundTransparentColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueBackgroundTransparentColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueForegroundColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueIdentityColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueLayerBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getLayerTransparentBackgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkLayerTransparentBackgroundColor;
      case EThemeTypes.eLight:
      return lightLayerTransparentBackgroundColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueLayerTransparentBackgroundColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueWidgetBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getWidgetBackgroundTransparentColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkWidgetBackgroundTransparentColor;
      case EThemeTypes.eLight:
      return lightWidgetBackgroundTransparentColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueWidgetBackgroundTransparentColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getWidgetBackgroundMouseOverColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkWidgetBackgroundMouseOverColor;
      case EThemeTypes.eLight:
      return lightWidgetBackgroundMouseOverColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueWidgetBackgroundMouseOverColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getWidgetIconForegroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkWidgetIconForegroundColor;
      case EThemeTypes.eLight:
      return lightWidgetIconForegroundColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueWidgetIconForegroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getWidgetIconForegroundMouseOverColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkWidgetIconForegroundMouseOverColor;
      case EThemeTypes.eLight:
      return lightWidgetIconForegroundMouseOverColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueWidgetIconForegroundMouseOverColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueIdentityMouseOverColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueTitleBarButtonIconColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueTitleBarButtonIconMouseOverColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueTitleBarButtonMouseOverBackgroundColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueTitleBarButtonMouseDownBackgroundColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueTitleBarCloseButtonMouseOverBackgroundColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueTitleBarCloseButtonMouseDownBackgroundColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBluePreferenceBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getPreferenceBackgroundTransparentColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkPreferenceBackgroundTransparentColor;
      case EThemeTypes.eLight:
      return lightPreferenceBackgroundTransparentColor;
      case EThemeTypes.ePinkBlue:
      return pinkBluePreferenceBackgroundTransparentColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBluePreferenceUnderlineBakcgroundColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueTextFormFieldUnderlineColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueTextFormFieldUnderlineFocusedColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueTextFormFieldUnderlineInvalidColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getTextFormFieldUnderlineInvalidFocusedColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkTextFormFieldUnderlineInvalidFocusedColor;
      case EThemeTypes.eLight:
      return lightTextFormFieldUnderlineInvalidFocusedColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueTextFormFieldUnderlineInvalidFocusedColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueHintTextColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueLogoutButtonBackgroundColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueLogoutButtonBackgroundMouseOverColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueTooltipForegroundColor;
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
      case EThemeTypes.ePinkBlue:
      return pinkBlueTooltipBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getDatePickerDialogBackgroundColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkDatePickerDialogBackgroundColor;
      case EThemeTypes.eLight:
      return lightDatePickerDialogBackgroundColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueDatePickerDialogBackgroundColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getDataGridLineColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkDataGridLineColor;
      case EThemeTypes.eLight:
      return lightDataGridLineColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueDataGridLineColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getDataGridRowHoverColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkDataGridRowHoverColor;
      case EThemeTypes.eLight:
      return lightDataGridRowHoverColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueDataGridRowHoverColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getDataGridSelectionColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkDataGridSelectionColor;
      case EThemeTypes.eLight:
      return lightDataGridSelectionColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueDataGridSelectionColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getCursorColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkCursorColor;
      case EThemeTypes.eLight:
      return lightCursorColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueCursorColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getLoadingIndicatorColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkLoadingIndicatorColor;
      case EThemeTypes.eLight:
      return lightLoadingIndicatorColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueLoadingIndicatorColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getChartLabelColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkChartLabelColor;
      case EThemeTypes.eLight:
      return lightChartLabelColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueChartLabelColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getChartXAxisColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkChartXAxisColor;
      case EThemeTypes.eLight:
      return lightChartXAxisColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueChartXAxisColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getChartYAxisColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkChartYAxisColor;
      case EThemeTypes.eLight:
      return lightChartYAxisColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueChartYAxisColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getChartOutcomeColumnColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkChartOutcomeColumnColor;
      case EThemeTypes.eLight:
      return lightChartOutcomeColumnColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueChartOutcomeColumnColor;
      default:
      return Colors.transparent;
    }
  }

  static Color getChartIncomeColumnColor(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return darkChartIncomeColumnColor;
      case EThemeTypes.eLight:
      return lightChartIncomeColumnColor;
      case EThemeTypes.ePinkBlue:
      return pinkBlueChartIncomeColumnColor;
      default:
      return Colors.transparent;
    }
  }

  static ColorScheme getDatePickerColorScheme(EThemeTypes themeType) {
    switch (themeType) {
      case EThemeTypes.eDark:
      return const ColorScheme.dark(
        primary: darkIdentityColor,
        onPrimary: Colors.white,
        surface: Color.fromARGB(255, 44, 44, 44),    
      );
      case EThemeTypes.eLight:
      return const ColorScheme.light(
        primary: lightIdentityColor,
        onPrimary: Colors.black,
      );
      default:
      return const ColorScheme.light(
        primary: pinkBlueIdentityColor,
        onPrimary: Colors.black
      );
    }
  }
}