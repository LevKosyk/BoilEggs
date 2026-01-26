import 'package:boil_eggs/providers/egg_timer_provider.dart';
import 'package:boil_eggs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DonenessCard extends StatelessWidget {
  final EggDoneness doneness;
  final bool isSelected;
  final VoidCallback onTap;

  const DonenessCard({
    super.key,
    required this.doneness,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (doneness) {
      EggDoneness.soft => AppColors.softEgg,
      EggDoneness.medium => AppColors.mediumEgg,
      EggDoneness.hard => AppColors.hardEgg,
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        transform: Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: isSelected ? 0.4 : 0.1),
              blurRadius: isSelected ? 20 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Mini Egg Icon
            Container(
              width: 48,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.elliptical(48, 60)),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doneness.label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doneness.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${doneness.minutes}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
                Text(
                  'min',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
