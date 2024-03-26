import 'package:authentication_ffm/Daily%20tasks/relapse_historyPage.dart';
import 'package:authentication_ffm/Streaks/streak_page.dart';
import 'package:authentication_ffm/signup.dart';
import 'package:flutter/material.dart';

class GuestHomePage extends StatefulWidget {
  const GuestHomePage({super.key});

  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>StreakScreen()));
            }, child: Text("Streak")),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RelapseHistoryPage()));
            }, child: Text("Relapse History")),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));
            }, child: Text("SignUp"))
          ],
        ),
      ),
    );
  }
}
