import 'app_locale.dart';

/// Centralized, runtime-localizable string catalogue.
///
/// Every user-facing label resolves through [AppLocale.t], which returns the
/// literal for the currently active [AppLocale.current] language. Keeping all
/// strings behind these static getters means views never hard-code copy and
/// never plumb a `BuildContext` for translation, while a language switch
/// (driven by `LocaleBloc`) re-resolves the whole catalogue on the next build.
///
/// Adding a language is a total, compiler-enforced change: extend `AppLanguage`
/// and the `switch` inside [AppLocale.t] stops compiling until every string has
/// the new translation.
abstract final class AppStrings {
  /// Application brand name.
  static String get appName => AppLocale.t(en: 'SoftWork', es: 'SoftWork');

  // --- Login ------------------------------------------------------------------

  /// Login institutional email field label.
  static String get institutionalEmail =>
      AppLocale.t(en: 'Institutional email', es: 'Correo institucional');

  /// Password field label.
  static String get password => AppLocale.t(en: 'Password', es: 'Contraseña');

  /// "Forgot your password?" action.
  static String get forgotPassword => AppLocale.t(
        en: 'Forgot your password?',
        es: '¿Olvidaste tu contraseña?',
      );

  /// Primary sign-in button label.
  static String get signIn => AppLocale.t(en: 'Sign In', es: 'Iniciar sesión');

  /// Divider separator word.
  static String get orSeparator => AppLocale.t(en: 'or', es: 'o');

  /// Federated Google sign-in button label.
  static String get continueWithGoogle => AppLocale.t(
        en: 'Continue with Google',
        es: 'Continuar con Google',
      );

  /// "Don't have an account?" prompt.
  static String get dontHaveAccount => AppLocale.t(
        en: "Don't have an account? ",
        es: '¿No tienes una cuenta? ',
      );

  /// Sign-up link label.
  static String get signUp => AppLocale.t(en: 'Sign Up', es: 'Regístrate');

  // --- Registration -----------------------------------------------------------

  /// Registration screen title.
  static String get createAccount =>
      AppLocale.t(en: 'Create account', es: 'Crear cuenta');

  /// Registration subtitle constraint.
  static String get onlyCorporateEmails => AppLocale.t(
        en: 'Only corporate emails are accepted',
        es: 'Solo se aceptan correos corporativos',
      );

  /// Username field label.
  static String get username =>
      AppLocale.t(en: 'Username', es: 'Nombre de usuario');

  /// Corporate email field label.
  static String get corporateEmail =>
      AppLocale.t(en: 'Corporate email', es: 'Correo corporativo');

  /// Verified-domain badge label.
  static String get verifiedDomain =>
      AppLocale.t(en: 'Verified domain', es: 'Dominio verificado');

  /// Confirm-password field label.
  static String get confirmPassword =>
      AppLocale.t(en: 'Confirm password', es: 'Confirmar contraseña');

  /// Inline error shown when the two passwords differ.
  static String get passwordsDoNotMatch => AppLocale.t(
        en: 'The passwords do not match.',
        es: 'Las contraseñas no coinciden.',
      );

  /// "Already have an account?" prompt.
  static String get alreadyHaveAccount => AppLocale.t(
        en: 'Already have an account? ',
        es: '¿Ya tienes una cuenta? ',
      );

  // --- Success interstitials --------------------------------------------------

  /// "Session Started" status label.
  static String get sessionStarted =>
      AppLocale.t(en: 'Session Started', es: 'Sesión iniciada');

  /// "User Registered" status label.
  static String get userRegistered =>
      AppLocale.t(en: 'User Registered', es: 'Usuario registrado');

  /// Generic continue CTA.
  static String get continueLabel =>
      AppLocale.t(en: 'Continue', es: 'Continuar');

  // --- Shared / diagnostics ---------------------------------------------------

  /// Accessibility / tooltip label to reveal the password.
  static String get showPassword =>
      AppLocale.t(en: 'Show password', es: 'Mostrar contraseña');

  /// Accessibility / tooltip label to hide the password.
  static String get hidePassword =>
      AppLocale.t(en: 'Hide password', es: 'Ocultar contraseña');

  /// Back-navigation tooltip.
  static String get back => AppLocale.t(en: 'Back', es: 'Atrás');

  /// Generic, user-facing failure message.
  static String get somethingWentWrong => AppLocale.t(
        en: 'Something went wrong. Please try again.',
        es: 'Algo salió mal. Inténtalo de nuevo.',
      );

  // --- Bottom navigation tabs -------------------------------------------------

  /// Menu (dashboard) tab label.
  static String get menuTab => AppLocale.t(en: 'Menu', es: 'Menú');

  /// Profile tab label.
  static String get profileTab => AppLocale.t(en: 'Profile', es: 'Perfil');

