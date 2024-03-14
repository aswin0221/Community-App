import 'package:authentication_ffm/optionsPage.dart';
import 'package:authentication_ffm/servicepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signup(String name , String email, String password)async
  {
    print("___________________");
    print(name);
    print("___________________");
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) =>
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
          "name" : name,
          "email" : email,
        })
    );
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

   _googlesignin()async{
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
                signup(name.text, email.text, password.text);
              }, child: Text("Create Account",style:TextStyle(color: Colors.blue) ,) , style: ElevatedButton.styleFrom(fixedSize: Size.fromHeight(50),backgroundColor: Colors.white ,surfaceTintColor: Colors.white ,foregroundColor: Colors.red),),
              SizedBox(height: 20,),
              Divider(),
              TextButton(onPressed: (){
                // googleSignIn();
               // googleSignIn();
                _googlesignin();
              }, child: Text("Login With Google",style: TextStyle(color: Colors.blue),))
            ],
          ),
        ),
      )
    );
  }
}
