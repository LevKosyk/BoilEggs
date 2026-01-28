import 'package:boil_eggs/theme/app_colors.dart';
import 'package:flutter/material.dart';
class CircularTimer extends StatelessWidget {
  final double progress;  
  final String timeText;
  const CircularTimer({
    super.key,
    required this.progress,
    required this.timeText,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 250,
            height: 250,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 15,
              color: AppColors.softEgg.withValues(alpha: 0.3),
            ),
          ),
          SizedBox(
            width: 250,
            height: 250,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 15,
              strokeCap: StrokeCap.round,
              color: AppColors.primaryAccent,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeText,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
              ),
              Text(
                "remaining",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
