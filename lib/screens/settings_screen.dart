import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ThemeService _themeService = ThemeService();
  late DateTime _currentTime;
  late String _formattedDate;
  late String _formattedTime;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    // Update time every second
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _updateDateTime();
        });
        return true;
      }
      return false;
    });
  }

  void _updateDateTime() {
    _currentTime = DateTime.now();
    _formattedDate = DateFormat('EEEE, MMMM d, y').format(_currentTime);
    _formattedTime = DateFormat('HH:mm:ss').format(_currentTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings, size: 24),
            SizedBox(width: 8),
            Text('Settings'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and Time Card
            _buildDateTimeCard(),
            const SizedBox(height: 16),
            
            // Theme Settings Card
            _buildThemeCard(),
            const SizedBox(height: 16),
            
            // Shape Settings Card
            _buildShapeSettingsCard(),
            const SizedBox(height: 16),
            
            // App Info Card
            _buildAppInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Current Date & Time',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _formattedDate,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formattedTime,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Theme Mode Selector
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildThemeOption(
                    title: '☀️ Light Mode',
                    subtitle: 'Bright and clean interface',
                    value: ThemeMode.light,
                    groupValue: _themeService.themeMode,
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                  _buildThemeOption(
                    title: '🌙 Dark Mode',
                    subtitle: 'Easy on the eyes in low light',
                    value: ThemeMode.dark,
                    groupValue: _themeService.themeMode,
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                  _buildThemeOption(
                    title: '🔄 System Default',
                    subtitle: 'Matches your device settings',
                    value: ThemeMode.system,
                    groupValue: _themeService.themeMode,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required ThemeMode value,
    required ThemeMode groupValue,
  }) {
    return RadioListTile<ThemeMode>(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      value: value,
      groupValue: groupValue,
      onChanged: (ThemeMode? newValue) {
        if (newValue != null) {
          _themeService.setThemeMode(newValue);
          setState(() {});
        }
      },
      activeColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildShapeSettingsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.category, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Shape Settings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildSettingItem(
              icon: Icons.format_shapes,
              title: 'Available Shapes',
              subtitle: '47 shapes including A-Z letters',
              trailing: const Text('47'),
            ),
            
            _buildSettingItem(
              icon: Icons.emoji_emotions,
              title: 'Popular Emojis',
              subtitle: 'Quick access to trending emojis',
              trailing: const Text('40+'),
            ),
            
            _buildSettingItem(
              icon: Icons.palette,
              title: 'Fill Modes',
              subtitle: 'Solid and outline shape options',
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Handle fill mode toggle
                },
                activeColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info, size: 24),
                const SizedBox(width: 8),
                Text(
                  'App Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildSettingItem(
              icon: Icons.apps,
              title: 'Math Shape Creator',
              subtitle: 'Version 1.0.0',
            ),
            
            _buildSettingItem(
              icon: Icons.code,
              title: 'Built with Flutter',
              subtitle: 'Cross-platform development framework',
            ),
            
            _buildSettingItem(
              icon: Icons.calculate,
              title: 'Mathematical Algorithms',
              subtitle: 'Powered by precise geometric calculations',
            ),
            
            const SizedBox(height: 16),
            
            // Feature Highlights
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✨ Features',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('• 47 different shape types'),
                  const Text('• Solid and outline rendering'),
                  const Text('• A-Z alphabetic shapes'),
                  const Text('• Emoji and symbol support'),
                  const Text('• Real-time preview'),
                  const Text('• Copy and share functionality'),
                  const Text('• Light and dark themes'),
                  const Text('• Responsive design'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}