/// Canonical, type-safe catalogue of the payment feature's navigation routes.
///
/// Centralizing the path/name literals keeps `go_router` configuration,
/// redirects and call sites consistent and refactor-safe.
abstract final class PaymentRoutes {
  /// Path of the plan-selection ("Membresías") onboarding screen.
  static const String plansPath = '/payment/plans';

  /// Symbolic name of the plan-selection route.
  static const String plansName = 'payment-plans';

  /// Path of the payment-methods ("Métodos de pago") overview screen.
  static const String methodsPath = '/payment/methods';

  /// Symbolic name of the payment-methods route.
  static const String methodsName = 'payment-methods';

  /// Path of the card-provisioning ("Agregar método de pago") screen.
  static const String addCardPath = '/payment/methods/add-card';

  /// Symbolic name of the card-provisioning route.
  static const String addCardName = 'payment-add-card';

  /// Path of the "Membresía adquirida" success screen.
  static const String successPath = '/payment/success';

  /// Symbolic name of the success route.
  static const String successName = 'payment-success';
}
