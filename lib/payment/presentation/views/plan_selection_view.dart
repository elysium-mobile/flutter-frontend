import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../iam/application/bloc/session_bloc.dart';
import '../../../shared/domain/models/id.dart';
import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../application/bloc/membership_gate_bloc.dart';
import '../../application/bloc/plan_selection_bloc.dart';
import '../../domain/models/membership_plan.dart';
import '../navigation/payment_routes.dart';

/// Plan-selection screen ("Membresías") — Screen 1.
///
/// Establishes the [PlanSelectionBloc] provider boundary and renders the
/// scrolling list of subscription plans. On a successful purchase it notifies
/// the global [MembershipGateBloc] and routes to the success screen.
class PlanSelectionView extends StatelessWidget {
  /// Creates a [PlanSelectionView].
  const PlanSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlanSelectionBloc>(
      create: (_) =>
          GetIt.instance<PlanSelectionBloc>()..add(const PlanSelectionStarted()),
      child: const _PlanSelectionScreen(),
    );
  }
}

/// Screen body reacting to [PlanSelectionState].
class _PlanSelectionScreen extends StatelessWidget {
  const _PlanSelectionScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        title: Text(AppStrings.membershipsTitle, style: AppTypography.title),
      ),
      body: BlocConsumer<PlanSelectionBloc, PlanSelectionState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (BuildContext context, PlanSelectionState state) {
          if (state.status == PlanSelectionStatus.purchased &&
              state.acquiredMembership != null) {
            // Synchronize the global routing gate, then advance to success.
            context
                .read<MembershipGateBloc>()
                .add(MembershipGateActivated(state.acquiredMembership!));
            context.goNamed(PaymentRoutes.successName);
          } else if (state.status == PlanSelectionStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.danger,
                  content: Text(AppStrings.somethingWentWrong),
                ),
              );
          }
        },
        builder: (BuildContext context, PlanSelectionState state) {
          if (state.status == PlanSelectionStatus.loading ||
              state.status == PlanSelectionStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.plans.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  AppStrings.somethingWentWrong,
                  textAlign: TextAlign.center,
                  style: AppTypography.subtitle,
                ),
              ),
            );
          }

          final int maxPrice = state.plans
              .map((MembershipPlan plan) => plan.price)
              .reduce((int a, int b) => a > b ? a : b);

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: state.plans.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (BuildContext context, int index) {
              final MembershipPlan plan = state.plans[index];
              final bool isPro = state.plans.length > 1 && plan.price == maxPrice;
              return _PlanCard(
                plan: plan,
                isPro: isPro,
                isBusy: state.isPurchasing && state.selectedPlan == plan,
                onSelect: () => _purchase(context, plan),
              );
            },
          );
        },
      ),
    );
  }

  /// Dispatches the purchase for [plan] using the authenticated account id.
  void _purchase(BuildContext context, MembershipPlan plan) {
    final Id? userAccountId = context.read<SessionBloc>().state.user?.id;
    if (userAccountId == null) return;
    context.read<PlanSelectionBloc>().add(
          PlanSelectionPurchaseRequested(
            plan: plan,
            userAccountId: userAccountId,
          ),
        );
  }
}

/// Single subscription plan card with pricing, feature matrix and CTA.
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.isPro,
    required this.isBusy,
    required this.onSelect,
  });

  final MembershipPlan plan;
  final bool isPro;
  final bool isBusy;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.dark.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            plan.name,
            style: AppTypography.title.copyWith(
              color: isPro ? AppColors.teal : AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _PriceTag(price: plan.price),
          const SizedBox(height: AppSpacing.md),
          for (final _PlanFeature feature in _PlanFeature.values)
            _FeatureRow(
              label: feature.label,
              included: feature.includedFor(isPro),
            ),
          const SizedBox(height: AppSpacing.md),
          _SelectButton(isPro: isPro, isBusy: isBusy, onPressed: onSelect),
        ],
      ),
    );
  }
}

/// Composed price token, e.g. "S/. 59 /mes".
class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.price});

  final int price;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '${AppStrings.currencySymbol} $price ',
            style: AppTypography.displayLarge,
          ),
          TextSpan(
            text: AppStrings.perMonth,
            style: AppTypography.subtitle,
          ),
        ],
      ),
    );
  }
}

/// A single check/cross feature row.
class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.label, required this.included});

  final String label;
  final bool included;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: <Widget>[
          Icon(
            included ? Icons.check_rounded : Icons.close_rounded,
            size: 18,
            color: included
                ? AppColors.teal
                : AppColors.dark.withValues(alpha: 0.35),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.body.copyWith(
              color: included
                  ? AppColors.dark
                  : AppColors.dark.withValues(alpha: 0.35),
              decoration: included ? null : TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }
}

/// The plan CTA: a white/navy button for basic, a solid teal button for pro.
class _SelectButton extends StatelessWidget {
  const _SelectButton({
    required this.isPro,
    required this.isBusy,
    required this.onPressed,
  });

  final bool isPro;
  final bool isBusy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Widget child = isBusy
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          )
        : Text(
            AppStrings.selectPlan,
            style: AppTypography.label.copyWith(
              color: isPro ? AppColors.accentWhite : AppColors.primaryNavy,
            ),
          );

    return SizedBox(
      width: double.infinity,
      height: AppSizes.primaryButtonHeight,
      child: FilledButton(
        onPressed: isBusy ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isPro ? AppColors.teal : AppColors.surface,
          side: isPro
              ? null
              : const BorderSide(color: AppColors.primaryNavy),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
        ),
        child: child,
      ),
    );
  }
}

/// The fixed product feature catalogue and its per-tier inclusion.
///
/// The feature list is product-tier copy (not backend records): the basic tier
/// includes the first two features, while the pro tier includes all five.
enum _PlanFeature {
  /// Basic check-in feature.
  checkInBasic,

  /// Surveys feature.
  surveys,

  /// Labor forum feature.
  laborForum,

  /// HR messaging feature.
  hrMessaging,

  /// Encrypted reports feature.
  encryptedReports;

  /// Localized label for this feature.
  String get label {
    switch (this) {
      case _PlanFeature.checkInBasic:
        return AppStrings.featureCheckInBasic;
      case _PlanFeature.surveys:
        return AppStrings.featureSurveys;
      case _PlanFeature.laborForum:
        return AppStrings.featureLaborForum;
      case _PlanFeature.hrMessaging:
        return AppStrings.featureHrMessaging;
      case _PlanFeature.encryptedReports:
        return AppStrings.featureEncryptedReports;
    }
  }

  /// Whether this feature is included for the given tier.
  bool includedFor(bool isPro) {
    if (isPro) return true;
    return this == _PlanFeature.checkInBasic || this == _PlanFeature.surveys;
  }
}
