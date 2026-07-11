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

/// Arguments passed (via `GoRouter` `extra`, never the URL) to seed the
/// registration form with a verified Google context for phase-2 sign-up.
///
/// The [idToken] is sensitive and is deliberately never placed in a query
/// string; it travels only through the in-memory route `extra`.
class GoogleSignUpArgs {
  /// Creates a [GoogleSignUpArgs].
  const GoogleSignUpArgs({required this.idToken, required this.email});

  /// The verified Google ID token to replay on submit.
  final String idToken;

  /// The Google account email, prefilled and locked in the form.
  final String email;
}

/// RRHH registration screen route widget.
///
/// Establishes the [RegistrationBloc] provider boundary (resolved from the
/// service locator). When [googleContext] is provided, the form runs in phase-2
/// Google sign-up mode: the email is locked and the password fields are hidden.
class RegistrationView extends StatelessWidget {
  /// Creates a [RegistrationView].
  const RegistrationView({super.key, this.googleContext});

  /// Optional verified Google context that switches the form into Google mode.
  final GoogleSignUpArgs? googleContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegistrationBloc>(
      create: (_) {
        final RegistrationBloc bloc = GetIt.instance<RegistrationBloc>();
        final GoogleSignUpArgs? args = googleContext;
        if (args != null) {
          bloc.add(RegistrationGoogleContextProvided(
            idToken: args.idToken,
            email: args.email,
          ));
        }
        return bloc;
      },
      child: _RegistrationScreen(googleEmail: googleContext?.email),
    );
  }
}

/// Stateful body owning the field controllers for the registration form.
class _RegistrationScreen extends StatefulWidget {
  const _RegistrationScreen({this.googleEmail});

  final String? googleEmail;

  @override
  State<_RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<_RegistrationScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dniController;
  late final TextEditingController _departmentController;
  late final TextEditingController _hierarchyController;
  late final TextEditingController _anonymousNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _dniController = TextEditingController();
    _departmentController = TextEditingController();
    _hierarchyController = TextEditingController();
    _anonymousNameController = TextEditingController();
    _emailController = TextEditingController(text: widget.googleEmail ?? '');
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dniController.dispose();
    _departmentController.dispose();
    _hierarchyController.dispose();
    _anonymousNameController.dispose();
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
            content: Text(_readableError(state.errorMessage)),
          ),
        );
    }
  }

  /// Presents the specific backend/transport failure when available, stripping
  /// the leading `Exception:` noise, and falls back to the generic message.
  String _readableError(String? raw) {
    if (raw == null || raw.trim().isEmpty) return AppStrings.somethingWentWrong;
    return raw.replaceFirst(RegExp(r'^Exception:\s*'), '').trim();
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
            final bool isGoogle = state.isGoogleMode;
            final bool isDomainVerified =
                CorporateEmail.isCorporate(state.email);
            final bool showPasswordMismatch =
                state.confirmPassword.isNotEmpty && !state.passwordsMatch;

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
                  if (isGoogle) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      AppStrings.googleSignUpIntro,
                      style: AppTypography.subtitle,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: AppStrings.firstNameLabel,
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => bloc.add(RegistrationNameChanged(v)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: AppStrings.lastNameLabel,
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => bloc.add(RegistrationLastNameChanged(v)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: AppStrings.phoneNumberLabel,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => bloc.add(RegistrationPhoneChanged(v)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: AppStrings.dniLabel,
                    controller: _dniController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => bloc.add(RegistrationDniChanged(v)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: AppStrings.rrhhDepartmentLabel,
                    controller: _departmentController,
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => bloc.add(RegistrationDepartmentChanged(v)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: AppStrings.statusHierarchyLabel,
                    controller: _hierarchyController,
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => bloc.add(RegistrationHierarchyChanged(v)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (isGoogle)
                    _LockedEmailField(email: state.email)
                  else
                    ..._classicCredentialFields(
                      bloc: bloc,
                      isDomainVerified: isDomainVerified,
                      showPasswordMismatch: showPasswordMismatch,
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  GradientButton(
                    label: isGoogle
                        ? AppStrings.completeSignUp
                        : AppStrings.createAccount,
                    isLoading: isBusy,
                    onPressed: state.canSubmit
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

  /// The classic-mode credential fields (email + anonymous name + passwords).
  List<Widget> _classicCredentialFields({
    required RegistrationBloc bloc,
    required bool isDomainVerified,
    required bool showPasswordMismatch,
  }) {
    return <Widget>[
      _CorporateEmailField(
        controller: _emailController,
        isDomainVerified: isDomainVerified,
        onChanged: (v) => bloc.add(RegistrationEmailChanged(v)),
      ),
      const SizedBox(height: AppSpacing.sm),
      AppTextField(
        label: AppStrings.anonymousNameLabel,
        controller: _anonymousNameController,
        textInputAction: TextInputAction.next,
        onChanged: (v) => bloc.add(RegistrationAnonymousNameChanged(v)),
      ),
      const SizedBox(height: AppSpacing.sm),
      AppTextField(
        label: AppStrings.password,
        controller: _passwordController,
        obscureText: true,
        textInputAction: TextInputAction.next,
        onChanged: (v) => bloc.add(RegistrationPasswordChanged(v)),
      ),
      const SizedBox(height: AppSpacing.sm),
      AppTextField(
        label: AppStrings.confirmPassword,
        controller: _confirmPasswordController,
        obscureText: true,
        textInputAction: TextInputAction.done,
        errorText:
            showPasswordMismatch ? AppStrings.passwordsDoNotMatch : null,
        onChanged: (v) => bloc.add(RegistrationConfirmPasswordChanged(v)),
      ),
    ];
  }
}

/// Read-only field displaying the locked Google account email.
class _LockedEmailField extends StatelessWidget {
  const _LockedEmailField({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(AppStrings.accountEmailLabel, style: AppTypography.label),
        const SizedBox(height: AppSpacing.xs),
        Container(
          width: double.infinity,
          height: AppSizes.inputHeight,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.accentWhite,
            borderRadius: BorderRadius.circular(AppRadii.input),
            border: Border.all(color: AppColors.mint),
          ),
          child: Row(
            children: <Widget>[
              const Icon(Icons.lock_outline_rounded,
                  size: 18, color: AppColors.dark),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  email,
                  style: AppTypography.input,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
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
