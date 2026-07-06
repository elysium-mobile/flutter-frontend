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

  // --- HR Analytics (Reports) -------------------------------------------------
  //
  // The user-facing values below are the localized (Spanish) UI strings taken
  // verbatim from the approved HR Analytics mockup. They are intentionally
  // exempt from the English-only rule (which still governs identifiers and
  // dartdoc) and remain routed through the i18n engine rather than hard-coded.

  /// HR Analytics screen header title (mockup: "Reportes").
  static String get hrReportsTitle =>
      Intl.message('Reportes', name: 'hrReportsTitle');

  /// Team selector container label (mockup: "Elegir equipo").
  static String get chooseTeam =>
      Intl.message('Elegir equipo', name: 'chooseTeam');

  /// Neutral "no team selected" option shown in the selector (mockup:
  /// "Ninguno"). Selecting it collapses the entire metrics canvas.
  static String get noneOption =>
      Intl.message('Ninguno', name: 'noneOption');

  /// Empty-state copy when the HR specialist has no assigned teams.
  static String get noAssignedTeams => Intl.message(
        'No hay equipos asignados.',
        name: 'noAssignedTeams',
      );

  /// Average-wellbeing metric box label (mockup: "Bienestar promedio").
  static String get averageWellbeing =>
      Intl.message('Bienestar promedio', name: 'averageWellbeing');

  /// Members metric box label (mockup: "Integrantes").
  static String get members => Intl.message('Integrantes', name: 'members');

  /// Forum-reports metric box label (mockup: "Reportes en foro").
  static String get forumReports =>
      Intl.message('Reportes en foro', name: 'forumReports');

  /// Completed-surveys metric box label (mockup: "Encuestas realizadas").
  static String get completedSurveys =>
      Intl.message('Encuestas realizadas', name: 'completedSurveys');

  /// Historical progress chart title (mockup: "Progreso histórico").
  static String get historicalProgress =>
      Intl.message('Progreso histórico', name: 'historicalProgress');

  /// Empty-state copy for the historical progress chart.
  static String get noHistoryData => Intl.message(
        'No hay datos históricos disponibles.',
        name: 'noHistoryData',
      );

  /// Primary footer button label (mockup: "Generar reporte").
  static String get generateReport =>
      Intl.message('Generar reporte', name: 'generateReport');

  /// Snackbar acknowledgement after requesting a report.
  static String get reportRequested => Intl.message(
        'Generación de reporte solicitada.',
        name: 'reportRequested',
      );

  // --- Payment (subscriptions & cards) ---------------------------------------
  //
  // As with the HR Analytics panel, the user-facing values below are the
  // localized (Spanish) UI strings from the approved payment mockups. Only the
  // display values are localized; identifiers and dartdoc remain English, and
  // every string is still routed through the i18n engine.

  /// Plan-selection screen title (mockup: "Membresías").
  static String get membershipsTitle =>
      Intl.message('Membresías', name: 'membershipsTitle');

  /// Currency symbol prefix for prices (mockup: "S/.").
  static String get currencySymbol =>
      Intl.message('S/.', name: 'currencySymbol');

  /// Per-month price suffix (mockup: "/mes").
  static String get perMonth => Intl.message('/mes', name: 'perMonth');

  /// Plan-card call-to-action (mockup: "Seleccionar plan").
  static String get selectPlan =>
      Intl.message('Seleccionar plan', name: 'selectPlan');

  /// Plan feature — basic check-in (mockup: "Check-in básico").
  static String get featureCheckInBasic =>
      Intl.message('Check-in básico', name: 'featureCheckInBasic');

  /// Plan feature — surveys (mockup: "Encuestas").
  static String get featureSurveys =>
      Intl.message('Encuestas', name: 'featureSurveys');

  /// Plan feature — labor forum (mockup: "Foro laboral").
  static String get featureLaborForum =>
      Intl.message('Foro laboral', name: 'featureLaborForum');

  /// Plan feature — HR messaging (mockup: "Mensajería HR").
  static String get featureHrMessaging =>
      Intl.message('Mensajería HR', name: 'featureHrMessaging');

  /// Plan feature — encrypted reports (mockup: "Denuncias cifradas").
  static String get featureEncryptedReports =>
      Intl.message('Denuncias cifradas', name: 'featureEncryptedReports');

  /// Payment-methods screen title (mockup: "Métodos de pago").
  static String get paymentMethodsTitle =>
      Intl.message('Métodos de pago', name: 'paymentMethodsTitle');

  /// Billing banner label (mockup: "Próximo cobro").
  static String get nextCharge =>
      Intl.message('Próximo cobro', name: 'nextCharge');

  /// Add-method button label (mockup: "Agregar método de pago").
  static String get addPaymentMethod =>
      Intl.message('Agregar método de pago', name: 'addPaymentMethod');

  /// Cancel-subscription button label (mockup: "Cancelar suscripción").
  static String get cancelSubscription =>
      Intl.message('Cancelar suscripción', name: 'cancelSubscription');

  /// Cardholder-name placeholder (mockup: "Nombre1").
  static String get cardHolderHint =>
      Intl.message('Nombre1', name: 'cardHolderHint');

  /// Card-number placeholder (mockup: "5123 xxxx xxxx xxxx").
  static String get cardNumberHint =>
      Intl.message('5123 xxxx xxxx xxxx', name: 'cardNumberHint');

  /// Expiry-date placeholder (mockup: "08 / 2028").
  static String get expiryHint =>
      Intl.message('08 / 2028', name: 'expiryHint');

  /// Security-code placeholder (mockup: "715").
  static String get cvvHint => Intl.message('715', name: 'cvvHint');

  /// Save-card switch label (mockup: "Save this card").
  static String get saveThisCard =>
      Intl.message('Save this card', name: 'saveThisCard');

  /// Add-method footer button (mockup: "Agregar método").
  static String get addMethod =>
      Intl.message('Agregar método', name: 'addMethod');

  /// Success-screen title (mockup: "Membresía adquirida").
  static String get membershipAcquired =>
      Intl.message('Membresía adquirida', name: 'membershipAcquired');

  /// Success-screen CTA that resets to the initial menu (mockup: "Menú inicial").
  static String get initialMenu =>
      Intl.message('Menú inicial', name: 'initialMenu');

  /// Profile "Pago" section box title (mockup: "Pago").
  static String get paymentSectionTitle =>
      Intl.message('Pago', name: 'paymentSectionTitle');

  /// Card-graphic "card holder" caption (mockup: "CARD HOLDER").
  static String get cardHolderTag =>
      Intl.message('CARD HOLDER', name: 'cardHolderTag');

  /// Card-graphic "expires" caption (mockup: "EXPIRES").
  static String get cardExpiresTag =>
      Intl.message('EXPIRES', name: 'cardExpiresTag');
}
