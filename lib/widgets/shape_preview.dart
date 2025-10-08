import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ShapePreview extends StatelessWidget {
  final String shapeOutput;
  final String character;
  final int repetitions;
  final String shapeTypeName;

  const ShapePreview({
    super.key,
    required this.shapeOutput,
    required this.character,
    required this.repetitions,
    required this.shapeTypeName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shape Preview',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Character: "$character" • Type: $shapeTypeName • Repetitions: $repetitions',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      context,
                      icon: Icons.copy,
                      tooltip: 'Copy to Clipboard',
                      onPressed: () => _copyToClipboard(context),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      context,
                      icon: Icons.share,
                      tooltip: 'Share Shape',
                      onPressed: () => _shareShape(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Shape Display Area
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: shapeOutput.isEmpty
                  ? _buildEmptyState(context)
                  : _buildShapeDisplay(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: shapeOutput.isEmpty ? null : onPressed,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Your math shape will appear here!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a character, select a shape type, and click Generate to create your mathematical art.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShapeDisplay(BuildContext context) {
    // Check if the output contains sticker tokens
    final bool hasStickers = shapeOutput.contains(RegExp(r'\[sticker:[^\]]+\]'));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: hasStickers 
              ? _buildStickerPreview(context)
              : SelectableText(
                  shapeOutput,
                  style: const TextStyle(
                    fontFamily: 'Courier New',
                    fontSize: 12,
                    height: 1.0,
                    color: Color(0xFF333333),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStickerPreview(BuildContext context) {
    final List<Widget> children = [];
    final RegExp stickerRegex = RegExp(r'\[sticker:([^\]]+)\]');
    
    // Parse line-by-line to preserve structure
    final lines = shapeOutput.split('\n');
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final List<Widget> lineWidgets = [];
      
      int lastIndex = 0;
      for (final match in stickerRegex.allMatches(line)) {
        // Add text before the match
        if (match.start > lastIndex) {
          final text = line.substring(lastIndex, match.start);
          lineWidgets.add(Text(
            text,
            style: const TextStyle(
              fontFamily: 'Courier New',
              fontSize: 12,
              height: 1.0,
            ),
          ));
        }
        
        // Add sticker image
        final stickerId = match.group(1)!;
        Widget stickerWidget;
        if (stickerId.startsWith('http')) {
          stickerWidget = Image.network(
            stickerId,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 20),
          );
        } else {
          stickerWidget = Image.asset(
            stickerId,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 20),
          );
        }
        lineWidgets.add(stickerWidget);
        lastIndex = match.end;
      }
      
      // Add remaining text
      if (lastIndex < line.length) {
        final text = line.substring(lastIndex);
        lineWidgets.add(Text(
          text,
          style: const TextStyle(
            fontFamily: 'Courier New',
            fontSize: 12,
            height: 1.0,
          ),
        ));
      }
      
      // Add the line as a Row
      if (lineWidgets.isNotEmpty) {
        children.add(Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: lineWidgets,
        ));
      }
      
      // Add line break (except for last line)
      if (i < lines.length - 1) {
        children.add(const SizedBox(height: 12));
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  void _copyToClipboard(BuildContext context) {
    if (shapeOutput.isEmpty) return;

    Clipboard.setData(ClipboardData(text: shapeOutput));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Shape copied to clipboard!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareShape(BuildContext context) {
    if (shapeOutput.isEmpty) return;

    final String shareText = '''
Math Shape Creator 🎨

Shape: $shapeTypeName
Character: "$character"
Repetitions: $repetitions

$shapeOutput

Created with Math Shape Creator app! 📱✨
''';

    Share.share(
      shareText,
      subject: 'Check out my math shape creation!',
    );
  }
}