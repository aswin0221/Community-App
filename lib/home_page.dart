import 'dart:ui';

import 'package:authentication_ffm/login.dart';
import 'package:authentication_ffm/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.jpg"),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50) , bottomRight: Radius.circular(50) )
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), // Adjust the sigma values for the desired blur strength
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/welcome.svg"),
                  SizedBox(height:50,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),fixedSize: Size.fromWidth(500), ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                    },
                    // child: Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: const Center(
                    //     child: Text(
                    //       "Login",style: TextStyle(fontSize: 20, color:Colors.deepPurple),
                    //     ),
                    //   ),
                    // ),
                    child: Text("Login"),
                  ),
                  SizedBox(height:20,),
                  InkWell(
                    onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign up",style: TextStyle(fontSize: 20, color:Colors.deepPurple),
                        ),
                      ),
                    ),
                  ),SizedBox(height:20,),
                  InkWell(
                    onTap: (){
          
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Guest Mode",style: TextStyle(fontSize: 20 , color:Colors.deepPurple),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
