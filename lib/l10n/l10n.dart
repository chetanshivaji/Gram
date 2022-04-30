import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('mr'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'mr':
        return '🇮🇳';
      case 'en':
      default:
        return '🇺🇸';
    }
  }
}
