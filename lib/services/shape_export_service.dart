import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Service for exporting and sharing shape creations
class ShapeExportService {
  /// Copy shape text to clipboard
  static Future<void> copyToClipboard(String text, BuildContext context) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Copied to clipboard!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error copying to clipboard: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Save shape to a text file
  static Future<void> saveToFile(String text, String filename, BuildContext context) async {
    try {
      // Get the appropriate directory based on platform
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('Could not access storage directory');
      }

      // Create shapes folder if it doesn't exist
      final shapesDir = Directory('${directory.path}/shapes');
      if (!await shapesDir.exists()) {
        await shapesDir.create(recursive: true);
      }

      // Create file with timestamp if filename already exists
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${shapesDir.path}/${filename}_$timestamp.txt');
      
      // Write the shape text to file
      await file.writeAsString(text);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Saved to: ${file.path}'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Share',
              textColor: Colors.white,
              onPressed: () => shareFile(file.path),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Share shape via system share dialog
  static Future<void> shareText(String text, String subject) async {
    try {
      await Share.share(
        text,
        subject: subject,
      );
    } catch (e) {
      debugPrint('Error sharing text: $e');
    }
  }

  /// Share file via system share dialog
  static Future<void> shareFile(String filePath) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'My Shape Creation',
      );
    } catch (e) {
      debugPrint('Error sharing file: $e');
    }
  }

  /// Get list of saved shapes
  static Future<List<FileSystemEntity>> getSavedShapes() async {
    try {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) return [];

      final shapesDir = Directory('${directory.path}/shapes');
      if (!await shapesDir.exists()) {
        return [];
      }

      final files = shapesDir.listSync()
        ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      
      return files;
    } catch (e) {
      debugPrint('Error getting saved shapes: $e');
      return [];
    }
  }

  /// Read shape from file
  static Future<String?> readShapeFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      debugPrint('Error reading shape file: $e');
      return null;
    }
  }

  /// Delete saved shape file
  static Future<void> deleteShapeFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting shape file: $e');
    }
  }
}
