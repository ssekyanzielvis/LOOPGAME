import '../services/enhanced_shape_generator.dart';

/// Preset template for quick shape generation
class ShapePreset {
  final String name;
  final String description;
  final String character;
  final int repetitions;
  final ShapeType shapeType;
  final double size;
  final bool filled;
  final ColorMode colorMode;
  final String emoji;

  const ShapePreset({
    required this.name,
    required this.description,
    required this.character,
    required this.repetitions,
    required this.shapeType,
    required this.size,
    required this.filled,
    required this.colorMode,
    required this.emoji,
  });
}

/// Service for managing shape presets
class PresetService {
  /// Get all available presets
  static List<ShapePreset> getAllPresets() {
    return [
      // Basic Shapes
      const ShapePreset(
        name: 'Classic Heart',
        description: 'A beautiful heart made with love',
        character: '❤️',
        repetitions: 40,
        shapeType: ShapeType.heart,
        size: 5.0,
        filled: true,
        colorMode: ColorMode.single,
        emoji: '💖',
      ),
      const ShapePreset(
        name: 'Shining Star',
        description: 'A bright star to light up your day',
        character: '⭐',
        repetitions: 35,
        shapeType: ShapeType.star,
        size: 5.5,
        filled: true,
        colorMode: ColorMode.rainbow,
        emoji: '✨',
      ),
      const ShapePreset(
        name: 'Perfect Circle',
        description: 'A smooth, perfect circle',
        character: '●',
        repetitions: 45,
        shapeType: ShapeType.circle,
        size: 5.0,
        filled: true,
        colorMode: ColorMode.single,
        emoji: '⭕',
      ),
      const ShapePreset(
        name: 'Simple Square',
        description: 'A clean, geometric square',
        character: '■',
        repetitions: 40,
        shapeType: ShapeType.square,
        size: 5.0,
        filled: false,
        colorMode: ColorMode.single,
        emoji: '⬜',
      ),
      const ShapePreset(
        name: 'Triangle Power',
        description: 'A strong triangular shape',
        character: '▲',
        repetitions: 38,
        shapeType: ShapeType.triangle,
        size: 5.2,
        filled: true,
        colorMode: ColorMode.gradient,
        emoji: '🔺',
      ),
      const ShapePreset(
        name: 'Diamond Sparkle',
        description: 'A sparkling diamond shape',
        character: '💎',
        repetitions: 35,
        shapeType: ShapeType.diamond,
        size: 5.0,
        filled: true,
        colorMode: ColorMode.rainbow,
        emoji: '💠',
      ),
      const ShapePreset(
        name: 'Mystic Spiral',
        description: 'A mesmerizing spiral pattern',
        character: '◉',
        repetitions: 50,
        shapeType: ShapeType.spiral,
        size: 4.5,
        filled: true,
        colorMode: ColorMode.gradient,
        emoji: '🌀',
      ),
      
      // Geometric Patterns
      const ShapePreset(
        name: 'Hexagon Grid',
        description: 'Perfect hexagonal pattern',
        character: '⬡',
        repetitions: 42,
        shapeType: ShapeType.hexagon,
        size: 5.0,
        filled: false,
        colorMode: ColorMode.single,
        emoji: '⬢',
      ),
      const ShapePreset(
        name: 'Pentagon Shield',
        description: 'A protective pentagon shape',
        character: '⬟',
        repetitions: 40,
        shapeType: ShapeType.pentagon,
        size: 5.2,
        filled: true,
        colorMode: ColorMode.single,
        emoji: '🛡️',
      ),
      const ShapePreset(
        name: 'Flower Bloom',
        description: 'A beautiful blooming flower',
        character: '✿',
        repetitions: 45,
        shapeType: ShapeType.flower,
        size: 5.0,
        filled: true,
        colorMode: ColorMode.rainbow,
        emoji: '🌸',
      ),
      
      // Letters
      const ShapePreset(
        name: 'Letter A',
        description: 'The first letter of alphabet',
        character: '*',
        repetitions: 35,
        shapeType: ShapeType.letterA,
        size: 5.0,
        filled: true,
        colorMode: ColorMode.single,
        emoji: '🅰️',
      ),
      const ShapePreset(
        name: 'Love Letter',
        description: 'Express love with letter L',
        character: '❤️',
        repetitions: 38,
        shapeType: ShapeType.letterL,
        size: 5.0,
        filled: true,
        colorMode: ColorMode.rainbow,
        emoji: '💌',
      ),
      
      // Numbers
      const ShapePreset(
        name: 'Number Zero',
        description: 'The perfect number 0',
        character: '0',
        repetitions: 40,
        shapeType: ShapeType.digit0,
        size: 5.0,
        filled: false,
        colorMode: ColorMode.single,
        emoji: '0️⃣',
      ),
      const ShapePreset(
        name: 'Number One',
        description: 'Stand tall like number 1',
        character: '1',
        repetitions: 38,
        shapeType: ShapeType.digit1,
        size: 5.0,
        filled: true,
        colorMode: ColorMode.single,
        emoji: '1️⃣',
      ),
      const ShapePreset(
        name: 'Lucky Seven',
        description: 'The lucky number 7',
        character: '7',
        repetitions: 40,
        shapeType: ShapeType.digit7,
        size: 5.0,
        filled: true,
        colorMode: ColorMode.rainbow,
        emoji: '7️⃣',
      ),
      const ShapePreset(
        name: 'Infinity Eight',
        description: 'Number 8 representing infinity',
        character: '∞',
        repetitions: 42,
        shapeType: ShapeType.digit8,
        size: 5.0,
        filled: true,
        colorMode: ColorMode.gradient,
        emoji: '8️⃣',
      ),
      
      // Special Designs
      const ShapePreset(
        name: 'Plus Sign',
        description: 'Positive vibes with plus',
        character: '+',
        repetitions: 40,
        shapeType: ShapeType.plus,
        size: 5.0,
        filled: true,
        colorMode: ColorMode.single,
        emoji: '➕',
      ),
      const ShapePreset(
        name: 'Arrow Up',
        description: 'Point the way forward',
        character: '↑',
        repetitions: 38,
        shapeType: ShapeType.arrow,
        size: 5.0,
        filled: true,
        colorMode: ColorMode.gradient,
        emoji: '⬆️',
      ),
      const ShapePreset(
        name: 'Emoji Heart',
        description: 'Express emotions with emoji heart',
        character: '😍',
        repetitions: 40,
        shapeType: ShapeType.heart,
        size: 5.0,
        filled: true,
        colorMode: ColorMode.rainbow,
        emoji: '💝',
      ),
      const ShapePreset(
        name: 'Fire Star',
        description: 'A blazing star of fire',
        character: '🔥',
        repetitions: 40,
        shapeType: ShapeType.star,
        size: 5.5,
        filled: true,
        colorMode: ColorMode.rainbow,
        emoji: '🔥',
      ),
    ];
  }

