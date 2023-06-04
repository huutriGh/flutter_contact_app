import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contact.dart';

class SqlHelper {
  final String colId = 'id';
  final String colName = 'name';
  final String colPhone = 'phone';

  final String tableContact = 'contact';

  static Database? _db;
  static final SqlHelper _singleton = SqlHelper._internal();
  final int version = 1;
  factory SqlHelper() {
    return _singleton;
  }
  SqlHelper._internal();

  Future<Database> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'contact.db');
    Database dbNotes =
        await openDatabase(dbPath, version: version, onCreate: _createDb);
    return dbNotes;
  }

  Future _createDb(Database db, int verion) async {
    String query =
        'CREATE TABLE $tableContact ($colId INTEGER PRIMARY KEY, $colName TEXT, $colPhone TEXT)';
    await db.execute(query);
  }

  Future<List<Contact>> getContact() async {
    _db ??= await init();
    List<Map<String, dynamic>>? contactsList =
        await _db?.query(tableContact, orderBy: colName);
    List<Contact> contacts = [];
    contactsList?.forEach((element) {
      contacts.add(Contact.fromMap(element));
    });
    return contacts;
  }

  Future<List<Contact>> searchContact(String name) async {
    _db ??= await init();
    List<Map<String, dynamic>>? contactsList = await _db?.query(tableContact,
        orderBy: colName, where: '$colName like ?', whereArgs: ["%$name%"]);
    List<Contact> contacts = [];
    contactsList?.forEach((element) {
      contacts.add(Contact.fromMap(element));
    });
    return contacts;
  }

  Future<int> insertContact(Contact contact) async {
    _db ??= await init();
    int result = await _db!.insert(tableContact, contact.toMap());
    return result;
  }

  Future<int> updateContact(Contact contact) async {
    _db ??= await init();
    int result = await _db!.update(tableContact, contact.toMap(),
        where: '$colId = ?', whereArgs: [contact.id]);
    return result;
  }

  Future<int> deleteContact(Contact contact) async {
    _db ??= await init();
    int result = await _db!
        .delete(tableContact, where: '$colId = ?', whereArgs: [contact.id]);
    return result;
  }
}


/**
 * version: a version number for your database. required when using onCreate, onUpgrare, onDowngrade
 * onConfigure: is the first callback invoked when opeining the database. Can use it to perform initialztion tasks, 
 * like setting values that depend on the opening of the database or to write logs.
 * onCreate, onUpgrade, onDowngrade: They are mutually exclusive, mean that 
 * only one of them can be called depending on the version number
 * onCreate is called if the database dose not exist.
 * onUpgrade is called when the version number is higher than existing database version
 * or when the database does not exist and you have not set the onCreate callback.
 * onDowngrade is called when you have not set the onCreate callback.
 * onDowngrade is called when the version is lower than the existing on, and this actually
 * rather unlikely scenario
 * onOpen is invoked just before returning database. You can also specify the the readOnly parameter to open the database
 * to open the database in read-only mode and singleInstance the allows returning a single instance of the database
 * at the path that is set, and this is true by default.
 * 
 */
/**
 * Data in SQLite
 * NULL
 * INTEGER
 * REAL
 * TEXT
 * BLOB
 * SQLite uses Dynamic Typing
 */