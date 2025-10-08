# Sticker Assets

This directory contains sticker images for use in the Math Shape Creator app.

## Adding Stickers

1. Place PNG or JPG sticker images in this directory
2. Update `lib/widgets/sticker_picker.dart` to reference the new stickers in the `defaultStickers()` method
3. Use relative paths like `assets/stickers/your_sticker.png`

## Example Sticker Names

- `unicorn.png`
- `star.png`
- `heart.png`
- `smiley.png`
- `rocket.png`
- `diamond.png`

## Image Requirements

- **Format**: PNG (with transparency recommended) or JPG
- **Size**: 64x64 to 256x256 pixels recommended
- **File size**: Keep under 100KB for best performance

## Usage

Once added, stickers will appear in the Sticker Picker UI in the app. Users can select them to create sticker loop patterns!
