/// {@template media_res}
/// Centralized resource manager for all media assets (icons, images,
/// vectors, and animations).
///
/// This class provides **string constants** pointing to the asset paths
/// defined in your `pubspec.yaml`. Instead of hardcoding asset paths in
/// multiple places, you can reference them from here:
///
/// ```dart
/// Image.asset(MediaRes.exampleImage);
/// SvgPicture.asset(MediaRes.exampleVector);
/// Lottie.asset(MediaRes.exampleAnimation);
/// ```
///
/// ### Benefits:
/// - Keeps all asset paths consistent and easy to maintain.
/// - If the asset path changes, only this file needs to be updated.
/// - Provides better readability and avoids typos in asset strings.
///
/// ### Folder Structure Convention:
/// ```text
/// assets/
/// ├── icons/
/// │    └── example.svg
/// ├── images/
/// │    └── example.png
/// ├── vectors/
/// │    └── example.svg
/// └── animations/
///      └── example.json
/// ```
///
/// Make sure all assets are declared in your `pubspec.yaml`:
/// ```yaml
/// flutter:
///   assets:
///     - assets/icons/
///     - assets/images/
///     - assets/vectors/
///     - assets/animations/
/// ```
///
/// To add a new asset, simply create a new constant in this class pointing
/// to the correct path.
/// {@endtemplate}
class MediaRes {
  const MediaRes._();

  // =====================
  // Base Paths
  // =====================
  static const _baseIcons = 'assets/icons';
  static const _baseImages = 'assets/images';
  static const _baseVectors = 'assets/vectors';
  static const _baseAnimations = 'assets/animations';

  // =====================
  // Icons
  // =====================
  /// Example SVG icon.
  /// Replace `.svg` with the actual file name in your `assets/icons` folder.
  static const githubIcon = '$_baseIcons/github_icon.svg';
  static const exampleIcon = '$_baseIcons/.svg';

  // =====================
  // Images
  // =====================
  /// Example PNG image.
  /// Replace `.png` with the actual file name in your `assets/images` folder.
  static const exampleImage = '$_baseImages/.png';

  // =====================
  // Vectors
  // =====================
  /// Example SVG vector.
  /// Replace `.svg` with the actual file name in your `assets/vectors` folder.
  static const emptyStateVector = '$_baseVectors/empty_state_vector.svg';
  static const errorStateVector = '$_baseVectors/error_state_vector.svg';
  static const pageNotFoundVector = '$_baseVectors/page_not_found_vector.svg';
  static const exampleVector = '$_baseVectors/.svg';

  // =====================
  // Animations
  // =====================
  /// Example Lottie animation.
  /// Replace `.json` with the actual file name in your `assets/animations` folder.
  static const exampleAnimation = '$_baseAnimations/.json';
}
