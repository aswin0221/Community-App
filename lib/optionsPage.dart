import 'package:authentication_ffm/posts/add_post.dart';
import 'package:authentication_ffm/posts/post_feed.dart';
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PostFeed()));
            }, child: Text("Post feeds")),
            SizedBox(height: 50,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPost()));
      }, label: Text("Add Post "))
    );
  }
}