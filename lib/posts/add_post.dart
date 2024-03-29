import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController title = TextEditingController();
  TextEditingController postContent = TextEditingController();

  String? userName;

  getUserName()async{
    DocumentSnapshot<Map<String,dynamic>> userNameSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
     userName = userNameSnapshot.data()!['name'];
     setState(() {
     });
  }


  addPost(String title,String postContent)async
  {
    String postId = FirebaseFirestore.instance.collection("posts").doc().id;
    FirebaseFirestore.instance.collection("posts").doc(postId).set(
      {
        "postId":postId,
        "postUser" : FirebaseAuth.instance.currentUser!.uid,
        "time" : DateTime.now().millisecondsSinceEpoch.toString(),
        "title" : title,
        "postContent" : postContent,
        "likes" : 0,
        "UserName":userName
      }
    );
  }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
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
              }, child: Text("Add Post"))
            ],
          ),
        ),
      ),
    );
  }
}
