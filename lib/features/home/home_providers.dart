import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show StreamProviderFamily;
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/features/home/data/catalog_remote_data_source.dart';
import 'package:jdonuts/features/home/data/drift_home_repository.dart';
import 'package:jdonuts/features/home/domain/home_content.dart';
import 'package:jdonuts/features/home/domain/home_repository.dart';

final Provider<CatalogRemoteDataSource> catalogRemoteDataSourceProvider =
    Provider((ref) => CatalogRemoteDataSource(ref.watch(apiClientProvider)));

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => DriftHomeRepository(
    ref.watch(databaseProvider),
    ref.watch(catalogRemoteDataSourceProvider),
    clock: ref.watch(clockProvider),
  ),
);

final StreamProvider<List<PromoBanner>> bannersProvider =
    StreamProvider.autoDispose<List<PromoBanner>>(
      (ref) => ref
          .watch(homeRepositoryProvider)
          .watchBanners()
          .map((result) => result.getOrThrow()),
    );

final StreamProvider<List<ProductSection>> sectionsProvider =
    StreamProvider.autoDispose<List<ProductSection>>(
      (ref) => ref
          .watch(homeRepositoryProvider)
          .watchSections()
          .map((result) => result.getOrThrow()),
    );

// One section by id; null when the catalogue no longer has it.
final StreamProviderFamily<ProductSection?, String> sectionProvider =
    StreamProvider.autoDispose.family<ProductSection?, String>(
      (ref, id) => ref
          .watch(homeRepositoryProvider)
          .watchSections()
          .map(
            (result) =>
                result.getOrThrow().where((s) => s.id == id).firstOrNull,
          ),
    );

final StreamProvider<List<Shop>> shopsProvider =
    StreamProvider.autoDispose<List<Shop>>(
      (ref) => ref
          .watch(homeRepositoryProvider)
          .watchShops()
          .map((result) => result.getOrThrow()),
    );
