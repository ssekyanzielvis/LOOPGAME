import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../widgets/interactive_shape_canvas.dart';
import '../services/shape_visualization_service.dart';

/// Screen for advanced mathematical shape visualization
/// Provides MATLAB-like interactive visualization capabilities
class VisualizationScreen extends StatefulWidget {
  const VisualizationScreen({super.key});

  @override
  State<VisualizationScreen> createState() => _VisualizationScreenState();
}

class _VisualizationScreenState extends State<VisualizationScreen> {
  ShapeVisualizationType _selectedShape = ShapeVisualizationType.heart;
  Color _shapeColor = Colors.blue;
  double _shapeSize = 100;
  bool _showGrid = true;
  bool _showAxes = true;
  bool _showStatistics = true;

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick Shape Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _shapeColor,
            onColorChanged: (color) {
              setState(() {
                _shapeColor = color;
              });
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _getShapeName(ShapeVisualizationType type) {
    switch (type) {
      case ShapeVisualizationType.circle:
        return '⭕ Circle';
      case ShapeVisualizationType.heart:
        return '❤️ Heart';
      case ShapeVisualizationType.star:
        return '⭐ Star';
      case ShapeVisualizationType.spiral:
        return '🌀 Spiral';
      case ShapeVisualizationType.lissajous:
        return '〰️ Lissajous';
      case ShapeVisualizationType.rose:
        return '🌹 Rose';
      case ShapeVisualizationType.butterfly:
        return '🦋 Butterfly';
      case ShapeVisualizationType.infinity:
        return '∞ Infinity';
    }
  }

  String _getShapeDescription(ShapeVisualizationType type) {
    switch (type) {
      case ShapeVisualizationType.circle:
        return 'Parametric: x = r·cos(t), y = r·sin(t)';
      case ShapeVisualizationType.heart:
        return 'Parametric: x = 16sin³(t), y = 13cos(t) - 5cos(2t) - 2cos(3t) - cos(4t)';
      case ShapeVisualizationType.star:
        return 'Regular 5-pointed star with alternating radii';
      case ShapeVisualizationType.spiral:
        return 'Archimedean spiral: r = a + b·θ';
      case ShapeVisualizationType.lissajous:
        return 'Lissajous curve: x = A·sin(at + δ), y = B·sin(bt)';
      case ShapeVisualizationType.rose:
        return 'Rose curve: r = a·cos(k·θ)';
      case ShapeVisualizationType.butterfly:
        return 'Butterfly curve (Fay): r = e^cos(t) - 2cos(4t) + sin^5(t/12)';
      case ShapeVisualizationType.infinity:
        return 'Lemniscate: (x² + y²)² = 2a²(x² - y²)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.analytics, size: 24),
            SizedBox(width: 8),
            Text('Mathematical Visualization'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Visualization'),
                  content: const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '🎓 Mathematical Shape Visualization',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'This feature provides MATLAB-like capabilities for visualizing '
                          'mathematical shapes using parametric equations and advanced algorithms.',
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Features:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('• Interactive zoom, pan, and rotation'),
                        Text('• Real-time shape rendering'),
                        Text('• Mathematical statistics'),
                        Text('• Coordinate grid and axes'),
                        Text('• 8 different mathematical curves'),
                        SizedBox(height: 12),
                        Text(
                          'Gestures:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('• Pinch to zoom in/out'),
                        Text('• Drag with one finger to pan'),
                        Text('• Rotate with two fingers'),
                        Text('• Tap buttons for precise control'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Got it!'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.help_outline),
            tooltip: 'About',
          ),
        ],
      ),
      body: Column(
        children: [
          // Control Panel
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shape selector
                Row(
                  children: [
                    const Icon(Icons.category, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Shape Type',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Shape dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<ShapeVisualizationType>(
                    value: _selectedShape,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: ShapeVisualizationType.values.map((shape) {
                      return DropdownMenuItem(
                        value: shape,
                        child: Text(_getShapeName(shape)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedShape = value;
                        });
                      }
                    },
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Shape description
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getShapeDescription(_selectedShape),
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Size slider
                Row(
                  children: [
                    const Icon(Icons.photo_size_select_small, size: 20),
                    const SizedBox(width: 8),
                    const Text('Size:'),
                    Expanded(
                      child: Slider(
                        value: _shapeSize,
                        min: 50,
                        max: 200,
                        divisions: 15,
                        label: _shapeSize.toStringAsFixed(0),
                        onChanged: (value) {
                          setState(() {
                            _shapeSize = value;
                          });
                        },
                      ),
                    ),
                    Text(_shapeSize.toStringAsFixed(0)),
                  ],
                ),
                
                // Options
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Grid', style: TextStyle(fontSize: 12)),
                        value: _showGrid,
                        onChanged: (value) {
                          setState(() {
                            _showGrid = value ?? true;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Axes', style: TextStyle(fontSize: 12)),
                        value: _showAxes,
                        onChanged: (value) {
                          setState(() {
                            _showAxes = value ?? true;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Stats', style: TextStyle(fontSize: 12)),
                        value: _showStatistics,
                        onChanged: (value) {
                          setState(() {
                            _showStatistics = value ?? true;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                
                // Color picker button
                ElevatedButton.icon(
                  onPressed: _showColorPicker,
                  icon: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _shapeColor,
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  label: const Text('Change Color'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                ),
              ],
            ),
          ),
          
          // Visualization Canvas
          Expanded(
            child: InteractiveShapeCanvas(
              key: ValueKey('${_selectedShape}_${_shapeSize}_${_shapeColor}_${_showGrid}_${_showAxes}_${_showStatistics}'),
              shapeType: _selectedShape,
              shapeColor: _shapeColor,
              initialSize: _shapeSize,
              showGrid: _showGrid,
              showAxes: _showAxes,
              showStatistics: _showStatistics,
            ),
          ),
        ],
      ),
    );
  }
}
