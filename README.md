# Math Shape Creator 🎨

A Flutter mobile app that creates beautiful mathematical shapes using characters, numbers, letters, emojis, and mathematical algorithms.

## Features ✨

- **7 Shape Types**: Circle, Square, Triangle, Heart, Spiral, Star, and Diamond
- **Custom Characters**: Use any character, number, letter, or emoji
- **Adjustable Parameters**: Control repetitions (10-500) and size (1.0x-10.0x)
- **Real-time Preview**: See your shapes update as you change parameters
- **Copy to Clipboard**: Easy copying of generated shapes
- **Share Functionality**: Share your mathematical art with others
- **Responsive Design**: Works on phones and tablets
- **Mathematical Algorithms**: Powered by precise geometric calculations

## Mathematical Algorithms 📐

### Circle Generation
Uses the circle equation: `x² + y² = r²` with grid-based rendering for accurate circular shapes.

### Triangle Generation
Implements incremental character count per row with proper spacing and center alignment algorithms.

### Heart Generation
Uses the heart curve equation: `(x² + y² - 1)³ - x² × y³ ≤ 0` with coordinate transformation.

### Spiral Generation
Employs polar coordinates with progressive radius increase and angular displacement calculations.

### Star Generation
Calculates multiple point coordinates with line drawing between points and symmetry handling.

### Diamond Generation
Uses symmetrical increasing/decreasing patterns with center alignment logic.

### Square Generation
Simple grid pattern implementation with equal sides and dynamic sizing.

## Getting Started 🚀

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio or VS Code
- Android device or emulator

### Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

**Android APK:**
```bash
flutter build apk --release
```

## Usage Instructions 📱

1. **Choose a Character**: Enter any character, number, letter, or emoji in the input field
2. **Select Shape Type**: Choose from 7 different mathematical shapes
3. **Adjust Repetitions**: Use the slider to control the density (10-500)
4. **Set Size**: Adjust the size multiplier (1.0x-10.0x)
5. **Generate**: Click "Generate Shape" or watch real-time updates
6. **Copy/Share**: Use the action buttons to copy or share your creation

## Project Structure 📁

```
lib/
├── main.dart                 # App entry point and theme configuration
├── screens/
│   └── home_screen.dart      # Main app screen with responsive layout
├── widgets/
│   ├── control_panel.dart    # Input controls and sliders
│   └── shape_preview.dart    # Shape display and action buttons
└── services/
    └── shape_generator_service.dart  # Mathematical algorithms
```

**Created with ❤️ using Flutter and Mathematics**
