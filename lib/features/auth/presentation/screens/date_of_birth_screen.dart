import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/domain/validators/date_of_birth_validator.dart';
import 'package:jdonuts/features/auth/presentation/controllers/auth_flow_controller.dart';
import 'package:jdonuts/features/auth/presentation/widgets/auth_step_scaffold.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Step 4: month, day and year, chosen on one wheel sheet (no typing). The
// year wheel starts at the latest year that can make someone 13. Continue
// creates the account; the router then shows Welcome.
class DateOfBirthScreen extends ConsumerStatefulWidget {
  const DateOfBirthScreen({super.key});

  @override
  ConsumerState<DateOfBirthScreen> createState() => _DateOfBirthState();
}

class _DateOfBirthState extends ConsumerState<DateOfBirthScreen> {
  late final AuthFlowState _initial = ref.read(authFlowControllerProvider);
  late int? _month = _initial.month;
  late int? _day = _initial.day;
  late int? _year = _initial.year;

  List<String> get _monthNames {
    final format = DateFormat.MMMM(context.l10n.localeName);
    return [for (var m = 1; m <= 12; m++) format.format(DateTime(2000, m))];
  }

  List<int> get _years => selectableBirthYears(ref.read(clockProvider)());

  void _save() => ref
      .read(authFlowControllerProvider.notifier)
      .setDateOfBirth(month: _month, day: _day, year: _year);

  // Where the wheels start when nothing is chosen yet.
  static const _defaultMonth = 1;
  static const _defaultDay = 1;
  static const _defaultYear = 2000;

  // One sheet with month, day and year wheels, whichever field was tapped.
  Future<void> _openWheels() async {
    final l10n = context.l10n;
    final months = _monthNames;
    final years = _years;
    final yearIndex = years.indexOf(_year ?? _defaultYear);
    final picked = await showAppWheelPickerSheet(
      context,
      title: l10n.dobSheetTitle,
      confirmLabel: l10n.done,
      columns: [
        AppWheelColumn(
          label: l10n.monthHint,
          options: months,
          initialIndex: (_month ?? _defaultMonth) - 1,
          flex: 3,
        ),
        AppWheelColumn(
          label: l10n.dayHint,
          options: [for (final d in selectableDays) '$d'],
          initialIndex: selectableDays.indexOf(_day ?? _defaultDay),
          flex: 2,
        ),
        AppWheelColumn(
          label: l10n.yearHint,
          options: [for (final y in years) '$y'],
          initialIndex: yearIndex < 0 ? 0 : yearIndex,
          flex: 2,
        ),
      ],
      validate: (s) => _message(
        _validate(
          month: s[0] + 1,
          day: selectableDays[s[1]],
          year: years[s[2]],
        ),
      ),
    );
    FocusManager.instance.primaryFocus?.unfocus();
    if (picked == null || !mounted) return;
    setState(() {
      _month = picked[0] + 1;
      _day = selectableDays[picked[1]];
      _year = years[picked[2]];
    });
    _save();
  }

  Future<void> _submit() async {
    _save();
    final outcome = await ref
        .read(authFlowControllerProvider.notifier)
        .submitDateOfBirth();
    if (!mounted) return;
    if (outcome case StepFailed(:final failure)) {
      showAppSnackbar(context, context.l10n.failureMessage(failure));
    }
  }

  DateOfBirthError? get _error =>
      _validate(month: _month, day: _day, year: _year);

  DateOfBirthError? _validate({int? month, int? day, int? year}) =>
      validateDateOfBirth(
        year: year,
        month: month,
        day: day,
        today: ref.read(clockProvider)(),
      );

  String? _message(DateOfBirthError? error) => switch (error) {
    DateOfBirthError.invalidDate => context.l10n.dobErrorInvalid,
    DateOfBirthError.inFuture => context.l10n.dobErrorFuture,
    DateOfBirthError.tooYoung => context.l10n.dobErrorTooYoung(minimumAgeYears),
    DateOfBirthError.incomplete || null => null,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final flow = ref.watch(authFlowControllerProvider);
    final error = _error;
    final month = _month;
    return AuthStepScaffold(
      title: l10n.dobTitle,
      step: 4,
      onBack: () {
        _save();
        context.pop();
      },
      continueLabel: l10n.continueLabel,
      isLoading: flow.isSubmitting,
      onContinue: error == null ? _submit : null,
      children: [
        _PickerField(
          key: const Key('month-input'),
          hint: l10n.monthHint,
          value: month == null ? null : _monthNames[month - 1],
          onTap: _openWheels,
        ),
        const SizedBox(height: AppSpacing.lg),
        _PickerField(
          key: const Key('day-input'),
          hint: l10n.dayHint,
          value: _day?.toString(),
          onTap: _openWheels,
        ),
        const SizedBox(height: AppSpacing.lg),
        _PickerField(
          key: const Key('year-input'),
          hint: l10n.yearHint,
          value: _year?.toString(),
          onTap: _openWheels,
          errorText: _message(error),
        ),
      ],
    );
  }
}

// A read-only field that opens a picker sheet; shows [value] or [hint].
class _PickerField extends StatefulWidget {
  const _PickerField({
    super.key,
    required this.hint,
    required this.value,
    required this.onTap,
    this.errorText,
  });

  final String hint;
  final String? value;
  final VoidCallback onTap;
  final String? errorText;

  @override
  State<_PickerField> createState() => _PickerFieldState();
}

class _PickerFieldState extends State<_PickerField> {
  late final _controller = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(_PickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.text = widget.value ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextInput(
      controller: _controller,
      hintText: widget.hint,
      readOnly: true,
      onTap: widget.onTap,
      errorText: widget.errorText,
      suffix: const Icon(AppIcons.expand),
    );
  }
}
