import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts/core/app_assets.dart';
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/design_system/design_system.dart';

/// A catalogue image by its data path (`products/coconut.png`): loaded from
/// the server through the disk cache, with the bundled seed copy as the
/// placeholder and offline fallback.
class CatalogImage extends ConsumerWidget {
  const CatalogImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.semanticLabel,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppNetworkImage(
      url: ref.watch(envProvider).imageUrl(path),
      fallbackAsset: AppAsset.catalogImage(path),
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      semanticLabel: semanticLabel,
    );
  }
}
