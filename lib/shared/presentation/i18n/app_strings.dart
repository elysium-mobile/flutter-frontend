import 'package:intl/intl.dart';

/// Centralized, localizable string catalogue backed by the `intl` engine.
///
/// Every user-facing label is declared through [Intl.message], giving a single
/// extraction point for translation tooling while returning English copy by
/// default. Keeping all strings here guarantees views contain no hard-coded
/// (and no Spanish) text.
abstract final class AppStrings {
  /// Application brand name.
  static String get appName =>
      Intl.message('SoftWork', name: 'appName');

  // --- Login ------------------------------------------------------------------

  /// Login institutional email field label.
  static String get institutionalEmail => Intl.message(
        'Institutional email',
        name: 'institutionalEmail',
      );

  /// Password field label.
  static String get password => Intl.message('Password', name: 'password');

  /// "Forgot your password?" action.
  static String get forgotPassword => Intl.message(
        'Forgot your password?',
        name: 'forgotPassword',
      );

  /// Primary sign-in button label.
  static String get signIn => Intl.message('Sign In', name: 'signIn');

  /// Divider separator character.
  static String get orSeparator => Intl.message('o', name: 'orSeparator');

  /// Federated Google sign-in button label.
  static String get continueWithGoogle => Intl.message(
        'Continue with Google',
        name: 'continueWithGoogle',
      );

  /// "Don't have an account?" prompt.
  static String get dontHaveAccount => Intl.message(
        "Don't have an account? ",
        name: 'dontHaveAccount',
      );

  /// Sign-up link label.
  static String get signUp => Intl.message('Sign Up', name: 'signUp');

  // --- Registration -----------------------------------------------------------

  /// Registration screen title.
  static String get createAccount =>
      Intl.message('Create account', name: 'createAccount');

  /// Registration subtitle constraint.
  static String get onlyCorporateEmails => Intl.message(
        'Only corporate emails are accepted',
        name: 'onlyCorporateEmails',
      );

  /// Username field label.
  static String get username => Intl.message('Username', name: 'username');

  /// Corporate email field label.
  static String get corporateEmail =>
      Intl.message('Corporate email', name: 'corporateEmail');

  /// Verified-domain badge label.
  static String get verifiedDomain =>
      Intl.message('Verified domain', name: 'verifiedDomain');

  /// Confirm-password field label.
  static String get confirmPassword =>
      Intl.message('Confirm password', name: 'confirmPassword');

  /// Inline error shown when the two passwords differ.
  static String get passwordsDoNotMatch => Intl.message(
        'The passwords do not match.',
        name: 'passwordsDoNotMatch',
      );

  /// "Already have an account?" prompt.
  static String get alreadyHaveAccount => Intl.message(
        'Already have an account? ',
        name: 'alreadyHaveAccount',
      );

  // --- Success interstitials --------------------------------------------------

  /// "Session Started" status label.
  static String get sessionStarted =>
      Intl.message('Session Started', name: 'sessionStarted');

  /// "User Registered" status label.
  static String get userRegistered =>
      Intl.message('User Registered', name: 'userRegistered');

  /// Generic continue CTA.
  static String get continueLabel =>
      Intl.message('Continue', name: 'continueLabel');

  // --- Shared / diagnostics ---------------------------------------------------

  /// Accessibility / tooltip label to reveal the password.
  static String get showPassword =>
      Intl.message('Show password', name: 'showPassword');

  /// Accessibility / tooltip label to hide the password.
  static String get hidePassword =>
      Intl.message('Hide password', name: 'hidePassword');

  /// Back-navigation tooltip.
  static String get back => Intl.message('Back', name: 'back');

  /// Generic, user-facing failure message.
  static String get somethingWentWrong => Intl.message(
        'Something went wrong. Please try again.',
        name: 'somethingWentWrong',
      );

  // --- Bottom navigation tabs -------------------------------------------------

  /// Menu (dashboard) tab label.
  static String get menuTab => Intl.message('Menu', name: 'menuTab');

  /// Profile tab label.
  static String get profileTab => Intl.message('Profile', name: 'profileTab');

  /// Alerts tab label.
  static String get alertsTab => Intl.message('Alerts', name: 'alertsTab');

  /// Reports tab label.
  static String get reportsTab => Intl.message('Reports', name: 'reportsTab');

  // --- Dashboard / main menu --------------------------------------------------

  /// Dashboard header title.
  static String get dashboardTitle =>
      Intl.message('Dashboard', name: 'dashboardTitle');

  /// "Assigned Teams" container card title.
  static String get assignedTeams =>
      Intl.message('Assigned Teams', name: 'assignedTeams');

  /// "Company" metadata label.
  static String get company => Intl.message('Company', name: 'company');

  /// "Team" metadata label.
  static String get team => Intl.message('Team', name: 'team');

  /// Neutral default job-role label, shown when no role is assigned.
  static String get employeeRole =>
      Intl.message('Employee', name: 'employeeRole');

  // --- Profile ----------------------------------------------------------------

  /// Profile screen title ("My Profile").
  static String get myProfile => Intl.message('My Profile', name: 'myProfile');

  /// "Edit" app-bar action label.
  static String get edit => Intl.message('Edit', name: 'edit');

  /// "Employment Information" section title.
  static String get employmentInformation => Intl.message(
        'Employment Information',
        name: 'employmentInformation',
      );

  /// "Area" metadata label.
  static String get area => Intl.message('Area', name: 'area');

  /// "Role" metadata label.
  static String get role => Intl.message('Role', name: 'role');

  /// "Email" metadata label.
  static String get email => Intl.message('Email', name: 'email');

  /// "Payment Methods" card link label.
  static String get paymentMethods =>
      Intl.message('Payment Methods', name: 'paymentMethods');

  /// Outlined "Edit Profile" CTA label.
  static String get editProfile =>
      Intl.message('Edit Profile', name: 'editProfile');

  /// Critical "Sign Out" action label.
  static String get signOut => Intl.message('Sign Out', name: 'signOut');

  /// Camera overlay tooltip to change the avatar photo.
  static String get changePhoto =>
      Intl.message('Change photo', name: 'changePhoto');

  /// Placeholder shown for unassigned employment fields.
  static String get notAssigned =>
      Intl.message('Not assigned', name: 'notAssigned');

  // --- Profile configuration --------------------------------------------------

  /// Profile configuration screen title.
  static String get profileConfiguration => Intl.message(
        'Profile Configuration',
        name: 'profileConfiguration',
      );

  /// Solid primary "Save Changes" CTA label.
  static String get saveChanges =>
      Intl.message('Save Changes', name: 'saveChanges');

  // --- Alerts / reports placeholders -----------------------------------------

  /// Empty-state copy for the alerts tab.
  static String get noAlertsYet =>
      Intl.message('No alerts yet.', name: 'noAlertsYet');

  /// Empty-state copy for the reports tab.
  static String get noReportsYet =>
      Intl.message('No reports yet.', name: 'noReportsYet');
}
