import 'dart:math' as math;

enum ShapeType {
  // Basic Shapes
  circle,
  square,
  triangle,
  heart,
  spiral,
  star,
  diamond,
  // Additional Geometric Shapes
  pentagon,
  hexagon,
  octagon,
  oval,
  plus,
  cross,
  arrow,
  flower,
  // Numeric Shapes (0-9)
  digit0,
  digit1,
  digit2,
  digit3,
  digit4,
  digit5,
  digit6,
  digit7,
  digit8,
  digit9,
  // Alphabetic Shapes
  letterA,
  letterB,
  letterC,
  letterD,
  letterE,
  letterF,
  letterG,
  letterH,
  letterI,
  letterJ,
  letterK,
  letterL,
  letterM,
  letterN,
  letterO,
  letterP,
  letterQ,
  letterR,
  letterS,
  letterT,
  letterU,
  letterV,
  letterW,
  letterX,
  letterY,
  letterZ,
  // Text Looping
  textLoop,
}

enum LoopMode {
  shape,      // Traditional shape generation
  textLoop,   // Text/character repetition mode
}

enum LoopPattern {
  horizontal,  // Text repeats horizontally
  vertical,    // Text repeats vertically (one per line)
  wrapped,     // Text wraps at specified width
  grid,        // Text in grid pattern
}

enum ColorMode {
  single,
  rainbow,
  gradient,
}

class ShapeGeneratorService {
  static String generateShape({
    required String character,
    required int repetitions,
    required ShapeType shapeType,
    required double size,
    bool filled = true,
    ColorMode colorMode = ColorMode.single,
  }) {
    if (character.isEmpty) character = '*';
    
    switch (shapeType) {
      // Basic Shapes
      case ShapeType.circle:
        return _generateCircle(character, repetitions, size, filled);
      case ShapeType.square:
        return _generateSquare(character, repetitions, size, filled);
      case ShapeType.triangle:
        return _generateTriangle(character, repetitions, size, filled);
      case ShapeType.heart:
        return _generateHeart(character, repetitions, size, filled);
      case ShapeType.spiral:
        return _generateSpiral(character, repetitions, size);
      case ShapeType.star:
        return _generateStar(character, repetitions, size, filled);
      case ShapeType.diamond:
        return _generateDiamond(character, repetitions, size, filled);
      // Additional Geometric Shapes
      case ShapeType.pentagon:
        return _generatePolygon(character, repetitions, size, 5, filled);
      case ShapeType.hexagon:
        return _generatePolygon(character, repetitions, size, 6, filled);
      case ShapeType.octagon:
        return _generatePolygon(character, repetitions, size, 8, filled);
      case ShapeType.oval:
        return _generateOval(character, repetitions, size, filled);
      case ShapeType.plus:
        return _generatePlus(character, repetitions, size, filled);
      case ShapeType.cross:
        return _generateCross(character, repetitions, size, filled);
      case ShapeType.arrow:
        return _generateArrow(character, repetitions, size, filled);
      case ShapeType.flower:
        return _generateFlower(character, repetitions, size, filled);
      // Numeric Shapes (0-9)
      case ShapeType.digit0:
        return _generateDigit0(character, repetitions, size, filled);
      case ShapeType.digit1:
        return _generateDigit1(character, repetitions, size, filled);
      case ShapeType.digit2:
        return _generateDigit2(character, repetitions, size, filled);
      case ShapeType.digit3:
        return _generateDigit3(character, repetitions, size, filled);
      case ShapeType.digit4:
        return _generateDigit4(character, repetitions, size, filled);
      case ShapeType.digit5:
        return _generateDigit5(character, repetitions, size, filled);
      case ShapeType.digit6:
        return _generateDigit6(character, repetitions, size, filled);
      case ShapeType.digit7:
        return _generateDigit7(character, repetitions, size, filled);
      case ShapeType.digit8:
        return _generateDigit8(character, repetitions, size, filled);
      case ShapeType.digit9:
        return _generateDigit9(character, repetitions, size, filled);
      // Alphabetic Shapes
      case ShapeType.letterA:
        return _generateLetterA(character, repetitions, size, filled);
      case ShapeType.letterB:
        return _generateLetterB(character, repetitions, size, filled);
      case ShapeType.letterC:
        return _generateLetterC(character, repetitions, size, filled);
      case ShapeType.letterD:
        return _generateLetterD(character, repetitions, size, filled);
      case ShapeType.letterE:
        return _generateLetterE(character, repetitions, size, filled);
      case ShapeType.letterF:
        return _generateLetterF(character, repetitions, size, filled);
      case ShapeType.letterG:
        return _generateLetterG(character, repetitions, size, filled);
      case ShapeType.letterH:
        return _generateLetterH(character, repetitions, size, filled);
      case ShapeType.letterI:
        return _generateLetterI(character, repetitions, size, filled);
      case ShapeType.letterJ:
        return _generateLetterJ(character, repetitions, size, filled);
      case ShapeType.letterK:
        return _generateLetterK(character, repetitions, size, filled);
      case ShapeType.letterL:
        return _generateLetterL(character, repetitions, size, filled);
      case ShapeType.letterM:
        return _generateLetterM(character, repetitions, size, filled);
      case ShapeType.letterN:
        return _generateLetterN(character, repetitions, size, filled);
      case ShapeType.letterO:
        return _generateLetterO(character, repetitions, size, filled);
      case ShapeType.letterP:
        return _generateLetterP(character, repetitions, size, filled);
      case ShapeType.letterQ:
        return _generateLetterQ(character, repetitions, size, filled);
      case ShapeType.letterR:
        return _generateLetterR(character, repetitions, size, filled);
      case ShapeType.letterS:
        return _generateLetterS(character, repetitions, size, filled);
      case ShapeType.letterT:
        return _generateLetterT(character, repetitions, size, filled);
      case ShapeType.letterU:
        return _generateLetterU(character, repetitions, size, filled);
      case ShapeType.letterV:
        return _generateLetterV(character, repetitions, size, filled);
      case ShapeType.letterW:
        return _generateLetterW(character, repetitions, size, filled);
      case ShapeType.letterX:
        return _generateLetterX(character, repetitions, size, filled);
      case ShapeType.letterY:
        return _generateLetterY(character, repetitions, size, filled);
      case ShapeType.letterZ:
        return _generateLetterZ(character, repetitions, size, filled);
      // Text Loop
      case ShapeType.textLoop:
        return ''; // Will be handled by generateTextLoop method
    }
  }

