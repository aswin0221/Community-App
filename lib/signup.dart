import 'package:authentication_ffm/Daily%20tasks/relapse_historyPage.dart';
import 'package:authentication_ffm/optionsPage.dart';
import 'package:authentication_ffm/servicepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RelapseHistory {
  final String uid;
  final int startTime;
  final int endTime;

  RelapseHistory({
    required this.uid,
    required this.startTime,
    required this.endTime,
  });
}


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {


  ///For relaspse history

  late Database _database;
  late List<RelapseHistory> _relapseHistory = [];

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'relapse_history.db'),
    );
  }

  Future<void> _retrieveRelapseHistory() async {
    try {
      final List<Map<String, dynamic>> relapseHistoryMaps =
      await _database.query('relapses');

      setState(() {
        _relapseHistory = relapseHistoryMaps
            .map((map) => RelapseHistory(
          uid: FirebaseAuth.instance.currentUser?.uid ?? "",
          startTime: map['startTime'],
          endTime: map['endTime'],
        ))
            .toList();
      });
    } catch (e) {
      print('Error retrieving relapse history: $e');
      // Handle error, e.g., show an error message to the user
    }
  }




  int? currentStreak;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  getCurrentStreak() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      currentStreak = pref.getInt("currentStreak") ?? DateTime.now().millisecondsSinceEpoch;
    });
  }
  
  signup(String name , String email, String password , BuildContext context)async
  {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) =>
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
          "name" : name,
          "email" : email,
        }).then((value) {
          FirebaseFirestore.instance.collection("currentStreak").doc(FirebaseAuth.instance.currentUser!.uid).set({
            "currentStreak" : currentStreak
          });
        })
    );
    FirebaseFirestore.instance.collection("relapseHistory").doc().set({
      "user":"",
      "startDate":"",
      "endDate":""
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OptionsPage()));
  }
  void googleSignIn()
  {
    try{
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      FirebaseAuth.instance.signInWithProvider(authProvider);
    }catch(e)
    {
      print(e);
    }
  }

   _googlesignin( BuildContext context)async{
  final GoogleSignIn googleSignIn =GoogleSignIn();

      try{
        final  GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
        if(googleSignInAccount != null)
          {
            final GoogleSignInAuthentication googleSignInAuthentication = await
                googleSignInAccount.authentication;
            final AuthCredential credential = GoogleAuthProvider.credential(
              idToken: googleSignInAuthentication.idToken,
              accessToken: googleSignInAuthentication.accessToken
            );
            UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

            FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
              "name":userCredential.user!.displayName,
              "email":userCredential.user!.email,
            });
            DocumentReference documentRef = FirebaseFirestore.instance.collection("currentStreak").doc(FirebaseAuth.instance.currentUser!.uid);
            DocumentSnapshot documentSnapshot =await documentRef.get();
            if(documentSnapshot.exists)
              {
                final map = documentSnapshot.data() as Map<String , dynamic>;
                int currentStreak = map["currentStreak"];
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setInt("currentStreak", currentStreak);
              }
            else
              {
                SharedPreferences pref = await SharedPreferences.getInstance();
                int currentStreak = pref.getInt("currentStreak") ?? DateTime.now().millisecondsSinceEpoch;
                FirebaseFirestore.instance.collection("currentStreak").doc(FirebaseAuth.instance.currentUser!.uid).set({
                  "currentStreak" :currentStreak
                });
                pref.setInt("currentStreak", currentStreak);
              }
            print(userCredential.user!.displayName);
            print(userCredential.user!.email);
            print(userCredential.user!.uid);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OptionsPage()));
          }
      }
      catch(e)
     {
       print(e);
     }
  }


  @override
  void initState() {
    // TODO: implement initState
    _initializeDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Text("Sign-Up Form"),
              SizedBox(height: 20,),
              TextField(
                controller: name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Name"
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email"
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: password,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Password"
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                signup(name.text, email.text, password.text ,context);
              }, child: Text("Create Account",style:TextStyle(color: Colors.blue) ,) , style: ElevatedButton.styleFrom(fixedSize: Size.fromHeight(50),backgroundColor: Colors.white ,surfaceTintColor: Colors.white ,foregroundColor: Colors.red),),
              SizedBox(height: 20,),
              Divider(),
              TextButton(onPressed: (){
                // googleSignIn();
               // googleSignIn();
                _googlesignin(context);
              }, child: Text("Login With Google",style: TextStyle(color: Colors.blue),)),

              TextButton(onPressed: () async{
                await _retrieveRelapseHistory();
                for( RelapseHistory e in _relapseHistory)
                  {
                    print(e.startTime);
                    print(e.endTime);
                  }
              }, child: Text("Try"))
            ],
          ),
        ),
      )
    );
  }
}
