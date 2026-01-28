import 'package:boil_eggs/providers/egg_timer_provider.dart';
import 'package:boil_eggs/screens/finish_screen.dart';  
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
              if (provider.status == TimerStatus.boiling)
                 const Positioned.fill(
                   child: BoilingAnimation(),
                 ),
              SafeArea(
                child: Column(
                  children: [
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
                          const SizedBox(width: 48),  
                        ],
                      ),
                    ),
                    const Spacer(),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 20,
                            color: AppColors.softEgg.withValues(alpha: 0.2),
                          ),
                        ),
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
                        const EggIllustration(height: 140)
                            .animate(
                              target: provider.status == TimerStatus.boiling ? 1 : 0,
                              onPlay: (controller) => controller.repeat(reverse: true),
                            )
                            .moveY(begin: 0, end: -10, duration: 1000.ms, curve: Curves.easeInOut)  
                            .shake(hz: 0.5, rotation: 0.05),  
                      ],
                    ).animate().scale(curve: Curves.easeOutBack, duration: 500.ms),
                    const SizedBox(height: 40),
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
                    if (provider.status == TimerStatus.boiling) ...[
                       Builder(
                         builder: (context) {
                           final tips = _getTips(t);
                           final tip = tips[_currentTipIndex % tips.length];
                           return InkWell(
                             onTap: _nextTip,
                             borderRadius: BorderRadius.circular(16),
                             child: Container(
                               margin: const EdgeInsets.symmetric(horizontal: 24),
                               padding: const EdgeInsets.all(16),
                               decoration: BoxDecoration(
                                 color: Colors.white.withValues(alpha: 0.9),
                                 borderRadius: BorderRadius.circular(16),
                                 boxShadow: [
                                   BoxShadow(
                                     color: Colors.black.withValues(alpha: 0.05),
                                     blurRadius: 10,
                                     offset: const Offset(0, 4),
                                   ),
                                 ],
                               ),
                               child: Row(
                                 children: [
                                   Icon(Icons.lightbulb_rounded, color: Colors.orangeAccent)
                                      .animate(key: ValueKey(_currentTipIndex))
                                      .rotate(duration: 400.ms, curve: Curves.easeOutBack)  
                                      .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), duration: 400.ms),  
                                   const SizedBox(width: 12),
                                   Expanded(
                                      child: Text(
                                        "Tip: $tip",
                                        key: ValueKey(_currentTipIndex),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.textSecondary,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ).animate(key: ValueKey(_currentTipIndex))  
                                       .fadeIn(duration: 300.ms)
                                       .slideX(begin: 0.2, end: 0, curve: Curves.easeOut),  
                                   ),
                                   const Icon(Icons.touch_app_rounded, size: 16, color: AppColors.textSecondary),
                                 ],
                               ),
                             ),
                           ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: 1000.ms);
                         }
                       ),
                    ],
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
  int _currentTipIndex = 0;
  List<String> _getTips(AppLocalizations t) {
    return [
      t.tip1, t.tip2, t.tip3, t.tip4, t.tip5, t.tip6, t.tip7, t.tip8, t.tip9, t.tip10,
      t.tip11, t.tip12, t.tip13, t.tip14, t.tip15, t.tip16, t.tip17, t.tip18, t.tip19, t.tip20,
      t.tip21, t.tip22, t.tip23, t.tip24, t.tip25, t.tip26, t.tip27, t.tip28, t.tip29, t.tip30,
      t.tip31, t.tip32, t.tip33, t.tip34, t.tip35, t.tip36, t.tip37, t.tip38, t.tip39, t.tip40,
      t.tip41, t.tip42, t.tip43, t.tip44, t.tip45, t.tip46, t.tip47, t.tip48, t.tip49, t.tip50,
      t.tip51, t.tip52, t.tip53, t.tip54, t.tip55, t.tip56, t.tip57, t.tip58, t.tip59, t.tip60,
      t.tip61, t.tip62, t.tip63, t.tip64, t.tip65, t.tip66, t.tip67, t.tip68, t.tip69, t.tip70,
      t.tip71, t.tip72, t.tip73, t.tip74, t.tip75, t.tip76, t.tip77, t.tip78, t.tip79, t.tip80,
      t.tip81, t.tip82, t.tip83, t.tip84, t.tip85, t.tip86, t.tip87, t.tip88, t.tip89, t.tip90,
      t.tip91, t.tip92, t.tip93, t.tip94, t.tip95, t.tip96, t.tip97, t.tip98, t.tip99, t.tip100,
      t.tip101, t.tip102, t.tip103, t.tip104, t.tip105, t.tip106, t.tip107,
    ];
  }
  void _nextTip() {
    setState(() {
      _currentTipIndex++;
    });
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
