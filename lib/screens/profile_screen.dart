import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hustle_gpt/providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 32),
            _SettingsSection(
              title: 'Appearance',
              children: [
                _SettingsTile(
                  title: 'Theme',
                  subtitle: _getThemeModeName(themeProvider.themeMode),
                  onTap: () => _showThemeDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SettingsSection(
              title: 'About',
              children: [
                _SettingsTile(
                  title: 'Version',
                  subtitle: '1.0.0',
                ),
                _SettingsTile(
                  title: 'Terms of Service',
                  onTap: () {},
                ),
                _SettingsTile(
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  Future<void> _showThemeDialog(BuildContext context) async {
    final themeProvider = context.read<ThemeProvider>();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              title: 'System',
              selected: themeProvider.themeMode == ThemeMode.system,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              title: 'Light',
              selected: themeProvider.themeMode == ThemeMode.light,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              title: 'Dark',
              selected: themeProvider.themeMode == ThemeMode.dark,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.05),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.7),
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              if (selected)
                Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
