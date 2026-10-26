import 'package:sembast_web/sembast_web.dart';

class SembastHelper {
  SembastHelper._();

  static final SembastHelper instance = SembastHelper._();

  Database? _database;

  final StoreRef<int, Map<String, Object?>> _store =
      intMapStoreFactory.store('contacts');

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await databaseFactoryWeb.openDatabase(
      'sembast_contacts.db',
    );

    return _database!;
  }

  Future<int> insertContact(
    Map<String, Object?> contact,
  ) async {
    final db = await database;
    return _store.add(db, contact);
  }

  Future<List<RecordSnapshot<int, Map<String, Object?>>>>
      getContacts() async {
    final db = await database;

    return _store.find(
      db,
      finder: Finder(
        sortOrders: [SortOrder('name')],
      ),
    );
  }

  Future<void> updateContact(
    int id,
    Map<String, Object?> contact,
  ) async {
    final db = await database;
    await _store.record(id).put(db, contact);
  }

  Future<void> deleteContact(int id) async {
    final db = await database;
    await _store.record(id).delete(db);
  }
}