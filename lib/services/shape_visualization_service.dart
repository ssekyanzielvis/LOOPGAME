import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Advanced visualization service for mathematical shape rendering
/// Provides MATLAB-like capabilities for shape analysis and visualization
class ShapeVisualizationService {
  /// Generate visualization data points for a shape
  static List<Offset> generateShapePoints({
    required ShapeVisualizationType type,
    required double size,
    int resolution = 100,
    double rotation = 0.0,
  }) {
    switch (type) {
      case ShapeVisualizationType.circle:
        return _generateCirclePoints(size, resolution);
      case ShapeVisualizationType.heart:
        return _generateHeartPoints(size, resolution);
      case ShapeVisualizationType.star:
        return _generateStarPoints(size, resolution);
      case ShapeVisualizationType.spiral:
        return _generateSpiralPoints(size, resolution);
      case ShapeVisualizationType.lissajous:
        return _generateLissajousPoints(size, resolution);
      case ShapeVisualizationType.rose:
        return _generateRosePoints(size, resolution);
      case ShapeVisualizationType.butterfly:
        return _generateButterflyPoints(size, resolution);
      case ShapeVisualizationType.infinity:
        return _generateInfinityPoints(size, resolution);
    }
  }

  /// Generate circle points using parametric equations
  static List<Offset> _generateCirclePoints(double radius, int resolution) {
    List<Offset> points = [];
    for (int i = 0; i <= resolution; i++) {
      double t = (i / resolution) * 2 * math.pi;
      double x = radius * math.cos(t);
      double y = radius * math.sin(t);
      points.add(Offset(x, y));
    }
    return points;
  }

  /// Generate heart shape using parametric equations
  /// x(t) = 16sin³(t), y(t) = 13cos(t) - 5cos(2t) - 2cos(3t) - cos(4t)
  static List<Offset> _generateHeartPoints(double size, int resolution) {
    List<Offset> points = [];
    for (int i = 0; i <= resolution; i++) {
      double t = (i / resolution) * 2 * math.pi;
      double x = 16 * math.pow(math.sin(t), 3).toDouble();
      double y = 13 * math.cos(t) - 
                 5 * math.cos(2 * t) - 
                 2 * math.cos(3 * t) - 
                 math.cos(4 * t);
      points.add(Offset(x * size / 20, -y * size / 20));
    }
    return points;
  }

  /// Generate star points
  static List<Offset> _generateStarPoints(double size, int resolution) {
    List<Offset> points = [];
    int numPoints = 5;
    double outerRadius = size;
    double innerRadius = size * 0.4;
    
    for (int i = 0; i <= resolution; i++) {
      double angle = (i / resolution) * 2 * math.pi;
      int pointIndex = (i * numPoints * 2 / resolution).floor();
      double radius = pointIndex % 2 == 0 ? outerRadius : innerRadius;
      
      double x = radius * math.cos(angle - math.pi / 2);
      double y = radius * math.sin(angle - math.pi / 2);
      points.add(Offset(x, y));
    }
    return points;
  }

  /// Generate spiral points (Archimedean spiral)
  /// r = a + b*θ
  static List<Offset> _generateSpiralPoints(double size, int resolution) {
    List<Offset> points = [];
    double spirals = 3;
    
    for (int i = 0; i <= resolution; i++) {
      double t = (i / resolution) * spirals * 2 * math.pi;
      double r = size * (t / (spirals * 2 * math.pi));
      double x = r * math.cos(t);
      double y = r * math.sin(t);
      points.add(Offset(x, y));
    }
    return points;
  }

  /// Generate Lissajous curve
  /// x = A*sin(at + δ), y = B*sin(bt)
  static List<Offset> _generateLissajousPoints(double size, int resolution) {
    List<Offset> points = [];
    double a = 3; // Frequency x
    double b = 4; // Frequency y
    double delta = math.pi / 2; // Phase shift
    
    for (int i = 0; i <= resolution; i++) {
      double t = (i / resolution) * 2 * math.pi;
      double x = size * math.sin(a * t + delta);
      double y = size * math.sin(b * t);
      points.add(Offset(x, y));
    }
    return points;
  }

  /// Generate rose curve (rhodonea curve)
  /// r = a*cos(k*θ)
  static List<Offset> _generateRosePoints(double size, int resolution) {
    List<Offset> points = [];
    double k = 5; // Number of petals
    
    for (int i = 0; i <= resolution; i++) {
      double t = (i / resolution) * 2 * math.pi;
      double r = size * math.cos(k * t);
      double x = r * math.cos(t);
      double y = r * math.sin(t);
      points.add(Offset(x, y));
    }
    return points;
  }

  /// Generate butterfly curve
  /// Butterfly curve (Fay's butterfly)
  static List<Offset> _generateButterflyPoints(double size, int resolution) {
    List<Offset> points = [];
    
    for (int i = 0; i <= resolution; i++) {
      double t = (i / resolution) * 12 * math.pi;
      double r = math.exp(math.cos(t)) - 
                 2 * math.cos(4 * t) + 
                 math.pow(math.sin(t / 12), 5);
      double x = size * r * math.cos(t) / 3;
      double y = size * r * math.sin(t) / 3;
      points.add(Offset(x, y));
    }
    return points;
  }