  /// Get presets by category
  static List<ShapePreset> getPresetsByCategory(PresetCategory category) {
    final allPresets = getAllPresets();
    
    switch (category) {
      case PresetCategory.basic:
        return allPresets.where((p) => 
          p.shapeType == ShapeType.circle ||
          p.shapeType == ShapeType.square ||
          p.shapeType == ShapeType.triangle ||
          p.shapeType == ShapeType.heart ||
          p.shapeType == ShapeType.star ||
          p.shapeType == ShapeType.diamond
        ).toList();
        
      case PresetCategory.geometric:
        return allPresets.where((p) => 
          p.shapeType == ShapeType.pentagon ||
          p.shapeType == ShapeType.hexagon ||
          p.shapeType == ShapeType.octagon ||
          p.shapeType == ShapeType.flower ||
          p.shapeType == ShapeType.spiral
        ).toList();
        
      case PresetCategory.letters:
        return allPresets.where((p) => 
          p.shapeType.toString().contains('letter')
        ).toList();
        
      case PresetCategory.numbers:
        return allPresets.where((p) => 
          p.shapeType.toString().contains('digit')
        ).toList();
        
      case PresetCategory.special:
        return allPresets.where((p) => 
          p.shapeType == ShapeType.plus ||
          p.shapeType == ShapeType.cross ||
          p.shapeType == ShapeType.arrow ||
          p.character.contains(RegExp(r'[\u{1F600}-\u{1F64F}]', unicode: true))
        ).toList();
        
      case PresetCategory.all:
        return allPresets;
    }
  }

  /// Get random preset
  static ShapePreset getRandomPreset() {
    final presets = getAllPresets();
    return presets[(DateTime.now().millisecondsSinceEpoch % presets.length)];
  }

  /// Search presets by name or description
  static List<ShapePreset> searchPresets(String query) {
    final allPresets = getAllPresets();
    final lowerQuery = query.toLowerCase();
    
    return allPresets.where((preset) =>
      preset.name.toLowerCase().contains(lowerQuery) ||
      preset.description.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}

/// Categories for organizing presets
enum PresetCategory {
  all,
  basic,
  geometric,
  letters,
  numbers,
  special,
}

/// Extension to get display name for preset categories
extension PresetCategoryExtension on PresetCategory {
  String get displayName {
    switch (this) {
      case PresetCategory.all:
        return 'All Templates';
      case PresetCategory.basic:
        return 'Basic Shapes';
      case PresetCategory.geometric:
        return 'Geometric';
      case PresetCategory.letters:
        return 'Letters';
      case PresetCategory.numbers:
        return 'Numbers';
      case PresetCategory.special:
        return 'Special';
    }
  }

  String get emoji {
    switch (this) {
      case PresetCategory.all:
        return '📚';
      case PresetCategory.basic:
        return '⭕';
      case PresetCategory.geometric:
        return '⬢';
      case PresetCategory.letters:
        return '🅰️';
      case PresetCategory.numbers:
        return '🔢';
      case PresetCategory.special:
        return '✨';
    }
  }
}
