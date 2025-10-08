import 'package:flutter/material.dart';
import '../services/enhanced_shape_generator.dart';

class ControlPanel extends StatefulWidget {
  final String character;
  final int repetitions;
  final ShapeType shapeType;
  final double size;
  final Function(String) onCharacterChanged;
  final Function(int) onRepetitionsChanged;
  final Function(ShapeType) onShapeTypeChanged;
  final Function(double) onSizeChanged;
  final VoidCallback onGenerate;

  const ControlPanel({
    super.key,
    required this.character,
    required this.repetitions,
    required this.shapeType,
    required this.size,
    required this.onCharacterChanged,
    required this.onRepetitionsChanged,
    required this.onShapeTypeChanged,
    required this.onSizeChanged,
    required this.onGenerate,
  });

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  late TextEditingController _characterController;

  @override
  void initState() {
    super.initState();
    _characterController = TextEditingController(text: widget.character);
  }

  @override
  void dispose() {
    _characterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shape Controls',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            
            // Character Input
            _buildCharacterInput(),
            const SizedBox(height: 16),
            
            // Shape Type Selector
            _buildShapeTypeSelector(),
            const SizedBox(height: 16),
            
            // Repetitions Slider
            _buildRepetitionsSlider(),
            const SizedBox(height: 16),
            
            // Size Slider
            _buildSizeSlider(),
            const SizedBox(height: 24),
            
            // Generate Button
            _buildGenerateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Character',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _characterController,
          maxLength: 5,
          decoration: const InputDecoration(
            hintText: 'Enter character (*, #, ❤️, etc.)',
            counterText: '',
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              widget.onCharacterChanged(value);
            }
          },
        ),
        const SizedBox(height: 4),
        Text(
          'Use any character, number, letter, or emoji',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildShapeTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shape Type',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
        Slider(
          value: widget.repetitions.toDouble(),
          min: 10,
          max: 500,
          divisions: 49,
          onChanged: (double value) {
            widget.onRepetitionsChanged(value.round());
          },
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
        Slider(
          value: widget.size,
          min: 1.0,
          max: 10.0,
          divisions: 90,
          onChanged: (double value) {
            widget.onSizeChanged(value);
          },
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

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.onGenerate,
        icon: const Icon(Icons.refresh, size: 20),
        label: const Text(
          'Generate Shape',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}