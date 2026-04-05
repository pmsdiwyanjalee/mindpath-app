import 'package:flutter/material.dart';

class LocaleManager {
  static final ValueNotifier<Locale> localeNotifier =
      ValueNotifier(const Locale('en'));

  static void changeLocale(Locale locale) {
    localeNotifier.value = locale;
  }
}
