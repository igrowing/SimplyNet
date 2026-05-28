import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/models/app_settings.dart';
import 'package:simply_net/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<SettingsProvider>();
    final s = prov.settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // ── Appearance ──────────────────────────────────────────────────
          _SectionHeader('Appearance'),

          // Theme
          _SegmentedTile(
            icon: Icons.brightness_4,
            label: 'Theme',
            child: SegmentedButton<AppTheme>(
              segments: const [
                ButtonSegment(value: AppTheme.light,
                    icon: Icon(Icons.light_mode), label: Text('Light')),
                ButtonSegment(value: AppTheme.dark,
                    icon: Icon(Icons.dark_mode), label: Text('Dark')),
                ButtonSegment(value: AppTheme.system,
                    icon: Icon(Icons.brightness_auto), label: Text('Auto')),
              ],
              selected: {s.theme},
              onSelectionChanged: (v) => prov.setTheme(v.first),
            ),
          ),

          // Screen on timeout
          _SegmentedTile(
            icon: Icons.screen_lock_portrait_outlined,
            label: 'Screen On Timeout',
            child: SegmentedButton<AppScreenTimeout>(
              segments: const [
                ButtonSegment(
                  value: AppScreenTimeout.system,
                  icon: Icon(Icons.phone_android),
                  label: Text('System'),
                ),
                ButtonSegment(
                  value: AppScreenTimeout.triple,
                  icon: Icon(Icons.timer_3_select),
                  label: Text('3× System'),
                ),
                ButtonSegment(
                  value: AppScreenTimeout.stayOn,
                  icon: Icon(Icons.lock_open_outlined),
                  label: Text('Stay On'),
                ),
              ],
              selected: {s.screenTimeout},
              onSelectionChanged: (v) => prov.setScreenTimeout(v.first),
            ),
          ),

          // Font size
          _SegmentedTile(
            icon: Icons.text_fields,
            label: 'Font Size',
            child: SegmentedButton<AppFontSize>(
              segments: [
                ButtonSegment(
                  value: AppFontSize.small,
                  label: const Text('Small'),
                ),
                ButtonSegment(
                  value: AppFontSize.medium,
                  label: const Text('Medium'),
                ),
                ButtonSegment(
                  value: AppFontSize.large,
                  label: const Text('Large'),
                ),
              ],
              selected: {s.fontSize},
              onSelectionChanged: (v) => prov.setFontSize(v.first),
            ),
          ),

          const Divider(height: 24),
          _SectionHeader('Scanning'),

          SwitchListTile(
            secondary: const Icon(Icons.router_outlined),
            title: const Text('Show MAC Address'),
            subtitle: const Text('Display MAC column in scan results'),
            value: s.showMac,
            onChanged: prov.setShowMac,
          ),

          SwitchListTile(
            secondary: const Icon(Icons.dns_outlined),
            title: const Text('Resolve Hostnames'),
            subtitle: const Text('Perform reverse-DNS + mDNS during scan'),
            value: s.resolveNames,
            onChanged: prov.setResolveNames,
          ),

          SwitchListTile(
            secondary: const Icon(Icons.save_alt),
            title: const Text('Enable Logging'),
            subtitle: const Text('Save scan and tool output to log files'),
            value: s.loggingEnabled,
            onChanged: prov.setLoggingEnabled,
          ),

          const Divider(height: 24),
          _SectionHeader('Account'),

          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Log In'),
            subtitle: const Text('Coming soon'),
            trailing: const Icon(Icons.chevron_right),
            enabled: false,
          ),
        ],
      ),
    );
  }
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
              Icon(icon, size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 10),
              Text(label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      )),
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
