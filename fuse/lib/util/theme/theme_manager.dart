import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

enum BrightnessPreference { system, light, dark }

typedef ThemedWidgetBuilder = Widget Function(BuildContext context, ThemeData data);

typedef ThemeDataWithBrightnessBuilder = ThemeData Function(Brightness brightness);

class ThemeManager extends StatefulWidget {
  const ThemeManager({
    Key? key,
    required this.data,
    required this.themedWidgetBuilder,
    this.defaultBrightnessPreference = BrightnessPreference.system,
    this.loadBrightnessOnStart = true,
  }) : super(key: key);

  final ThemedWidgetBuilder themedWidgetBuilder;

  final ThemeDataWithBrightnessBuilder data;

  final BrightnessPreference defaultBrightnessPreference;

  final bool loadBrightnessOnStart;

  @override
  ThemeManagerState createState() => ThemeManagerState();

  static ThemeManagerState of(BuildContext context) {
    return context.findAncestorStateOfType<State<ThemeManager>>() as ThemeManagerState;
  }
}

class ThemeManagerState extends State<ThemeManager> {
  bool? _shouldLoadBrightness;

  static const String _sharedPreferencesKey = 'brightnessPreference';

  ThemeData get themeData => _themeData;
  late ThemeData _themeData;

  Brightness get brightness => _brightness;
  late Brightness _brightness;

  BrightnessPreference get brightnessPreference => _brightnessPreference;
  late BrightnessPreference _brightnessPreference;

  @override
  void initState() {
    super.initState();
    _initVariables();
    _loadBrightness();
  }

  Future<void> _loadBrightness() async {
    if (_shouldLoadBrightness == null || !_shouldLoadBrightness!) {
      return;
    }
    _brightnessPreference = await _getBrightnessPreference();
    _brightness = _getBrightnessFromBrightnessPreference(brightnessPreference);
    _themeData = widget.data(_brightness);
    if (mounted) {
      setState(() {});
    }
  }

  void _initVariables() {
    _brightnessPreference = widget.defaultBrightnessPreference;
    _brightness = _getBrightnessFromBrightnessPreference(brightnessPreference);
    _themeData = widget.data(_brightness);
    _shouldLoadBrightness = widget.loadBrightnessOnStart;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeData = widget.data(_brightness);
  }

  @override
  void didUpdateWidget(ThemeManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    _themeData = widget.data(_brightness);
  }

  Future<void> _setBrightness(Brightness brightness, BrightnessPreference preference) async {
    setState(() {
      _brightness = brightness;
      _brightnessPreference = preference;
      _themeData = widget.data(brightness);
    });
  }

  Future<void> setBrightnessPreference(BrightnessPreference preference) async {
    _setBrightness(_getBrightnessFromBrightnessPreference(preference), preference);
    await _saveBrightness(preference);
  }

  void setThemeData(ThemeData data) {
    setState(() {
      _themeData = data;
    });
  }

  Future<void> _saveBrightness(BrightnessPreference preference) async {
    if (_shouldLoadBrightness != null && !_shouldLoadBrightness!) {
      return;
    }
    int saveState = 0;
    switch (preference) {
      case BrightnessPreference.light:
        saveState = 1;
        break;
      case BrightnessPreference.dark:
        saveState = 2;
        break;
      default:
        saveState = 0;
        break;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sharedPreferencesKey, saveState);
  }

  Future<BrightnessPreference> _getBrightnessPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int savedState = prefs.getInt(_sharedPreferencesKey) ?? 0;
    switch (savedState) {
      case 1:
        return BrightnessPreference.light;
      case 2:
        return BrightnessPreference.dark;
      default:
        return BrightnessPreference.system;
    }
  }

  Brightness _getBrightnessFromBrightnessPreference(BrightnessPreference preference) {
    if (preference == BrightnessPreference.dark) {
      return Brightness.dark;
    } else if (preference == BrightnessPreference.light) {
      return Brightness.light;
    } else {
      return WidgetsBinding.instance?.window.platformBrightness ?? Brightness.light;
    }
  }

  Future<void> clearBrightnessPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sharedPreferencesKey);
  }

  @override
  Widget build(BuildContext context) {
    return widget.themedWidgetBuilder(context, _themeData);
  }
}


