import 'package:flutter/material.dart';
import '../services/enhanced_shape_generator.dart';
import '../widgets/emoji_picker.dart';

class EnhancedControlPanel extends StatefulWidget {
  final String character;
  final int repetitions;
  final ShapeType shapeType;
  final double size;
  final bool filled;
  final ColorMode colorMode;
  final Function(String) onCharacterChanged;
  final Function(int) onRepetitionsChanged;
  final Function(ShapeType) onShapeTypeChanged;
  final Function(double) onSizeChanged;
  final Function(bool) onFilledChanged;
  final Function(ColorMode) onColorModeChanged;
  final VoidCallback onGenerate;
  final VoidCallback onAddToMultiple;

  const EnhancedControlPanel({
    super.key,
    required this.character,
    required this.repetitions,
    required this.shapeType,
    required this.size,
    required this.filled,
    required this.colorMode,
    required this.onCharacterChanged,
    required this.onRepetitionsChanged,
    required this.onShapeTypeChanged,
    required this.onSizeChanged,
    required this.onFilledChanged,
    required this.onColorModeChanged,
    required this.onGenerate,
    required this.onAddToMultiple,
  });

  @override
  State<EnhancedControlPanel> createState() => _EnhancedControlPanelState();
}

class _EnhancedControlPanelState extends State<EnhancedControlPanel>
    with TickerProviderStateMixin {
  late TextEditingController _characterController;
  late TabController _tabController;
  bool _showEmojiPicker = false;
  bool _showQuickCharacters = false;

  @override
  void initState() {
    super.initState();
    _characterController = TextEditingController(text: widget.character);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _characterController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Column(
        children: [
          // Header with tabs
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey[600],
              tabs: const [
                Tab(
                  icon: Icon(Icons.tune),
                  text: 'Basic',
                ),
                Tab(
                  icon: Icon(Icons.palette),
                  text: 'Style',
                ),
                Tab(
                  icon: Icon(Icons.layers),
                  text: 'Multiple',
                ),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicTab(),
                _buildStyleTab(),
                _buildMultipleTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Character Input Section
          _buildCharacterInputSection(),
          const SizedBox(height: 20),
          
          // Shape Type Selector
          _buildShapeTypeSelector(),
          const SizedBox(height: 20),
          
          // Repetitions Slider
          _buildRepetitionsSlider(),
          const SizedBox(height: 20),
          
          // Size Slider
          _buildSizeSlider(),
          const SizedBox(height: 24),
          
          // Generate Button
          _buildGenerateButton(),
        ],
      ),
    );
  }

  Widget _buildStyleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fill Mode Toggle
          _buildFillModeSection(),
          const SizedBox(height: 20),
          
          // Color Mode Selector
          _buildColorModeSection(),
          const SizedBox(height: 20),
          
          // Emoji Picker Toggle
          _buildEmojiSection(),
          const SizedBox(height: 20),
          
          // Quick Characters Toggle
          _buildQuickCharactersSection(),
        ],
      ),
    );
  }

  Widget _buildMultipleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Multiple Shapes',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create multiple shapes with different parameters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          
          // Current Shape Preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Shape Configuration:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Character: "${widget.character}"'),
                Text('Shape: ${ShapeGeneratorService.getShapeDisplayName(widget.shapeType)}'),
                Text('Repetitions: ${widget.repetitions}'),
                Text('Size: ${widget.size.toStringAsFixed(1)}x'),
                Text('Fill: ${widget.filled ? 'Solid' : 'Outline'}'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Add to Multiple Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onAddToMultiple,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add to Multiple Shapes'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'How Multiple Shapes Work',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('1. Configure your first shape'),
                const Text('2. Click "Add to Multiple Shapes"'),
                const Text('3. Change parameters for next shape'),
                const Text('4. Repeat to add more shapes'),
                const Text('5. Generate to see all shapes together'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Character',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  _showEmojiPicker = !_showEmojiPicker;
                  if (_showEmojiPicker) _showQuickCharacters = false;
                });
              },
              icon: Icon(
                Icons.emoji_emotions,
                color: _showEmojiPicker ? Theme.of(context).primaryColor : null,
              ),
              tooltip: 'Emoji Picker',
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _showQuickCharacters = !_showQuickCharacters;
                  if (_showQuickCharacters) _showEmojiPicker = false;
                });
              },
              icon: Icon(
                Icons.stars,
                color: _showQuickCharacters ? Theme.of(context).primaryColor : null,
              ),
              tooltip: 'Quick Characters',
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _characterController,
          maxLength: 5,
          decoration: const InputDecoration(
            hintText: 'Enter character (*, #, ❤️, etc.)',
            counterText: '',
            prefixIcon: Icon(Icons.edit),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              widget.onCharacterChanged(value);
            }
          },
        ),
        if (_showEmojiPicker) ...[
          const SizedBox(height: 12),
          EmojiPicker(
            onEmojiSelected: (emoji) {
              _characterController.text = emoji;
              widget.onCharacterChanged(emoji);
              setState(() {
                _showEmojiPicker = false;
              });
            },
            currentEmoji: widget.character,
          ),
        ],
        if (_showQuickCharacters) ...[
          const SizedBox(height: 12),
          QuickCharacterPicker(
            onCharacterSelected: (char) {
              _characterController.text = char;
              widget.onCharacterChanged(char);
              setState(() {
                _showQuickCharacters = false;
              });
            },
            currentCharacter: widget.character,
          ),
        ],
      ],
    );
  }

  Widget _buildShapeTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shape Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ShapeType>(
              value: widget.shapeType,
              isExpanded: true,
              items: ShapeType.values.map((ShapeType type) {
                return DropdownMenuItem<ShapeType>(
                  value: type,
                  child: Text(
                    ShapeGeneratorService.getShapeDisplayName(type),
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (ShapeType? newValue) {
                if (newValue != null) {
                  widget.onShapeTypeChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRepetitionsSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Repetitions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${widget.repetitions}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
          ),
          child: Slider(
            value: widget.repetitions.toDouble(),
            min: 10,
            max: 500,
            divisions: 49,
            onChanged: (double value) {
              widget.onRepetitionsChanged(value.round());
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('10', style: Theme.of(context).textTheme.bodySmall),
            Text('500', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Size',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${widget.size.toStringAsFixed(1)}x',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
          ),
          child: Slider(
            value: widget.size,
            min: 1.0,
            max: 10.0,
            divisions: 90,
            onChanged: (double value) {
              widget.onSizeChanged(value);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1.0x', style: Theme.of(context).textTheme.bodySmall),
            Text('10.0x', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildFillModeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fill Mode',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => widget.onFilledChanged(true),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.filled
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: Border.all(
                      color: widget.filled
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!,
                      width: widget.filled ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.crop_square,
                        color: widget.filled
                            ? Theme.of(context).primaryColor
                            : Colors.grey[600],
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Solid',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: widget.filled
                              ? Theme.of(context).primaryColor
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => widget.onFilledChanged(false),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: !widget.filled
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: Border.all(
                      color: !widget.filled
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!,
                      width: !widget.filled ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.crop_free,
                        color: !widget.filled
                            ? Theme.of(context).primaryColor
                            : Colors.grey[600],
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Outline',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: !widget.filled
                              ? Theme.of(context).primaryColor
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorModeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Mode',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: ColorMode.values.map((mode) {
            final isSelected = widget.colorMode == mode;
            String title;
            IconData icon;
            
            switch (mode) {
              case ColorMode.single:
                title = 'Single';
                icon = Icons.palette;
                break;
              case ColorMode.rainbow:
                title = 'Rainbow';
                icon = Icons.gradient;
                break;
              case ColorMode.gradient:
                title = 'Gradient';
                icon = Icons.auto_awesome;
                break;
            }
            
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => widget.onColorModeChanged(mode),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          icon,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey[600],
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmojiSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_emotions, color: Colors.orange),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emoji Support',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Use emojis as characters for colorful shapes',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _showEmojiPicker = !_showEmojiPicker;
                _showQuickCharacters = false;
              });
            },
            child: const Text('Browse'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCharactersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.stars, color: Colors.purple),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Characters',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Popular symbols and special characters',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _showQuickCharacters = !_showQuickCharacters;
                _showEmojiPicker = false;
              });
            },
            child: const Text('Browse'),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.onGenerate,
        icon: const Icon(Icons.auto_awesome, size: 24),
        label: const Text(
          'Generate Shape',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}