  /// Generate text loop with specified pattern
  /// Supports up to 1 million repetitions
  static String generateTextLoop({
    required String text,
    required int loopCount,
    LoopPattern pattern = LoopPattern.horizontal,
    int wrapWidth = 80,
    String separator = '',
  }) {
    if (text.isEmpty) return '';
    if (loopCount <= 0) return '';
    if (loopCount > 1000000) {
      return 'Error: Loop count exceeds maximum (1,000,000)';
    }

    final StringBuffer buffer = StringBuffer();

    switch (pattern) {
      case LoopPattern.horizontal:
        // Repeat text horizontally with separator
        for (int i = 0; i < loopCount; i++) {
          buffer.write(text);
          if (i < loopCount - 1 && separator.isNotEmpty) {
            buffer.write(separator);
          }
        }
        break;

      case LoopPattern.vertical:
        // Repeat text vertically (one per line)
        for (int i = 0; i < loopCount; i++) {
          buffer.writeln(text);
        }
        break;

      case LoopPattern.wrapped:
        // Repeat text with word wrapping
        final int textLength = text.length + separator.length;
        int currentLineLength = 0;
        
        for (int i = 0; i < loopCount; i++) {
          if (currentLineLength + textLength > wrapWidth && currentLineLength > 0) {
            buffer.writeln();
            currentLineLength = 0;
          }
          
          buffer.write(text);
          currentLineLength += text.length;
          
          if (i < loopCount - 1 && separator.isNotEmpty) {
            buffer.write(separator);
            currentLineLength += separator.length;
          }
        }
        break;

      case LoopPattern.grid:
        // Repeat text in grid pattern
        final int itemsPerRow = (wrapWidth / (text.length + separator.length)).floor();
        if (itemsPerRow <= 0) {
          // Fallback to vertical if text too long
          for (int i = 0; i < loopCount; i++) {
            buffer.writeln(text);
          }
        } else {
          for (int i = 0; i < loopCount; i++) {
            buffer.write(text);
            
            if ((i + 1) % itemsPerRow == 0) {
              buffer.writeln();
            } else if (separator.isNotEmpty && i < loopCount - 1) {
              buffer.write(separator);
            }
          }
        }
        break;
    }

    return buffer.toString();
  }

  /// Generate text loop with progress callback for large counts
  static Stream<String> generateTextLoopStream({
    required String text,
    required int loopCount,
    LoopPattern pattern = LoopPattern.horizontal,
    int wrapWidth = 80,
    String separator = '',
    int chunkSize = 10000,
  }) async* {
    if (text.isEmpty || loopCount <= 0) {
      yield '';
      return;
    }

    final StringBuffer buffer = StringBuffer();
    int processed = 0;

    switch (pattern) {
      case LoopPattern.horizontal:
      case LoopPattern.wrapped:
        while (processed < loopCount) {
          final int remaining = loopCount - processed;
          final int toProcess = remaining < chunkSize ? remaining : chunkSize;
          
          for (int i = 0; i < toProcess; i++) {
            buffer.write(text);
            if (separator.isNotEmpty && (processed + i) < loopCount - 1) {
              buffer.write(separator);
            }
          }
          
          processed += toProcess;
          yield buffer.toString();
        }
        break;

      case LoopPattern.vertical:
      case LoopPattern.grid:
        while (processed < loopCount) {
          final int remaining = loopCount - processed;
          final int toProcess = remaining < chunkSize ? remaining : chunkSize;
          
          for (int i = 0; i < toProcess; i++) {
            buffer.writeln(text);
          }
          
          processed += toProcess;
          yield buffer.toString();
        }
        break;
    }
  }

