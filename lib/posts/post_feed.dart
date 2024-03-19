import 'package:authentication_ffm/posts/comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Post {
  final String postId;
  final String userName;
  final String postUser;
  final String time;
  final String title;
  final String postContent;
  final String userId;
  final int likes;

  Post({
    required this.userName,
    required this.postId,
    required this.postUser,
    required this.userId,
    required this.time,
    required this.title,
    required this.postContent,
    required this.likes,
  });
}

class PostFeed extends StatefulWidget {
  const PostFeed({Key? key});

  @override
  State<PostFeed> createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  late List<Post> posts;

  @override
  void initState() {
    super.initState();
    posts = [];
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final QuerySnapshot<Map<String, dynamic>> postSnapshot =
    await FirebaseFirestore.instance.collection('posts').get();

    final List<Post> fetchedPosts = [];

    for (final DocumentSnapshot postDoc in postSnapshot.docs) {
      final Map<String, dynamic> postData = postDoc.data()! as Map<String, dynamic>;
      //print(postData);
      // Fetch user data based on postUser field
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(postData['postUser']).get();
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("likes").where("postID",isEqualTo: postDoc.id).get();
      final Map<String, dynamic> userData = userSnapshot.data()!;
      final Post post = Post(
        postId: postDoc.id,
        postUser: postData['postUser'],
        userId : postDoc['postUser'],
        userName: userData['name'], // Assuming there's a 'userName' field in your user document
        time: postData['time'],
        title: postData['title'],
        postContent: postData['postContent'],
        likes: snapshot.size,
      );
      fetchedPosts.add(post);
    }

    setState(() {
      posts = fetchedPosts;
    });
  }

    int likeCount =0;

  Future<void> _refreshPosts() async {
    await fetchPosts();
  }

  addLike(String postId)async
  {
    FirebaseFirestore.instance.collection('likes').doc().set({
      "postID":postId,
      "likedUser":FirebaseAuth.instance.currentUser!.uid
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Feeds"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              width: MediaQuery.of(context).size.width*0.7,
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
                      Text(posts[index].userName),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(posts[index].title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            SizedBox(height: 10,),
                            Text(posts[index].postContent),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(onPressed: () async{
                             addLike(posts[index].postId);
                            await fetchPosts();
                          }, icon: Icon(Icons.heart_broken,color: Colors.red,)),
                          Text(posts[index].likes.toString())
                        ],
                      ),
                      IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PostComments(uid:posts[index].userId,title:posts[index].title,likes: posts[index].likes,name: posts[index].userName,postContent: posts[index].postContent,postId: posts[index].postId,time: posts[index].time)));
                      }, icon: Icon(Icons.comment,color: Colors.black54,)),
                      Text("15 minuts ago")
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


