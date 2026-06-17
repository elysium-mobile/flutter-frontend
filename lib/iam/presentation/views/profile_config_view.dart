import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/presentation/components/gradient_button.dart';
import '../../../shared/presentation/components/outlined_action_button.dart';
import '../../../shared/presentation/components/user_avatar.dart';
import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../application/bloc/session_bloc.dart';
import '../navigation/iam_routes.dart';

/// Profile configuration view ("Profile Configuration").
///
/// Adapts the profile into an active input form: an enlarged avatar focal point
/// and editable metadata lines (Company, Area, Role, Email) each carrying a
/// pencil modification indicator, closed by a "Back" / "Save Changes" action
/// row. Field controllers are local; profile persistence is intentionally out of
/// the current scope (no update capability is declared on the port).
class ProfileConfigView extends StatefulWidget {
  /// Creates a [ProfileConfigView].
  const ProfileConfigView({super.key});

  @override
  State<ProfileConfigView> createState() => _ProfileConfigViewState();
}

class _ProfileConfigViewState extends State<ProfileConfigView> {
  late final TextEditingController _companyController;
  late final TextEditingController _areaController;
  late final TextEditingController _roleController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // Seed the editable fields from the current session snapshot.
    final user = context.read<SessionBloc>().state.user;
    _companyController = TextEditingController();
    _areaController = TextEditingController();
    _roleController = TextEditingController();
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _companyController.dispose();
    _areaController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _returnToProfile() => context.goNamed(IamRoutes.profileName);

  @override
  Widget build(BuildContext context) {
    final String name = context.select<SessionBloc, String>(
      (bloc) => bloc.state.user?.username ?? '',
    );

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.profileConfiguration,
          style: AppTypography.title,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: AppSpacing.sm),
            Center(child: UserAvatar(name: name, diameter: 128)),
            const SizedBox(height: AppSpacing.xl),
            _EditableLine(
              label: AppStrings.company,
              controller: _companyController,
            ),
            _EditableLine(label: AppStrings.area, controller: _areaController),
            _EditableLine(label: AppStrings.role, controller: _roleController),
            _EditableLine(
              label: AppStrings.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedActionButton(
                    label: AppStrings.back,
                    onPressed: _returnToProfile,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: GradientButton(
                    label: AppStrings.saveChanges,
                    onPressed: _returnToProfile,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom editable metadata line: a label, an inline text field and an adjacent
/// pencil modification icon.
class _EditableLine extends StatelessWidget {
  const _EditableLine({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.dark.withValues(alpha: 0.6),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: AppTypography.input,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mint),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mint),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.sky),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColors.primaryNavy,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
