import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/app_cta_button.dart';
import 'package:jdonuts/design_system/components/app_motion.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/motion_tokens.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';
import 'package:jdonuts/design_system/tokens/typography_tokens.dart';
import 'package:material_ui/material_ui.dart' as material;

/// One wheel in [showAppWheelPickerSheet].
@immutable
class AppWheelColumn {
  const AppWheelColumn({
    required this.label,
    required this.options,
    this.initialIndex = 0,
    this.flex = 1,
  });

  /// Read by screen readers ("Month", "Day", "Year").
  final String label;
  final List<String> options;
  final int initialIndex;
  final int flex;
}

/// Bottom sheet with side-by-side wheels (for example month, day, year),
/// a highlighted selection band, a live [validate] message and a
/// [confirmLabel] button. Resolves to the selected index of each column,
/// or null if dismissed. Brand-only: same on every platform.
Future<List<int>?> showAppWheelPickerSheet(
  BuildContext context, {
  required String title,
  required List<AppWheelColumn> columns,
  required String confirmLabel,
  String? Function(List<int> selection)? validate,
}) {
  return material.showModalBottomSheet<List<int>>(
    context: context,
    builder: (context) => _WheelSheet(
      title: title,
      columns: columns,
      confirmLabel: confirmLabel,
      validate: validate,
    ),
  );
}

class _WheelSheet extends StatefulWidget {
  const _WheelSheet({
    required this.title,
    required this.columns,
    required this.confirmLabel,
    this.validate,
  });

  final String title;
  final List<AppWheelColumn> columns;
  final String confirmLabel;
  final String? Function(List<int> selection)? validate;

  @override
  State<_WheelSheet> createState() => _WheelSheetState();
}

class _WheelSheetState extends State<_WheelSheet> {
  late final List<int> _selection = [
    for (final c in widget.columns) c.initialIndex,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final message = widget.validate?.call(_selection);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenGutter,
          0,
          AppSpacing.screenGutter,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: theme.text.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            _Wheels(
              columns: widget.columns,
              selection: _selection,
              onChanged: (column, index) =>
                  setState(() => _selection[column] = index),
            ),
            _LiveMessage(message: message),
            const SizedBox(height: AppSpacing.lg),
            AppCtaButton(
              key: const Key('wheel-done'),
              label: widget.confirmLabel,
              onPressed: () => Navigator.of(context).pop([..._selection]),
            ),
          ],
        ),
      ),
    );
  }
}

/// The wheels over one shared selection band, faded at top and bottom.
class _Wheels extends StatelessWidget {
  const _Wheels({
    required this.columns,
    required this.selection,
    required this.onChanged,
  });

  final List<AppWheelColumn> columns;
  final List<int> selection;
  final void Function(int column, int index) onChanged;

  static const double itemExtent = AppSize.minTouchTarget - AppSpacing.xs;
  static const _visibleRows = 5;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    return SizedBox(
      height: itemExtent * _visibleRows,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: itemExtent,
            decoration: BoxDecoration(
              color: colors.backgroundBlush,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          Row(
            children: [
              for (final (index, column) in columns.indexed)
                Expanded(
                  flex: column.flex,
                  child: _Wheel(
                    key: Key('wheel-$index'),
                    column: column,
                    selected: selection[index],
                    onChanged: (value) => onChanged(index, value),
                  ),
                ),
            ],
          ),
          IgnorePointer(child: _EdgeFade(color: colors.surface)),
        ],
      ),
    );
  }
}

class _Wheel extends StatefulWidget {
  const _Wheel({
    super.key,
    required this.column,
    required this.selected,
    required this.onChanged,
  });

  final AppWheelColumn column;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  State<_Wheel> createState() => _WheelState();
}

class _WheelState extends State<_Wheel> {
  late final _controller = FixedExtentScrollController(
    initialItem: widget.column.initialIndex,
  );

  static const _diameterRatio = 1.6;
  static const _squeeze = 1.05;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Tapping a row turns the wheel to it.
  void _jumpTo(int index) => _controller.animateToItem(
    index,
    duration: context.motion(AppMotion.medium),
    curve: AppMotion.standard,
  );

  @override
  Widget build(BuildContext context) {
    final options = widget.column.options;
    return Semantics(
      label: widget.column.label,
      value: options[widget.selected],
      child: ListWheelScrollView.useDelegate(
        controller: _controller,
        itemExtent: _Wheels.itemExtent,
        diameterRatio: _diameterRatio,
        squeeze: _squeeze,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) async {
          widget.onChanged(index);
          await HapticFeedback.selectionClick();
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: options.length,
          builder: (context, index) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _jumpTo(index),
            child: _WheelItem(
              text: options[index],
              isSelected: index == widget.selected,
            ),
          ),
        ),
      ),
    );
  }
}

class _WheelItem extends StatelessWidget {
  const _WheelItem({required this.text, required this.isSelected});

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Center(
      child: AnimatedDefaultTextStyle(
        duration: context.motion(AppMotion.fast),
        style: isSelected
            ? theme.text.title.copyWith(color: theme.colors.accent)
            : theme.text.body.copyWith(color: theme.colors.onSurfaceMuted),
        child: Text(text, maxLines: 1, overflow: TextOverflow.fade),
      ),
    );
  }
}

class _EdgeFade extends StatelessWidget {
  const _EdgeFade({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final clear = color.withValues(alpha: 0);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color, clear, clear, color],
          stops: const [0, 0.3, 0.7, 1],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}

/// Validation message under the wheels; keeps its height so the sheet
/// doesn't jump.
class _LiveMessage extends StatelessWidget {
  const _LiveMessage({required this.message});

  /// Room for two caption lines, so the sheet keeps its height.
  static const _reservedLines = 2;

  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final message = this.message;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.textScalerOf(context)
              .scale(AppTypography.caption.lineHeight * _reservedLines),
        ),
        child: AnimatedSwitcher(
          duration: context.motion(AppMotion.fast),
          child: message == null
              ? const SizedBox.shrink()
              : Semantics(
                  liveRegion: true,
                  child: Text(
                    message,
                    key: ValueKey(message),
                    textAlign: TextAlign.center,
                    style: theme.text.caption.copyWith(
                      color: theme.colors.error,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
