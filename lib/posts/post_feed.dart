import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostFeed extends StatefulWidget {
  const PostFeed({super.key});

  @override
  State<PostFeed> createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Feeds"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator(); // Or any other loading indicator
            default:
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['title']),
                    subtitle: Text(data['postContent']),
                    // Add more widgets to display other data fields as needed
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
