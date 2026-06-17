/// Hardcoded, immutable corporate-email validation values and helper.
///
/// Lives in the shared presentation `utils` layer so any feature can drive the
/// "✓ Verified domain" indicator from one source of truth. It is a pure,
/// dependency-free utility: it computes a boolean and never performs I/O.
abstract final class CorporateEmail {
  /// Public providers explicitly rejected by the corporate policy.
  static const Set<String> blockedPublicDomains = <String>{
    'gmail.com',
    'hotmail.com',
    'outlook.com',
    'yahoo.com',
    'live.com',
    'icloud.com',
    'proton.me',
    'protonmail.com',
  };

  /// Structural email pattern (`local@domain.tld`).
  static final RegExp _structure = RegExp(
    r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,}$',
  );

  /// Returns `true` when [email] is well formed and not a public provider, i.e.
  /// it is accepted as a corporate address.
  static bool isCorporate(String email) {
    final normalized = email.trim().toLowerCase();
    if (!_structure.hasMatch(normalized)) {
      return false;
    }
    final domain = normalized.split('@').last;
    return !blockedPublicDomains.contains(domain);
  }
}
