import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/bill_record.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'electricity_bills.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bills (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            month TEXT NOT NULL,
            units REAL NOT NULL,
            totalCharges REAL NOT NULL,
            rebatePercent REAL NOT NULL,
            finalCost REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertBill(BillRecord bill) async {
    final db = await database;
    return await db.insert('bills', bill.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BillRecord>> getAllBills() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bills', orderBy: 'id DESC');
    return maps.map((m) => BillRecord.fromMap(m)).toList();
  }

  Future<BillRecord?> getBillById(int id) async {
    final db = await database;
    final maps = await db.query('bills', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return BillRecord.fromMap(maps.first);
  }

  Future<int> updateBill(BillRecord bill) async {
    final db = await database;
    return await db.update('bills', bill.toMap(),
        where: 'id = ?', whereArgs: [bill.id]);
  }

  Future<int> deleteBill(int id) async {
    final db = await database;
    return await db.delete('bills', where: 'id = ?', whereArgs: [id]);
  }
}