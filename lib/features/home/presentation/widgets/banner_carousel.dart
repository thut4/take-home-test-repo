import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:jdonuts/app/widgets/catalog_image.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/home/domain/home_content.dart';

// Auto-playing banner carousel. Pauses while the user drags and stops
// under Reduce Motion.
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key, required this.banners});

  final List<PromoBanner> banners;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  static const _viewportFraction = 0.86;
  final _controller = PageController(viewportFraction: _viewportFraction);
  Timer? _timer;
  int _page = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _restartTimer();
  }

  void _restartTimer() {
    _timer?.cancel();
    if (context.reduceMotion || widget.banners.length < 2) return;
    _timer = Timer.periodic(AppMotion.carouselInterval, (_) => _advance());
  }

  void _advance() {
    if (!_controller.hasClients) return;
    final next = (_page + 1) % widget.banners.length;
    _controller.animateToPage(
      next,
      duration: AppMotion.carouselSlide,
      curve: AppMotion.standard,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppSize.bannerHeight,
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n is ScrollStartNotification && n.dragDetails != null) {
                _timer?.cancel();
              } else if (n is ScrollEndNotification) {
                _restartTimer();
              }
              return false;
            },
            child: PageView.builder(
              controller: _controller,
              padEnds: false,
              itemCount: widget.banners.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: AppSpacing.listGutter),
                child: _BannerCard(banner: widget.banners[index]),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _Dots(count: widget.banners.length, active: _page),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner});

  final PromoBanner banner;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final background = switch (banner.style) {
      BannerStyle.feature => theme.colors.surfaceFeature,
      BannerStyle.primary => theme.colors.primary,
      BannerStyle.accent => theme.colors.accent,
    };
    return Semantics(
      label: '${banner.tag}. ${banner.title}',
      excludeSemantics: true,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Row(
          children: [
            Expanded(child: _BannerText(banner: banner)),
            Expanded(
              child: CatalogImage(
                path: banner.imagePath,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerText extends StatelessWidget {
  const _BannerText({required this.banner});

  final PromoBanner banner;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppBadge(label: banner.tag),
          const SizedBox(height: AppSpacing.sm),
          Flexible(
            child: Text(
              banner.title,
              style: theme.text.title.copyWith(color: theme.colors.onPrimary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: context.motion(AppMotion.medium),
              curve: AppMotion.standard,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              width: i == active
                  ? AppSpacing.lg
                  : AppSpacing.xs + AppSpacing.xxs,
              height: AppSpacing.xs + AppSpacing.xxs,
              decoration: BoxDecoration(
                color: i == active ? colors.accent : colors.border,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
        ],
      ),
    );
  }
}
