import 'package:flutter/material.dart';
import '../services/preset_service.dart';
import '../services/responsive_service.dart';

class PresetsScreen extends StatefulWidget {
  final Function(ShapePreset) onPresetSelected;

  const PresetsScreen({
    super.key,
    required this.onPresetSelected,
  });

  @override
  State<PresetsScreen> createState() => _PresetsScreenState();
}

class _PresetsScreenState extends State<PresetsScreen> {
  PresetCategory _selectedCategory = PresetCategory.all;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ShapePreset> _getFilteredPresets() {
    if (_searchQuery.isNotEmpty) {
      return PresetService.searchPresets(_searchQuery);
    }
    return PresetService.getPresetsByCategory(_selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final presets = _getFilteredPresets();
    final gridColumns = ResponsiveService.getGridColumns(context);
    final spacing = ResponsiveService.getResponsiveSpacing(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shape Templates'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: ResponsiveService.getResponsivePadding(context),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search templates...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveService.getBorderRadius(context),
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              
              // Category Chips
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: spacing),
                  itemCount: PresetCategory.values.length,
                  itemBuilder: (context, index) {
                    final category = PresetCategory.values[index];
                    final isSelected = _selectedCategory == category;
                    
                    return Padding(
                      padding: EdgeInsets.only(right: spacing / 2),
                      child: FilterChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(category.emoji),
                            const SizedBox(width: 4),
                            Text(category.displayName),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: presets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: ResponsiveService.getIconSize(context, 64),
                    color: Colors.grey,
                  ),
                  SizedBox(height: spacing),
                  Text(
                    'No templates found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: spacing / 2),
                  Text(
                    'Try a different search or category',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: ResponsiveService.getResponsivePadding(context),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridColumns,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: 0.85,
              ),
              itemCount: presets.length,
              itemBuilder: (context, index) {
                final preset = presets[index];
                return _buildPresetCard(preset);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final randomPreset = PresetService.getRandomPreset();
          widget.onPresetSelected(randomPreset);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.shuffle),
        label: const Text('Random'),
      ),
    );
  }

  Widget _buildPresetCard(ShapePreset preset) {
    final spacing = ResponsiveService.getResponsiveSpacing(context);
    final elevation = ResponsiveService.getCardElevation(context);
    final borderRadius = ResponsiveService.getBorderRadius(context);
    
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: () {
          widget.onPresetSelected(preset);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: EdgeInsets.all(spacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji Icon
              Text(
                preset.emoji,
                style: TextStyle(
                  fontSize: ResponsiveService.getResponsiveFontSize(context, 40),
                ),
              ),
              SizedBox(height: spacing),
              
              // Preset Name
              Text(
                preset.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing / 2),
              
              // Description
              Text(
                preset.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing),
              
              // Details
              Wrap(
                spacing: 4,
                children: [
                  Chip(
                    label: Text(
                      preset.character,
                      style: const TextStyle(fontSize: 12),
                    ),
                    padding: const EdgeInsets.all(2),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Chip(
                    label: Text(
                      preset.filled ? 'Filled' : 'Outline',
                      style: const TextStyle(fontSize: 10),
                    ),
                    padding: const EdgeInsets.all(2),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
