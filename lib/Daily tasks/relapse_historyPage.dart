import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RelapseHistoryPage extends StatefulWidget {
  @override
  _RelapseHistoryPageState createState() => _RelapseHistoryPageState();
}

class RelapseHistory {
  final int id;
  final int startTime;
  final int endTime;

  RelapseHistory({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  String formattedDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute}.${dateTime.second}';
  }
}

class _RelapseHistoryPageState extends State<RelapseHistoryPage> {
  late Database _database;
  late List<RelapseHistory> _relapseHistory = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase().then((_) {
      _retrieveRelapseHistory();
    });
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'relapse_history.db'),
    );
  }

  Future<void> _retrieveRelapseHistory() async {
    try {
      final List<Map<String, dynamic>> relapseHistoryMaps =
      await _database.query('relapses');

      setState(() {
        _relapseHistory = relapseHistoryMaps
            .map((map) => RelapseHistory(
          id: map['id'],
          startTime: map['startTime'],
          endTime: map['endTime'],
        ))
            .toList();
      });
    } catch (e) {
      print('Error retrieving relapse history: $e');
      // Handle error, e.g., show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relapse History'),
      ),
      body: _relapseHistory.isEmpty
          ? Center(
        child: Text('No relapse history available'),
      )
          : ListView.builder(
        itemCount: _relapseHistory.length,
        itemBuilder: (context, index) {
          final history = _relapseHistory[index];
          final startTime =
          DateTime.fromMillisecondsSinceEpoch(history.startTime);
          final endTime =
          DateTime.fromMillisecondsSinceEpoch(history.endTime);
          final duration = endTime.difference(startTime);

          return ListTile(
            title: Text(
                'Attempt ${index + 1} from ${history.formattedDateTime(startTime)} to ${history.formattedDateTime(endTime)}'),
            subtitle: Text('Duration: ${duration.inHours}hrs'),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
}
