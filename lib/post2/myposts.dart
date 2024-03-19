import 'package:authentication_ffm/post2/editPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyPost extends StatefulWidget {
  const MyPost({super.key});

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {

  String? uid;

   @override
  void initState() {
    // TODO: implement initState
     uid = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Posts"),
      ),
      body:  PaginateFirestore(
        query: FirebaseFirestore.instance.collection("posts").where("postUser",isEqualTo:uid),
        itemBuilderType: PaginateBuilderType.listView,
        isLive: true,
        initialLoader: Center(child: SpinKitWaveSpinner(
          color: Colors.deepPurple,
          size: 100.0,
        )),
        itemsPerPage: 3,
        onEmpty: Text("No Posts !!"),
        itemBuilder: (context, snapshots, index) {
          final Map<String, dynamic> json = snapshots[index].data() as Map<String, dynamic>;
          final time  =json['time'];
          int time1 = int.parse(time);
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time1);
          String timeAgo = timeago.format(dateTime);
          final userName = json['UserName'];
          final postContent = json["postContent"];
          final postId = json["postId"];
          final postTitle = json['title'];
          int likes = json['likes'];
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Text(""),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              Row(
                                children: [
                                  TextButton(onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditPost(postId:postId,postTitle: postTitle, postContent: postContent)));
                                  }, child: Text("Edit Post")),
                                  IconButton(onPressed: (){}, icon: Icon(Icons.delete))
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 20,),
                          Text(postTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          SizedBox(height: 10,),
                          Text(postContent),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                      Row(
                        children: [
                          Icon(Icons.favorite , color: Colors.red,),
                          Text(likes.toString()),
                        ],
                      ),
                      Icon(Icons.comment),
                      Text(timeAgo)
                  ],
                ),
              ],
            ),
          );
        },
      )
    );
  }
}
