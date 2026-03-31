import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../util/constants.dart';

class DbService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'dashboard.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        empId TEXT PRIMARY KEY,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE leaveBalance(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        name TEXT,
        count INTEGER,
        total INTEGER,
        FOREIGN KEY(userId) REFERENCES user(empId),
        UNIQUE(userId, name)
      )
    ''');

    await db.execute('''
      CREATE TABLE quickActions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        action TEXT,
        desc TEXT,
        lock INTEGER,
        FOREIGN KEY(userId) REFERENCES user(empId),
        UNIQUE(userId, action)
      )
    ''');

    await db.execute('''
      CREATE TABLE activityTimeline(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        activity TEXT,
        desc TEXT,
        date TEXT,
        FOREIGN KEY(userId) REFERENCES user(empId),
        UNIQUE(userId, activity)
      )
    ''');

    await db.execute('''
  CREATE TABLE leaves(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId TEXT,
    name TEXT,
    count INTEGER,
    description TEXT,
    FOREIGN KEY(userId) REFERENCES user(empId),
    UNIQUE(userId, name)
  )
''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Add migration scripts here
  }

  Future<void> insertUser(Map<String, dynamic> userData) async {
    final db = await database;

    try {
    // Insert user
    await db.insert(Tables.user, {
      'empId': userData['empId'],
      'name': userData['name'],
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    final userId = userData['empId'];

    // Insert leave
    for (var leave in userData['leaves']) {
      await db.insert(Tables.leaves, {
        'userId': userId,
        'name': leave['name'],
        'count': leave['count'],
        'description': leave['description'],
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Insert leaveBalanceDetail
    for (var leave in userData['leaveBalanceDetail']) {
      await db.insert(Tables.leaveBalance, {
        'userId': userId,
        'name': leave['name'],
        'count': leave['count'],
        'total': leave['total'],
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Insert quickActions
    for (var action in userData['quickActions']) {
      await db.insert(Tables.quickActions, {
        'userId': userId,
        'action': action['action'],
        'desc': action['desc'],
        'lock': action['lock'] ? 1 : 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Insert activityTimeline
    for (var activity in userData['activityTimeline']) {
      await db.insert(Tables.activityTimeline, {
        'userId': userId,
        'activity': activity['activity'],
        'desc': activity['desc'],
        'date': activity['date'],
      }, conflictAlgorithm: ConflictAlgorithm.replace,);
    }
    } on DatabaseException catch (e) {
      print("Database Error: ${e.toString()}");
      throw Exception("Failed to add data: ${e.toString()}");
    } catch (e) {
      print("Unexpected Error: $e");
      throw Exception("Unexpected error");
    }
  }

  Future<Map<String, dynamic>?> getUser(String empId) async {
    final db = await database;
    final userList = await db.query('user', where: 'empId = ?', whereArgs: [empId]);
    if (userList.isEmpty) return null;
    final user = userList.first;

    final leaveList = await db.query('leaves', where: 'userId = ?', whereArgs: [empId]);
    final leaveBalanceList = await db.query('leaveBalance', where: 'userId = ?', whereArgs: [empId]);
    final quickActionsList = await db.query('quickActions', where: 'userId = ?', whereArgs: [empId]);
    final activityList = await db.query('activityTimeline', where: 'userId = ?', whereArgs: [empId]);

    return {
      'user': {
        'empId': user['empId'],
        'name': user['name'],
        'leaves': leaveList,
        'leaveBalanceDetail': leaveBalanceList,
        'quickActions': quickActionsList,
        'activityTimeline': activityList,
      }
    };
  }
}