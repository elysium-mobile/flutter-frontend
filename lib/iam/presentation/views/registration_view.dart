import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/presentation/components/app_text_field.dart';
import '../../../shared/presentation/components/gradient_button.dart';
import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../../shared/presentation/utils/corporate_email.dart';
import '../../application/bloc/registration_bloc.dart';
import '../components/verified_domain_badge.dart';
import '../navigation/iam_routes.dart';

/// Email registration screen route widget.
///
/// Establishes the [RegistrationBloc] provider boundary (resolved from the
/// service locator) and delegates rendering to [_RegistrationScreen].
class RegistrationView extends StatelessWidget {
  /// Creates a [RegistrationView].
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegistrationBloc>(
      create: (_) => GetIt.instance<RegistrationBloc>(),
      child: const _RegistrationScreen(),
    );
  }
}

/// Stateful body owning the field controllers for the registration form.
class _RegistrationScreen extends StatefulWidget {
  const _RegistrationScreen();

  @override
  State<_RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<_RegistrationScreen> {
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, RegistrationState state) {
    if (state.status == RegistrationStatus.success) {
      context.goNamed(IamRoutes.userRegisteredName);
    } else if (state.status == RegistrationStatus.failure) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: AppColors.danger,
            content: Text(AppStrings.somethingWentWrong),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: BlocConsumer<RegistrationBloc, RegistrationState>(
          listener: _onStateChanged,
          builder: (BuildContext context, RegistrationState state) {
            final RegistrationBloc bloc = context.read<RegistrationBloc>();
            final bool isBusy = state.status == RegistrationStatus.submitting;
            final bool isDomainVerified =
                CorporateEmail.isCorporate(state.email);
            final bool showPasswordMismatch =
                state.confirmPassword.isNotEmpty && !state.passwordsMatch;
            final bool canSubmit =
                state.hasRequiredFields && isDomainVerified;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _RegistrationHeader(
                    onBack: () => context.goNamed(IamRoutes.loginName),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: AppStrings.username,
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) =>
                        bloc.add(RegistrationUsernameChanged(value)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _CorporateEmailField(
                    controller: _emailController,
                    isDomainVerified: isDomainVerified,
                    onChanged: (value) =>
                        bloc.add(RegistrationEmailChanged(value)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: AppStrings.password,
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) =>
                        bloc.add(RegistrationPasswordChanged(value)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: AppStrings.confirmPassword,
                    controller: _confirmPasswordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    errorText: showPasswordMismatch
                        ? AppStrings.passwordsDoNotMatch
                        : null,
                    onChanged: (value) =>
                        bloc.add(RegistrationConfirmPasswordChanged(value)),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GradientButton(
                    label: AppStrings.createAccount,
                    isLoading: isBusy,
                    onPressed: canSubmit
                        ? () => bloc.add(const RegistrationSubmitted())
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SignInPrompt(
                    onSignIn: () => context.goNamed(IamRoutes.loginName),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Custom back-navigation header with "Create account" title and subtitle.
class _RegistrationHeader extends StatelessWidget {
  const _RegistrationHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              onPressed: onBack,
              tooltip: AppStrings.back,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primaryNavy,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(AppStrings.createAccount, style: AppTypography.title),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(AppStrings.onlyCorporateEmails, style: AppTypography.subtitle),
      ],
    );
  }
}

/// Corporate email field augmented with the "✓ Verified domain" badge.
class _CorporateEmailField extends StatelessWidget {
  const _CorporateEmailField({
    required this.controller,
    required this.isDomainVerified,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool isDomainVerified;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(AppStrings.corporateEmail, style: AppTypography.label),
            const SizedBox(width: AppSpacing.xs),
            if (isDomainVerified) const VerifiedDomainBadge(),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        AppTextField(
          label: '',
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Bottom "Already have an account? Sign In" prompt.
class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(AppStrings.alreadyHaveAccount, style: AppTypography.body),
        GestureDetector(
          onTap: onSignIn,
          child: Text(
            AppStrings.signIn,
            style: AppTypography.body.copyWith(
              color: AppColors.teal,
              fontWeight: AppTypography.bold,
            ),
          ),
        ),
      ],
    );
  }
}
