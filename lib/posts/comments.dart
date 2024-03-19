import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Comments {
  final String userName;
  final String commentTime;
  final String commentContent;
  final String userId;
  final String commentId;


  Comments({
    required this.userName,
    required this.userId,
    required this.commentTime,
    required this.commentContent,
    required this.commentId
  });
}

class PostComments extends StatefulWidget {
  String name;
  String title;
  String postContent;
  String postId;
  int likes;
  String time;
  String uid;

  PostComments({super.key ,required this.uid, required this.name,required this.postContent,required this.title,required this.postId,required this.time,required this.likes});

  @override
  State<PostComments> createState() => _PostCommentsState();
}


class _PostCommentsState extends State<PostComments> {
  
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

  //To retrive all comments
   List<Comments> commentList = [];

  fetchComments()async{
    print(FirebaseAuth.instance.currentUser!.uid);
    final List<Comments> fetchedComments = [];
    QuerySnapshot<Map<String,dynamic>> snapshot = await FirebaseFirestore.instance.collection("comments").get();
    for(DocumentSnapshot docs in snapshot.docs)
      {
       final Map <String , dynamic> comments = docs.data() as Map<String,dynamic>;
       if(comments['postID'] == widget.postId)
         {
           print(comments);
           Comments commentsModel = Comments(commentId:comments['commentId'] ,userName: "", userId: comments['userId'], commentTime: comments['commentTime'].toString(), commentContent: comments['commentContent']);
           fetchedComments.add(commentsModel);
         }
       setState(() {
         commentList = fetchedComments;
       });
      }
  }

  deleteComment(String commentID) async{
    commentList =[];
   await FirebaseFirestore.instance.collection('comments').doc(commentID).delete();
   await fetchComments();
   setState(() {});
  }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchComments();
  }

   TextEditingController comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Comments"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text(widget.postContent),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  IconButton(onPressed: (){

                  }, icon: Icon(Icons.heart_broken,color: Colors.red,)),
                  IconButton(onPressed: (){
                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>PostComments(title:posts[index].title,likes: posts[index].likes,name: posts[index].userName,postContent: posts[index].postContent,postId: posts[index].postId,time: posts[index].time)));
                  }, icon: Icon(Icons.comment,color: Colors.black54,)),

                ],
              )
            ],
          ),
           ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
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
                      await fetchComments();
                      comment.clear();
                    }, child: Text("Add"))
                  ],
                ),
              ),
             SizedBox(height: 10,),
              Expanded(
                child: ListView.builder(
                    itemCount: commentList.length,
                    itemBuilder: (context,index){
                      bool isCurrentUser = commentList[index].userId.toString() == FirebaseAuth.instance.currentUser!.uid;
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Text(commentList[index].commentContent)),
                            if(isCurrentUser)
                              IconButton(onPressed: (){
                                deleteComment(commentList[index].commentId);
                              }, icon: Icon(Icons.delete,color: Colors.black54,size: 15,))
                          ],
                        ),
                      );
                    }
                ),
              )

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        fetchComments();
      },),
    );
  }
}
