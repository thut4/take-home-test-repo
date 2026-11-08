import 'package:drift/drift.dart';

// Products shown on Home and Product detail. Public catalogue data: seeded
// from JSON, refreshed from the server.
@DataClassName('ProductRow')
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  IntColumn get priceMmk => integer()();
  BoolColumn get isNew => boolean().withDefault(const Constant(false))();
  IntColumn get discountPercent => integer().nullable()();
  TextColumn get imagePath => text()();
  TextColumn get description => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  // Added in schema v2. Nullable because SQLite can't add a NOT NULL
  // column with a computed default; the migration backfills it.
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// Horizontal lists on Home ("Seasonal specials", "Popular", ...).
@DataClassName('SectionRow')
class Sections extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get layout => text()();
  BoolColumn get showFlame => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// Which products appear in which section, in order.
@DataClassName('SectionProductRow')
class SectionProducts extends Table {
  TextColumn get sectionId => text().references(Sections, #id)();
  TextColumn get productId => text()();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {sectionId, productId};
}

@DataClassName('BannerRow')
class Banners extends Table {
  TextColumn get id => text()();
  TextColumn get tag => text()();
  TextColumn get title => text()();
  TextColumn get imagePath => text()();
  TextColumn get style => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ShopRow')
class Shops extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  TextColumn get imagePath => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// Registered accounts: the fake auth back end's user store.
@DataClassName('UserRow')
class Users extends Table {
  TextColumn get phone => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text().nullable()();
  DateTimeColumn get dateOfBirth => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {phone};
}

// The loyalty profile. One row per account; Home and Rewards both read it.
@DataClassName('MemberRow')
class Members extends Table {
  TextColumn get phone => text().references(Users, #phone)();
  TextColumn get photoPath => text()();
  TextColumn get tierId => text().references(Tiers, #id)();
  IntColumn get tierPoints => integer()();
  IntColumn get totalPoints => integer()();
  IntColumn get notificationCount => integer()();
  IntColumn get rewardCount => integer()();

  @override
  Set<Column<Object>> get primaryKey => {phone};
}

// Loyalty tiers in order. [pointsToNext] is the tier points needed to move
// from this tier to the next one (null for the top tier).
@DataClassName('TierRow')
class Tiers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get rank => integer()();
  IntColumn get pointsToNext => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// Reward challenges on the Rewards tabs.
@DataClassName('ChallengeRow')
class Challenges extends Table {
  TextColumn get id => text()();
  TextColumn get tab => text()();
  TextColumn get title => text()();
  TextColumn get artwork => text()();
  TextColumn get imagePath => text()();
  IntColumn get progress => integer()();
  IntColumn get goal => integer()();
  IntColumn get points => integer()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// Persistent cart. Added in schema v2.
@DataClassName('CartItemRow')
class CartItems extends Table {
  TextColumn get productId => text()();
  IntColumn get quantity => integer()();

  @override
  Set<Column<Object>> get primaryKey => {productId};
}

// Small key/value store: seed version, last refresh time, locale.
@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
