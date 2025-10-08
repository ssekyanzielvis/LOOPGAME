import 'package:flutter/material.dart';
import '../services/enhanced_shape_generator.dart';
import '../services/shape_history_service.dart';
import '../services/shape_export_service.dart';
import '../services/responsive_service.dart';
import '../services/preset_service.dart';
import '../widgets/enhanced_control_panel.dart';
import '../widgets/text_loop_panel.dart';
import '../widgets/shape_preview.dart';
import 'settings_screen.dart';
import 'presets_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mode selection
  LoopMode _mode = LoopMode.shape;
  
  // Shape mode state variables
  String _character = '*';
  String? _selectedSticker; // sticker identifier for sticker loop mode
  int _repetitions = 50;
  ShapeType _shapeType = ShapeType.circle;
  double _size = 5.0;
  bool _filled = true;
  ColorMode _colorMode = ColorMode.single;
  String _shapeOutput = '';
  bool _isGenerating = false;
  final List<String> _multipleShapes = [];
  
  // Text loop mode state variables
  String _loopText = 'Hello World';
  int _loopCount = 100;
  LoopPattern _loopPattern = LoopPattern.horizontal;
  int _wrapWidth = 80;
  String _separator = ' ';
  
  // History service
  final ShapeHistoryService _historyService = ShapeHistoryService();

  @override
  void initState() {
    super.initState();
    // Generate initial shape with responsive defaults
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeResponsiveDefaults();
      _generateShape();
    });
  }

  void _initializeResponsiveDefaults() {
    // Set responsive default values based on screen size
    _repetitions = ResponsiveService.getOptimalRepetitions(context);
    _size = ResponsiveService.getOptimalSizeMultiplier(context);
  }

  void _generateShape() async {
    if (_isGenerating) return;
    
    setState(() {
      _isGenerating = true;
    });

    try {
      // Add slight delay to show loading state for complex shapes
      await Future.delayed(const Duration(milliseconds: 100));
      
      String output;
      if (_selectedSticker != null && _selectedSticker!.isNotEmpty) {
        // Sticker loop mode
        output = ShapeGeneratorService.generateStickerLoop(
          stickerId: _selectedSticker!,
          loopCount: _mode == LoopMode.textLoop ? _loopCount : _repetitions,
          pattern: _mode == LoopMode.textLoop ? _loopPattern : LoopPattern.horizontal,
          wrapWidth: _wrapWidth,
          separator: _separator,
        );
      } else if (_mode == LoopMode.textLoop) {
        output = ShapeGeneratorService.generateTextLoop(
          text: _loopText,
          loopCount: _loopCount,
          pattern: _loopPattern,
          wrapWidth: _wrapWidth,
          separator: _separator,
        );
      } else {
        output = ShapeGeneratorService.generateShape(
          character: _character,
          repetitions: _repetitions,
          shapeType: _shapeType,
          size: _size,
          filled: _filled,
        );
      }
      
      if (mounted) {
        setState(() {
          _shapeOutput = output;
          _isGenerating = false;
        });
        
        // Add to history
        _historyService.addState(ShapeState(
          character: _mode == LoopMode.textLoop ? _loopText : _character,
          repetitions: _mode == LoopMode.textLoop ? _loopCount : _repetitions,
          shapeType: _shapeType,
          size: _size,
          filled: _filled,
          colorMode: _colorMode,
          output: output,
        ));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _shapeOutput = 'Error generating: ${e.toString()}';
          _isGenerating = false;
        });
      }
    }
  }

  void _undo() {
    final previousState = _historyService.undo();
    if (previousState != null) {
      setState(() {
        _character = previousState.character;
        _repetitions = previousState.repetitions;
        _shapeType = previousState.shapeType;
        _size = previousState.size;
        _filled = previousState.filled;
        _colorMode = previousState.colorMode;
        _shapeOutput = previousState.output;
      });
    }
  }

  void _redo() {
    final nextState = _historyService.redo();
    if (nextState != null) {
      setState(() {
        _character = nextState.character;
        _repetitions = nextState.repetitions;
        _shapeType = nextState.shapeType;
        _size = nextState.size;
        _filled = nextState.filled;
        _colorMode = nextState.colorMode;
        _shapeOutput = nextState.output;
      });
    }
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: ResponsiveService.getResponsivePadding(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy to Clipboard'),
              onTap: () {
                Navigator.pop(context);
                ShapeExportService.copyToClipboard(_shapeOutput, context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                ShapeExportService.shareText(
                  _shapeOutput,
                  'My Shape Creation - ${ShapeGeneratorService.getShapeDisplayName(_shapeType)}',
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text('Save to File'),
              onTap: () {
                Navigator.pop(context);
                final filename = ShapeGeneratorService.getShapeDisplayName(_shapeType)
                    .replaceAll(RegExp(r'[^\w\s]'), '')
                    .replaceAll(' ', '_');
                ShapeExportService.saveToFile(_shapeOutput, filename, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _applyPreset(ShapePreset preset) {
    setState(() {
      _character = preset.character;
      _repetitions = preset.repetitions;
      _shapeType = preset.shapeType;
      _size = preset.size;
      _filled = preset.filled;
      _colorMode = preset.colorMode;
    });
    _generateShape();
    
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(preset.emoji),
            const SizedBox(width: 8),
            Text('Applied: ${preset.name}'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onCharacterChanged(String newCharacter) {
    setState(() {
      _character = newCharacter;
    });
    _generateShapeWithDebounce();
  }

  void _onRepetitionsChanged(int newRepetitions) {
    setState(() {
      _repetitions = newRepetitions;
    });
    _generateShapeWithDebounce();
  }

  void _onShapeTypeChanged(ShapeType newShapeType) {
    setState(() {
      _shapeType = newShapeType;
    });
    _generateShapeWithDebounce();
  }

  void _onSizeChanged(double newSize) {
    setState(() {
      _size = newSize;
    });
    _generateShapeWithDebounce();
  }

  void _onFilledChanged(bool filled) {
    setState(() {
      _filled = filled;
    });
    _generateShapeWithDebounce();
  }

  void _onColorModeChanged(ColorMode colorMode) {
    setState(() {
      _colorMode = colorMode;
    });
    _generateShapeWithDebounce();
  }

  void _onStickerChanged(String? stickerId) {
    setState(() {
      _selectedSticker = stickerId;
    });
    _generateShapeWithDebounce();
  }

  void _onAddToMultiple() {
    if (_shapeOutput.isNotEmpty) {
      setState(() {
        _multipleShapes.add(_shapeOutput);
      });
    }
  }

  // Text Loop handlers
  void _onLoopTextChanged(String text) {
    setState(() {
      _loopText = text;
    });
    _generateShapeWithDebounce();
  }

  void _onLoopCountChanged(int count) {
    setState(() {
      _loopCount = count.clamp(1, 1000000);
    });
    _generateShapeWithDebounce();
  }

  void _onLoopPatternChanged(LoopPattern pattern) {
    setState(() {
      _loopPattern = pattern;
    });
    _generateShapeWithDebounce();
  }

  void _onWrapWidthChanged(int width) {
    setState(() {
      _wrapWidth = width;
    });
    _generateShapeWithDebounce();
  }

  void _onSeparatorChanged(String separator) {
    setState(() {
      _separator = separator;
    });
    _generateShapeWithDebounce();
  }

  // Debounced shape generation to avoid excessive updates during slider changes
  void _generateShapeWithDebounce() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _generateShape();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calculate, size: ResponsiveService.getIconSize(context, 24)),
            SizedBox(width: ResponsiveService.getResponsiveSpacing(context) / 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Math Shape Creator'),
                Text(
                  _mode == LoopMode.shape ? 'Shape Mode' : 'Text Loop Mode',
                  style: TextStyle(fontSize: 10, color: Colors.grey[300]),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Mode Switcher
          SegmentedButton<LoopMode>(
            segments: const [
              ButtonSegment<LoopMode>(
                value: LoopMode.shape,
                label: Text('Shapes'),
                icon: Icon(Icons.star, size: 16),
              ),
              ButtonSegment<LoopMode>(
                value: LoopMode.textLoop,
                label: Text('Text Loop'),
                icon: Icon(Icons.loop, size: 16),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (Set<LoopMode> newSelection) {
              setState(() {
                _mode = newSelection.first;
              });
              _generateShape();
            },
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12)),
            ),
          ),
          const SizedBox(width: 8),
          // Presets/Templates button (only for shape mode)
          if (_mode == LoopMode.shape)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PresetsScreen(
                      onPresetSelected: _applyPreset,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.auto_awesome),
              tooltip: 'Templates',
            ),
          // Undo button
          IconButton(
            onPressed: _historyService.canUndo ? _undo : null,
            icon: const Icon(Icons.undo),
            tooltip: 'Undo',
          ),
          // Redo button
          IconButton(
            onPressed: _historyService.canRedo ? _redo : null,
            icon: const Icon(Icons.redo),
            tooltip: 'Redo',
          ),
          // Export/Share button
          IconButton(
            onPressed: _shapeOutput.isNotEmpty ? _showExportOptions : null,
            icon: const Icon(Icons.ios_share),
            tooltip: 'Export & Share',
          ),
          // Settings button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
          IconButton(
            onPressed: () {
              _showInfoDialog(context);
            },
            icon: const Icon(Icons.info_outline),
            tooltip: 'About App',
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive layout
            if (constraints.maxWidth > 768) {
              // Tablet/Desktop layout - side by side
              return _buildWideLayout();
            } else {
              // Mobile layout - stacked
              return _buildMobileLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Shape Preview (60% of screen)
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isGenerating 
              ? _buildLoadingPreview()
              : ShapePreview(
                  shapeOutput: _shapeOutput,
                  character: _mode == LoopMode.textLoop ? _loopText : _character,
                  repetitions: _mode == LoopMode.textLoop ? _loopCount : _repetitions,
                  shapeTypeName: _mode == LoopMode.textLoop 
                      ? '🔁 Text Loop (${_loopPattern.name})' 
                      : ShapeGeneratorService.getShapeDisplayName(_shapeType),
                ),
          ),
        ),
        
        // Control Panel (40% of screen)
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _mode == LoopMode.textLoop
                ? TextLoopPanel(
                    text: _loopText,
                    loopCount: _loopCount,
                    pattern: _loopPattern,
                    wrapWidth: _wrapWidth,
                    separator: _separator,
                    onTextChanged: _onLoopTextChanged,
                    onLoopCountChanged: _onLoopCountChanged,
                    onPatternChanged: _onLoopPatternChanged,
                    onWrapWidthChanged: _onWrapWidthChanged,
                    onSeparatorChanged: _onSeparatorChanged,
                    onGenerate: _generateShape,
                  )
                : EnhancedControlPanel(
                    character: _character,
                    sticker: _selectedSticker,
                    repetitions: _repetitions,
                    shapeType: _shapeType,
                    size: _size,
                    filled: _filled,
                    colorMode: _colorMode,
                    onCharacterChanged: _onCharacterChanged,
                    onStickerChanged: _onStickerChanged,
                    onRepetitionsChanged: _onRepetitionsChanged,
                    onShapeTypeChanged: _onShapeTypeChanged,
                    onSizeChanged: _onSizeChanged,
                    onFilledChanged: _onFilledChanged,
                    onColorModeChanged: _onColorModeChanged,
                    onGenerate: _generateShape,
                    onAddToMultiple: _onAddToMultiple,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        // Control Panel (30% of screen)
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _mode == LoopMode.textLoop
                ? TextLoopPanel(
                    text: _loopText,
                    loopCount: _loopCount,
                    pattern: _loopPattern,
                    wrapWidth: _wrapWidth,
                    separator: _separator,
                    onTextChanged: _onLoopTextChanged,
                    onLoopCountChanged: _onLoopCountChanged,
                    onPatternChanged: _onLoopPatternChanged,
                    onWrapWidthChanged: _onWrapWidthChanged,
                    onSeparatorChanged: _onSeparatorChanged,
                    onGenerate: _generateShape,
                  )
                : EnhancedControlPanel(
                    character: _character,
                    sticker: _selectedSticker,
                    repetitions: _repetitions,
                    shapeType: _shapeType,
                    size: _size,
                    filled: _filled,
                    colorMode: _colorMode,
              onCharacterChanged: _onCharacterChanged,
              onStickerChanged: _onStickerChanged,
              onRepetitionsChanged: _onRepetitionsChanged,
              onShapeTypeChanged: _onShapeTypeChanged,
              onSizeChanged: _onSizeChanged,
              onFilledChanged: _onFilledChanged,
              onColorModeChanged: _onColorModeChanged,
              onGenerate: _generateShape,
              onAddToMultiple: _onAddToMultiple,
            ),
          ),
        ),
        
        // Shape Preview (70% of screen)
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isGenerating 
              ? _buildLoadingPreview()
              : ShapePreview(
                  shapeOutput: _shapeOutput,
                  character: _character,
                  repetitions: _repetitions,
                  shapeTypeName: ShapeGeneratorService.getShapeDisplayName(_shapeType),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingPreview() {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Generating ${ShapeGeneratorService.getShapeDisplayName(_shapeType)}...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.calculate, color: Colors.blue),
              SizedBox(width: 8),
              Text('Math Shape Creator'),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create beautiful mathematical shapes using characters, numbers, letters, and emojis!',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                Text(
                  'Features:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('• 7 different shape types'),
                Text('• Custom characters and emojis'),
                Text('• Adjustable size and repetitions'),
                Text('• Copy and share functionality'),
                Text('• Real-time preview'),
                SizedBox(height: 12),
                Text(
                  'Mathematical algorithms power the shape generation, creating precise geometric patterns.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}