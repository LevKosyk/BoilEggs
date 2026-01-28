import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boil_eggs/l10n/app_localizations.dart';
import 'package:boil_eggs/widgets/settings_widgets.dart';
import 'package:boil_eggs/services/history_service.dart';
import 'package:boil_eggs/providers/egg_timer_provider.dart';  
import 'package:boil_eggs/theme/app_colors.dart';
import '../providers/locale_provider.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  @override
  @override
  Widget build(BuildContext context) {
    var localeProvider = Provider.of<LocaleProvider>(context);
    var timerProvider = Provider.of<EggTimerProvider>(context);  
    var t = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: Text(
          t.settings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SettingsSection(
                title: t.language.toUpperCase(),
                children: [
                  SettingsTile(
                    title: t.language,
                    showDivider: false,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getLanguageName(localeProvider.locale?.languageCode),
                          style: const TextStyle(
                            color: AppColors.primaryAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                      ],
                    ),
                    onTap: () => _showLanguageSelector(context, localeProvider),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FutureBuilder<List<int>>(
                future: Future.wait([
                  HistoryService().getBoilsToday(),
                  HistoryService().getBoilsThisWeek(),
                ]),
                builder: (context, snapshot) {
                  final today = snapshot.data?[0] ?? 0;
                  final week = snapshot.data?[1] ?? 0;
                  return SettingsSection(
                    title: "STATISTICS",
                    children: [
                       SettingsTile(
                         title: "Boiled Today",
                         trailing: Text(
                           "$today",
                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                         ),
                       ),
                       SettingsTile(
                         title: "Boiled This Week",
                         showDivider: false,
                         trailing: Text(
                           "$week",
                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                         ),
                       ),
                    ],
                  );
                }
              ),
              const SizedBox(height: 24),
              SettingsSection(
                title: "SOUND & HAPTICS",
                children: [
                  SettingsTile(
                    title: "Sound Effect",
                    trailing: Switch(
                      value: timerProvider.soundEnabled,
                      onChanged: (val) => timerProvider.setSound(val),
                      activeTrackColor: AppColors.primaryAccent,
                    ),
                  ),
                  SettingsTile(
                    title: "Vibration",
                    showDivider: false,
                    trailing: Switch(
                      value: timerProvider.vibrationEnabled, 
                      onChanged: (val) => timerProvider.setVibration(val),
                      activeTrackColor: AppColors.primaryAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showLanguageSelector(BuildContext context, LocaleProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.selectLanguage,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  _LanguageOption(
                    label: "System Default",
                    code: null,
                    isSelected: provider.locale == null,
                    onTap: () {
                      provider.setLocale(null);
                      Navigator.pop(context);
                    },
                  ),
                  _LanguageOption(
                    label: "English",
                    code: 'en',
                    isSelected: provider.locale?.languageCode == 'en',
                    onTap: () {
                      provider.setLocale(const Locale('en'));
                      Navigator.pop(context);
                    },
                  ),
                  _LanguageOption(
                    label: "Español",
                    code: 'es',
                    isSelected: provider.locale?.languageCode == 'es',
                    onTap: () {
                      provider.setLocale(const Locale('es'));
                      Navigator.pop(context);
                    },
                  ),
                  _LanguageOption(
                    label: "Polski",
                    code: 'pl',
                    isSelected: provider.locale?.languageCode == 'pl',
                    onTap: () {
                      provider.setLocale(const Locale('pl'));
                      Navigator.pop(context);
                    },
                  ),
                  _LanguageOption(
                    label: "Deutsch",
                    code: 'de',
                    isSelected: provider.locale?.languageCode == 'de',
                    onTap: () {
                      provider.setLocale(const Locale('de'));
                      Navigator.pop(context);
                    },
                  ),
                  _LanguageOption(
                    label: "Português",
                    code: 'pt',
                    isSelected: provider.locale?.languageCode == 'pt',
                    onTap: () {
                      provider.setLocale(const Locale('pt'));
                      Navigator.pop(context);
                    },
                  ),
                  _LanguageOption(
                    label: "Українська",
                    code: 'uk',
                    isSelected: provider.locale?.languageCode == 'uk',
                    onTap: () {
                      provider.setLocale(const Locale('uk'));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _getLanguageName(String? code) {
    if (code == null) return "System Default";
    return switch (code) {
      'en' => "English",
      'es' => "Español",
      'pl' => "Polski",
      'de' => "Deutsch",
      'pt' => "Português",
      'uk' => "Українська",
      _ => code.toUpperCase(),
    };
  }
}
class _LanguageOption extends StatelessWidget {
  final String label;
  final String? code;
  final bool isSelected;
  final VoidCallback onTap;
  const _LanguageOption({
    required this.label,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAccent.withValues(alpha: 0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primaryAccent : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primaryAccent),
          ],
        ),
      ),
    );
  }
}
