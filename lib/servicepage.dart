import 'package:authentication_ffm/optionsPage.dart';
import 'package:authentication_ffm/room1.dart';
import 'package:authentication_ffm/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {

  late TextEditingController controller;

   logout()async{
    final GoogleSignIn googleSignIn =GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn
          .signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignupPage()));
    }
    catch(e)
    {
      print(e);
    }
   }


  List<Map<String, dynamic>> chatMessages = [];
  DatabaseReference? databaseReference1;
  TextEditingController text = TextEditingController();

  List<Room1Model> room1List = [];

  ScrollController _scrollController = ScrollController();


     getRoom1Message() {
    room1List.clear();
    databaseReference1 = FirebaseDatabase.instance.ref().child("ChatRoom1");
    databaseReference1?.onValue.listen((event)async {
      // Clear the list before populating it again
      final dynamic data = event.snapshot.value;
      if (data != null) {
        room1List.clear();
        data.forEach((key, value)  {
          // print(value["uid"]);
          var room1Model = Room1Model();
          room1Model.uid = value['uid'];
          room1Model.message = value["message"];
          room1Model.time = value["time"];
          room1List.add(room1Model);
        });

        setState(() {});

        room1List.sort((a, b) => a.time!.compareTo(b.time!));
        await Future.delayed(const Duration(milliseconds: 100),(){
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        });
      }
      else
      {
        print(room1List);
      }
    });
  }

  String? uid;
  getcurrentuser()async
  {
     uid =FirebaseAuth.instance.currentUser!.uid;
  }


    //convert time and date
    String formatMillisToDateTime(String millisSinceEpoch) {
    int milliseconds = int.parse(millisSinceEpoch);
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    // Format the date and time
    String formattedDate = "${dateTime.day}'${_getMonthAbbreviation(dateTime.month)} ${_formatTwoDigits(dateTime.hour)}.${_formatTwoDigits(dateTime.minute)} ${_getPeriod(dateTime.hour)}";

    return formattedDate;
  }

  String _getMonthAbbreviation(int month) {
    List<String> monthAbbreviations = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return monthAbbreviations[month];
  }

  String _formatTwoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  String _getPeriod(int hour) {
    return hour >= 12 ? 'pm' : 'am';
  }


bool isTyping = false;
  @override
  void initState() {
    super.initState();
    getRoom1Message();
    getcurrentuser();
    controller =TextEditingController();
    controller.addListener(() {
     setState(() {
        isTyping  = controller.text.isNotEmpty;
     });
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  final databaseReference = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OptionsPage()));
                      }, icon: Icon(Icons.arrow_back_ios_sharp)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Ocean Academy Interns",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                      ),
                      IconButton(onPressed: (){
                        logout();
                      },icon : Icon(Icons.logout))
                    ],
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: room1List.length+1,
                      itemBuilder: (context, index) {
                        if (room1List.length == index) {
                          return Container(height:20);
                        } else {
                          bool isCurrentUser = room1List[index].uid == FirebaseAuth.instance.currentUser!.uid;
                          return Align(
                            alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: GestureDetector(
                              onLongPress: (){

                              },
                              child: Container(
                                //width: MediaQuery.of(context).size.width*0.8,
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7, // Set maximum width here
                                ),
                                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: isCurrentUser ? Colors.blueGrey[100] : Colors.grey[100],
                                  borderRadius: isCurrentUser
                                      ? BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )
                                      : BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${room1List[index].message!}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      formatMillisToDateTime(room1List[index].time!),
                                      style: TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(bottom: 20,top: 10,left: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width*0.8,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[300],
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextField(
                            controller: controller,
                            onTap: ()async{
                              await Future.delayed(const Duration(milliseconds: 410),(){
                                // _scrollController.animateTo(
                                //   _scrollController.position.maxScrollExtent,
                                //   duration: const Duration(milliseconds: 1),
                                //   curve: Curves.easeOut,
                                // );
                                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

                              });
                              print("heloooo");
                            },
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                border: InputBorder.none
                            ),
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),
                          ),
                        ),
                           // Icon(Icons.send,color:Colors.blueGrey[100]) ,
                        // isTyping ?
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[100],
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: IconButton(onPressed: ()  async {
                                 isTyping? await databaseReference.child("ChatRoom1").child(DateTime.now().millisecondsSinceEpoch.toString()).set(
                                {
                                  'uid': FirebaseAuth.instance.currentUser!.uid.toString(),
                                  'message': controller.text.toString(),
                                  'time': DateTime.now().millisecondsSinceEpoch.toString(),
                                },
                              ) : null;
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 50),
                                curve: Curves.easeOut,
                              );
                                controller.clear();
                            },
                                icon: Icon(Icons.send , color: isTyping?Colors.blueGrey[300]:Colors.blueGrey[50] ,)),
                        )
                            // : Icon(Icons.send,color: Colors.blueGrey[50],)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}