import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/presentation/components/app_logo.dart';
import '../../../shared/presentation/components/app_text_field.dart';
import '../../../shared/presentation/components/google_sign_in_button.dart';
import '../../../shared/presentation/components/gradient_button.dart';
import '../../../shared/presentation/components/labeled_divider.dart';
import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../application/bloc/login_bloc.dart';
import '../navigation/iam_routes.dart';

/// Login screen route widget.
///
/// Establishes the [LoginBloc] provider boundary (resolved from the service
/// locator) and delegates rendering to [_LoginScreen]. The bloc lives and dies
/// with this boundary; it never pollutes the locator with volatile UI scope.
class LoginView extends StatelessWidget {
  /// Creates a [LoginView].
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) => GetIt.instance<LoginBloc>(),
      child: const _LoginScreen(),
    );
  }
}

/// Stateful body owning the field controllers and wiring them to [LoginBloc].
class _LoginScreen extends StatefulWidget {
  const _LoginScreen();

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, LoginState state) {
    if (state.status == LoginStatus.success) {
      context.goNamed(IamRoutes.sessionStartedName);
    } else if (state.status == LoginStatus.failure) {
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
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: _onStateChanged,
          builder: (BuildContext context, LoginState state) {
            final LoginBloc bloc = context.read<LoginBloc>();
            final bool isBusy = state.status == LoginStatus.submitting;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  const Center(child: AppLogo()),
                  const SizedBox(height: AppSpacing.xl),
                  _LoginCard(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    state: state,
                    isBusy: isBusy,
                    onEmailChanged: (value) =>
                        bloc.add(LoginEmailChanged(value)),
                    onPasswordChanged: (value) =>
                        bloc.add(LoginPasswordChanged(value)),
                    onToggleVisibility: () =>
                        bloc.add(const LoginPasswordVisibilityToggled()),
                    onSubmit: () => bloc.add(const LoginSubmitted()),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LabeledDivider(label: AppStrings.orSeparator),
                  const SizedBox(height: AppSpacing.md),
                  GoogleSignInButton(
                    label: AppStrings.continueWithGoogle,
                    isLoading: isBusy,
                    onPressed: isBusy
                        ? null
                        : () => bloc.add(const LoginGoogleSubmitted()),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _SignUpPrompt(
                    onSignUp: () => context.goNamed(IamRoutes.registerName),
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

/// White input card grouping the credentials fields and the primary CTA.
class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.state,
    required this.isBusy,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onToggleVisibility,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoginState state;
  final bool isBusy;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onToggleVisibility;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primaryNavy.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppTextField(
            label: AppStrings.institutionalEmail,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: onEmailChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: AppStrings.password,
            controller: passwordController,
            obscureText: state.isPasswordObscured,
            textInputAction: TextInputAction.done,
            onChanged: onPasswordChanged,
            onSubmitted: (_) {
              if (state.canSubmit) onSubmit();
            },
            suffix: IconButton(
              tooltip: state.isPasswordObscured
                  ? AppStrings.showPassword
                  : AppStrings.hidePassword,
              icon: Icon(
                state.isPasswordObscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.dark.withValues(alpha: 0.6),
              ),
              onPressed: onToggleVisibility,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                AppStrings.forgotPassword,
                style: AppTypography.body.copyWith(
                  color: AppColors.sky,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          GradientButton(
            label: AppStrings.signIn,
            isLoading: isBusy,
            onPressed: state.canSubmit ? onSubmit : null,
          ),
        ],
      ),
    );
  }
}

/// Bottom-anchored "Don't have an account? Sign Up" prompt.
class _SignUpPrompt extends StatelessWidget {
  const _SignUpPrompt({required this.onSignUp});

  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(AppStrings.dontHaveAccount, style: AppTypography.body),
        GestureDetector(
          onTap: onSignUp,
          child: Text(
            AppStrings.signUp,
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
