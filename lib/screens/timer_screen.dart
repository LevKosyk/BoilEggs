import 'package:boil_eggs/providers/egg_timer_provider.dart';
import 'package:boil_eggs/screens/finish_screen.dart'; // We'll create this next
import 'package:boil_eggs/theme/app_colors.dart';
import 'package:boil_eggs/widgets/boiling_animation.dart';
import 'package:boil_eggs/widgets/circular_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
                            provider.selectedDoneness?.label ?? "Boil Eggs",
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

                    // Timer Circular Indicator
                    CircularTimer(
                      progress: provider.progress,
                      timeText: timeText,
                    ).animate().scale(curve: Curves.easeOutBack, duration: 500.ms),

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
                              label: "Pause",
                              color: AppColors.primaryAccent,
                              onTap: provider.pauseTimer,
                            )
                          else if (provider.status == TimerStatus.paused || provider.status == TimerStatus.idle)
                             _ControlButton(
                              icon: Icons.play_arrow_rounded,
                              label: "Resume",
                              color: AppColors.secondaryAccent,
                              onTap: provider.startTimer,
                            ),
                            
                          const SizedBox(width: 24),
                          
                          _ControlButton(
                            icon: Icons.stop_rounded,
                            label: "Cancel",
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
