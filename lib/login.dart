import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      // body: Markdown(
      //   selectable: true,
      //   data: "# h1 Heading \n## h2 Heading \n### h3 Heading \n#### h4 Heading \n##### h5 Heading \n###### h6 Heading"
      // ),
      // body: IconButton(
      //   onPressed: (){},
      //   icon: Icon(
      //     const IconData(
      //       fontFamily: "customicon",
      //       0xe914, // Replace with your actual code point
      //     ),
      //     size: 200 ,
      //     color: Colors.deepPurple,
      //   ),
      // ),
    );
  }
}
