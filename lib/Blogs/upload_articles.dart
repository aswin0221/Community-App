import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


///Article Model
class Article {
  final String imgUrl;
  final String heading;
  final List<String> subtitles;
  final List<String> descriptions;

  Article({
    required this.imgUrl,
    required this.heading,
    required this.subtitles,
    required this.descriptions,
  });

  Map<String, dynamic> toJson() {
    return {
      'imgUrl': imgUrl,
      'heading': heading,
      'subtitles': subtitles,
      'descriptions': descriptions,
    };
  }
}


class UploadArticle extends StatefulWidget {
  const UploadArticle({Key? key}) : super(key: key);

  @override
  State<UploadArticle> createState() => _UploadArticleState();
}

class _UploadArticleState extends State<UploadArticle> {
  List<String> titles = [''];
  List<String> descriptions = [''];
  TextEditingController headingController = TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Upload Articles"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           const Text("Heading"),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: headingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _imageFile != null
                ? Image.file(_imageFile!)
                : ElevatedButton(
              onPressed: () {
                _pickImage();
              },
              child: const Text("Select Image"),
            ),
            const SizedBox(height: 20),
            Column(
              children: List.generate(titles.length, (index) {
                return Container(
                  margin:const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Sub Title ${index+1}"
                        ),
                        onChanged: (value) {
                          titles[index] = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          border:const OutlineInputBorder(),
                            hintText: "Description ${index+1}"
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          descriptions[index] = value;
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  _uploadArticle();
                },
                child:const Text("Publish"),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            titles.add('');
            descriptions.add('');
          });
        },
        child:const Icon(Icons.add),
      ),
    );
  }

  void _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _uploadArticle() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          content: Text('Please select an image.'),
        ),
      );
      return;
    }

    final storageRef = FirebaseStorage.instance.ref().child('article_images').child('${DateTime.now()}.png');

    // Upload image to Firebase Storage
    final uploadTask = storageRef.putFile(_imageFile!);

    // Wait for the upload to complete and get the download URL
    uploadTask.then((taskSnapshot) async {
      String imgUrl = await taskSnapshot.ref.getDownloadURL();


      final article = Article(
        imgUrl: imgUrl,
        heading: headingController.text,
        subtitles: titles,
        descriptions: descriptions,
      );

      // Save article data to Firestore
      FirebaseFirestore.instance.collection('articles').add(article.toJson());

      // Clear controllers and image file after uploading
      setState(() {
        headingController.clear();
        _imageFile = null;
        // Clear the titles and descriptions lists
        titles = ['SubTitle 1'];
        descriptions = ['Description 1'];
      });
    }).catchError((error) {
      // Handle any errors that occur during the upload process
     // print("Error uploading image: $error");
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          content: Text('Error uploading image. Please try again later.'),
        ),
      );
    });
  }
}
