import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.settings, size: 24),
                SizedBox(width: 8),
                Text('Settings & Customization'),
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
                
                // Theme Mode Card
                _buildThemeModeCard(themeService),
                const SizedBox(height: 16),
                
                // Theme Color Card
                _buildThemeColorCard(themeService),
                const SizedBox(height: 16),
                
                // Font Customization Card
                _buildFontCustomizationCard(themeService),
                const SizedBox(height: 16),
                
                // Text Color Card
                _buildTextColorCard(themeService),
                const SizedBox(height: 16),
                
                // Preview Card
                _buildPreviewCard(themeService),
                const SizedBox(height: 16),
                
                // App Info Card
                _buildAppInfoCard(themeService),
              ],
            ),
          ),
        );
      },
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

  Widget _buildThemeModeCard(ThemeService themeService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  size: 24,
                  color: themeService.getPrimaryColor(),
                ),
                const SizedBox(width: 8),
                Text(
                  'Theme Mode',
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
                    groupValue: themeService.themeMode,
                    onChanged: (val) => themeService.setThemeMode(val!),
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                  _buildThemeOption(
                    title: '🌙 Dark Mode',
                    subtitle: 'Easy on the eyes in low light',
                    value: ThemeMode.dark,
                    groupValue: themeService.themeMode,
                    onChanged: (val) => themeService.setThemeMode(val!),
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                  _buildThemeOption(
                    title: '🔄 System Default',
                    subtitle: 'Matches your device settings',
                    value: ThemeMode.system,
                    groupValue: themeService.themeMode,
                    onChanged: (val) => themeService.setThemeMode(val!),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeColorCard(ThemeService themeService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette, size: 24, color: themeService.getPrimaryColor()),
                const SizedBox(width: 8),
                Text(
                  'Theme Color',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Choose your favorite color theme',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppThemeColor.values.map((color) {
                final isSelected = themeService.themeColor == color;
                return _buildColorOption(
                  color: color,
                  isSelected: isSelected,
                  onTap: () => themeService.setThemeColor(color),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption({
    required AppThemeColor color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Color displayColor;
    String colorName;
    
    switch (color) {
      case AppThemeColor.blue:
        displayColor = const Color(0xFF2196F3);
        colorName = 'Blue';
        break;
      case AppThemeColor.green:
        displayColor = const Color(0xFF4CAF50);
        colorName = 'Green';
        break;
      case AppThemeColor.purple:
        displayColor = const Color(0xFF9C27B0);
        colorName = 'Purple';
        break;
      case AppThemeColor.orange:
        displayColor = const Color(0xFFFF9800);
        colorName = 'Orange';
        break;
      case AppThemeColor.red:
        displayColor = const Color(0xFFF44336);
        colorName = 'Red';
        break;
      case AppThemeColor.teal:
        displayColor = const Color(0xFF009688);
        colorName = 'Teal';
        break;
      case AppThemeColor.pink:
        displayColor = const Color(0xFFE91E63);
        colorName = 'Pink';
        break;
      case AppThemeColor.indigo:
        displayColor = const Color(0xFF3F51B5);
        colorName = 'Indigo';
        break;
    }
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: displayColor.withOpacity(0.1),
          border: Border.all(
            color: isSelected ? displayColor : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: displayColor,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: displayColor.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 24)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              colorName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? displayColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontCustomizationCard(ThemeService themeService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.format_size, size: 24, color: themeService.getPrimaryColor()),
                const SizedBox(width: 8),
                Text(
                  'Font Size',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Adjust text size: ${(themeService.fontSize * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                const Text('Small', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: themeService.fontSize,
                    min: 0.8,
                    max: 1.4,
                    divisions: 12,
                    label: '${(themeService.fontSize * 100).toInt()}%',
                    onChanged: (value) => themeService.setFontSize(value),
                  ),
                ),
                const Text('Large', style: TextStyle(fontSize: 16)),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Quick size buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickSizeButton('80%', 0.8, themeService),
                _buildQuickSizeButton('100%', 1.0, themeService),
                _buildQuickSizeButton('120%', 1.2, themeService),
                _buildQuickSizeButton('140%', 1.4, themeService),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSizeButton(String label, double size, ThemeService themeService) {
    final isSelected = (themeService.fontSize - size).abs() < 0.01;
    return FilledButton.tonal(
      onPressed: () => themeService.setFontSize(size),
      style: FilledButton.styleFrom(
        backgroundColor: isSelected ? themeService.getPrimaryColor() : null,
        foregroundColor: isSelected ? Colors.white : null,
      ),
      child: Text(label),
    );
  }

  Widget _buildTextColorCard(ThemeService themeService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.color_lens, size: 24, color: themeService.getPrimaryColor()),
                const SizedBox(width: 8),
                Text(
                  'Custom Text Color',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Override default text colors',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('Enable Custom Text Color'),
              subtitle: const Text('Use a custom color for all text'),
              value: themeService.useCustomTextColor,
              onChanged: (value) => themeService.setUseCustomTextColor(value),
              activeColor: themeService.getPrimaryColor(),
            ),
            
            if (themeService.useCustomTextColor) ...[
              const SizedBox(height: 16),
              const Text('Choose your text color:'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildTextColorSwatch(Colors.black, themeService),
                  _buildTextColorSwatch(Colors.grey[800]!, themeService),
                  _buildTextColorSwatch(Colors.blueGrey, themeService),
                  _buildTextColorSwatch(Colors.blue, themeService),
                  _buildTextColorSwatch(Colors.green, themeService),
                  _buildTextColorSwatch(Colors.purple, themeService),
                  _buildTextColorSwatch(Colors.orange, themeService),
                  _buildTextColorSwatch(Colors.red, themeService),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextColorSwatch(Color color, ThemeService themeService) {
    final isSelected = themeService.customTextColor.value == color.value;
    return InkWell(
      onTap: () => themeService.setCustomTextColor(color),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? themeService.getPrimaryColor() : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildPreviewCard(ThemeService themeService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.preview, size: 24, color: themeService.getPrimaryColor()),
                const SizedBox(width: 8),
                Text(
                  'Preview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeService.getPrimaryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: themeService.getPrimaryColor().withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Headline Text',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is body text at your current font size.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Small text for descriptions and labels.',
                    style: Theme.of(context).textTheme.bodySmall,
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
    required ValueChanged<ThemeMode?> onChanged,
  }) {
    return RadioListTile<ThemeMode>(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildAppInfoCard(ThemeService themeService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 24, color: themeService.getPrimaryColor()),
                const SizedBox(width: 8),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            ListTile(
              leading: const Icon(Icons.app_settings_alt),
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
            ),
            
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Build Number'),
              subtitle: const Text('1'),
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.developer_mode),
              title: const Text('Developer'),
              subtitle: const Text('Math Shape Creator Team'),
            ),
            
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text('Made with Love'),
              subtitle: const Text('Thank you for using our app!'),
            ),
          ],
        ),
      ),
    );
  }
}