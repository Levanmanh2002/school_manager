import 'package:flutter/widgets.dart';
import 'package:school_web/web/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
