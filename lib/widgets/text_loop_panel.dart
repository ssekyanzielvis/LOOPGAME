import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/enhanced_shape_generator.dart';
import '../services/responsive_service.dart';

class TextLoopPanel extends StatefulWidget {
  final String text;
  final int loopCount;
  final LoopPattern pattern;
  final int wrapWidth;
  final String separator;
  final Function(String) onTextChanged;
  final Function(int) onLoopCountChanged;
  final Function(LoopPattern) onPatternChanged;
  final Function(int) onWrapWidthChanged;
  final Function(String) onSeparatorChanged;
  final VoidCallback onGenerate;

  const TextLoopPanel({
    super.key,
    required this.text,
    required this.loopCount,
    required this.pattern,
    required this.wrapWidth,
    required this.separator,
    required this.onTextChanged,
    required this.onLoopCountChanged,
    required this.onPatternChanged,
    required this.onWrapWidthChanged,
    required this.onSeparatorChanged,
    required this.onGenerate,
  });

  @override
  State<TextLoopPanel> createState() => _TextLoopPanelState();
}

class _TextLoopPanelState extends State<TextLoopPanel> {
  late TextEditingController _textController;
  late TextEditingController _loopCountController;
  late TextEditingController _separatorController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.text);
    _loopCountController = TextEditingController(text: widget.loopCount.toString());
    _separatorController = TextEditingController(text: widget.separator);
  }

  @override
  void dispose() {
    _textController.dispose();
    _loopCountController.dispose();
    _separatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveService.getResponsiveSpacing(context);
    final padding = ResponsiveService.getResponsivePadding(context);

    return Card(
      elevation: ResponsiveService.getCardElevation(context),
      child: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding: padding,
            child: Row(
              children: [
                const Icon(Icons.loop, size: 24),
                SizedBox(width: spacing),
                Text(
                  'Text Loop Generator',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: const Text('Max: 1M'),
                  backgroundColor: Colors.green.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Input
                  _buildSectionTitle('Text to Repeat', Icons.text_fields),
                  SizedBox(height: spacing / 2),
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter text or emoji...',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.emoji_emotions),
                        onPressed: () => _showEmojiPicker(),
                      ),
                    ),
                    maxLines: 3,
                    onChanged: widget.onTextChanged,
                  ),
                  SizedBox(height: spacing * 2),

                  // Loop Count
                  _buildSectionTitle('Loop Count', Icons.repeat),
                  SizedBox(height: spacing / 2),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _loopCountController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter count (1-1,000,000)',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            final count = int.tryParse(value) ?? 1;
                            widget.onLoopCountChanged(count.clamp(1, 1000000));
                          },
                        ),
                      ),
                      SizedBox(width: spacing),
                      Column(
                        children: [
                          IconButton.filled(
                            onPressed: () => _incrementCount(1000),
                            icon: const Icon(Icons.add),
                            tooltip: '+1,000',
                          ),
                          IconButton.outlined(
                            onPressed: () => _decrementCount(1000),
                            icon: const Icon(Icons.remove),
                            tooltip: '-1,000',
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),
                  
                  // Quick Count Buttons
                  Wrap(
                    spacing: spacing / 2,
                    runSpacing: spacing / 2,
                    children: [
                      _buildQuickCountButton('100', 100),
                      _buildQuickCountButton('1K', 1000),
                      _buildQuickCountButton('10K', 10000),
                      _buildQuickCountButton('100K', 100000),
                      _buildQuickCountButton('1M', 1000000),
                    ],
                  ),
                  SizedBox(height: spacing * 2),

                  // Pattern Selection
                  _buildSectionTitle('Loop Pattern', Icons.pattern),
                  SizedBox(height: spacing / 2),
                  ...LoopPattern.values.map((pattern) {
                    return RadioListTile<LoopPattern>(
                      title: Text(_getPatternName(pattern)),
                      subtitle: Text(_getPatternDescription(pattern)),
                      value: pattern,
                      groupValue: widget.pattern,
                      onChanged: (value) {
                        if (value != null) {
                          widget.onPatternChanged(value);
                        }
                      },
                    );
                  }),
                  SizedBox(height: spacing * 2),

                  // Separator
                  _buildSectionTitle('Separator (Optional)', Icons.space_bar),
                  SizedBox(height: spacing / 2),
                  TextField(
                    controller: _separatorController,
                    decoration: const InputDecoration(
                      hintText: 'Space, comma, newline, etc.',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: widget.onSeparatorChanged,
                  ),
                  SizedBox(height: spacing * 2),

                  // Wrap Width (for wrapped pattern)
                  if (widget.pattern == LoopPattern.wrapped ||
                      widget.pattern == LoopPattern.grid) ...[
                    _buildSectionTitle('Wrap Width', Icons.view_week),
                    SizedBox(height: spacing / 2),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: widget.wrapWidth.toDouble(),
                            min: 20,
                            max: 200,
                            divisions: 36,
                            label: widget.wrapWidth.toString(),
                            onChanged: (value) {
                              widget.onWrapWidthChanged(value.round());
                            },
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Text(
                            '${widget.wrapWidth}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing * 2),
                  ],

                  // Generate Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: widget.onGenerate,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Generate Loop'),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.all(spacing),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing),

                  // Info Card
                  Card(
                    color: Colors.blue.withValues(alpha: 0.1),
                    child: Padding(
                      padding: padding,
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: spacing),
                          Expanded(
                            child: Text(
                              'Large loop counts may take time to generate. '
                              'Your text will repeat ${_formatNumber(widget.loopCount)} times.',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickCountButton(String label, int count) {
    final isSelected = widget.loopCount == count;
    return FilledButton.tonal(
      onPressed: () {
        _loopCountController.text = count.toString();
        widget.onLoopCountChanged(count);
      },
      style: FilledButton.styleFrom(
        backgroundColor: isSelected 
            ? Theme.of(context).primaryColor 
            : null,
        foregroundColor: isSelected 
            ? Colors.white 
            : null,
      ),
      child: Text(label),
    );
  }

  void _incrementCount(int amount) {
    final newCount = (widget.loopCount + amount).clamp(1, 1000000);
    _loopCountController.text = newCount.toString();
    widget.onLoopCountChanged(newCount);
  }

  void _decrementCount(int amount) {
    final newCount = (widget.loopCount - amount).clamp(1, 1000000);
    _loopCountController.text = newCount.toString();
    widget.onLoopCountChanged(newCount);
  }

  void _showEmojiPicker() {
    // Show emoji picker dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Emojis'),
        content: SizedBox(
          width: 300,
          child: GridView.count(
            crossAxisCount: 6,
            shrinkWrap: true,
            children: ShapeGeneratorService.getPopularEmojis().map((emoji) {
              return InkWell(
                onTap: () {
                  _textController.text = emoji;
                  widget.onTextChanged(emoji);
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  String _getPatternName(LoopPattern pattern) {
    switch (pattern) {
      case LoopPattern.horizontal:
        return 'Horizontal';
      case LoopPattern.vertical:
        return 'Vertical (One per line)';
      case LoopPattern.wrapped:
        return 'Wrapped';
      case LoopPattern.grid:
        return 'Grid';
    }
  }

  String _getPatternDescription(LoopPattern pattern) {
    switch (pattern) {
      case LoopPattern.horizontal:
        return 'All text in a single line';
      case LoopPattern.vertical:
        return 'Each repetition on new line';
      case LoopPattern.wrapped:
        return 'Auto-wrap at specified width';
      case LoopPattern.grid:
        return 'Organized in grid layout';
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
}
