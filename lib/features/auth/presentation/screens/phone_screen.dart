import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/app/routes.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/domain/auth_failure.dart';
import 'package:jdonuts/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:jdonuts/features/auth/domain/validators/phone_validator.dart';
import 'package:jdonuts/features/auth/presentation/controllers/auth_flow_controller.dart';
import 'package:jdonuts/features/auth/presentation/widgets/auth_step_scaffold.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Step 1: phone number. Continue stays disabled until the number is
// valid; the rule's message appears once the field loses focus.
class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  late final TextEditingController _controller = TextEditingController(
    text: ref.read(authFlowControllerProvider).phoneInput,
  );
  final FocusNode _focus = FocusNode();
  bool _blurred = false;
  AuthFailure? _accountProblem;

  static final _allowedCharacters = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9+\s-]'),
  );
  static const _maxInputLength = 18;
  static const _maxDigits = 11;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus && _controller.text.isNotEmpty) {
        setState(() => _blurred = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    _focus.unfocus();
    final outcome = await ref
        .read(authFlowControllerProvider.notifier)
        .submitPhone();
    if (!mounted) return;
    switch (outcome) {
      case StepDone():
        await context.push(Routes.otp);
      case StepFailed(:final AuthFailure failure)
          when failure is PhoneNotRegisteredFailure ||
              failure is PhoneAlreadyRegisteredFailure:
        setState(() => _accountProblem = failure);
      case StepFailed(:final failure):
        showAppSnackbar(context, context.l10n.failureMessage(failure));
      case StepIgnored():
        break;
    }
  }

  void _switchMode(AuthMode mode) {
    ref.read(authFlowControllerProvider.notifier).switchMode(mode);
    setState(() => _accountProblem = null);
    unawaited(_submit());
  }

  String? _errorText() {
    final l10n = context.l10n;
    if (!_blurred) return null;
    return switch (validatePhone(_controller.text)) {
      PhoneError.empty => l10n.phoneErrorEmpty,
      PhoneError.invalid => l10n.phoneErrorInvalid,
      null => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(authFlowControllerProvider);
    final l10n = context.l10n;
    final isValid = validatePhone(flow.phoneInput) == null;
    return AuthStepScaffold(
      title: l10n.phoneTitle,
      step: flow.mode == AuthMode.register ? 1 : null,
      onBack: () => context.pop(),
      continueLabel: l10n.continueLabel,
      isLoading: flow.isSubmitting,
      onContinue: isValid ? _submit : null,
      children: [
        AppTextInput(
          key: const Key('phone-input'),
          controller: _controller,
          focusNode: _focus,
          prefixText: myanmarCountryCode,
          hintText: l10n.phoneHint,
          errorText: _errorText(),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.telephoneNumberNational],
          inputFormatters: [
            _allowedCharacters,
            LengthLimitingTextInputFormatter(_maxInputLength),
            const _MaxDigitsFormatter(_maxDigits),
          ],
          onChanged: (value) {
            ref.read(authFlowControllerProvider.notifier).setPhoneInput(value);
            if (_accountProblem != null) setState(() => _accountProblem = null);
          },
          onSubmitted: (_) => isValid ? _submit() : null,
        ),
        if (_accountProblem case final problem?)
          _AccountProblem(failure: problem, onSwitch: _switchMode),
      ],
    );
  }
}

// Ignores an edit that would leave more than [maxDigits] digits in the
// field. Spaces, dashes and a pasted `+` don't count.
class _MaxDigitsFormatter extends TextInputFormatter {
  const _MaxDigitsFormatter(this.maxDigits);

  final int maxDigits;

  static final _digit = RegExp(r'\d');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) =>
      _digit.allMatches(newValue.text).length > maxDigits ? oldValue : newValue;
}

// "This number isn't registered yet. Create an account" (and the reverse).
class _AccountProblem extends StatefulWidget {
  const _AccountProblem({required this.failure, required this.onSwitch});

  final AuthFailure failure;
  final ValueChanged<AuthMode> onSwitch;

  @override
  State<_AccountProblem> createState() => _AccountProblemState();
}

class _AccountProblemState extends State<_AccountProblem> {
  final _link = TapGestureRecognizer();

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.appTheme;
    final notRegistered = widget.failure is PhoneNotRegisteredFailure;
    _link.onTap = () =>
        widget.onSwitch(notRegistered ? AuthMode.register : AuthMode.logIn);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: AppEntrance(
        child: Semantics(
          liveRegion: true,
          child: Text.rich(
            key: const Key('account-problem'),
            TextSpan(
              style: theme.text.caption.copyWith(color: theme.colors.error),
              children: [
                TextSpan(
                  text: notRegistered
                      ? l10n.phoneNotRegistered
                      : l10n.phoneAlreadyRegistered,
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: notRegistered ? l10n.createAccount : l10n.logInInstead,
                  recognizer: _link,
                  style: TextStyle(
                    color: theme.colors.accent,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
