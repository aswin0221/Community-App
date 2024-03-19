import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';

class Comments2 extends StatefulWidget {
  String title;
  String postContent;
  String postId;
  int likecount;
  String timeAgo;
  Comments2({super.key ,required this.timeAgo,required this.likecount, required this.postContent ,required this.postId ,required this.title});
  @override
  State<Comments2> createState() => _Comments2State();
}

class _Comments2State extends State<Comments2> {
  //comment text controller
  TextEditingController comment = TextEditingController();

  //to add comments
  addComments(String comment) async{
    String commentId =  FirebaseFirestore.instance.collection("comments").doc().id;
    await FirebaseFirestore.instance.collection("comments").doc(commentId).set({
      'commentId':commentId,
      'postID':widget.postId,
      'commentTime':DateTime.now().millisecondsSinceEpoch,
      'userId':FirebaseAuth.instance.currentUser!.uid,
      'commentContent':comment
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    SizedBox(height: 10,),
                    Text(widget.postContent),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(onPressed: (){

                            }, icon: Icon(Icons.favorite),color: Colors.red,),
                            Text(widget.likecount.toString()),
                          ],
                        ),
                        IconButton(onPressed: (){
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>Comments2(postContent: postContent, postId: postId, title: postTitle)));
                        }, icon: Icon(Icons.comment),color: Colors.grey,),
                        Text(widget.timeAgo)
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width:MediaQuery.sizeOf(context).width*0.7 ,
                      child: TextField(
                        controller: comment,
                        decoration: InputDecoration(
                          hintText: "Add Comments....",
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                        ),
                        maxLines: null,
                      ),
                    ),
                    ElevatedButton(onPressed: () async{
                      await addComments(comment.text);
                      comment.clear();
                    }, child: Text("Add"))
                  ],
                ),
              ),
              Expanded(
                child: PaginateFirestore(
                    query: FirebaseFirestore.instance.collection("comments").orderBy("commentTime" ,descending: true),
                    itemBuilderType: PaginateBuilderType.listView,
                    isLive: true,
                    itemsPerPage: 5,
                    onEmpty: Text("No Comments Yet"),
                    initialLoader: CircularProgressIndicator.adaptive(),
                    itemBuilder: (context,snapshots,index) {
                      final Map<String , dynamic > json = snapshots[index].data() as Map<String , dynamic>;
                      final commentContent = json["commentContent"];
                      final postID = json["postID"];
                      final userId = json['userId'];
                      bool currentUser = userId == FirebaseAuth.instance.currentUser!.uid;
                      if(postID == widget.postId)
                        {
                          return GestureDetector(
                            onTap: (){
                              //Navigator.push(context, MaterialPageRoute(builder: (context)=>Comments2(postContent: postContent, postId: postId, title: postTitle)));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(userId,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                      if(currentUser)
                                        Icon(Icons.delete,size: 15)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Text(commentContent),
                                ],
                              ),
                            ),
                          );
                        }
                      else
                         {
                          return Container(
                          );
                        }
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
