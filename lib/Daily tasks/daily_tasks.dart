import 'dart:math';
import 'package:authentication_ffm/Daily%20tasks/singleTaskPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyTask extends StatefulWidget {
  const DailyTask({Key? key}) : super(key: key);

  @override
  State<DailyTask> createState() => _DailyTaskState();
}

class _DailyTaskState extends State<DailyTask> {
  List<String> fetchedTasks = [];
  List<String> dailyTask = [];
  List<String> completedTask = [];
  String? selectedTask;
  bool isLoading = true;
  String? selectedIndex;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    initTask();
    completedTasks();
  }
  //To Get the Completed Tasks

  completedTasks()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      completedTask = pref.getStringList("completedTasks")!;
      if(completedTask.length == 3)
        {
          setState(() {
            isCompleted = true;
          });
        }
    });
   }



  // To initialize tasks
   initTask() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isTaskStarted = pref.getBool("taskStarted") ?? false;

    setState(() {
      isLoading = true;
    });

    if (isTaskStarted) {
      checkTime();
    } else {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection("daily tasks").get();
      for (DocumentSnapshot docs in snapshot.docs) {
        final task = docs.data() as Map<String, dynamic>;
        fetchedTasks.add(task['task']);
      }
      setState(() {
        dailyTask = getRandomElements(fetchedTasks, 3);
      });
      await pref.setStringList("tasks", dailyTask);
      int startDate = DateTime.now().millisecondsSinceEpoch;
      await pref.setInt("startDate", startDate);
      int nextEndDate =
          DateTime.fromMillisecondsSinceEpoch(startDate)
              .add(const Duration(minutes: 10))
              .millisecondsSinceEpoch;
      await pref.setInt("endDate", nextEndDate);
      await pref.setBool("taskStarted", true);
    }
    setState(() {
      isLoading = false;
    });
  }

  // To check the time and give data according to that
  checkTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int startDate = pref.getInt("startDate")!;
    int endDate = pref.getInt("endDate")!;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime >= endDate) {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection("daily tasks").get();
      for (DocumentSnapshot docs in snapshot.docs) {
        final task = docs.data() as Map<String, dynamic>;
        fetchedTasks.add(task['task']);
      }
      setState(() {
        dailyTask = getRandomElements(fetchedTasks, 3);
      });
      await pref.setStringList("tasks", dailyTask);
      await pref.setInt("startDate", endDate);
      int nextEndDate = DateTime.fromMillisecondsSinceEpoch(endDate)
          .add(const Duration(minutes: 10))
          .millisecondsSinceEpoch;
      await pref.setInt("endDate", nextEndDate);
      await pref.setStringList("completedTasks", []);
    } else {
      dailyTask = pref.getStringList("tasks")!;
    }
  }

  // To get the random 3 list of tasks from the database
  List<String> getRandomElements(List<String> list, int numberOfElements) {
    if (numberOfElements >= list.length) {
      return List<String>.from(list);
    }
    Random random = Random();
    List<String> resultList = [];
    while (resultList.length < numberOfElements) {
      int randomIndex = random.nextInt(list.length);
      String selectedItem = list[randomIndex];
      if (!resultList.contains(selectedItem)) {
        resultList.add(selectedItem);
      }
    }
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Tasks"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            width: 120,
            decoration: BoxDecoration(
              color: isLoading  ? Colors.white :  isCompleted ? Colors.green :Colors.red[300],
              borderRadius: BorderRadius.circular(10)
            ),
            child: isLoading
                ? Center(child: Text(""))
                : Center(child: isCompleted ? Text("Completed",style: TextStyle(color: Colors.white),) : Text("Pending",style: TextStyle(color: Colors.white),) ) ,
          ),
          Expanded(
            child: isLoading
                ? Center(child: SpinKitRipple(color: Colors.grey,))
                : Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: dailyTask.length,
                itemBuilder: (context, index) {
                  if(completedTask.contains(index.toString()))
                    {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  child: Text(
                                    "Task ${index + 1}",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(dailyTask[index]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle,color: Colors.green,),
                        ],
                      );
                    }
                  else{
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTask = dailyTask[index];
                          selectedIndex = index.toString();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedTask == dailyTask[index]
                              ? Colors.blue
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              child: Text(
                                "Task ${index + 1}",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                height: 100,
                                decoration: BoxDecoration(
                                  color: selectedTask == dailyTask[index]
                                      ? Colors.blue[100]
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(dailyTask[index]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              onPressed: !isCompleted ? () {
                if (selectedTask != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SingleTaskPage(task: selectedTask! ,taskIndex: selectedIndex!,),
                    ),
                  ).then((value) => setState(() async {
                    await completedTasks();
                    selectedTask = null;
                  }));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please select a task to start."),
                  ));
                }
              } : (){} ,
              child: !isCompleted ? Text("Start") : Text("Get Coins"),
            ),
          ),
        ],
      ),
    );
  }
}
