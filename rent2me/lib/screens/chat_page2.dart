import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:rent2me/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rent2me/components/chat_bubble.dart';
import 'package:rent2me/components/chat_bubble2.dart';
import 'package:rent2me/models/message.dart';

class chatPage2 extends StatefulWidget {
  chatPage2({super.key, this.docId});
  static String id = 'chatPage2';
  String? docId;

  @override
  State<chatPage2> createState() => _chatPage2State();
}

class _chatPage2State extends State<chatPage2> {
  String? text;

  final ScrollController scrollController = ScrollController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  // CollectionReference apartments =
  //     FirebaseFirestore.instance.collection('apartments');

  TextEditingController controler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var list = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(Message.fromjeson(snapshot.data!.docs[i]));
          }
          List<Message> myList = [];
          for (int i = 0; i < messageList.length; i++) {
            if ((messageList[i].to == FirebaseAuth.instance.currentUser!.uid &&
                    messageList[i].imageUrl == list[0] &&
                    list[1] == messageList[i].id) ||
                (messageList[i].imageUrl == list[0] &&
                    messageList[i].to == list[1] &&
                    messageList[i].id ==
                        FirebaseAuth.instance.currentUser!.uid)) {
              myList.add(messageList[i]);
            }
          }
          return Scaffold(
            backgroundColor: kPrimaryBackgroundColor,
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              title: Text(
                'Chat',
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      reverse: true,
                      controller: scrollController,
                      itemCount: myList.length,
                      itemBuilder: (context, index) {
                        return myList[index].id ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? chatBubble2(
                                message: myList[index],
                              )
                            : chatBubble(
                                message: myList[index],
                              );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controler,
                    onChanged: (value) {
                      text = value;
                    },
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          messages.add({
                            'message': text,
                            'createdAt': DateTime.now(),
                            'id': FirebaseAuth.instance.currentUser!.uid,
                            'imageUrl': list[0],
                            'userName':
                                FirebaseAuth.instance.currentUser!.displayName,
                            'to': list[1]
                          });

                          controler.clear();
                          scrollController.animateTo(
                            0,
                            duration: Duration(seconds: 2),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                        child: Icon(
                          Icons.send,
                          color: kPrimaryColor,
                        ),
                      ),
                      hintText: 'Send a message',
                      hintStyle: TextStyle(color: kPrimaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
