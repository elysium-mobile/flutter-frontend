import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/presentation/components/app_text_field.dart';
import '../../../shared/presentation/components/gradient_button.dart';
import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../application/bloc/dashboard_assistant_bloc.dart';
import '../../domain/models/climate_diagnosis.dart';
import '../../domain/models/company.dart';
import '../components/climate_report_content.dart';

/// HR AI Climate Assistant view — a full-screen diagnosis surface backed by the
/// `POST /api/v1/dashboard-assistant` endpoint.
///
/// The HR specialist selects a company, optionally types a steering question,
/// and requests an AI climate diagnosis. The result renders via the shared
/// [ClimateReportContent] (status banner, markdown analysis and per-area
/// metrics). All state is owned by [DashboardAssistantBloc]; this view holds
/// only the ephemeral question-field controller.
class HrAiAssistantView extends StatefulWidget {
  /// Creates an [HrAiAssistantView].
  const HrAiAssistantView({super.key});

  @override
  State<HrAiAssistantView> createState() => _HrAiAssistantViewState();
}

class _HrAiAssistantViewState extends State<HrAiAssistantView> {
  /// Backs the optional steering-question field. Created in [initState] and
  /// released in [dispose], per the resource-lifecycle discipline.
  late final TextEditingController _questionController;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _requestDiagnosis(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<DashboardAssistantBloc>().add(
          ClimateDiagnosisRequested(question: _questionController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(AppStrings.aiAssistantTitle, style: AppTypography.title),
      ),
      body: BlocBuilder<DashboardAssistantBloc, DashboardAssistantState>(
        builder: (BuildContext context, DashboardAssistantState state) {
          if (state.status == DashboardAssistantStatus.loadingCompanies) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _CompanySelector(
                  companies: state.companies,
                  selectedCompany: state.selectedCompany,
                  onSelected: (Company company) => context
                      .read<DashboardAssistantBloc>()
                      .add(DashboardAssistantCompanySelected(company)),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: AppStrings.climateQuestionLabel,
                  controller: _questionController,
                  hintText: AppStrings.climateQuestionHint,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (state.canDiagnose) _requestDiagnosis(context);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                GradientButton(
                  label: AppStrings.analyzeClimate,
                  isLoading: state.isDiagnosing,
                  onPressed: state.canDiagnose
                      ? () => _requestDiagnosis(context)
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                _ResultSection(state: state),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Company dropdown selector, presenting a neutral hint until one is chosen.
class _CompanySelector extends StatelessWidget {
  const _CompanySelector({
    required this.companies,
    required this.selectedCompany,
    required this.onSelected,
  });

  final List<Company> companies;
  final Company? selectedCompany;
  final ValueChanged<Company> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppStrings.chooseCompany,
          style: AppTypography.caption.copyWith(
            color: AppColors.dark.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.accentWhite,
            borderRadius: BorderRadius.circular(AppRadii.input),
            border: Border.all(color: AppColors.mint),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Company>(
              value: selectedCompany,
              isExpanded: true,
              hint: Text(
                AppStrings.selectCompanyHint,
                style: AppTypography.input.copyWith(
                  color: AppColors.dark.withValues(alpha: 0.4),
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primaryNavy,
              ),
              style: AppTypography.input,
              borderRadius: BorderRadius.circular(AppRadii.input),
              items: <DropdownMenuItem<Company>>[
                for (final Company company in companies)
                  DropdownMenuItem<Company>(
                    value: company,
                    child: Text(company.name, style: AppTypography.input),
                  ),
              ],
              onChanged: (Company? company) {
                if (company != null) onSelected(company);
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Reactive result region: prompt, failure message, or the resolved diagnosis.
class _ResultSection extends StatelessWidget {
  const _ResultSection({required this.state});

  final DashboardAssistantState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == DashboardAssistantStatus.failure) {
      return Center(
        child: Text(
          AppStrings.somethingWentWrong,
          textAlign: TextAlign.center,
          style: AppTypography.subtitle,
        ),
      );
    }

    final ClimateDiagnosis? diagnosis = state.diagnosis;
    if (diagnosis == null) {
      return Center(
        child: Text(
          AppStrings.selectCompanyToStart,
          textAlign: TextAlign.center,
          style: AppTypography.subtitle,
        ),
      );
    }

    return ClimateReportContent(diagnosis: diagnosis);
  }
}
