import 'package:flutter/material.dart';

typedef OnStickerSelected = void Function(String stickerId);

/// A small, safe sticker picker that returns a string identifier for a sticker.
/// For now stickerId can be an asset path or a network URL. Keep it simple.
class StickerPicker extends StatelessWidget {
  final OnStickerSelected onStickerSelected;
  final String? currentSticker;

  const StickerPicker({super.key, required this.onStickerSelected, this.currentSticker});

  static List<String> defaultStickers() {
    return [
      'assets/stickers/unicorn.png',
      'assets/stickers/star.png',
      'assets/stickers/heart.png',
      'https://example.com/stickers/cool.png',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final stickers = defaultStickers();

    return Container(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: stickers.length,
        itemBuilder: (context, index) {
          final id = stickers[index];
          final isSelected = id == currentSticker;

          Widget thumb;
          if (id.startsWith('http')) {
            thumb = Image.network(id, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.broken_image));
          } else {
            thumb = Image.asset(id, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.broken_image));
          }

          return InkWell(
            onTap: () => onStickerSelected(id),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.08) : null,
              ),
              child: Center(child: thumb),
            ),
          );
        },
      ),
    );
  }
}
