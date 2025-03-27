import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';
import '../models/history_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('inventory.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      barcode TEXT NOT NULL UNIQUE,
      name TEXT NOT NULL,
      quantity INTEGER NOT NULL,
      price_per_quantity REAL NOT NULL,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE product_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER NOT NULL,
      product_name TEXT NOT NULL,
      barcode TEXT NOT NULL,
      quantity INTEGER NOT NULL,
      type INTEGER NOT NULL,
      given_to TEXT,
      agency TEXT,
      rental_days INTEGER,
      rented_date TEXT NOT NULL,
      return_date TEXT,
      notes TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (product_id) REFERENCES products (id)
    )
    ''');
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final maps = await db.query('products');
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    final db = await database;
    final maps = await db.query('products', where: 'barcode = ?', whereArgs: [barcode]);
    return maps.isNotEmpty ? Product.fromMap(maps.first) : null;
  }

  Future<Product> addProduct(Product product) async {
    final db = await database;
    final id = await db.insert('products', product.toMap(includeId: false));
    return product.copyWith(id: id);
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      'products',
      product.toMap(), // includeId: true by default
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> addHistory(ProductHistory history) async {
    final db = await database;
    await db.insert('product_history', history.toMap());
  }

  Future<List<ProductHistory>> getHistoryByType(HistoryType type) async {
    final db = await database;
    final maps = await db.query('product_history', where: 'type = ?', whereArgs: [type.index], orderBy: 'created_at DESC');
    return maps.map((map) => ProductHistory.fromMap(map)).toList();
  }
}