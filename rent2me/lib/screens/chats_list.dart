import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rent2me/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rent2me/components/apartment_widget.dart';
import 'package:rent2me/models/message.dart';
import 'package:rent2me/screens/chat_page.dart';
import 'package:rent2me/screens/chat_page2.dart';
import 'package:pair/pair.dart';

class chatList extends StatefulWidget {
  const chatList({super.key});
  static String id = 'chatList';

  @override
  State<chatList> createState() => _chatListState();
}

class _chatListState extends State<chatList> {
  List<QueryDocumentSnapshot> myMessage = [];

  getApartments() async {
    Map<Pair<String, String>, bool> m = {};
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('messages')
        .where('to', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    for (var element in querySnapshot.docs) {
      var pair = Pair<String, String>(element['id'], element['imageUrl']);
      if (m[pair] == true) continue;
      m[pair] = true;
      myMessage.add(element);
    }
    // myMessage.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  void initState() {
    getApartments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryBackgroundColor,
        title: Text(
          'Chats',
          style: TextStyle(color: kPrimaryColor),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext, int) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, chatPage2.id, arguments: [
                  myMessage[int]['imageUrl'],
                  myMessage[int]['id']
                ]);
              },
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 251, 251, 251),
                ),
                width: double.infinity,
                height: 13.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 7.h,
                      width: 14.w,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 122, 121, 118),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          ' ${myMessage[int]['userName'][0]} ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${myMessage[int]['userName']}',
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Send a message....',
                          style: TextStyle(
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_circle_right,
                      color: kPrimaryColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: myMessage.length,
      ),
    );
  }
}
