import 'package:flutter/material.dart';

import 'theme/theme_manager.dart';

void setAsSystemDefault(context) => ThemeManager.of(context).setBrightnessPreference(BrightnessPreference.system);
void setAsLight(context) => ThemeManager.of(context).setBrightnessPreference(BrightnessPreference.light);
void setAsDark(context) => ThemeManager.of(context).setBrightnessPreference(BrightnessPreference.dark);
void themeClear(context) => ThemeManager.of(context).clearBrightnessPreference();

Widget horizontalSpace([double? width]) => SizedBox(width: width ?? 5.0);
Widget verticalSpace([double? height]) => SizedBox(height: height ?? 5.0);

void notMounted(mounted, setState) {
  if (!mounted) return;
  setState(() {});
}

void thisMounted(mounted, setState) {
  if (mounted) {
    setState(() {});
  }
}
