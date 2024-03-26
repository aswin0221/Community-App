import 'package:authentication_ffm/Blogs/articlesPage.dart';
import 'package:authentication_ffm/Blogs/blogs_page.dart';
import 'package:authentication_ffm/Blogs/upload_articles.dart';
import 'package:authentication_ffm/Daily%20tasks/daily_tasks.dart';
import 'package:authentication_ffm/Daily%20tasks/relapse_historyPage.dart';
import 'package:authentication_ffm/Streaks/streak_page.dart';
import 'package:authentication_ffm/post2/PostFeed2.dart';
import 'package:authentication_ffm/post2/myposts.dart';
import 'package:authentication_ffm/posts/add_post.dart';
import 'package:authentication_ffm/servicepage.dart';
import 'package:flutter/material.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicePage()));
            }, child: Text("Chatroom")),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PostFeed2()));
            }, child: Text("Post feeds")),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyPost()));
            }, child: Text("My Posts")),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>DailyTask()));
            }, child: Text("Daily Task")),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ListArticlesPage()));
            }, child: Text("Blogs")),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>StreakScreen()));
            }, child: Text("Streks")),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RelapseHistoryPage()));
            }, child: Text("Relapse History")),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadArticle()));
            }, child: Text("Upload Articles")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPost()));
      }, label: Text("Add Post "))
    );
  }
}
