import 'package:boil_eggs/providers/egg_timer_provider.dart';
import 'package:boil_eggs/screens/settings_screen.dart';
import 'package:boil_eggs/screens/timer_screen.dart'; // We'll create this next
import 'package:boil_eggs/theme/app_colors.dart'; // Import AppColors
import 'package:boil_eggs/widgets/doneness_card.dart';
import 'package:boil_eggs/widgets/egg_illustration.dart';
import 'package:boil_eggs/widgets/ad_banner.dart'; // Import BannerAdWidget
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
      extendBodyBehindAppBar: true,
      bottomNavigationBar: const BannerAdWidget(), // Ad Banner fixed at bottom
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
        child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top),
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
                        
                        const SizedBox(height: 30), // Reduced spacing
                        
                        // Hero Egg Illustration
                        const Hero(
                          tag: 'egg_hero',
                          child: EggIllustration(height: 200), // Slightly smaller
                        ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                        
                        const SizedBox(height: 16),
                        
                        // Customization Panel
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Consumer<EggTimerProvider>(
                              builder: (context, provider, _) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                       BoxShadow(
                                         color: Colors.black.withValues(alpha: 0.05),
                                         blurRadius: 10,
                                         offset: const Offset(0, 4),
                                       ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Size Selector
                                      _CustomizationOption(
                                        label: "Size",
                                        value: provider.selectedSize.label,
                                        icon: Icons.egg_rounded,
                                        onTap: () {
                                          // Rotate through sizes
                                          final nextIndex = (provider.selectedSize.index + 1) % EggSize.values.length;
                                          provider.setSize(EggSize.values[nextIndex]);
                                        },
                                      ),
                                      Container(width: 1, height: 40, color: Colors.grey.withValues(alpha: 0.2)),
                                      // Temp Selector
                                      _CustomizationOption(
                                        label: "Temp",
                                        value: provider.selectedTemp.label,
                                        icon: Icons.thermostat_rounded,
                                        onTap: () {
                                          // Rotate through temps
                                          final nextIndex = (provider.selectedTemp.index + 1) % EggTemp.values.length;
                                          provider.setTemp(EggTemp.values[nextIndex]);
                                        },
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: 200.ms);
                              }
                          ),
                        ),

                        const Spacer(),
                        
                        // Selection Cards
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Consumer<EggTimerProvider>(
                            builder: (context, provider, child) {
                              return Column(
                                children: EggDoneness.values.map((doneness) {
                                  // Calculate dynamic time for this option based on current size/temp
                                  final durationSeconds = provider.calculateDuration(doneness);
                                  final minutes = (durationSeconds / 60).floor();
                                  final seconds = durationSeconds % 60;
                                  
                                  String timeStr;
                                  if (seconds == 0) {
                                    timeStr = "$minutes";
                                  } else {
                                    timeStr = "$minutes:${seconds.toString().padLeft(2, '0')}";
                                  }

                                  return DonenessCard(
                                    doneness: doneness,
                                    isSelected: provider.selectedDoneness == doneness,
                                    displayTime: timeStr,
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
          ),
        ),
      );
  }
}

class _CustomizationOption extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _CustomizationOption({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
             Row(
               children: [
                 Icon(icon, size: 16, color: AppColors.textSecondary),
                 const SizedBox(width: 4),
                 Text(
                   label.toUpperCase(),
                   style: Theme.of(context).textTheme.labelSmall?.copyWith(
                     color: AppColors.textSecondary,
                     fontWeight: FontWeight.bold,
                     letterSpacing: 1.0,
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 4),
             Text(
               value,
               style: Theme.of(context).textTheme.titleMedium?.copyWith(
                 fontWeight: FontWeight.bold,
                 color: AppColors.primaryAccent,
               ),
             ),
          ],
        ),
      ),
    );
  }
}
