import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:jdonuts/core/app_assets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/member/domain/member.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Member header on the peach band: photo, name, tier, a white status pill
// and, optionally, the notification bell.
class MemberHeader extends StatelessWidget {
  const MemberHeader({
    super.key,
    required this.member,
    this.statusLabel,
    this.showBell = true,
  });

  final Member member;

  /// Text in the pill. Defaults to the points left to the next tier.
  final String? statusLabel;
  final bool showBell;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = context.l10n;
    final next = member.nextTier;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Avatar(path: member.photoPath),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.displayName,
                    style: theme.text.headline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    l10n.memberTier(member.tier.name),
                    style: theme.text.caption,
                  ),
                ],
              ),
            ),
            if (showBell) _Bell(count: member.notificationCount),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: theme.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            statusLabel ??
                (next == null
                    ? l10n.topTier
                    : l10n.pointsToNextTier(
                        l10n.number(member.pointsToNextTier),
                        next.name,
                      )),
            style: theme.text.caption.copyWith(color: theme.colors.onSurface),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.avatar,
      height: AppSize.avatar,
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: context.appTheme.colors.surface,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          AppAsset.catalogImage(path),
          fit: BoxFit.cover,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}

class _Bell extends StatelessWidget {
  const _Bell({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return AppPressable(
      semanticLabel: context.l10n.notifications(count),
      onPressed: () => showAppSnackbar(context, context.l10n.comingSoonBody),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: theme.colors.highlight,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.bell, color: theme.colors.onHighlight),
            if (count > 0) ...[
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: theme.colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '$count',
                  style: theme.text.caption.copyWith(
                    color: theme.colors.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// The rounded hexagon with a star behind the header, drawn to scale.
class HeaderBadgePainter extends CustomPainter {
  const HeaderBadgePainter();

  static const double size = 150;

  static const _points = 6;
  static const _starPoints = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final hexagon = Path();
    for (var i = 0; i < _points; i++) {
      final angle = math.pi / 3 * i + math.pi / 6;
      final point = centre + Offset.fromDirection(angle, radius);
      i == 0
          ? hexagon.moveTo(point.dx, point.dy)
          : hexagon.lineTo(point.dx, point.dy);
    }
    hexagon.close();
    canvas
      ..drawPath(
        hexagon,
        Paint()
          ..color = AppArtColors.headerBadge
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.fill,
      )
      ..drawPath(
        _star(centre, radius * 0.32),
        Paint()..color = AppArtColors.headerStar,
      );
  }

  Path _star(Offset centre, double radius) {
    final path = Path();
    for (var i = 0; i < _starPoints * 2; i++) {
      final r = i.isEven ? radius : radius * 0.45;
      final angle = -math.pi / 2 + math.pi / _starPoints * i;
      final point = centre + Offset.fromDirection(angle, r);
      i == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(HeaderBadgePainter oldDelegate) => false;
}

// Header placeholder while the member record loads.
class MemberHeaderSkeleton extends StatelessWidget {
  const MemberHeaderSkeleton({super.key});

  static const _nameWidth = 120.0;
  static const _pillWidth = 220.0;

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppSkeletonBox(
                width: AppSize.avatar,
                height: AppSize.avatar,
                radius: AppRadius.pill,
              ),
              SizedBox(width: AppSpacing.md),
              AppSkeletonBox(width: _nameWidth, height: AppSpacing.xl),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          AppSkeletonBox(
            width: _pillWidth,
            height: AppSpacing.lg,
            radius: AppRadius.pill,
          ),
        ],
      ),
    );
  }
}
