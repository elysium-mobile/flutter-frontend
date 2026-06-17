import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/presentation/components/danger_button.dart';
import '../../../shared/presentation/components/outlined_action_button.dart';
import '../../../shared/presentation/components/user_avatar.dart';
import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../application/bloc/session_bloc.dart';
import '../navigation/iam_routes.dart';

/// Profile view ("My Profile") of the authenticated shell.
///
/// Renders the user identity block (avatar with a camera overlay), the
/// "Employment Information" content box, a "Payment Methods" card link, and the
/// outlined "Edit Profile" / critical "Sign Out" action row. Because these
/// screens manipulate the core [User] model, the profile lives in the IAM
/// context. All copy is sourced from the i18n engine.
class ProfileView extends StatelessWidget {
  /// Creates a [ProfileView].
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(AppStrings.myProfile, style: AppTypography.title),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.goNamed(IamRoutes.profileEditName),
            child: Text(
              AppStrings.edit,
              style: AppTypography.label.copyWith(color: AppColors.sky),
            ),
          ),
        ],
      ),
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (BuildContext context, SessionState state) {
          final String name = state.user?.username ?? '';
          final String email = state.user?.email ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(child: _AvatarWithCamera(name: name)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: AppTypography.title,
                ),
                const SizedBox(height: AppSpacing.lg),
                _EmploymentInformationBox(email: email),
                const SizedBox(height: AppSpacing.md),
                const _PaymentMethodsLink(),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedActionButton(
                        label: AppStrings.editProfile,
                        onPressed: () =>
                            context.goNamed(IamRoutes.profileEditName),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: DangerButton(
                        label: AppStrings.signOut,
                        onPressed: () => context
                            .read<SessionBloc>()
                            .add(const SessionSignOutRequested()),
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

/// Avatar with a circular camera modification layer at its bottom-right.
class _AvatarWithCamera extends StatelessWidget {
  const _AvatarWithCamera({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        UserAvatar(name: name, diameter: 104),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.primaryNavy,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 2),
            ),
            child: Semantics(
              label: AppStrings.changePhoto,
              button: true,
              child: const Icon(
                Icons.photo_camera_rounded,
                size: 16,
                color: AppColors.accentWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// "Employment Information" content box with Company/Area/Role/Email rows.
class _EmploymentInformationBox extends StatelessWidget {
  const _EmploymentInformationBox({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.dark.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Text(
              AppStrings.employmentInformation,
              style: AppTypography.label,
            ),
          ),
          _InformationRow(
            label: AppStrings.company,
            value: AppStrings.notAssigned,
          ),
          _InformationRow(label: AppStrings.area, value: AppStrings.notAssigned),
          _InformationRow(label: AppStrings.role, value: AppStrings.notAssigned),
          _InformationRow(label: AppStrings.email, value: email),
        ],
      ),
    );
  }
}

/// A single label/value row inside the employment information box.
class _InformationRow extends StatelessWidget {
  const _InformationRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: AppTypography.body.copyWith(
                color: AppColors.dark.withValues(alpha: 0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.body,
            ),
          ),
        ],
      ),
    );
  }
}

/// Separate "Payment Methods" card link row.
class _PaymentMethodsLink extends StatelessWidget {
  const _PaymentMethodsLink();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accentWhite,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.card),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.primaryNavy,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  AppStrings.paymentMethods,
                  style: AppTypography.label,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primaryNavy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
