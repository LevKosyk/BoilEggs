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

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('pl'),
    Locale('pt'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Boil Eggs'**
  String get appTitle;

  /// No description provided for @soft.
  ///
  /// In en, this message translates to:
  /// **'Soft'**
  String get soft;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @eggReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Egg Ready!'**
  String get eggReadyTitle;

  /// No description provided for @eggReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Your egg is boiled to perfection.'**
  String get eggReadyBody;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @defaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Boil Eggs'**
  String get defaultTitle;

  /// No description provided for @successTitle.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get successTitle;

  /// No description provided for @successBody.
  ///
  /// In en, this message translates to:
  /// **'Your eggs are ready to eat.\nEnjoy your meal!'**
  String get successBody;

  /// No description provided for @boilMore.
  ///
  /// In en, this message translates to:
  /// **'Boil More'**
  String get boilMore;

  /// No description provided for @upgradeToMedium.
  ///
  /// In en, this message translates to:
  /// **'Boil to Medium'**
  String get upgradeToMedium;

  /// No description provided for @upgradeToHard.
  ///
  /// In en, this message translates to:
  /// **'Boil to Hard'**
  String get upgradeToHard;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'Use older eggs for easier peeling.'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'Shock eggs in ice water immediately after boiling.'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'Add a pinch of salt to prevent cracking.'**
  String get tip3;

  /// No description provided for @tip4.
  ///
  /// In en, this message translates to:
  /// **'Room temperature eggs are less likely to crack.'**
  String get tip4;

  /// No description provided for @tip5.
  ///
  /// In en, this message translates to:
  /// **'Don\'t overcrowd the pot; keep a single layer.'**
  String get tip5;

  /// No description provided for @tip6.
  ///
  /// In en, this message translates to:
  /// **'Prick the shell bottom to prevent cracking.'**
  String get tip6;

  /// No description provided for @tip7.
  ///
  /// In en, this message translates to:
  /// **'Fresh eggs are harder to peel but tastier.'**
  String get tip7;

  /// No description provided for @tip8.
  ///
  /// In en, this message translates to:
  /// **'Start eggs in cold water for more even cooking.'**
  String get tip8;

  /// No description provided for @tip9.
  ///
  /// In en, this message translates to:
  /// **'Bring water to a gentle boil, not a rolling one.'**
  String get tip9;

  /// No description provided for @tip10.
  ///
  /// In en, this message translates to:
  /// **'Cover the pot to speed up boiling.'**
  String get tip10;

  /// No description provided for @tip11.
  ///
  /// In en, this message translates to:
  /// **'Adding vinegar can help whites seal if shells crack.'**
  String get tip11;

  /// No description provided for @tip12.
  ///
  /// In en, this message translates to:
  /// **'Use a spoon to lower eggs gently into water.'**
  String get tip12;

  /// No description provided for @tip13.
  ///
  /// In en, this message translates to:
  /// **'Stir eggs briefly to center the yolk.'**
  String get tip13;

  /// No description provided for @tip14.
  ///
  /// In en, this message translates to:
  /// **'Peel eggs under running water for easier removal.'**
  String get tip14;

  /// No description provided for @tip15.
  ///
  /// In en, this message translates to:
  /// **'Crack eggs on a flat surface, not the edge.'**
  String get tip15;

  /// No description provided for @tip16.
  ///
  /// In en, this message translates to:
  /// **'Peel from the wide end where the air pocket is.'**
  String get tip16;

  /// No description provided for @tip17.
  ///
  /// In en, this message translates to:
  /// **'Older eggs are better for hard-boiling.'**
  String get tip17;

  /// No description provided for @tip18.
  ///
  /// In en, this message translates to:
  /// **'Fresh eggs are ideal for poaching, not boiling.'**
  String get tip18;

  /// No description provided for @tip19.
  ///
  /// In en, this message translates to:
  /// **'Let eggs rest a minute before peeling.'**
  String get tip19;

  /// No description provided for @tip20.
  ///
  /// In en, this message translates to:
  /// **'Use a steamer basket for easy peeling.'**
  String get tip20;

  /// No description provided for @tip21.
  ///
  /// In en, this message translates to:
  /// **'Steamed eggs peel more easily than boiled ones.'**
  String get tip21;

  /// No description provided for @tip22.
  ///
  /// In en, this message translates to:
  /// **'Overcooking causes green rings around yolks.'**
  String get tip22;

  /// No description provided for @tip23.
  ///
  /// In en, this message translates to:
  /// **'Green rings are harmless but affect texture.'**
  String get tip23;

  /// No description provided for @tip24.
  ///
  /// In en, this message translates to:
  /// **'Egg size slightly changes cooking time.'**
  String get tip24;

  /// No description provided for @tip25.
  ///
  /// In en, this message translates to:
  /// **'High altitude requires longer boiling times.'**
  String get tip25;

  /// No description provided for @tip26.
  ///
  /// In en, this message translates to:
  /// **'Use a timer for consistent results.'**
  String get tip26;

  /// No description provided for @tip27.
  ///
  /// In en, this message translates to:
  /// **'Soft-boiled eggs pair well with toast.'**
  String get tip27;

  /// No description provided for @tip28.
  ///
  /// In en, this message translates to:
  /// **'Medium eggs have jammy yolks.'**
  String get tip28;

  /// No description provided for @tip29.
  ///
  /// In en, this message translates to:
  /// **'Hard-boiled eggs are best for salads.'**
  String get tip29;

  /// No description provided for @tip30.
  ///
  /// In en, this message translates to:
  /// **'Peel eggs once fully cooled.'**
  String get tip30;

  /// No description provided for @tip31.
  ///
  /// In en, this message translates to:
  /// **'Ice baths stop cooking immediately.'**
  String get tip31;

  /// No description provided for @tip32.
  ///
  /// In en, this message translates to:
  /// **'Shake eggs gently to loosen shells.'**
  String get tip32;

  /// No description provided for @tip33.
  ///
  /// In en, this message translates to:
  /// **'Store peeled eggs in water in the fridge.'**
  String get tip33;

  /// No description provided for @tip34.
  ///
  /// In en, this message translates to:
  /// **'Unpeeled eggs last longer in the fridge.'**
  String get tip34;

  /// No description provided for @tip35.
  ///
  /// In en, this message translates to:
  /// **'Label boiled eggs to avoid confusion.'**
  String get tip35;

  /// No description provided for @tip36.
  ///
  /// In en, this message translates to:
  /// **'Eggs float when old but are still usable.'**
  String get tip36;

  /// No description provided for @tip37.
  ///
  /// In en, this message translates to:
  /// **'Floating eggs should be cooked thoroughly.'**
  String get tip37;

  /// No description provided for @tip38.
  ///
  /// In en, this message translates to:
  /// **'Salted water slightly raises boiling point.'**
  String get tip38;

  /// No description provided for @tip39.
  ///
  /// In en, this message translates to:
  /// **'Use tongs to remove hot eggs safely.'**
  String get tip39;

  /// No description provided for @tip40.
  ///
  /// In en, this message translates to:
  /// **'Room temperature eggs cook more evenly.'**
  String get tip40;

  /// No description provided for @tip41.
  ///
  /// In en, this message translates to:
  /// **'Avoid overcrowding to prevent cracking.'**
  String get tip41;

  /// No description provided for @tip42.
  ///
  /// In en, this message translates to:
  /// **'A splash of oil reduces foam.'**
  String get tip42;

  /// No description provided for @tip43.
  ///
  /// In en, this message translates to:
  /// **'Gentle simmering prevents damage.'**
  String get tip43;

  /// No description provided for @tip44.
  ///
  /// In en, this message translates to:
  /// **'Eggshell color doesn’t affect taste.'**
  String get tip44;

  /// No description provided for @tip45.
  ///
  /// In en, this message translates to:
  /// **'Brown and white eggs cook the same.'**
  String get tip45;

  /// No description provided for @tip46.
  ///
  /// In en, this message translates to:
  /// **'Eggs are a complete protein.'**
  String get tip46;

  /// No description provided for @tip47.
  ///
  /// In en, this message translates to:
  /// **'Yolk color depends on hen’s diet.'**
  String get tip47;

  /// No description provided for @tip48.
  ///
  /// In en, this message translates to:
  /// **'Cool eggs before storing.'**
  String get tip48;

  /// No description provided for @tip49.
  ///
  /// In en, this message translates to:
  /// **'Use leftover eggs for sandwiches.'**
  String get tip49;

  /// No description provided for @tip50.
  ///
  /// In en, this message translates to:
  /// **'Eggs absorb fridge odors easily.'**
  String get tip50;

  /// No description provided for @tip51.
  ///
  /// In en, this message translates to:
  /// **'Store eggs in original carton.'**
  String get tip51;

  /// No description provided for @tip52.
  ///
  /// In en, this message translates to:
  /// **'Don’t microwave whole eggs.'**
  String get tip52;

  /// No description provided for @tip53.
  ///
  /// In en, this message translates to:
  /// **'Cracked eggs cook faster.'**
  String get tip53;

  /// No description provided for @tip54.
  ///
  /// In en, this message translates to:
  /// **'Use older eggs for deviled eggs.'**
  String get tip54;

  /// No description provided for @tip55.
  ///
  /// In en, this message translates to:
  /// **'Fresh eggs sink in water.'**
  String get tip55;

  /// No description provided for @tip56.
  ///
  /// In en, this message translates to:
  /// **'Rolling eggs gently loosens shells.'**
  String get tip56;

  /// No description provided for @tip57.
  ///
  /// In en, this message translates to:
  /// **'Steam makes shells separate cleanly.'**
  String get tip57;

  /// No description provided for @tip58.
  ///
  /// In en, this message translates to:
  /// **'Medium heat gives best control.'**
  String get tip58;

  /// No description provided for @tip59.
  ///
  /// In en, this message translates to:
  /// **'Use a lid to reduce splashing.'**
  String get tip59;

  /// No description provided for @tip60.
  ///
  /// In en, this message translates to:
  /// **'Don’t stack eggs in the pot.'**
  String get tip60;

  /// No description provided for @tip61.
  ///
  /// In en, this message translates to:
  /// **'Peeling warm eggs is harder.'**
  String get tip61;

  /// No description provided for @tip62.
  ///
  /// In en, this message translates to:
  /// **'Cold water shrinks egg whites slightly.'**
  String get tip62;

  /// No description provided for @tip63.
  ///
  /// In en, this message translates to:
  /// **'Hard-boiled eggs are meal-prep friendly.'**
  String get tip63;

  /// No description provided for @tip64.
  ///
  /// In en, this message translates to:
  /// **'Eggs contain vitamin D.'**
  String get tip64;

  /// No description provided for @tip65.
  ///
  /// In en, this message translates to:
  /// **'Overboiling dries the yolk.'**
  String get tip65;

  /// No description provided for @tip66.
  ///
  /// In en, this message translates to:
  /// **'Jammy yolks need precise timing.'**
  String get tip66;

  /// No description provided for @tip67.
  ///
  /// In en, this message translates to:
  /// **'Large eggs are the standard for recipes.'**
  String get tip67;

  /// No description provided for @tip68.
  ///
  /// In en, this message translates to:
  /// **'Soft eggs need careful handling.'**
  String get tip68;

  /// No description provided for @tip69.
  ///
  /// In en, this message translates to:
  /// **'Use eggs within one week after boiling.'**
  String get tip69;

  /// No description provided for @tip70.
  ///
  /// In en, this message translates to:
  /// **'Avoid sudden temperature shocks before boiling.'**
  String get tip70;

  /// No description provided for @tip71.
  ///
  /// In en, this message translates to:
  /// **'A slotted spoon prevents drops.'**
  String get tip71;

  /// No description provided for @tip72.
  ///
  /// In en, this message translates to:
  /// **'Boiling time starts after water boils.'**
  String get tip72;

  /// No description provided for @tip73.
  ///
  /// In en, this message translates to:
  /// **'Gentle bubbles are ideal.'**
  String get tip73;

  /// No description provided for @tip74.
  ///
  /// In en, this message translates to:
  /// **'Egg whites firm before yolks.'**
  String get tip74;

  /// No description provided for @tip75.
  ///
  /// In en, this message translates to:
  /// **'Peeling under water reduces tearing.'**
  String get tip75;

  /// No description provided for @tip76.
  ///
  /// In en, this message translates to:
  /// **'Use a pin for precise shell pricking.'**
  String get tip76;

  /// No description provided for @tip77.
  ///
  /// In en, this message translates to:
  /// **'Eggshell membranes affect peeling.'**
  String get tip77;

  /// No description provided for @tip78.
  ///
  /// In en, this message translates to:
  /// **'Steam escapes through shell pores.'**
  String get tip78;

  /// No description provided for @tip79.
  ///
  /// In en, this message translates to:
  /// **'Protein tightens with heat.'**
  String get tip79;

  /// No description provided for @tip80.
  ///
  /// In en, this message translates to:
  /// **'Eggs are naturally gluten-free.'**
  String get tip80;

  /// No description provided for @tip81.
  ///
  /// In en, this message translates to:
  /// **'Older eggs have larger air pockets.'**
  String get tip81;

  /// No description provided for @tip82.
  ///
  /// In en, this message translates to:
  /// **'Don’t reuse boiling water for taste.'**
  String get tip82;

  /// No description provided for @tip83.
  ///
  /// In en, this message translates to:
  /// **'Use timer presets for consistency.'**
  String get tip83;

  /// No description provided for @tip84.
  ///
  /// In en, this message translates to:
  /// **'Eggs cook faster at higher heat.'**
  String get tip84;

  /// No description provided for @tip85.
  ///
  /// In en, this message translates to:
  /// **'Cooling improves texture.'**
  String get tip85;

  /// No description provided for @tip86.
  ///
  /// In en, this message translates to:
  /// **'Peel gently to keep egg smooth.'**
  String get tip86;

  /// No description provided for @tip87.
  ///
  /// In en, this message translates to:
  /// **'A cracked shell doesn’t ruin taste.'**
  String get tip87;

  /// No description provided for @tip88.
  ///
  /// In en, this message translates to:
  /// **'Use vinegar for emergency cracks.'**
  String get tip88;

  /// No description provided for @tip89.
  ///
  /// In en, this message translates to:
  /// **'Eggs are budget-friendly protein.'**
  String get tip89;

  /// No description provided for @tip90.
  ///
  /// In en, this message translates to:
  /// **'Avoid overcrowding the steamer.'**
  String get tip90;

  /// No description provided for @tip91.
  ///
  /// In en, this message translates to:
  /// **'Room temp eggs reduce shock.'**
  String get tip91;

  /// No description provided for @tip92.
  ///
  /// In en, this message translates to:
  /// **'Shell thickness varies by age.'**
  String get tip92;

  /// No description provided for @tip93.
  ///
  /// In en, this message translates to:
  /// **'Soft eggs need less water depth.'**
  String get tip93;

  /// No description provided for @tip94.
  ///
  /// In en, this message translates to:
  /// **'Hard eggs are easier to transport.'**
  String get tip94;

  /// No description provided for @tip95.
  ///
  /// In en, this message translates to:
  /// **'Egg whites set at lower temperatures.'**
  String get tip95;

  /// No description provided for @tip96.
  ///
  /// In en, this message translates to:
  /// **'Yolks thicken as they cook.'**
  String get tip96;

  /// No description provided for @tip97.
  ///
  /// In en, this message translates to:
  /// **'Practice improves perfect timing.'**
  String get tip97;

  /// No description provided for @tip98.
  ///
  /// In en, this message translates to:
  /// **'Consistent egg size helps accuracy.'**
  String get tip98;

  /// No description provided for @tip99.
  ///
  /// In en, this message translates to:
  /// **'Use same pot for repeat results.'**
  String get tip99;

  /// No description provided for @tip100.
  ///
  /// In en, this message translates to:
  /// **'Timer apps improve consistency.'**
  String get tip100;

  /// No description provided for @tip101.
  ///
  /// In en, this message translates to:
  /// **'Don’t rush the cooling step.'**
  String get tip101;

  /// No description provided for @tip102.
  ///
  /// In en, this message translates to:
  /// **'Eggs are great post-workout food.'**
  String get tip102;

  /// No description provided for @tip103.
  ///
  /// In en, this message translates to:
  /// **'Eggshells can be composted.'**
  String get tip103;

  /// No description provided for @tip104.
  ///
  /// In en, this message translates to:
  /// **'Cool eggs peel more cleanly.'**
  String get tip104;

  /// No description provided for @tip105.
  ///
  /// In en, this message translates to:
  /// **'Use calm heat for best texture.'**
  String get tip105;

  /// No description provided for @tip106.
  ///
  /// In en, this message translates to:
  /// **'Eggs are naturally low-carb.'**
  String get tip106;

  /// No description provided for @tip107.
  ///
  /// In en, this message translates to:
  /// **'Perfect eggs come from consistency.'**
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
  // Lookup logic when only language code is specified.
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
