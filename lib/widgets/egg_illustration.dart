import 'package:boil_eggs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EggIllustration extends StatelessWidget {
  final double height;

  const EggIllustration({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height * 0.75, // Aspect ratio for an egg
      decoration: BoxDecoration(
        color: AppColors.softEgg, // Default to soft egg color, could be dynamic
        borderRadius: BorderRadius.all(Radius.elliptical(height * 0.75, height)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: 5,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.8),
            AppColors.softEgg,
            AppColors.softEgg.withValues(alpha: 0.8), // Slightly darker for 3D effect
          ],
          stops: const [0.1, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Shine reflection
          Positioned(
            top: height * 0.15,
            left: height * 0.15,
            child: Container(
              width: height * 0.15,
              height: height * 0.25,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                borderRadius: BorderRadius.all(Radius.elliptical(30, 60)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
