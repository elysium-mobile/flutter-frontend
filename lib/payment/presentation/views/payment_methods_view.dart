import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../iam/presentation/navigation/iam_routes.dart';
import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../application/bloc/payment_methods_bloc.dart';
import '../navigation/payment_routes.dart';

/// Payment-methods overview screen ("Métodos de pago") — Screen 2.
///
/// Establishes the [PaymentMethodsBloc] provider boundary and renders the
/// billing banner plus the add-method / cancel-subscription actions.
class PaymentMethodsView extends StatelessWidget {
  /// Creates a [PaymentMethodsView].
  const PaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentMethodsBloc>(
      create: (_) =>
          GetIt.instance<PaymentMethodsBloc>()..add(const PaymentMethodsStarted()),
      child: const _PaymentMethodsScreen(),
    );
  }
}

/// Screen body reacting to [PaymentMethodsState].
class _PaymentMethodsScreen extends StatelessWidget {
  const _PaymentMethodsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          tooltip: AppStrings.back,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryNavy,
            size: 20,
          ),
          onPressed: () => context.goNamed(IamRoutes.profileName),
        ),
        title: Text(AppStrings.paymentMethodsTitle, style: AppTypography.title),
      ),
      body: BlocBuilder<PaymentMethodsBloc, PaymentMethodsState>(
        builder: (BuildContext context, PaymentMethodsState state) {
          if (state.status == PaymentMethodsStatus.loading ||
              state.status == PaymentMethodsStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _BillingBanner(
                  amount: state.nextChargeAmount,
                  date: state.nextChargeDate,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _AddMethodButton(
                        onPressed: () =>
                            context.goNamed(PaymentRoutes.addCardName),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _CancelSubscriptionButton(
                        onPressed: () => context
                            .read<PaymentMethodsBloc>()
                            .add(const PaymentMethodsSubscriptionCancelled()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Primary gradient card showing the next-charge amount and date.
class _BillingBanner extends StatelessWidget {
  const _BillingBanner({required this.amount, required this.date});

  final int? amount;
  final DateTime? date;

  /// Localized Spanish month names for the billing date display.
  static const List<String> _months = <String>[
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  /// Formats [date] as "27 de Mayo, 2026", or a neutral dash when unknown.
  String get _formattedDate {
    final DateTime? value = date;
    if (value == null) return '—';
    return '${value.day} de ${_months[value.month - 1]}, ${value.year}';
  }

  @override
  Widget build(BuildContext context) {
    final String amountText =
        amount == null ? '—' : '${AppStrings.currencySymbol} $amount';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppGradients.billingBanner,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.nextCharge,
            style: AppTypography.body.copyWith(
              color: AppColors.accentWhite.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            amountText,
            style: AppTypography.displayLarge.copyWith(
              color: AppColors.accentWhite,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            _formattedDate,
            style: AppTypography.subtitle.copyWith(
              color: AppColors.accentWhite.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

/// Solid blue "Agregar método de pago" button.
class _AddMethodButton extends StatelessWidget {
  const _AddMethodButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.sky,
          foregroundColor: AppColors.accentWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
        ),
        child: Text(
          AppStrings.addPaymentMethod,
          textAlign: TextAlign.center,
          style: AppTypography.label.copyWith(color: AppColors.accentWhite),
        ),
      ),
    );
  }
}

/// Outlined red-text "Cancelar suscripción" button.
class _CancelSubscriptionButton extends StatelessWidget {
  const _CancelSubscriptionButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.danger,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
        ),
        child: Text(
          AppStrings.cancelSubscription,
          textAlign: TextAlign.center,
          style: AppTypography.label.copyWith(color: AppColors.danger),
        ),
      ),
    );
  }
}
