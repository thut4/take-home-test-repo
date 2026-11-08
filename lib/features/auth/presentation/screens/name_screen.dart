import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/app/routes.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/domain/validators/name_validator.dart';
import 'package:jdonuts/features/auth/presentation/controllers/auth_flow_controller.dart';
import 'package:jdonuts/features/auth/presentation/widgets/auth_step_scaffold.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Step 3: first name (required) and last name (optional).
class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key});

  @override
  ConsumerState<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> {
  late final _first = TextEditingController(
    text: ref.read(authFlowControllerProvider).firstName,
  );
  late final _last = TextEditingController(
    text: ref.read(authFlowControllerProvider).lastName,
  );
  final _firstFocus = FocusNode();
  final _lastFocus = FocusNode();
  bool _firstBlurred = false;

  @override
  void initState() {
    super.initState();
    _firstFocus.addListener(() {
      if (!_firstFocus.hasFocus) setState(() => _firstBlurred = true);
    });
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _firstFocus.dispose();
    _lastFocus.dispose();
    super.dispose();
  }

  void _save() => ref
      .read(authFlowControllerProvider.notifier)
      .setNames(firstName: _first.text, lastName: _last.text);

  void _continue() {
    _save();
    FocusScope.of(context).unfocus();
    unawaited(context.push(Routes.dateOfBirth));
  }

  String? _message(NameError? error) => switch (error) {
    NameError.required => context.l10n.nameErrorRequired,
    NameError.tooLong => context.l10n.nameErrorTooLong,
    NameError.invalidCharacters => context.l10n.nameErrorCharacters,
    null => null,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final firstError = validateFirstName(_first.text);
    final lastError = validateLastName(_last.text);
    // "Required" waits for the field to lose focus; a bad character shows
    // as soon as it is typed.
    final shownFirstError = firstError == NameError.required && !_firstBlurred
        ? null
        : firstError;
    final valid = firstError == null && lastError == null;
    return AuthStepScaffold(
      title: l10n.nameTitle,
      step: 3,
      onBack: () {
        _save();
        context.pop();
      },
      continueLabel: l10n.continueLabel,
      onContinue: valid ? _continue : null,
      children: [
        AppTextInput(
          key: const Key('first-name-input'),
          controller: _first,
          focusNode: _firstFocus,
          hintText: l10n.firstNameHint,
          errorText: _message(shownFirstError),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.givenName],
          onChanged: (_) => setState(_save),
          onSubmitted: (_) => _lastFocus.requestFocus(),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextInput(
          key: const Key('last-name-input'),
          controller: _last,
          focusNode: _lastFocus,
          hintText: l10n.lastNameHint,
          errorText: _message(lastError),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.familyName],
          onChanged: (_) => setState(_save),
          onSubmitted: (_) => valid ? _continue() : null,
        ),
      ],
    );
  }
}
