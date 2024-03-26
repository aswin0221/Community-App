import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Daily tasks/relapse_historyPage.dart';

class RelapseHistory {
  final int startTime;
  final int endTime;

  RelapseHistory({required this.startTime, required this.endTime});

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

class StreakScreen extends StatefulWidget {
  @override
  _StreakScreenState createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  late DateTime _startDate;
  late Duration _elapsedTime = Duration.zero;
  late Timer _timer;
  int? points = 0;

  late Database _database;


  // Initialize the SQLite database
  void _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'relapse_history.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE relapses(id INTEGER PRIMARY KEY, startTime INTEGER, endTime INTEGER)',
        );
      },
      version: 1,
    );
  }

  // Load the start date from SharedPreferences
  void _loadStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedTime = prefs.getInt('currentStreak');
    if (storedTime == null) {
      storedTime = DateTime.now().millisecondsSinceEpoch;
      prefs.setInt("currentStreak", storedTime);
    }
    _startDate = DateTime.fromMillisecondsSinceEpoch(storedTime);
    _calculateElapsedTime();
  }

  // Calculate the elapsed time since the start date
  void _calculateElapsedTime() {
    _elapsedTime = DateTime.now().difference(_startDate);
    setState(() {
      points = (_elapsedTime.inMinutes % 60) * 10;
    });
  }

  // Start the timer to update elapsed time continuously
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _calculateElapsedTime();
    });
  }

  // Relapse the streak and store relapse history
  void relapse() async {
    final now = DateTime.now();
    final relapseData = RelapseHistory(
      startTime: _startDate.millisecondsSinceEpoch,
      endTime: now.millisecondsSinceEpoch,
    );
    await _database.insert('relapses', relapseData.toMap());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("currentStreak", now.millisecondsSinceEpoch);
    _loadStartDate();
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _loadStartDate();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streaks'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Streak',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Days: ${_elapsedTime.inDays}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Hours: ${_elapsedTime.inHours % 24}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Minutes: ${_elapsedTime.inMinutes % 60}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Seconds: ${_elapsedTime.inSeconds % 60}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                relapse();
              },
              child: Text("Relapse"),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}