  /// Alerts tab label.
  static String get alertsTab => AppLocale.t(en: 'Alerts', es: 'Alertas');

  /// Reports tab label.
  static String get reportsTab => AppLocale.t(en: 'Reports', es: 'Reportes');

  // --- Dashboard / main menu --------------------------------------------------

  /// Dashboard header title.
  static String get dashboardTitle =>
      AppLocale.t(en: 'Dashboard', es: 'Panel');

  /// "Assigned Teams" container card title.
  static String get assignedTeams =>
      AppLocale.t(en: 'Assigned Teams', es: 'Equipos asignados');

  /// "Company" metadata label.
  static String get company => AppLocale.t(en: 'Company', es: 'Empresa');

  /// "Team" metadata label.
  static String get team => AppLocale.t(en: 'Team', es: 'Equipo');

  /// Neutral default job-role label, shown when no role is assigned.
  static String get employeeRole =>
      AppLocale.t(en: 'Employee', es: 'Empleado');

  // --- Profile ----------------------------------------------------------------

  /// Profile screen title ("My Profile").
  static String get myProfile => AppLocale.t(en: 'My Profile', es: 'Mi perfil');

  /// "Edit" app-bar action label.
  static String get edit => AppLocale.t(en: 'Edit', es: 'Editar');

  /// "Employment Information" section title.
  static String get employmentInformation => AppLocale.t(
        en: 'Employment Information',
        es: 'Información laboral',
      );

  /// "Area" metadata label.
  static String get area => AppLocale.t(en: 'Area', es: 'Área');

  /// "Role" metadata label.
  static String get role => AppLocale.t(en: 'Role', es: 'Rol');

  /// "Email" metadata label.
  static String get email => AppLocale.t(en: 'Email', es: 'Correo');

  /// "Payment Methods" card link label.
  static String get paymentMethods =>
      AppLocale.t(en: 'Payment Methods', es: 'Métodos de pago');

  /// Outlined "Edit Profile" CTA label.
  static String get editProfile =>
      AppLocale.t(en: 'Edit Profile', es: 'Editar perfil');

  /// Critical "Sign Out" action label.
  static String get signOut => AppLocale.t(en: 'Sign Out', es: 'Cerrar sesión');

  /// Camera overlay tooltip to change the avatar photo.
  static String get changePhoto =>
      AppLocale.t(en: 'Change photo', es: 'Cambiar foto');

  /// Placeholder shown for unassigned employment fields.
  static String get notAssigned =>
      AppLocale.t(en: 'Not assigned', es: 'No asignado');

  // --- Language selection (Profile tab) --------------------------------------

  /// "Language" section title in the Profile tab.
  static String get settingsLanguage =>
      AppLocale.t(en: 'Language', es: 'Idioma');

  /// English language option label.
  static String get languageNameEnglish =>
      AppLocale.t(en: 'English', es: 'Inglés');

  /// Spanish language option label.
  static String get languageNameSpanish =>
      AppLocale.t(en: 'Spanish', es: 'Español');

  // --- Profile configuration --------------------------------------------------

  /// Profile configuration screen title.
  static String get profileConfiguration => AppLocale.t(
        en: 'Profile Configuration',
        es: 'Configuración de perfil',
      );

  /// Solid primary "Save Changes" CTA label.
  static String get saveChanges =>
      AppLocale.t(en: 'Save Changes', es: 'Guardar cambios');

  // --- Alerts / reports placeholders -----------------------------------------

  /// Empty-state copy for the alerts tab.
  static String get noAlertsYet =>
      AppLocale.t(en: 'No alerts yet.', es: 'Aún no hay alertas.');

  /// Empty-state copy for the reports tab.
  static String get noReportsYet =>
      AppLocale.t(en: 'No reports yet.', es: 'Aún no hay reportes.');

  // --- HR Analytics (Reports) -------------------------------------------------

  /// HR Analytics screen header title.
  static String get hrReportsTitle =>
      AppLocale.t(en: 'Reports', es: 'Reportes');

  /// Team selector container label.
  static String get chooseTeam =>
      AppLocale.t(en: 'Choose team', es: 'Elegir equipo');

  /// Neutral "no team selected" option shown in the selector. Selecting it
  /// collapses the entire metrics canvas.
  static String get noneOption => AppLocale.t(en: 'None', es: 'Ninguno');

  /// Empty-state copy when the HR specialist has no assigned teams.
  static String get noAssignedTeams => AppLocale.t(
        en: 'No assigned teams.',
        es: 'No hay equipos asignados.',
      );

  /// Average-wellbeing metric box label.
  static String get averageWellbeing =>
      AppLocale.t(en: 'Average wellbeing', es: 'Bienestar promedio');

