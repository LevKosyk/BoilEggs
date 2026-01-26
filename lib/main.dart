import 'package:boil_eggs/providers/egg_timer_provider.dart';
import 'package:boil_eggs/screens/home_screen.dart';
import 'package:boil_eggs/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
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
      ],
      child: MaterialApp(
        title: 'Boil Eggs',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
