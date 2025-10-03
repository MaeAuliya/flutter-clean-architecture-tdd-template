// utils/constants.dart

/// {@template constants}
/// Centralized, **dummy-safe** constants used across the app.
///
/// Why this file exists:
/// - Keeps magic strings/numbers in one place
/// - Makes testing & localization easier (swap dummy vs real later)
/// - Avoids accidental leaks of real tokens/PII in code reviews
///
/// Usage examples:
/// ```dart
/// final token = Constants.mapAccessToken; // env-injected build-time value
/// final tncTitle = Constants.tncTitles.first; // read-only list item
/// final html = Constants.dummyHtmlContent; // render mock rich text
/// ```
///
/// ⚠️ All values below are **DUMMY / PLACEHOLDER**. Replace with real content
/// via your own configuration layer (remote config, CMS, localization, etc).
/// {@endtemplate}
class Constants {
  const Constants._();

  // ---------------------------------------------------------------------------
  // Build-time / Environment constants
  // ---------------------------------------------------------------------------

  /// {@template map_access_token}
  /// Build-time map access token injected via:
  /// `--dart-define=MAP_ACCESS_TOKEN=...` or `--dart-define-from-file=env.json`.
  ///
  /// Keep it **dummy** for development. For production, inject via CI/CD.
  /// {@endtemplate}
  static const String mapAccessToken = String.fromEnvironment(
    'MAP_ACCESS_TOKEN',
  );

  static const String githubUrl = 'https://github.com/MaeAuliya';
  static const String repositoryUrl =
      'https://github.com/MaeAuliya/flutter-clean-architecture-tdd-template';

  // ---------------------------------------------------------------------------
  // Dummy catalog & pricing (for UI prototyping only)
  // ---------------------------------------------------------------------------

  /// Example equipment names (UI placeholders).
  static const List<String> equipmentsDummy = <String>[
    'Upper Rack',
    'First Aid Kit (P3K)',
    'Spare Tire',
  ];

  /// Example prices in IDR formatted as strings (to test UI formatting).
  /// Prefer numeric types in real flows, then format at the presentation layer.
  static const List<String> pricesDummy = <String>[
    '2.000.000',
    '1.000.000',
    '3.000.000',
  ];

  /// Example price descriptions (lorem ipsum).
  static const List<String> priceDescDummy = <String>[
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ];

  /// Example address (fictional).
  static const String locationDummy =
      'Jl. Pahlawan Revolusi No. 456, Blok A-12, Kecamatan Cipayung, Jakarta Timur.';

  // ---------------------------------------------------------------------------
  // Rich text / HTML (Dummy)
  // ---------------------------------------------------------------------------

  /// Dummy HTML content for rendering/previewing rich text components.
  static const String dummyHtmlContent = """
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam.</p>
<p>Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel.</p>
<p>Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante.</p>
<p>Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus.</p>
""";

  // ---------------------------------------------------------------------------
  // FAQ (Dummy)
  // ---------------------------------------------------------------------------

  /// Example FAQ titles (dummy).
  static const List<String> faqTitles = <String>[
    'What is DriveX?',
    'What are DriveX’s operating hours?',
    'What are the requirements to register?',
    'How long does verification take?',
    'What is the hourly rate?',
    'What are my responsibilities during pickup/return?',
    'Am I eligible for a refund?',
    'What if I disagree with a fee or penalty?',
    'How do I delete my account and what happens to my data?',
    'What happens if the vehicle is low on fuel?',
  ];

  /// Dummy FAQ answer with basic HTML markup (for UI testing).
  static const String dummyFaqAnswer = """
<div class="faq-answer">
  You can delete your YourApp account anytime through the app:<br />
  <span class="faq-answer-bold">Profile &gt; Account Settings &gt; Delete Account</span>
  <br /><br />
  To proceed, make sure:<br /><br />
  • There are <span class="faq-answer-bold">no active bookings</span><br />
  • All <span class="faq-answer-bold">payments, fines, and balances</span> are settled
  <br /><br />
  Once deleted:<br /><br />
  • Your account and personal data will be <span class="faq-answer-bold">permanently erased</span> and cannot be recovered<br />
  • Booking history may be kept in <span class="faq-answer-bold">anonymous form</span> for compliance and safety records<br /><br />
  You will lose access to <span class="faq-answer-bold">unused credits</span>, booking records, and support history
</div>
""";
}
