import 'package:logger/logger.dart';
import 'package:readeth/config/constants.dart';
import 'package:readeth/models/book_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService.internal();

  DatabaseService.internal();

  Database? _database;

  factory DatabaseService() {
    return instance;
  }

  // get the database instance

  Future<Database> get database async {
    _database ??= await getDatabase();
    return _database!;
  }

  Future<Database> getDatabase() async {
    // location where the database is stored db path
    final dbDirPath = await getDatabasesPath();
    final dbPath = join(dbDirPath, 'readeth.db');

    final database = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
         CREATE TABLE $tableName (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnTitle TEXT NOT NULL,
          $columnAuthor TEXT NOT NULL,
          $columnDescription TEXT NOT NULL,
          $columnPublishDate TEXT NOT NULL
         )
        ''');
    });
    return database;
  }

  Future<void> addBook(BookModel book) async {
    final db = await database;
    await db.insert(tableName, {
      columnTitle: book.title,
      columnAuthor: book.author,
      columnDescription: book.description,
      columnPublishDate: book.publishDate,
    });
  }

  Future<List<BookModel>> getBooks() async {
    final db = await database;
    final data = await db.query(tableName);
    Logger().d(data);
    List<BookModel> bookList = (data as List<Map<String, dynamic>>).map((e)=> BookModel.fromMap(e)).toList();
    return bookList;
  }
}
