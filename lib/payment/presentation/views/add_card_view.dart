import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/presentation/components/app_text_field.dart';
import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../application/bloc/add_card_bloc.dart';
import '../navigation/payment_routes.dart';

/// Card-provisioning screen ("Agregar método de pago") — Screen 3.
///
/// Establishes the [AddCardBloc] provider boundary and delegates to the
/// stateful form body owning the field controllers.
class AddCardView extends StatelessWidget {
  /// Creates an [AddCardView].
  const AddCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddCardBloc>(
      create: (_) => GetIt.instance<AddCardBloc>(),
      child: const _AddCardScreen(),
    );
  }
}

/// Stateful body owning the field controllers for the card form.
class _AddCardScreen extends StatefulWidget {
  const _AddCardScreen();

  @override
  State<_AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<_AddCardScreen> {
  late final TextEditingController _holderController;
  late final TextEditingController _numberController;
  late final TextEditingController _expiryController;
  late final TextEditingController _cvvController;

  @override
  void initState() {
    super.initState();
    _holderController = TextEditingController();
    _numberController = TextEditingController();
    _expiryController = TextEditingController();
    _cvvController = TextEditingController();
  }

  @override
  void dispose() {
    _holderController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, AddCardState state) {
    if (state.status == AddCardStatus.success) {
      context.goNamed(PaymentRoutes.methodsName);
    } else if (state.status == AddCardStatus.failure) {
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
          onPressed: () => context.goNamed(PaymentRoutes.methodsName),
        ),
        title: Text(AppStrings.addPaymentMethod, style: AppTypography.title),
      ),
      body: BlocConsumer<AddCardBloc, AddCardState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: _onStateChanged,
        builder: (BuildContext context, AddCardState state) {
          final AddCardBloc bloc = context.read<AddCardBloc>();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _CardPreview(state: state),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: '',
                  controller: _holderController,
                  hintText: AppStrings.cardHolderHint,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => bloc.add(AddCardHolderChanged(value)),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: '',
                  controller: _numberController,
                  hintText: AppStrings.cardNumberHint,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.credit_card_rounded),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => bloc.add(AddCardNumberChanged(value)),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: AppTextField(
                        label: '',
                        controller: _expiryController,
                        hintText: AppStrings.expiryHint,
                        keyboardType: TextInputType.datetime,
                        prefixIcon: const Icon(Icons.calendar_today_rounded),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) =>
                            bloc.add(AddCardExpiryChanged(value)),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        label: '',
                        controller: _cvvController,
                        hintText: AppStrings.cvvHint,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        textInputAction: TextInputAction.done,
                        onChanged: (value) => bloc.add(AddCardCvvChanged(value)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _SaveCardSwitch(
                  value: state.saveCard,
                  onChanged: (bool value) =>
                      bloc.add(AddCardSaveToggled(value)),
                ),
                const SizedBox(height: AppSpacing.xl),
                _AddMethodFooterButton(
                  isBusy: state.status == AddCardStatus.submitting,
                  onPressed: state.canSubmit
                      ? () => bloc.add(const AddCardSubmitted())
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Realistic dark-teal digital card graphic reflecting the entered data, with
/// the mockup sample values as fallbacks.
class _CardPreview extends StatelessWidget {
  const _CardPreview({required this.state});

  final AddCardState state;

  @override
  Widget build(BuildContext context) {
    final String digits = state.digitsOnlyNumber;
    final String numberText = digits.length >= 4
        ? 'XXXX XXXX XXXX ${digits.substring(digits.length - 4)}'
        : 'XXXX XXXX XXXX 8790';
    final String holderText = state.cardHolder.trim().isEmpty
        ? 'RUSSELL AUSTIN'
        : state.cardHolder.trim().toUpperCase();
    final String expiryText =
        state.expiry.trim().isEmpty ? '01 / 22' : state.expiry.trim();

    return AspectRatio(
      aspectRatio: 1.6,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: AppGradients.paymentCard,
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const _BrandGlyphs(),
            const Spacer(),
            Text(
              numberText,
              style: AppTypography.title.copyWith(
                color: AppColors.accentWhite,
                letterSpacing: 2,
              ),
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: _CardCaption(
                    tag: AppStrings.cardHolderTag,
                    value: holderText,
                  ),
                ),
                _CardCaption(
                  tag: AppStrings.cardExpiresTag,
                  value: expiryText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The overlapping brand circles in the card's top-right corner.
class _BrandGlyphs extends StatelessWidget {
  const _BrandGlyphs();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 44,
        height: 26,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              child: _circle(AppColors.danger.withValues(alpha: 0.9)),
            ),
            Positioned(
              left: 18,
              child: _circle(AppColors.accentWhite.withValues(alpha: 0.85)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(Color color) => Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

/// A tag/value caption pair rendered on the card graphic.
class _CardCaption extends StatelessWidget {
  const _CardCaption({required this.tag, required this.value});

  final String tag;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tag,
          style: AppTypography.caption.copyWith(
            color: AppColors.accentWhite.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: AppTypography.body.copyWith(color: AppColors.accentWhite),
        ),
      ],
    );
  }
}

/// The "Save this card" switch row.
class _SaveCardSwitch extends StatelessWidget {
  const _SaveCardSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Switch(
          value: value,
          activeThumbColor: AppColors.sky,
          onChanged: onChanged,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(AppStrings.saveThisCard, style: AppTypography.body),
      ],
    );
  }
}

/// Full-width solid blue "Agregar método" footer button.
class _AddMethodFooterButton extends StatelessWidget {
  const _AddMethodFooterButton({required this.isBusy, required this.onPressed});

  final bool isBusy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.primaryButtonHeight,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.sky,
          foregroundColor: AppColors.accentWhite,
          disabledBackgroundColor: AppColors.sky.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
        ),
        child: isBusy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.accentWhite),
                ),
              )
            : Text(
                AppStrings.addMethod,
                style: AppTypography.label.copyWith(
                  color: AppColors.accentWhite,
                ),
              ),
      ),
    );
  }
}