  // Basic Shape Generators
  static String _generateCircle(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int radius = (repetitions * size / 10).round();
    final int diameter = radius * 2 + 1;
    final double centerX = radius.toDouble();
    final double centerY = radius.toDouble();

    for (int y = 0; y < diameter; y++) {
      for (int x = 0; x < diameter; x++) {
        final double distance = math.sqrt(
          math.pow(x - centerX, 2) + math.pow(y - centerY, 2)
        );
        
        if (filled) {
          if (distance <= radius) {
            buffer.write(char);
          } else {
            buffer.write(' ');
          }
        } else {
          if ((distance - radius).abs() <= size * 0.5) {
            buffer.write(char);
          } else {
            buffer.write(' ');
          }
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateSquare(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int sideLength = (repetitions * size / 10).round();
    
    for (int i = 0; i < sideLength; i++) {
      for (int j = 0; j < sideLength; j++) {
        if (filled) {
          buffer.write(char);
        } else {
          if (i == 0 || i == sideLength - 1 || j == 0 || j == sideLength - 1) {
            buffer.write(char);
          } else {
            buffer.write(' ');
          }
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateTriangle(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 10).round();
    
    for (int i = 0; i < height; i++) {
      final int spaces = height - i - 1;
      final int chars = (i * 2) + 1;
      
      buffer.write(' ' * spaces);
      
      for (int j = 0; j < chars; j++) {
        if (filled) {
          buffer.write(char);
        } else {
          if (j == 0 || j == chars - 1 || i == height - 1) {
            buffer.write(char);
          } else {
            buffer.write(' ');
          }
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateHeart(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int scale = (repetitions * size / 50).round().clamp(1, 20);
    
    for (int y = -scale; y <= scale; y++) {
      for (int x = -scale * 2; x <= scale * 2; x++) {
        final double xNorm = x / scale.toDouble();
        final double yNorm = y / scale.toDouble();
        
        final double heartEq = math.pow(xNorm * xNorm + yNorm * yNorm - 1, 3) - 
                              xNorm * xNorm * yNorm * yNorm * yNorm;
        
        if (heartEq <= 0) {
          buffer.write(char);
        } else {
          buffer.write(' ');
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateSpiral(String char, int repetitions, double size) {
    final StringBuffer buffer = StringBuffer();
    final int gridSize = (repetitions * size / 5).round();
    final List<List<String>> grid = List.generate(
      gridSize, 
      (index) => List.filled(gridSize, ' ')
    );
    
    final double centerX = gridSize / 2;
    final double centerY = gridSize / 2;
    
    for (int i = 0; i < repetitions; i++) {
      final double angle = i * 0.2;
      final double radius = i * size * 0.1;
      
      final int x = (centerX + radius * math.cos(angle)).round();
      final int y = (centerY + radius * math.sin(angle)).round();
      
      if (x >= 0 && x < gridSize && y >= 0 && y < gridSize) {
        grid[y][x] = char;
      }
    }
    
    for (final row in grid) {
      buffer.writeln(row.join(''));
    }
    return buffer.toString();
  }

  static String _generateStar(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int radius = (repetitions * size / 15).round();
    final int gridSize = radius * 2 + 1;
    final List<List<String>> grid = List.generate(
      gridSize, 
      (index) => List.filled(gridSize, ' ')
    );
    
    final double centerX = radius.toDouble();
    final double centerY = radius.toDouble();
    const int points = 5;
    
    final List<math.Point<double>> starPoints = [];
    for (int i = 0; i < points * 2; i++) {
      final double angle = i * math.pi / points;
      final double r = (i % 2 == 0) ? radius.toDouble() : radius * 0.4;
      final double x = centerX + r * math.cos(angle - math.pi / 2);
      final double y = centerY + r * math.sin(angle - math.pi / 2);
      starPoints.add(math.Point(x, y));
    }
    
    if (filled) {
      _fillPolygon(grid, starPoints, char);
    } else {
      for (int i = 0; i < starPoints.length; i++) {
        final math.Point<double> start = starPoints[i];
        final math.Point<double> end = starPoints[(i + 1) % starPoints.length];
        _drawLine(grid, start, end, char);
      }
    }
    
    for (final row in grid) {
      buffer.writeln(row.join(''));
    }
    return buffer.toString();
  }

  static String _generateDiamond(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 10).round();
    final int width = height;
    
    for (int i = 0; i < height; i++) {
      final int middle = width ~/ 2;
      final int distance = (i <= middle) ? i : height - 1 - i;
      final int spaces = middle - distance;
      final int chars = (distance * 2) + 1;
      
      buffer.write(' ' * spaces);
      
      for (int j = 0; j < chars; j++) {
        if (filled) {
          buffer.write(char);
        } else {
          if (j == 0 || j == chars - 1) {
            buffer.write(char);
          } else {
            buffer.write(' ');
          }
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  // Additional Geometric Shapes
  static String _generatePolygon(String char, int repetitions, double size, int sides, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int radius = (repetitions * size / 15).round();
    final int gridSize = radius * 2 + 1;
    final List<List<String>> grid = List.generate(
      gridSize, 
      (index) => List.filled(gridSize, ' ')
    );
    
    final double centerX = radius.toDouble();
    final double centerY = radius.toDouble();
    
    final List<math.Point<double>> polygonPoints = [];
    for (int i = 0; i < sides; i++) {
      final double angle = i * 2 * math.pi / sides - math.pi / 2;
      final double x = centerX + radius * math.cos(angle);
      final double y = centerY + radius * math.sin(angle);
      polygonPoints.add(math.Point(x, y));
    }
    
    if (filled) {
      _fillPolygon(grid, polygonPoints, char);
    } else {
      for (int i = 0; i < polygonPoints.length; i++) {
        final math.Point<double> start = polygonPoints[i];
        final math.Point<double> end = polygonPoints[(i + 1) % polygonPoints.length];
        _drawLine(grid, start, end, char);
      }
    }
    
    for (final row in grid) {
      buffer.writeln(row.join(''));
    }
    return buffer.toString();
  }

  static String _generateOval(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int radiusX = (repetitions * size / 8).round();
    final int radiusY = (repetitions * size / 12).round();
    final int width = radiusX * 2 + 1;
    final int height = radiusY * 2 + 1;
    final double centerX = radiusX.toDouble();
    final double centerY = radiusY.toDouble();

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final double normalizedX = (x - centerX) / radiusX;
        final double normalizedY = (y - centerY) / radiusY;
        final double ellipseEq = normalizedX * normalizedX + normalizedY * normalizedY;
        
        if (filled) {
          if (ellipseEq <= 1) {
            buffer.write(char);
          } else {
            buffer.write(' ');
          }
        } else {
          if ((ellipseEq - 1).abs() <= 0.1) {
            buffer.write(char);
          } else {
            buffer.write(' ');
          }
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generatePlus(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int length = (repetitions * size / 10).round();
    final int thickness = (length / 4).round().clamp(1, length ~/ 2);
    final int center = length ~/ 2;
    
    for (int y = 0; y < length; y++) {
      for (int x = 0; x < length; x++) {
        final bool horizontalBar = y >= center - thickness ~/ 2 && y <= center + thickness ~/ 2;
        final bool verticalBar = x >= center - thickness ~/ 2 && x <= center + thickness ~/ 2;
        
        if (horizontalBar || verticalBar) {
          buffer.write(char);
        } else {
          buffer.write(' ');
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateCross(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int length = (repetitions * size / 10).round();
    
    for (int y = 0; y < length; y++) {
      for (int x = 0; x < length; x++) {
        if (x == y || x == length - 1 - y) {
          buffer.write(char);
        } else {
          buffer.write(' ');
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateArrow(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int length = (repetitions * size / 10).round();
    final int arrowHeadHeight = length ~/ 3;
    final int shaftHeight = length - arrowHeadHeight;
    final int shaftWidth = length ~/ 4;
    final int center = length ~/ 2;
    
    // Arrow head
    for (int y = 0; y < arrowHeadHeight; y++) {
      final int width = y + 1;
      final int spaces = center - width ~/ 2;
      
      buffer.write(' ' * spaces);
      
      if (filled) {
        buffer.write(char * width);
      } else {
        if (width == 1) {
          buffer.write(char);
        } else {
          buffer.write(char);
          buffer.write(' ' * (width - 2));
          buffer.write(char);
        }
      }
      buffer.writeln();
    }
    
    // Arrow shaft
    for (int y = 0; y < shaftHeight; y++) {
      final int spaces = center - shaftWidth ~/ 2;
      buffer.write(' ' * spaces);
      
      if (filled) {
        buffer.write(char * shaftWidth);
      } else {
        buffer.write(char);
        if (shaftWidth > 2) {
          buffer.write(' ' * (shaftWidth - 2));
          buffer.write(char);
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateFlower(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int radius = (repetitions * size / 15).round();
    final int gridSize = radius * 2 + 1;
    final List<List<String>> grid = List.generate(
      gridSize, 
      (index) => List.filled(gridSize, ' ')
    );
    
    final double centerX = radius.toDouble();
    final double centerY = radius.toDouble();
    const int petals = 8;
    
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final double dx = x - centerX;
        final double dy = y - centerY;
        final double distance = math.sqrt(dx * dx + dy * dy);
        final double angle = math.atan2(dy, dx);
        
        final double petalRadius = radius * (0.5 + 0.5 * math.cos(petals * angle));
        
        if (distance <= petalRadius) {
          grid[y][x] = char;
        }
      }
    }
    
    for (final row in grid) {
      buffer.writeln(row.join(''));
    }
    return buffer.toString();
  }

  // Letter Generators (A-Z)
  static String _generateLetterA(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 8).round().clamp(7, 20);
    final int width = height ~/ 2 + 2;
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool shouldDraw = false;
        
        // Left diagonal
        if (x == y ~/ 2) shouldDraw = true;
        // Right diagonal
        if (x == width - 1 - y ~/ 2) shouldDraw = true;
        // Horizontal bar at middle
        if (y == height ~/ 2 && x >= y ~/ 2 && x <= width - 1 - y ~/ 2) shouldDraw = true;
        
        if (shouldDraw) {
          buffer.write(char);
        } else {
          buffer.write(' ');
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateLetterB(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 8).round().clamp(7, 20);
    final int width = height ~/ 2;
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool shouldDraw = false;
        
        // Left vertical line
        if (x == 0) shouldDraw = true;
        // Top horizontal line
        if (y == 0 && x < width - 1) shouldDraw = true;
        // Middle horizontal line
        if (y == height ~/ 2 && x < width - 1) shouldDraw = true;
        // Bottom horizontal line
        if (y == height - 1 && x < width - 1) shouldDraw = true;
        // Right vertical lines for curves
        if (x == width - 1 && (y < height ~/ 2 - 1 || y > height ~/ 2 + 1) && y != 0 && y != height - 1) shouldDraw = true;
        
        if (shouldDraw) {
          buffer.write(char);
        } else {
          buffer.write(' ');
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateLetterC(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 8).round().clamp(7, 20);
    final int width = height ~/ 2;
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool shouldDraw = false;
        
        // Left vertical line
        if (x == 0 && y > 0 && y < height - 1) shouldDraw = true;
        // Top horizontal line
        if (y == 0) shouldDraw = true;
        // Bottom horizontal line
        if (y == height - 1) shouldDraw = true;
        
        if (shouldDraw) {
          buffer.write(char);
        } else {
          buffer.write(' ');
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  // Continue with more letters...
  static String _generateLetterD(String char, int repetitions, double size, bool filled) {
    return _generateCircle(char, repetitions ~/ 2, size, filled); // Simplified for now
  }

  static String _generateLetterE(String char, int repetitions, double size, bool filled) {
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 8).round().clamp(7, 20);
    final int width = height ~/ 2;
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool shouldDraw = false;
        
        // Left vertical line
        if (x == 0) shouldDraw = true;
        // Top horizontal line
        if (y == 0) shouldDraw = true;
        // Middle horizontal line
        if (y == height ~/ 2) shouldDraw = true;
        // Bottom horizontal line
        if (y == height - 1) shouldDraw = true;
        
        if (shouldDraw) {
          buffer.write(char);
        } else {
          buffer.write(' ');
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  // Add remaining letters (simplified implementations)
  static String _generateLetterF(String char, int repetitions, double size, bool filled) {
    return _generateLetterE(char, repetitions, size, filled).replaceAllMapped(RegExp(r'^(.*)$', multiLine: true), (match) {
      final line = match.group(1)!;
      if (line.trim().isEmpty) return line;
      final isLastLine = line == line.replaceAll(char, ' ');
      return isLastLine ? ' ' * line.length : line;
    });
  }

  // Simplified implementations for remaining letters
  static String _generateLetterG(String char, int repetitions, double size, bool filled) => _generateLetterC(char, repetitions, size, filled);
  static String _generateLetterH(String char, int repetitions, double size, bool filled) => _generatePlus(char, repetitions, size, filled);
  static String _generateLetterI(String char, int repetitions, double size, bool filled) => _generateSquare(char, repetitions ~/ 4, size, filled);
  static String _generateLetterJ(String char, int repetitions, double size, bool filled) => _generateLetterC(char, repetitions, size, filled);
  static String _generateLetterK(String char, int repetitions, double size, bool filled) => _generateCross(char, repetitions, size, filled);
  static String _generateLetterL(String char, int repetitions, double size, bool filled) => _generateSquare(char, repetitions, size, false);
  static String _generateLetterM(String char, int repetitions, double size, bool filled) => _generateTriangle(char, repetitions, size, filled);
  static String _generateLetterN(String char, int repetitions, double size, bool filled) => _generateCross(char, repetitions, size, filled);
  static String _generateLetterO(String char, int repetitions, double size, bool filled) => _generateCircle(char, repetitions, size, filled);
  static String _generateLetterP(String char, int repetitions, double size, bool filled) => _generateLetterB(char, repetitions, size, filled);
  static String _generateLetterQ(String char, int repetitions, double size, bool filled) => _generateCircle(char, repetitions, size, filled);
  static String _generateLetterR(String char, int repetitions, double size, bool filled) => _generateLetterB(char, repetitions, size, filled);
  static String _generateLetterS(String char, int repetitions, double size, bool filled) => _generateSpiral(char, repetitions, size);
  static String _generateLetterT(String char, int repetitions, double size, bool filled) => _generatePlus(char, repetitions, size, filled);
  static String _generateLetterU(String char, int repetitions, double size, bool filled) => _generateOval(char, repetitions, size, filled);
  static String _generateLetterV(String char, int repetitions, double size, bool filled) => _generateTriangle(char, repetitions, size, filled);
  static String _generateLetterW(String char, int repetitions, double size, bool filled) => _generateTriangle(char, repetitions, size, filled);
  static String _generateLetterX(String char, int repetitions, double size, bool filled) => _generateCross(char, repetitions, size, filled);
  static String _generateLetterY(String char, int repetitions, double size, bool filled) => _generateTriangle(char, repetitions, size, filled);
  static String _generateLetterZ(String char, int repetitions, double size, bool filled) => _generateCross(char, repetitions, size, filled);

  // Numeric Shape Generators (0-9)
  static String _generateDigit0(String char, int repetitions, double size, bool filled) {
    // Generate an oval/circle shape for digit 0
    return _generateOval(char, repetitions, size, filled);
  }

  static String _generateDigit1(String char, int repetitions, double size, bool filled) {
    // Generate a vertical line with a small angled top for digit 1
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 5).round().clamp(10, 40);
    final int width = (height * 0.4).round().clamp(5, 15);
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (y < 3 && x >= width - 3) {
          // Top diagonal stroke
          buffer.write(char);
        } else if (x >= width ~/ 2 - 1 && x <= width ~/ 2 + 1) {
          // Main vertical line
          buffer.write(char);
        } else {
          buffer.write(' ');
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateDigit2(String char, int repetitions, double size, bool filled) {
    // Generate digit 2 with curved top and diagonal bottom
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 5).round().clamp(10, 40);
    final int width = (height * 0.6).round().clamp(8, 20);
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool shouldDraw = false;
        
        // Top horizontal line
        if (y < 2) {
          shouldDraw = true;
        }
        // Top right curve
        else if (y >= 2 && y < height * 0.4) {
          if (x >= width - 2) shouldDraw = true;
        }
        // Middle diagonal
        else if (y >= height * 0.4 && y < height * 0.8) {
          final int diagX = width - (((y - height * 0.4) / (height * 0.4)) * width).round();
          if ((x - diagX).abs() <= 1) shouldDraw = true;
        }
        // Bottom horizontal line
        else {
          shouldDraw = true;
        }
        
        if (filled || !filled) {
          buffer.write(shouldDraw ? char : ' ');
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateDigit3(String char, int repetitions, double size, bool filled) {
    // Generate digit 3 with two curves on the right
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 5).round().clamp(10, 40);
    final int width = (height * 0.6).round().clamp(8, 20);
    final int midY = height ~/ 2;
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool shouldDraw = false;
        
        // Top, middle, and bottom horizontal lines
        if (y < 2 || (y >= midY - 1 && y <= midY + 1) || y >= height - 2) {
          if (x >= width * 0.2) shouldDraw = true;
        }
        // Right curves
        else if (x >= width - 2) {
          shouldDraw = true;
        }
        
        buffer.write(shouldDraw ? char : ' ');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateDigit4(String char, int repetitions, double size, bool filled) {
    // Generate digit 4 with vertical line and intersection
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 5).round().clamp(10, 40);
    final int width = (height * 0.6).round().clamp(8, 20);
    final int crossY = (height * 0.6).round();
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool shouldDraw = false;
        
        // Left diagonal line (top to middle)
        if (y < crossY) {
          final int diagX = (y * width * 0.7 / crossY).round();
          if ((x - diagX).abs() <= 1) shouldDraw = true;
        }
        
        // Horizontal line at cross point
        if (y >= crossY - 1 && y <= crossY + 1) {
          shouldDraw = true;
        }
        
        // Right vertical line
        if (x >= width - 3 && x <= width - 1) {
          shouldDraw = true;
        }
        
        buffer.write(shouldDraw ? char : ' ');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateDigit5(String char, int repetitions, double size, bool filled) {
    // Generate digit 5 similar to S shape
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 5).round().clamp(10, 40);
    final int width = (height * 0.6).round().clamp(8, 20);
    final int midY = height ~/ 2;
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool shouldDraw = false;
        
        // Top horizontal line
        if (y < 2) {
          shouldDraw = true;
        }
        // Top left vertical
        else if (y < midY && x < 2) {
          shouldDraw = true;
        }
        // Middle horizontal line
        else if (y >= midY - 1 && y <= midY + 1) {
          shouldDraw = true;
        }
        // Bottom right curve
        else if (y > midY && x >= width - 2) {
          shouldDraw = true;
        }
        // Bottom horizontal line
        else if (y >= height - 2 && x < width - 2) {
          shouldDraw = true;
        }
        
        buffer.write(shouldDraw ? char : ' ');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateDigit6(String char, int repetitions, double size, bool filled) {
    // Generate digit 6 with curve at bottom
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 5).round().clamp(10, 40);
    final int width = (height * 0.6).round().clamp(8, 20);
    final int midY = height ~/ 2;
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool shouldDraw = false;
        
        // Left vertical line
        if (x < 2) {
          shouldDraw = true;
        }
        // Top horizontal (smaller)
        else if (y < 2 && x < width * 0.7) {
          shouldDraw = true;
        }
        // Middle horizontal line
        else if (y >= midY - 1 && y <= midY + 1) {
          shouldDraw = true;
        }
        // Bottom right curve
        else if (y > midY) {
          if (y >= height - 2 || x >= width - 2) {
            shouldDraw = true;
          }
        }
        
        buffer.write(shouldDraw ? char : ' ');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateDigit7(String char, int repetitions, double size, bool filled) {
    // Generate digit 7 with top line and diagonal
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 5).round().clamp(10, 40);
    final int width = (height * 0.6).round().clamp(8, 20);
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool shouldDraw = false;
        
        // Top horizontal line
        if (y < 2) {
          shouldDraw = true;
        }
        // Diagonal line from top-right to bottom-left
        else {
          final int diagX = width - (((y - 2) * width * 0.6) / (height - 2)).round();
          if ((x - diagX).abs() <= 1) shouldDraw = true;
        }
        
        buffer.write(shouldDraw ? char : ' ');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateDigit8(String char, int repetitions, double size, bool filled) {
    // Generate digit 8 with two stacked ovals
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 5).round().clamp(10, 40);
    final int width = (height * 0.6).round().clamp(8, 20);
    final double radius1 = height * 0.25;
    final double radius2 = height * 0.25;
    final double centerY1 = height * 0.25;
    final double centerY2 = height * 0.75;
    final double centerX = width / 2;
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool shouldDraw = false;
        
        // Top circle
        final double dist1 = math.sqrt(math.pow(x - centerX, 2) + math.pow(y - centerY1, 2));
        if ((dist1 - radius1).abs() <= 1.5 || (filled && dist1 <= radius1)) {
          shouldDraw = true;
        }
        
        // Bottom circle
        final double dist2 = math.sqrt(math.pow(x - centerX, 2) + math.pow(y - centerY2, 2));
        if ((dist2 - radius2).abs() <= 1.5 || (filled && dist2 <= radius2)) {
          shouldDraw = true;
        }
        
        buffer.write(shouldDraw ? char : ' ');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _generateDigit9(String char, int repetitions, double size, bool filled) {
    // Generate digit 9 (inverted 6)
    final StringBuffer buffer = StringBuffer();
    final int height = (repetitions * size / 5).round().clamp(10, 40);
    final int width = (height * 0.6).round().clamp(8, 20);
    final int midY = height ~/ 2;
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool shouldDraw = false;
        
        // Right vertical line
        if (x >= width - 2) {
          shouldDraw = true;
        }
        // Top horizontal line
        else if (y < 2) {
          shouldDraw = true;
        }
        // Top left curve
        else if (y < midY) {
          if (y < 2 || x < 2) {
            shouldDraw = true;
          }
        }
        // Middle horizontal line
        else if (y >= midY - 1 && y <= midY + 1) {
          shouldDraw = true;
        }
        
        buffer.write(shouldDraw ? char : ' ');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  // Helper Methods
  static void _drawLine(List<List<String>> grid, math.Point<double> start, 
                       math.Point<double> end, String char) {
    final int x0 = start.x.round();
    final int y0 = start.y.round();
    final int x1 = end.x.round();
    final int y1 = end.y.round();
    
    final int dx = (x1 - x0).abs();
    final int dy = (y1 - y0).abs();
    final int sx = x0 < x1 ? 1 : -1;
    final int sy = y0 < y1 ? 1 : -1;
    int err = dx - dy;
    
    int x = x0;
    int y = y0;
    
    while (true) {
      if (x >= 0 && x < grid[0].length && y >= 0 && y < grid.length) {
        grid[y][x] = char;
      }
      
      if (x == x1 && y == y1) break;
      
      final int e2 = 2 * err;
      if (e2 > -dy) {
        err -= dy;
        x += sx;
      }
      if (e2 < dx) {
        err += dx;
        y += sy;
      }
    }
  }

  static void _fillPolygon(List<List<String>> grid, List<math.Point<double>> points, String char) {
    // Simple polygon fill using scanline algorithm
    for (int y = 0; y < grid.length; y++) {
      final List<int> intersections = [];
      
      for (int i = 0; i < points.length; i++) {
        final math.Point<double> p1 = points[i];
        final math.Point<double> p2 = points[(i + 1) % points.length];
        
        if ((p1.y <= y && p2.y > y) || (p2.y <= y && p1.y > y)) {
          final double x = p1.x + (y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y);
          intersections.add(x.round());
        }
      }
      
      intersections.sort();
      
      for (int i = 0; i < intersections.length; i += 2) {
        if (i + 1 < intersections.length) {
          final int startX = intersections[i];
          final int endX = intersections[i + 1];
          
          for (int x = startX; x <= endX; x++) {
            if (x >= 0 && x < grid[0].length) {
              grid[y][x] = char;
            }
          }
        }
      }
    }
  }

  static String getShapeDisplayName(ShapeType shapeType) {
    switch (shapeType) {
      // Basic Shapes
      case ShapeType.circle:
        return '⭕ Circle';
      case ShapeType.square:
        return '⬜ Square';
      case ShapeType.triangle:
        return '🔺 Triangle';
      case ShapeType.heart:
        return '❤️ Heart';
      case ShapeType.spiral:
        return '🌀 Spiral';
      case ShapeType.star:
        return '⭐ Star';
      case ShapeType.diamond:
        return '💎 Diamond';
      // Additional Geometric Shapes
      case ShapeType.pentagon:
        return '⬟ Pentagon';
      case ShapeType.hexagon:
        return '⬡ Hexagon';
      case ShapeType.octagon:
        return '⯃ Octagon';
      case ShapeType.oval:
        return '⭕ Oval';
      case ShapeType.plus:
        return '➕ Plus';
      case ShapeType.cross:
        return '❌ Cross';
      case ShapeType.arrow:
        return '⬆️ Arrow';
      case ShapeType.flower:
        return '🌸 Flower';
      // Numeric Shapes
      case ShapeType.digit0:
        return '0️⃣ Digit 0';
      case ShapeType.digit1:
        return '1️⃣ Digit 1';
      case ShapeType.digit2:
        return '2️⃣ Digit 2';
      case ShapeType.digit3:
        return '3️⃣ Digit 3';
      case ShapeType.digit4:
        return '4️⃣ Digit 4';
      case ShapeType.digit5:
        return '5️⃣ Digit 5';
      case ShapeType.digit6:
        return '6️⃣ Digit 6';
      case ShapeType.digit7:
        return '7️⃣ Digit 7';
      case ShapeType.digit8:
        return '8️⃣ Digit 8';
      case ShapeType.digit9:
        return '9️⃣ Digit 9';
      // Alphabetic Shapes
      case ShapeType.letterA:
        return '🅰️ Letter A';
      case ShapeType.letterB:
        return '🅱️ Letter B';
      case ShapeType.letterC:
        return '🅲 Letter C';
      case ShapeType.letterD:
        return '🅳 Letter D';
      case ShapeType.letterE:
        return '🅴 Letter E';
      case ShapeType.letterF:
        return '🅵 Letter F';
      case ShapeType.letterG:
        return '🅶 Letter G';
      case ShapeType.letterH:
        return '🅷 Letter H';
      case ShapeType.letterI:
        return '🅸 Letter I';
      case ShapeType.letterJ:
        return '🅹 Letter J';
      case ShapeType.letterK:
        return '🅺 Letter K';
      case ShapeType.letterL:
        return '🅻 Letter L';
      case ShapeType.letterM:
        return '🅼 Letter M';
      case ShapeType.letterN:
        return '🅽 Letter N';
      case ShapeType.letterO:
        return '🅾️ Letter O';
      case ShapeType.letterP:
        return '🅿️ Letter P';
      case ShapeType.letterQ:
        return '🆀 Letter Q';
      case ShapeType.letterR:
        return '🆁 Letter R';
      case ShapeType.letterS:
        return '🆂 Letter S';
      case ShapeType.letterT:
        return '🆃 Letter T';
      case ShapeType.letterU:
        return '🆄 Letter U';
      case ShapeType.letterV:
        return '🆅 Letter V';
      case ShapeType.letterW:
        return '🆆 Letter W';
      case ShapeType.letterX:
        return '🆇 Letter X';
      case ShapeType.letterY:
        return '🆈 Letter Y';
      case ShapeType.letterZ:
        return '🆉 Letter Z';
      // Text Loop
      case ShapeType.textLoop:
        return '🔁 Text Loop';
    }
  }

  static List<String> getPopularEmojis() {
    return [
      '❤️', '🌟', '✨', '🔥', '💎', '🌈', '⭐', '💫',
      '🎨', '🎭', '🎪', '🎯', '🎲', '🎸', '🎹', '🎵',
      '😀', '😍', '🤩', '😎', '🥳', '😊', '🤖', '👑',
      '🦄', '🐶', '🐱', '🦋', '🌸', '🌺', '🌻', '🌹',
      '☀️', '🌙', '⚡', '🌊', '❄️', '🔮', '💠', '🎆'
    ];
  }
}