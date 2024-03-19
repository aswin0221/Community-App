import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPost extends StatefulWidget {

  String postTitle;
  String postContent;
  String postId;

   EditPost({super.key ,required this.postId, required this.postTitle , required this.postContent});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {

  late TextEditingController title;
  late TextEditingController postContent;

  String? userName;

  getUserName()async{
    DocumentSnapshot<Map<String,dynamic>> userNameSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    userName = userNameSnapshot.data()!['name'];
    setState(() {
    });
  }


  addPost(String title,String postContent)async
  {
    //String postId = FirebaseFirestore.instance.collection("posts").doc().id;
    FirebaseFirestore.instance.collection("posts").doc(widget.postId).update(
        {
          "title" : title,
          "postContent" : postContent,
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    title =TextEditingController(text: widget.postTitle);
    postContent  =TextEditingController(text: widget.postContent);
    super.initState();
    getUserName();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Post"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              TextField(
                controller: title,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "title"
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: postContent,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Post Content"
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                addPost(title.text, postContent.text);
                title.clear();
                postContent.clear();
                Navigator.pop(context);
              }, child: Text("Edit Post"))
            ],
          ),
        ),
      ),
    );
  }
}
