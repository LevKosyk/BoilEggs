import 'package:boil_eggs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BoilingAnimation extends StatelessWidget {
  const BoilingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Generate multiple bubbles
          for (int i = 0; i < 15; i++)
            Positioned(
              left: (i * 25.0) % 300,
              bottom: 0,
              child: _Bubble(delay: i * 300),
            ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final int delay;

  const _Bubble({required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.softEgg.withValues(alpha: 0.5), width: 1),
      ),
    )
    .animate(onPlay: (controller) => controller.repeat())
    .scale(
      duration: 2000.ms,
      delay: delay.ms,
      begin: const Offset(0.5, 0.5),
      end: const Offset(1.5, 1.5),
    )
    .moveY(
      begin: 0,
      end: -250,
      duration: 2500.ms,
      delay: delay.ms,
      curve: Curves.easeIn,
    )
    .fadeOut(
      delay: (delay + 1500).ms,
      duration: 1000.ms,
    );
  }
}
