import '../services/enhanced_shape_generator.dart';

/// Represents a single shape creation state
class ShapeState {
  final String character;
  final int repetitions;
  final ShapeType shapeType;
  final double size;
  final bool filled;
  final ColorMode colorMode;
  final String output;
  final DateTime timestamp;

  ShapeState({
    required this.character,
    required this.repetitions,
    required this.shapeType,
    required this.size,
    required this.filled,
    required this.colorMode,
    required this.output,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  ShapeState copyWith({
    String? character,
    int? repetitions,
    ShapeType? shapeType,
    double? size,
    bool? filled,
    ColorMode? colorMode,
    String? output,
  }) {
    return ShapeState(
      character: character ?? this.character,
      repetitions: repetitions ?? this.repetitions,
      shapeType: shapeType ?? this.shapeType,
      size: size ?? this.size,
      filled: filled ?? this.filled,
      colorMode: colorMode ?? this.colorMode,
      output: output ?? this.output,
      timestamp: DateTime.now(),
    );
  }
}

/// Service for managing shape creation history with undo/redo functionality
class ShapeHistoryService {
  final List<ShapeState> _history = [];
  int _currentIndex = -1;
  static const int maxHistorySize = 50;

  /// Add a new state to history
  void addState(ShapeState state) {
    // Remove any states after current index (when user makes changes after undo)
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }

    // Add new state
    _history.add(state);
    _currentIndex = _history.length - 1;

    // Limit history size
    if (_history.length > maxHistorySize) {
      _history.removeAt(0);
      _currentIndex--;
    }
  }

  /// Undo to previous state
  ShapeState? undo() {
    if (canUndo) {
      _currentIndex--;
      return _history[_currentIndex];
    }
    return null;
  }

  /// Redo to next state
  ShapeState? redo() {
    if (canRedo) {
      _currentIndex++;
      return _history[_currentIndex];
    }
    return null;
  }

  /// Check if undo is available
  bool get canUndo => _currentIndex > 0;

  /// Check if redo is available
  bool get canRedo => _currentIndex < _history.length - 1;

  /// Get current state
  ShapeState? get currentState {
    if (_currentIndex >= 0 && _currentIndex < _history.length) {
      return _history[_currentIndex];
    }
    return null;
  }

  /// Get all history
  List<ShapeState> get history => List.unmodifiable(_history);

  /// Get history size
  int get historySize => _history.length;

  /// Clear all history
  void clear() {
    _history.clear();
    _currentIndex = -1;
  }

  /// Get a specific state by index
  ShapeState? getStateAt(int index) {
    if (index >= 0 && index < _history.length) {
      return _history[index];
    }
    return null;
  }

  /// Jump to a specific state in history
  ShapeState? jumpToState(int index) {
    if (index >= 0 && index < _history.length) {
      _currentIndex = index;
      return _history[_currentIndex];
    }
    return null;
  }
}
