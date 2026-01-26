import 'package:boil_eggs/providers/egg_timer_provider.dart';
import 'package:boil_eggs/screens/settings_screen.dart';
import 'package:boil_eggs/screens/timer_screen.dart'; // We'll create this next
import 'package:boil_eggs/theme/app_colors.dart'; // Import AppColors
import 'package:boil_eggs/widgets/doneness_card.dart';
import 'package:boil_eggs/widgets/egg_illustration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:boil_eggs/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.settings_rounded,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              // Title
              Text(
                t.appTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      color: AppColors.textPrimary,
                    ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
              
              const SizedBox(height: 40),
              
              // Hero Egg Illustration
              const Hero(
                tag: 'egg_hero',
                child: EggIllustration(height: 220),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
              
              const Spacer(),
              
              // Selection Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Consumer<EggTimerProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      children: EggDoneness.values.map((doneness) {
                        return DonenessCard(
                          doneness: doneness,
                          isSelected: provider.selectedDoneness == doneness,
                          onTap: () {
                            provider.selectDoneness(doneness);
                            // Navigate to Timer Screen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const TimerScreen(),
                              ),
                            );
                          },
                        );
                      }).toList()
                      .animate(interval: 100.ms)
                      .slideY(begin: 0.2, duration: 600.ms)
                      .fadeIn(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