  /// Members metric box label.
  static String get members =>
      AppLocale.t(en: 'Members', es: 'Integrantes');

  /// Forum-reports metric box label.
  static String get forumReports =>
      AppLocale.t(en: 'Forum reports', es: 'Reportes en foro');

  /// Completed-surveys metric box label.
  static String get completedSurveys =>
      AppLocale.t(en: 'Completed surveys', es: 'Encuestas realizadas');

  /// Historical progress chart title.
  static String get historicalProgress =>
      AppLocale.t(en: 'Historical progress', es: 'Progreso histórico');

  /// Empty-state copy for the historical progress chart.
  static String get noHistoryData => AppLocale.t(
        en: 'No historical data available.',
        es: 'No hay datos históricos disponibles.',
      );

  /// Primary footer button label.
  static String get generateReport =>
      AppLocale.t(en: 'Generate report', es: 'Generar reporte');

  /// Snackbar acknowledgement after requesting a report.
  static String get reportRequested => AppLocale.t(
        en: 'Report generation requested.',
        es: 'Generación de reporte solicitada.',
      );

  // --- Payment (subscriptions & cards) ---------------------------------------

  /// Plan-selection screen title.
  static String get membershipsTitle =>
      AppLocale.t(en: 'Memberships', es: 'Membresías');

  /// Currency symbol prefix for prices (locale-neutral).
  static String get currencySymbol => AppLocale.t(en: 'S/.', es: 'S/.');

  /// Per-month price suffix.
  static String get perMonth => AppLocale.t(en: '/mo', es: '/mes');

  /// Plan-card call-to-action.
  static String get selectPlan =>
      AppLocale.t(en: 'Select plan', es: 'Seleccionar plan');

  /// Plan feature — basic check-in.
  static String get featureCheckInBasic =>
      AppLocale.t(en: 'Basic check-in', es: 'Check-in básico');

  /// Plan feature — surveys.
  static String get featureSurveys =>
      AppLocale.t(en: 'Surveys', es: 'Encuestas');

  /// Plan feature — labor forum.
  static String get featureLaborForum =>
      AppLocale.t(en: 'Labor forum', es: 'Foro laboral');

  /// Plan feature — HR messaging.
  static String get featureHrMessaging =>
      AppLocale.t(en: 'HR messaging', es: 'Mensajería HR');

  /// Plan feature — encrypted reports.
  static String get featureEncryptedReports =>
      AppLocale.t(en: 'Encrypted reports', es: 'Denuncias cifradas');

  /// Payment-methods screen title.
  static String get paymentMethodsTitle =>
      AppLocale.t(en: 'Payment methods', es: 'Métodos de pago');

  /// Billing banner label.
  static String get nextCharge =>
      AppLocale.t(en: 'Next charge', es: 'Próximo cobro');

  /// Add-method button label.
  static String get addPaymentMethod =>
      AppLocale.t(en: 'Add payment method', es: 'Agregar método de pago');

  /// Cancel-subscription button label.
  static String get cancelSubscription =>
      AppLocale.t(en: 'Cancel subscription', es: 'Cancelar suscripción');

  /// Cardholder-name field hint.
  static String get cardHolderHint =>
      AppLocale.t(en: 'Cardholder name', es: 'Nombre del titular');

  /// Card-number field hint (locale-neutral sample).
  static String get cardNumberHint => AppLocale.t(
        en: '5123 xxxx xxxx xxxx',
        es: '5123 xxxx xxxx xxxx',
      );

  /// Expiry-date field hint (locale-neutral sample).
  static String get expiryHint =>
      AppLocale.t(en: '08 / 2028', es: '08 / 2028');

  /// Security-code field hint (locale-neutral sample).
  static String get cvvHint => AppLocale.t(en: '715', es: '715');

  /// Save-card switch label.
  static String get saveThisCard =>
      AppLocale.t(en: 'Save this card', es: 'Guardar esta tarjeta');

  /// Add-method footer button.
  static String get addMethod =>
      AppLocale.t(en: 'Add method', es: 'Agregar método');

  /// Success-screen title.
  static String get membershipAcquired =>
      AppLocale.t(en: 'Membership acquired', es: 'Membresía adquirida');

  /// Success-screen CTA that resets to the initial menu.
  static String get initialMenu =>
      AppLocale.t(en: 'Home menu', es: 'Menú inicial');

  /// Profile payment section box title.
  static String get paymentSectionTitle =>
      AppLocale.t(en: 'Payment', es: 'Pago');

  /// Card-graphic "card holder" caption.
  static String get cardHolderTag =>
      AppLocale.t(en: 'CARD HOLDER', es: 'TITULAR');

  /// Card-graphic "expires" caption.
  static String get cardExpiresTag =>
      AppLocale.t(en: 'EXPIRES', es: 'VENCE');
}
