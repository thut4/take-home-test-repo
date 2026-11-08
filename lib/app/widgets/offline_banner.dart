import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/l10n/l10n.dart';

/// Small bar that slides down while the internet is unreachable. Unknown
/// (still checking) counts as online, so it never flashes on launch.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline = ref.watch(isOnlineProvider).value == false;
    return AnimatedSize(
      duration: context.motion(AppMotion.banner),
      curve: AppMotion.standard,
      alignment: Alignment.topCenter,
      child: offline ? const _Bar() : const SizedBox(width: double.infinity),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar();

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final style = theme.text.caption.copyWith(color: theme.colors.surface);
    return Semantics(
      liveRegion: true,
      child: Container(
        key: const Key('offline-banner'),
        width: double.infinity,
        color: AppArtColors.offlineBar,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.offline,
              size: AppSize.iconSm,
              color: theme.colors.surface,
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(child: Text(context.l10n.offlineBanner, style: style)),
          ],
        ),
      ),
    );
  }
}