  /// Generate infinity symbol (lemniscate)
  /// (x² + y²)² = 2a²(x² - y²)
  static List<Offset> _generateInfinityPoints(double size, int resolution) {
    List<Offset> points = [];
    
    for (int i = 0; i <= resolution; i++) {
      double t = (i / resolution) * 2 * math.pi;
      double scale = size / (1 + math.pow(math.sin(t), 2));
      double x = scale * math.cos(t);
      double y = scale * math.sin(t) * math.cos(t);
      points.add(Offset(x, y));
    }
    return points;
  }

  /// Apply transformation matrix to points
  static List<Offset> transformPoints({
    required List<Offset> points,
    double rotation = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    Offset translation = Offset.zero,
  }) {
    // Transform all points manually
    return points.map((point) {
      // Apply scale
      double x = point.dx * scaleX;
      double y = point.dy * scaleY;
      
      // Apply rotation
      double cosR = math.cos(rotation);
      double sinR = math.sin(rotation);
      double rotatedX = x * cosR - y * sinR;
      double rotatedY = x * sinR + y * cosR;
      
      // Apply translation
      return Offset(
        rotatedX + translation.dx,
        rotatedY + translation.dy,
      );
    }).toList();
  }

  /// Calculate bounding box for points
  static Rect calculateBoundingBox(List<Offset> points) {
    if (points.isEmpty) return Rect.zero;
    
    double minX = points[0].dx;
    double maxX = points[0].dx;
    double minY = points[0].dy;
    double maxY = points[0].dy;
    
    for (var point in points) {
      minX = math.min(minX, point.dx);
      maxX = math.max(maxX, point.dx);
      minY = math.min(minY, point.dy);
      maxY = math.max(maxY, point.dy);
    }
    
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  /// Generate grid lines for coordinate system
  static List<List<Offset>> generateGrid({
    required Size canvasSize,
    required double spacing,
    required Offset center,
  }) {
    List<List<Offset>> gridLines = [];
    
    // Vertical lines
    for (double x = center.dx % spacing; x < canvasSize.width; x += spacing) {
      gridLines.add([
        Offset(x, 0),
        Offset(x, canvasSize.height),
      ]);
    }
    
    // Horizontal lines
    for (double y = center.dy % spacing; y < canvasSize.height; y += spacing) {
      gridLines.add([
        Offset(0, y),
        Offset(canvasSize.width, y),
      ]);
    }
    
    return gridLines;
  }

  /// Calculate shape statistics (area, perimeter, etc.)
  static ShapeStatistics calculateStatistics(List<Offset> points) {
    if (points.isEmpty) {
      return ShapeStatistics(
        area: 0,
        perimeter: 0,
        centroid: Offset.zero,
        pointCount: 0,
      );
    }
    
    // Calculate perimeter
    double perimeter = 0;
    for (int i = 0; i < points.length - 1; i++) {
      perimeter += (points[i + 1] - points[i]).distance;
    }
    
    // Calculate centroid
    double cx = 0, cy = 0;
    for (var point in points) {
      cx += point.dx;
      cy += point.dy;
    }
    cx /= points.length;
    cy /= points.length;
    
    // Calculate approximate area using shoelace formula
    double area = 0;
    for (int i = 0; i < points.length - 1; i++) {
      area += points[i].dx * points[i + 1].dy - points[i + 1].dx * points[i].dy;
    }
    area = area.abs() / 2;
    
    return ShapeStatistics(
      area: area,
      perimeter: perimeter,
      centroid: Offset(cx, cy),
      pointCount: points.length,
    );
  }

  /// Generate points for a parametric function
  /// x = f(t), y = g(t)
  static List<Offset> generateParametricCurve({
    required double Function(double t) xFunc,
    required double Function(double t) yFunc,
    required double tMin,
    required double tMax,
    int resolution = 100,
  }) {
    List<Offset> points = [];
    
    for (int i = 0; i <= resolution; i++) {
      double t = tMin + (i / resolution) * (tMax - tMin);
      double x = xFunc(t);
      double y = yFunc(t);
      points.add(Offset(x, y));
    }
    
    return points;
  }
}

/// Types of visualizable shapes
enum ShapeVisualizationType {
  circle,
  heart,
  star,
  spiral,
  lissajous,
  rose,
  butterfly,
  infinity,
}

/// Statistics about a shape
class ShapeStatistics {
  final double area;
  final double perimeter;
  final Offset centroid;
  final int pointCount;

  ShapeStatistics({
    required this.area,
    required this.perimeter,
    required this.centroid,
    required this.pointCount,
  });

  @override
  String toString() {
    return 'Area: ${area.toStringAsFixed(2)}\n'
           'Perimeter: ${perimeter.toStringAsFixed(2)}\n'
           'Centroid: (${centroid.dx.toStringAsFixed(2)}, ${centroid.dy.toStringAsFixed(2)})\n'
           'Points: $pointCount';
  }
}
