// import 'package:authentication_ffm/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'home_page.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,  // Optional for portrait-only
//     // DeviceOrientation.landscapeLeft,  // Optional for landscape support
//     // DeviceOrientation.landscapeRight, // Optional for landscape support
//   ]);
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const HomePage(),
//     );
//   }
// }
//
//
//


import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final title = 'salomon_bottom_bar';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.deepPurple
          ),
          child: SalomonBottomBar(
            curve: Curves.easeInCubic,
          //  itemShape: RoundedRectangleBorder(),
            selectedColorOpacity: 1,
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.deepPurple,
            items: [
              /// Home
              SalomonBottomBarItem(
                activeIcon: Icon(Icons.home,color: Colors.deepPurple),
                icon: Icon(Icons.home_filled,color: Colors.deepPurple[100],),
                title: Text(""),
                selectedColor: Colors.white,
                unselectedColor: Colors.white
              ),

              /// Like
              SalomonBottomBarItem(
                icon: Icon(Icons.favorite,color: Colors.deepPurple[100],),
                  activeIcon: Icon(Icons.favorite,color: Colors.deepPurple),
                title: Text(""),
                  selectedColor: Colors.white,
                  unselectedColor: Colors.white
              ),

              /// Search
              SalomonBottomBarItem(
                icon: Icon(Icons.people_alt_sharp,color: Colors.deepPurple[100],),
                  activeIcon: Icon(Icons.people_alt_sharp,color: Colors.deepPurple),
                title: Text(""),
                  selectedColor: Colors.white,
                  unselectedColor: Colors.white
              ),

              /// Profile
              SalomonBottomBarItem(
                icon: Icon(Icons.person,color: Colors.deepPurple[100],),
                title: Text(""),
                selectedColor: Colors.white,
                unselectedColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}