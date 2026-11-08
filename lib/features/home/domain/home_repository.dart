import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/home/domain/home_content.dart';

// Home's data. Streams read the local database only; [refresh] pulls the
// public catalogue from the server into it.
abstract interface class HomeRepository {
  Stream<Result<List<PromoBanner>>> watchBanners();
  Stream<Result<List<ProductSection>>> watchSections();
  Stream<Result<List<Shop>>> watchShops();

  // Fails with `NetworkFailure` or `ServerFailure`; local data stays as
  // it was.
  Future<Result<DateTime>> refresh();
}
