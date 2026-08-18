/// {@template media_res}
/// Centralized resource manager for all media assets (icons, images,
/// vectors, and animations).
///
/// This class provides **string constants** pointing to the asset paths
/// defined in your `pubspec.yaml`. Instead of hardcoding asset paths in
/// multiple places, you can reference them from here:
///
/// ```dart
/// SvgPicture.asset(MediaRes.githubIcon);
/// SvgPicture.asset(MediaRes.errorStateVector);
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
/// │    └── github_icon.svg
/// └── vectors/
///      ├── empty_state_vector.svg
///      ├── error_state_vector.svg
///      └── page_not_found_vector.svg
/// ```
///
/// Make sure all assets are declared in your `pubspec.yaml`:
/// ```yaml
/// flutter:
///   assets:
///     - assets/icons/
///     - assets/vectors/
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
  static const _baseVectors = 'assets/vectors';

  // =====================
  // Icons
  // =====================
  static const githubIcon = '$_baseIcons/github_icon.svg';

  // =====================
  // Vectors
  // =====================
  static const emptyStateVector = '$_baseVectors/empty_state_vector.svg';
  static const errorStateVector = '$_baseVectors/error_state_vector.svg';
  static const pageNotFoundVector = '$_baseVectors/page_not_found_vector.svg';
}
