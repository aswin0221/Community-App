import 'package:authentication_ffm/Blogs/viewArticlePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListArticlesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Articles"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('articles').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['heading']),
                leading: Image.network(data['imgUrl'],width: 100,),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewArticlePage(article: data)),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}