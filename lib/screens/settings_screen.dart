import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simply_net/l10n/app_languages.dart';
import 'package:simply_net/l10n/app_localizations.dart';
import 'package:simply_net/models/app_settings.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/utils/support_links.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<SettingsProvider>();
    final settings = prov.settings;
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.settingsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // ── Appearance ──────────────────────────────────────────────────
          _SectionHeader(l.appearance),

          // Language (first Appearance setting)
          _LanguageTile(current: prov.language, onSelected: prov.setLanguage),

          // Theme
          _SegmentedTile(
            icon: Icons.brightness_4,
            label: l.theme,
            child: SegmentedButton<AppTheme>(
              segments: [
                ButtonSegment(
                  value: AppTheme.light,
                  icon: const Icon(Icons.light_mode),
                  label: Text(l.themeLight),
                ),
                ButtonSegment(
                  value: AppTheme.dark,
                  icon: const Icon(Icons.dark_mode),
                  label: Text(l.themeDark),
                ),
                ButtonSegment(
                  value: AppTheme.system,
                  icon: const Icon(Icons.brightness_auto),
                  label: Text(l.themeAuto),
                ),
              ],
              selected: {settings.theme},
              onSelectionChanged: (v) => prov.setTheme(v.first),
            ),
          ),

          // Screen on timeout
          _SegmentedTile(
            icon: Icons.screen_lock_portrait_outlined,
            label: l.screenOnTimeout,
            child: SegmentedButton<AppScreenTimeout>(
              segments: [
                ButtonSegment(
                  value: AppScreenTimeout.system,
                  icon: const Icon(Icons.phone_android),
                  label: Text(l.timeoutSystem),
                ),
                ButtonSegment(
                  value: AppScreenTimeout.triple,
                  icon: const Icon(Icons.timer_3_select),
                  label: Text(l.timeoutTriple),
                ),
                ButtonSegment(
                  value: AppScreenTimeout.stayOn,
                  icon: const Icon(Icons.lock_open_outlined),
                  label: Text(l.timeoutStayOn),
                ),
              ],
              selected: {settings.screenTimeout},
              onSelectionChanged: (v) => prov.setScreenTimeout(v.first),
            ),
          ),

          const Divider(height: 24),
          _SectionHeader(l.scanning),

          SwitchListTile(
            secondary: const Icon(Icons.router_outlined),
            title: Text(l.showMacAddress),
            subtitle: Text(
              prov.macResolutionBlocked
                  ? l.showMacBlocked
                  : l.showMacSubtitle,
            ),
            value: settings.showMac,
            onChanged: prov.macResolutionBlocked ? null : prov.setShowMac,
          ),

          SwitchListTile(
            secondary: const Icon(Icons.dns_outlined),
            title: Text(l.resolveHostnames),
            subtitle: Text(l.resolveHostnamesSubtitle),
            value: settings.resolveNames,
            onChanged: prov.setResolveNames,
          ),

          SwitchListTile(
            secondary: const Icon(Icons.save_alt),
            title: Text(l.enableLogging),
            subtitle: Text(l.enableLoggingSubtitle),
            value: settings.loggingEnabled,
            onChanged: prov.setLoggingEnabled,
          ),

          const Divider(height: 24),
          _SectionHeader(l.about),
          const _AboutSection(),
        ],
      ),
    );
  }
}

// ── About section ────────────────────────────────────────────────────────────

class _AboutSection extends StatefulWidget {
  const _AboutSection();

  @override
  State<_AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<_AboutSection> {
  String _version = ''; // "1.1.0" — shown in the About row

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) {
        setState(() {
          _version = info.version;
        });
      }
    });
  }

  Future<void> _sendFeedback() async {
    final uri = feedbackMailtoUri(
      appVersion: _version,
      platform: Theme.of(context).platform.name,
    );
    await launchUrl(uri);
  }

  Future<void> _openCoffee() async {
    await launchUrl(Uri.parse(coffeeUrl), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(aboutTitle(_version)),
        ),
        ListTile(
          leading: const Icon(Icons.lightbulb_outline),
          title: Text(l.sendFeedback),
          trailing: const Icon(Icons.open_in_new, size: 18),
          onTap: _sendFeedback,
        ),
        ListTile(
          leading: const Text('☕', style: TextStyle(fontSize: 20)),
          title: Text(l.buyMeCoffee),
          trailing: const Icon(Icons.open_in_new, size: 18),
          onTap: _openCoffee,
        ),
      ],
    );
  }
}

// ── Language picker tile ──────────────────────────────────────────────────────

class _LanguageTile extends StatelessWidget {
  final AppLanguage current;
  final ValueChanged<AppLanguage> onSelected;

  const _LanguageTile({required this.current, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListTile(
      leading: _flag(current.countryCode),
      title: Text(l.language),
      subtitle: Text(current.endonym),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final picked = await showModalBottomSheet<AppLanguage>(
          context: context,
          showDragHandle: true,
          builder: (ctx) => SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final lang in AppLanguage.supported)
                  ListTile(
                    leading: _flag(lang.countryCode),
                    title: Text(lang.endonym),
                    trailing: lang.tag == current.tag
                        ? Icon(Icons.check,
                            color: Theme.of(ctx).colorScheme.primary)
                        : null,
                    onTap: () => Navigator.pop(ctx, lang),
                  ),
              ],
            ),
          ),
        );
        if (picked != null && picked.tag != current.tag) onSelected(picked);
      },
    );
  }

  Widget _flag(String countryCode) => CountryFlag.fromCountryCode(
        countryCode,
        theme: const ImageTheme(
          width: 32,
          height: 24,
          shape: RoundedRectangle(4),
        ),
      );
}

// ── Segmented setting tile ────────────────────────────────────────────────────

class _SegmentedTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _SegmentedTile({
    required this.icon,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: child),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
