import 'dart:io' show Directory;
import 'package:msapps/Movies.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

class SQLiteDbProvider {
  SQLiteDbProvider._();
  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "MSApps.db");
    return await openDatabase(
        path, version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE Product (id INTEGER PRIMARY KEY, title TEXT, image TEXT, rating REAL, genere TEXT, releaseYear TEXT)');
        }
    );
  }
  Future<List<Movies>> getAllProducts() async {
    final db = await database;
    List<Map> results = await db.query(
        "Product", columns: Movies.columns, orderBy: "releaseYear ASC"
    );
    List<Movies> products = new List();
    results.forEach((result) {
      Movies product = Movies.fromJson(result);
      products.add(product);
    });
    return products;
  }
  Future<Movies> getProductById(int id) async {
    final db = await database;
    var result = await db.query("Product", where: "id = ", whereArgs: [id]);
    return result.isNotEmpty ? Movies.fromJson(result.first) : Null;
  }

  Future<Movies> getProductByTitle(String title) async {
    final db = await database;
    List<Map> result = await db.rawQuery('SELECT * FROM Product WHERE title=?', [title]);
    if (result.isNotEmpty){
      return Movies.fromJson(result.first);
    } else{
      return null;
    }
  return null;
  }

  insert(Movies product) async {
    final db = await database;
    var maxIdResult = await db.rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM Product");
    var id = maxIdResult.first["last_inserted_id"];
    var result = await db.rawInsert(
        "INSERT Into Product (id, title, image, rating, releaseYear)"
            " VALUES (?, ?, ?, ?, ?)",
        [id, product.title, product.image, product.rating, product.releaseYear]
    );
    return result;
  }
  update(Movies product) async {
    final db = await database;
    var result = await db.update(
        "Product", product.toMap(), where: "id = ?", whereArgs: [product.id]
    );
    return result;
  }
  delete(int id) async {
    final db = await database;
    db.delete("Product", where: "id = ?", whereArgs: [id]);
  }
}