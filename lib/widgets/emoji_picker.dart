import 'package:flutter/material.dart';
import '../services/enhanced_shape_generator.dart';

class EmojiPicker extends StatelessWidget {
  final Function(String) onEmojiSelected;
  final String currentEmoji;

  const EmojiPicker({
    super.key,
    required this.onEmojiSelected,
    required this.currentEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎨 Popular Emojis',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: ShapeGeneratorService.getPopularEmojis().length,
                itemBuilder: (context, index) {
                  final emoji = ShapeGeneratorService.getPopularEmojis()[index];
                  final isSelected = emoji == currentEmoji;
                  
                  return GestureDetector(
                    onTap: () => onEmojiSelected(emoji),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected 
                          ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                          : null,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickCharacterPicker extends StatelessWidget {
  final Function(String) onCharacterSelected;
  final String currentCharacter;

  const QuickCharacterPicker({
    super.key,
    required this.onCharacterSelected,
    required this.currentCharacter,
  });

  static const List<String> quickCharacters = [
    '*', '#', '@', '&', '%', '+', '=', '~',
    '•', '○', '●', '■', '□', '▲', '△', '◆',
    '♠', '♣', '♥', '♦', '☆', '★', '◈', '◇',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⚡ Quick Characters',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: quickCharacters.map((char) {
                final isSelected = char == currentCharacter;
                return GestureDetector(
                  onTap: () => onCharacterSelected(char),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected 
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        char,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected 
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}