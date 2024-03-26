import 'package:flutter/material.dart';

class ViewArticlePage extends StatelessWidget {
  final Map<String, dynamic> article;

  const ViewArticlePage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['heading']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/loading.gif', // Placeholder widget to display while loading
                    image: article['imgUrl'], // The URL of the image to load
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  article['heading'],
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: article['subtitles'].length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article['subtitles'][index],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text(article['descriptions'][index]),
                          SizedBox(height: 16.0),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
