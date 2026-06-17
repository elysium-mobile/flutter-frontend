import 'package:flutter/material.dart';

import '../design/app_colors.dart';
import '../design/app_typography.dart';
import '../i18n/app_strings.dart';

/// Reports tab of the authenticated shell.
///
/// A minimal placeholder: reports have no dedicated bounded context yet, so this
/// renders the localized empty state while reserving the navigation target.
class ReportsView extends StatelessWidget {
  /// Creates a [ReportsView].
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(AppStrings.reportsTab, style: AppTypography.title),
      ),
      body: Center(
        child: Text(AppStrings.noReportsYet, style: AppTypography.subtitle),
      ),
    );
  }
}
