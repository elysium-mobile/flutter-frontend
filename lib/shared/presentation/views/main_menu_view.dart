import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../iam/application/bloc/session_bloc.dart';
import '../components/user_avatar.dart';
import '../design/app_colors.dart';
import '../design/app_dimensions.dart';
import '../design/app_typography.dart';
import '../i18n/app_strings.dart';

/// Lightweight, immutable presentation model for an assigned team entry.
///
/// The teams domain is not part of the current system declaration, so this view
/// renders representative sample data purely for layout fidelity until a
/// dedicated bounded context provides the real source.
class _AssignedTeam {
  const _AssignedTeam({required this.company, required this.team});

  /// Owning company name.
  final String company;

  /// Team name within the company.
  final String team;
}

/// "Dashboard" main menu view of the authenticated shell.
///
/// Shows the user greeting block (avatar initials, bold name, role/company
/// caption) and the "Assigned Teams" container card wrapping per-team sub-cards.
/// All labels come from the i18n engine; layout metrics use design tokens.
class MainMenuView extends StatelessWidget {
  /// Creates a [MainMenuView].
  const MainMenuView({super.key});

  /// Representative sample teams (see [_AssignedTeam]).
  static const List<_AssignedTeam> _sampleTeams = <_AssignedTeam>[
    _AssignedTeam(company: 'SoftWork', team: 'Platform'),
    _AssignedTeam(company: 'SoftWork', team: 'People Operations'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(AppStrings.dashboardTitle, style: AppTypography.title),
      ),
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (BuildContext context, SessionState state) {
          final String name = state.user?.username ?? '';
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: AppSpacing.sm),
                Center(child: UserAvatar(name: name)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: AppTypography.title,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${AppStrings.employeeRole} · ${AppStrings.appName}',
                  textAlign: TextAlign.center,
                  style: AppTypography.subtitle,
                ),
                const SizedBox(height: AppSpacing.lg),
                _AssignedTeamsCard(teams: _sampleTeams),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Isolated container card titled "Assigned Teams" wrapping the team sub-cards.
class _AssignedTeamsCard extends StatelessWidget {
  const _AssignedTeamsCard({required this.teams});

  final List<_AssignedTeam> teams;

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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xs,
            ),
            child: Text(AppStrings.assignedTeams, style: AppTypography.label),
          ),
          for (final _AssignedTeam team in teams) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            _TeamSubCard(team: team),
          ],
        ],
      ),
    );
  }
}

/// Sub-card showing "Company" and "Team" metadata with a navigation chevron.
class _TeamSubCard extends StatelessWidget {
  const _TeamSubCard({required this.team});

  final _AssignedTeam team;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accentWhite,
      borderRadius: BorderRadius.circular(AppRadii.button),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.button),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _MetadataColumn(
                  label: AppStrings.company,
                  value: team.company,
                ),
              ),
              Expanded(
                child: _MetadataColumn(
                  label: AppStrings.team,
                  value: team.team,
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

/// Stacked label/value metadata pair rendered inside a team sub-card.
class _MetadataColumn extends StatelessWidget {
  const _MetadataColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.dark.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(value, style: AppTypography.body),
      ],
    );
  }
}
