import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_uk.dart';
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());
  final String localeName;
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('pl'),
    Locale('pt'),
    Locale('uk'),
  ];
  String get appTitle;
  String get soft;
  String get medium;
  String get hard;
  String get start;
  String get stop;
  String get settings;
  String get language;
  String get english;
  String get spanish;
  String get eggReadyTitle;
  String get eggReadyBody;
  String get selectLanguage;
  String get pause;
  String get resume;
  String get cancel;
  String get defaultTitle;
  String get successTitle;
  String get successBody;
  String get boilMore;
  String get upgradeToMedium;
  String get upgradeToHard;
  String get tip1;
  String get tip2;
  String get tip3;
  String get tip4;
  String get tip5;
  String get tip6;
  String get tip7;
  String get tip8;
  String get tip9;
  String get tip10;
  String get tip11;
  String get tip12;
  String get tip13;
  String get tip14;
  String get tip15;
  String get tip16;
  String get tip17;
  String get tip18;
  String get tip19;
  String get tip20;
  String get tip21;
  String get tip22;
  String get tip23;
  String get tip24;
  String get tip25;
  String get tip26;
  String get tip27;
  String get tip28;
  String get tip29;
  String get tip30;
  String get tip31;
  String get tip32;
  String get tip33;
  String get tip34;
  String get tip35;
  String get tip36;
  String get tip37;
  String get tip38;
  String get tip39;
  String get tip40;
  String get tip41;
  String get tip42;
  String get tip43;
  String get tip44;
  String get tip45;
  String get tip46;
  String get tip47;
  String get tip48;
  String get tip49;
  String get tip50;
  String get tip51;
  String get tip52;
  String get tip53;
  String get tip54;
  String get tip55;
  String get tip56;
  String get tip57;
  String get tip58;
  String get tip59;
  String get tip60;
  String get tip61;
  String get tip62;
  String get tip63;
  String get tip64;
  String get tip65;
  String get tip66;
  String get tip67;
  String get tip68;
  String get tip69;
  String get tip70;
  String get tip71;
  String get tip72;
  String get tip73;
  String get tip74;
  String get tip75;
  String get tip76;
  String get tip77;
  String get tip78;
  String get tip79;
  String get tip80;
  String get tip81;
  String get tip82;
  String get tip83;
  String get tip84;
  String get tip85;
  String get tip86;
  String get tip87;
  String get tip88;
  String get tip89;
  String get tip90;
  String get tip91;
  String get tip92;
  String get tip93;
  String get tip94;
  String get tip95;
  String get tip96;
  String get tip97;
  String get tip98;
  String get tip99;
  String get tip100;
  String get tip101;
  String get tip102;
  String get tip103;
  String get tip104;
  String get tip105;
  String get tip106;
  String get tip107;
}
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }
  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'pl',
    'pt',
    'uk',
  ].contains(locale.languageCode);
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'uk':
      return AppLocalizationsUk();
  }
  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
