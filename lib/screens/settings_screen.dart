import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boil_eggs/l10n/app_localizations.dart';
import 'package:boil_eggs/widgets/settings_widgets.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    var localeProvider = Provider.of<LocaleProvider>(context);
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
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: localeProvider.locale?.languageCode, // null for system default
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blue),
                          isDense: true,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          onChanged: (String? newValue) {
                             if (newValue == null) {
                               localeProvider.setLocale(null);
                             } else {
                               localeProvider.setLocale(Locale(newValue));
                             }
                          },
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Text("System Default"),
                            ),
                            const DropdownMenuItem(
                              value: 'en',
                              child: Text("English"),
                            ),
                            const DropdownMenuItem(
                              value: 'es',
                              child: Text("Español"),
                            ),
                          ],
                        ),
                      ),
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
}
