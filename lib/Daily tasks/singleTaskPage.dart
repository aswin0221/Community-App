import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleTaskPage extends StatefulWidget {
  final String task;
  final String taskIndex;

  SingleTaskPage({Key? key, required this.task , required this.taskIndex}) : super(key: key);

  @override
  State<SingleTaskPage> createState() => _SingleTaskPageState();
}

class _SingleTaskPageState extends State<SingleTaskPage> {
  late Timer _timer;
  int _timerDuration = 60; // 2 minutes in seconds

  @override
  void initState() {
    super.initState();
    // Start the timer after 3 seconds of page initialization
    _timer = Timer(Duration(seconds: 3), startTimer);
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerDuration > 0) {
          _timerDuration--;
        } else {
          timer.cancel(); // Cancel the timer when it reaches 0
        }
      });
    });
  }

  taskCompleteStatus(String taskIndex)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> previousList =  pref.getStringList("completedTasks") ?? [];
    previousList.add(taskIndex);
    pref.setStringList("completedTasks", previousList);
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 5,
                        offset: Offset(0, 4),
                        blurStyle: BlurStyle.inner,
                      )
                    ],
                  ),
                  child: Text(widget.task),
                ),
                SizedBox(height: 100,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    '${_timerDuration ~/ 60}:${(_timerDuration % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 50),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: _timerDuration == 0 ? () async{
                  await taskCompleteStatus(widget.taskIndex);
                  Navigator.pop(context);
                } : null,
                child: Text("Finish"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
