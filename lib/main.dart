import 'package:boil_eggs/providers/egg_timer_provider.dart';
import 'package:boil_eggs/providers/locale_provider.dart';  
import 'package:boil_eggs/services/notification_service.dart';  
import 'package:boil_eggs/services/ad_service.dart';  
import 'package:boil_eggs/screens/home_screen.dart';
import 'package:boil_eggs/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';  
import 'package:boil_eggs/l10n/app_localizations.dart';  
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  try {
    await AdService().init();
  } catch (e) {
    debugPrint("Failed to initialize AdMob: $e");
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const BoilEggsApp());
}
class BoilEggsApp extends StatelessWidget {
  const BoilEggsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EggTimerProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),  
      ],
      child: Consumer<LocaleProvider>(  
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Boil Eggs',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: localeProvider.locale,  
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),  
              Locale('es'),  
              Locale('pl'),  
              Locale('de'),  
              Locale('pt'),  
              Locale('uk'),  
            ],
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
