import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/shape_visualization_service.dart';

/// Interactive canvas for visualizing mathematical shapes
/// Provides zoom, pan, and rotation capabilities
class InteractiveShapeCanvas extends StatefulWidget {
  final ShapeVisualizationType shapeType;
  final Color shapeColor;
  final double initialSize;
  final bool showGrid;
  final bool showAxes;
  final bool showStatistics;

  const InteractiveShapeCanvas({
    super.key,
    required this.shapeType,
    this.shapeColor = Colors.blue,
    this.initialSize = 100,
    this.showGrid = true,
    this.showAxes = true,
    this.showStatistics = false,
  });

  @override
  State<InteractiveShapeCanvas> createState() => _InteractiveShapeCanvasState();
}

class _InteractiveShapeCanvasState extends State<InteractiveShapeCanvas> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  double _rotation = 0.0;
  
  // For gesture tracking
  Offset? _lastFocalPoint;
  double _lastScale = 1.0;
  
  // Shape data
  List<Offset> _shapePoints = [];
  ShapeStatistics? _statistics;

  @override
  void initState() {
    super.initState();
    _generateShape();
  }

  @override
  void didUpdateWidget(InteractiveShapeCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shapeType != widget.shapeType ||
        oldWidget.initialSize != widget.initialSize) {
      _generateShape();
    }
  }

  void _generateShape() {
    setState(() {
      _shapePoints = ShapeVisualizationService.generateShapePoints(
        type: widget.shapeType,
        size: widget.initialSize,
        resolution: 200,
      );
      
      if (widget.showStatistics) {
        _statistics = ShapeVisualizationService.calculateStatistics(_shapePoints);
      }
    });
  }

  void _onScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
    _lastScale = _scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Handle zoom
      _scale = (_lastScale * details.scale).clamp(0.1, 10.0);
      
      // Handle pan
      if (_lastFocalPoint != null) {
        _offset += details.focalPoint - _lastFocalPoint!;
        _lastFocalPoint = details.focalPoint;
      }
      
      // Handle rotation (if 2 fingers)
      if (details.pointerCount == 2) {
        _rotation += details.rotation;
      }
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _lastFocalPoint = null;
  }

  void _resetView() {
    setState(() {
      _scale = 1.0;
      _offset = Offset.zero;
      _rotation = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Control buttons
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _scale = (_scale * 1.2).clamp(0.1, 10.0);
                  });
                },
                icon: const Icon(Icons.zoom_in),
                tooltip: 'Zoom In',
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _scale = (_scale / 1.2).clamp(0.1, 10.0);
                  });
                },
                icon: const Icon(Icons.zoom_out),
                tooltip: 'Zoom Out',
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _rotation += math.pi / 4;
                  });
                },
                icon: const Icon(Icons.rotate_right),
                tooltip: 'Rotate',
              ),
              IconButton(
                onPressed: _resetView,
                icon: const Icon(Icons.refresh),
                tooltip: 'Reset View',
              ),
            ],
          ),
        ),
        
        // Canvas
        Expanded(
          child: GestureDetector(
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            onScaleEnd: _onScaleEnd,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: CustomPaint(
                painter: ShapeVisualizationPainter(
                  points: _shapePoints,
                  color: widget.shapeColor,
                  scale: _scale,
                  offset: _offset,
                  rotation: _rotation,
                  showGrid: widget.showGrid,
                  showAxes: widget.showAxes,
                ),
                child: Container(),
              ),
            ),
          ),
        ),
        
        // Statistics panel
        if (widget.showStatistics && _statistics != null)
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shape Statistics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(_statistics.toString()),
              ],
            ),
          ),
        
        // Instructions
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: const Text(
            '👆 Pinch to zoom • Drag to pan • Two fingers to rotate',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// Custom painter for shape visualization
class ShapeVisualizationPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double scale;
  final Offset offset;
  final double rotation;
  final bool showGrid;
  final bool showAxes;

  ShapeVisualizationPainter({
    required this.points,
    required this.color,
    required this.scale,
    required this.offset,
    required this.rotation,
    required this.showGrid,
    required this.showAxes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw grid
    if (showGrid) {
      _drawGrid(canvas, size, center);
    }
    
    // Draw axes
    if (showAxes) {
      _drawAxes(canvas, size, center);
    }
    
    // Transform and draw shape
    if (points.isNotEmpty) {
      _drawShape(canvas, center);
    }
  }

  void _drawGrid(Canvas canvas, Size size, Offset center) {
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 0.5;
    
    double spacing = 50 * scale;
    
    // Draw vertical lines
    for (double x = (center.dx + offset.dx) % spacing; 
         x < size.width; 
         x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }
    
    // Draw horizontal lines
    for (double y = (center.dy + offset.dy) % spacing; 
         y < size.height; 
         y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }

  void _drawAxes(Canvas canvas, Size size, Offset center) {
    final axisPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..strokeWidth = 2;
    
    final axisCenter = center + offset;
    
    // X-axis
    canvas.drawLine(
      Offset(0, axisCenter.dy),
      Offset(size.width, axisCenter.dy),
      axisPaint,
    );
    
    // Y-axis
    canvas.drawLine(
      Offset(axisCenter.dx, 0),
      Offset(axisCenter.dx, size.height),
      axisPaint,
    );
    
    // Draw origin marker
    final originPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(axisCenter, 4, originPaint);
  }

  void _drawShape(Canvas canvas, Offset center) {
    if (points.isEmpty) return;
    
    // Apply transformations
    final transformedPoints = ShapeVisualizationService.transformPoints(
      points: points,
      rotation: rotation,
      scaleX: scale,
      scaleY: scale,
      translation: Offset.zero,
    );
    
    // Create path
    final path = Path();
    final firstPoint = transformedPoints[0];
    path.moveTo(
      center.dx + offset.dx + firstPoint.dx,
      center.dy + offset.dy + firstPoint.dy,
    );
    
    for (int i = 1; i < transformedPoints.length; i++) {
      final point = transformedPoints[i];
      path.lineTo(
        center.dx + offset.dx + point.dx,
        center.dy + offset.dy + point.dy,
      );
    }
    path.close();
    
    // Draw filled shape
    final fillPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);
    
    // Draw outline
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);
    
    // Draw points
    final pointPaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    
    for (var point in transformedPoints) {
      canvas.drawCircle(
        Offset(
          center.dx + offset.dx + point.dx,
          center.dy + offset.dy + point.dy,
        ),
        2,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ShapeVisualizationPainter oldDelegate) {
    return oldDelegate.points != points ||
           oldDelegate.color != color ||
           oldDelegate.scale != scale ||
           oldDelegate.offset != offset ||
           oldDelegate.rotation != rotation ||
           oldDelegate.showGrid != showGrid ||
           oldDelegate.showAxes != showAxes;
  }
}
