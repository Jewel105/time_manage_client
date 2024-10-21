import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this);
}

extension StringExtension on String? {
  bool get isEmptyOrNull => this == null || this!.isEmpty;
}