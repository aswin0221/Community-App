import 'package:authentication_ffm/post2/comments2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PostFeed2 extends StatefulWidget {
  const PostFeed2({Key? key}) : super(key: key);

  @override
  State<PostFeed2> createState() => _PostFeed2State();
}

class _PostFeed2State extends State<PostFeed2> {
  Map<String, int> likeCounts = {};
  Map<String, bool> likedPosts = {};
  bool likedPostsLoaded = false;

  @override
  void initState() {
    super.initState();
    loadLikedPosts();
  }

  void loadLikedPosts() {
    FirebaseFirestore.instance.collection('likes')
        .where("likedUser", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String postId = doc["postID"];
        setState(() {
          likedPosts[postId] = true;
        });
      });
      setState(() {
        likedPostsLoaded = true;
      });
    }).catchError((error) {
      print("An error occurred while fetching liked posts: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Feed'),
      ),
      body: likedPostsLoaded ? buildPostList() : Center(child: SpinKitWave(
        color: Colors.deepPurple,
        size: 100.0,
      )),
    );
  }

  Widget buildPostList() {
    return PaginateFirestore(
      query: FirebaseFirestore.instance.collection("posts").orderBy("time", descending: true),
      itemBuilderType: PaginateBuilderType.listView,
      isLive: true,
      onEmpty: Text("No Posts !!"),
      itemsPerPage: 2,
      itemBuilder: (context, snapshots, index) {
        final Map<String, dynamic> json = snapshots[index].data() as Map<String, dynamic>;
        return buildPostItem(json);
      },
    );
  }

  Widget buildPostItem(Map<String, dynamic> json) {
    final time  = json['time'];
    int time1 = int.parse(time);
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time1);
    String timeAgo = timeago.format(dateTime);
    final userName = json['UserName'];
    final postContent = json["postContent"];
    final postId = json["postId"];
    final postTitle = json['title'];
    int likes = json['likes'];
    int currentLikes = likeCounts.containsKey(postId) ? likeCounts[postId]! : likes;
    bool isLiked = likedPosts.containsKey(postId) ? likedPosts[postId]! : false;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Comments2(timeAgo:timeAgo ,likecount: currentLikes,postContent: postContent, postId: postId, title: postTitle)));
      },
      child: Container(
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
                      Text(userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
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
                buildLikeButton(postId, currentLikes, isLiked),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Comments2(timeAgo:timeAgo ,likecount: currentLikes,postContent: postContent, postId: postId, title: postTitle)));
                  },
                  icon: Icon(Icons.comment),
                  color: Colors.grey,
                ),
                Text(timeAgo)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLikeButton(String postId, int currentLikes, bool isLiked) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: IconButton(
            key: ValueKey<bool>(isLiked),
            onPressed: () {
              handleLikeButton(postId, currentLikes, isLiked);
            },
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
            color: isLiked ? Colors.red : null,
          ),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        Text(
          currentLikes.toString(),
          style: TextStyle(),
        ),
      ],
    );
  }

  void handleLikeButton(String postId, int currentLikes, bool isLiked) async {
    bool isConnected = await checkInternetConnectivity();
    if (!isConnected) {
      print("hello");
      final snackBar = SnackBar(content: Text('No internet connection. Please try again later.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    setState(() {
      // Update UI immediately
      if (isLiked) {
        // User unliked the post
        currentLikes--;
        likedPosts[postId] = false;
      } else {
        // User liked the post
        currentLikes++;
        likedPosts[postId] = true;
      }
      likeCounts[postId] = currentLikes; // Update like count in UI
    });

    // Perform background update asynchronously
    updateLikesInBackground(postId, currentLikes, isLiked);
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> updateLikesInBackground(String postId, int currentLikes, bool isLiked) async {
    try {
      if (isLiked) {
        // Unlike the post in the background
        await FirebaseFirestore.instance.collection('likes')
            .where("postID", isEqualTo: postId)
            .where("likedUser", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
      } else {
        // Like the post in the background
        await FirebaseFirestore.instance.collection('likes').doc().set({
          "postID": postId,
          "likedUser": FirebaseAuth.instance.currentUser!.uid
        });
      }

      // Update the like count in Firestore
      await FirebaseFirestore.instance.collection("posts").doc(postId).update({
        "likes": currentLikes
      });
    } catch (error) {
      print("An error occurred: $error");
      final snackBar = SnackBar(content: Text('Something went wrong: $error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Revert UI changes
      setState(() {
        if (isLiked) {
          // Revert like count decrement
          currentLikes++;
          likedPosts[postId] = true;
        } else {
          // Revert like count increment
          currentLikes--;
          likedPosts[postId] = false;
        }
        likeCounts[postId] = currentLikes;
      });
    }
  }
}
