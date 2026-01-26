import 'package:boil_eggs/providers/egg_timer_provider.dart';
import 'package:boil_eggs/screens/finish_screen.dart'; // We'll create this next
import 'package:boil_eggs/theme/app_colors.dart';
import 'package:boil_eggs/widgets/boiling_animation.dart';
import 'package:boil_eggs/widgets/egg_illustration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:boil_eggs/l10n/app_localizations.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-start timer after a short delay for smooth transition
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<EggTimerProvider>().startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: Consumer<EggTimerProvider>(
        builder: (context, provider, child) {
          // Listen for completion to navigate
          if (provider.status == TimerStatus.done) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const FinishScreen()),
              );
            });
          }

          final minutes = (provider.remainingSeconds / 60).floor();
          final seconds = provider.remainingSeconds % 60;
          final timeText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
          
          String titleStr = t.defaultTitle;
          if (provider.selectedDoneness != null) {
             titleStr = switch (provider.selectedDoneness!) {
                EggDoneness.soft => t.soft,
                EggDoneness.medium => t.medium,
                EggDoneness.hard => t.hard,
             };
          }

          return Stack(
            children: [
              // Boiling Animation Background (activates when boiling)
              if (provider.status == TimerStatus.boiling)
                 const Positioned.fill(
                   child: BoilingAnimation(),
                 ),

              SafeArea(
                child: Column(
                  children: [
                    // Top Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            onPressed: () {
                              provider.cancelTimer();
                              Navigator.of(context).pop();
                            },
                          ),
                          const Spacer(),
                          Text(
                            titleStr,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 48), // Balance for back button
                        ],
                      ),
                    ),
                    
                    const Spacer(),

                    // Timer & Egg Visual
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background Circle
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 20,
                            color: AppColors.softEgg.withValues(alpha: 0.2),
                          ),
                        ),
                        // Progress Circle
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: CircularProgressIndicator(
                            value: provider.progress,
                            strokeWidth: 20,
                            strokeCap: StrokeCap.round,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                        // The Egg
                        const EggIllustration(height: 140)
                            .animate(
                              target: provider.status == TimerStatus.boiling ? 1 : 0,
                              onPlay: (controller) => controller.repeat(reverse: true),
                            )
                            .moveY(begin: 0, end: -10, duration: 1000.ms, curve: Curves.easeInOut) // Bobbing effect
                            .shake(hz: 0.5, rotation: 0.05), // Slight wobble
                      ],
                    ).animate().scale(curve: Curves.easeOutBack, duration: 500.ms),

                    const SizedBox(height: 40),
                    
                    // Time Text
                    Column(
                      children: [
                        Text(
                          timeText,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFeatures: [const FontFeature.tabularFigures()],
                                color: AppColors.textPrimary,
                              ),
                        ),
                        Text(
                           titleStr,
                           style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),

                    // Upgrade Button
                    if (provider.selectedDoneness != null && provider.selectedDoneness != EggDoneness.hard)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              if (provider.selectedDoneness == EggDoneness.soft) {
                                provider.upgradeDoneness(EggDoneness.medium);
                              } else if (provider.selectedDoneness == EggDoneness.medium) {
                                provider.upgradeDoneness(EggDoneness.hard);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: Text(
                              provider.selectedDoneness == EggDoneness.soft 
                                  ? t.upgradeToMedium 
                                  : t.upgradeToHard,
                            ),
                          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                        ),

                    const Spacer(),

                    // Controls
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (provider.status == TimerStatus.boiling)
                            _ControlButton(
                              icon: Icons.pause_rounded,
                              label: t.pause,
                              color: AppColors.primaryAccent,
                              onTap: provider.pauseTimer,
                            )
                          else if (provider.status == TimerStatus.paused || provider.status == TimerStatus.idle)
                             _ControlButton(
                              icon: Icons.play_arrow_rounded,
                              label: t.resume,
                              color: AppColors.secondaryAccent,
                              onTap: provider.startTimer,
                            ),
                            
                          const SizedBox(width: 24),
                          
                          _ControlButton(
                            icon: Icons.stop_rounded,
                            label: t.cancel,
                            color: AppColors.hardEgg,
                            onTap: () {
                              provider.cancelTimer();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }
}
