import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent2me/components/custom_button.dart';
import 'package:rent2me/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rent2me/components/apartment_widget.dart';
import 'package:rent2me/screens/admin_home_page.dart';

class pendingApartment extends StatefulWidget {
  const pendingApartment({
    super.key,
  });

  static String id = 'pendingApartment';
  @override
  State<pendingApartment> createState() => _pendingApartmentState();
}

class _pendingApartmentState extends State<pendingApartment> {
  List<QueryDocumentSnapshot> pendding = [];

  getPendding() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('pendding')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    pendding.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  void initState() {
    getPendding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBackgroundColor,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: customButton(
              color: kPrimaryColor,
              width: 15.w,
              height: 5.h,
              onPressed: () {
                Navigator.popAndPushNamed(context, pendingApartment.id);
              },
              texts: [
                Text(
                  'Reload',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: kPrimaryBackgroundColor,
        title: Center(
            child: Text(
          'Rent2Me',
          style: TextStyle(
              color: kPrimaryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
            itemCount: pendding.length,
            itemBuilder: (Buildcontext, i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  height: 30.h,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('${i + 1}'),
                          Text(
                            'Pending :',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pendding[i]['Price'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                ),
                              ),
                              Text(
                                pendding[i]['car model'],
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          height: 10.h,
                          width: 10.w,
                          child: Image.network(
                            pendding[i]['imageUrl'],
                          ),
                        ),
                      ),
                      Text(pendding[i]['description']),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
