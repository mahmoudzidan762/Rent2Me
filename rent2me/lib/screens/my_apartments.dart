import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:rent2me/components/custom_button.dart';
import 'package:rent2me/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rent2me/components/apartment_widget.dart';
import 'package:rent2me/screens/add_apartment.dart';
import 'package:rent2me/screens/edit_apartment.dart';

class MyApartments extends StatefulWidget {
  const MyApartments({super.key});
  static String id = 'MyApartments';

  @override
  State<MyApartments> createState() => _MyApartmentsState();
}

class _MyApartmentsState extends State<MyApartments> {
  List<QueryDocumentSnapshot> apartments = [];

  getApartments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('apartments')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    apartments.addAll(querySnapshot.docs);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddApartment.id);
        },
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.add_card_rounded,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: customButton(
              color: kPrimaryColor,
              width: 15.w,
              height: 5.h,
              onPressed: () {
                Navigator.popAndPushNamed(context, MyApartments.id);
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
              fontSize: 20.sp,
              fontWeight: FontWeight.bold),
        )),
      ),
      body: apartments.length == 0
          ? Center(
              child: Text(
              'no Cars available',
              style: TextStyle(fontSize: 18.sp),
            ))
          : ListView.builder(
              itemCount: apartments.length,
              itemBuilder: (BuildContext, int) {
                return GestureDetector(
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      title: 'Warning',
                      desc: 'do you want to delete or edit ?',
                      btnCancelText: 'Delete',
                      btnOkText: 'Edit',
                      btnOkOnPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditApartment(
                              olddescription: apartments[int]['description'],
                              oldcarBrand: apartments[int]['car brand'],
                              oldcarModel: apartments[int]['car model'],
                              oldcolor: apartments[int]['color'],
                              oldlisencePlate: apartments[int]['lisence Plate'],
                              oldfuelType: apartments[int]['fuel type'],
                              oldimageUrl: apartments[int]['imageUrl'],
                              olddocId: apartments[int].id,
                              olduserId: apartments[int]['id'],
                              oldyear: apartments[int]['year'],
                              oldmatloop: apartments[int]['المطلوب'],
                              oldprice: apartments[int]['Price'],
                            ),
                          ),
                        );
                      },
                      btnCancelOnPress: () {
                        FirebaseFirestore.instance
                            .collection('apartments')
                            .doc(apartments[int].id)
                            .delete();
                        Navigator.popAndPushNamed(context, MyApartments.id);
                      },
                    ).show();
                  },
                  child: Apartment(
                      userId: apartments[int]['id'],
                      docId: apartments[int].id,
                      color: apartments[int]['color'],
                      year: apartments[int]['year'],
                      fuelType: apartments[int]['fuel type'],
                      lisencePlate: apartments[int]['lisence Plate'],
                      description: apartments[int]['description'],
                      price: apartments[int]['Price'],
                      matloop: apartments[int]['المطلوب'],
                      carBrand: apartments[int]['car brand'],
                      carModel: apartments[int]['car model'],
                      imageUrl: apartments[int]['imageUrl'] != null
                          ? apartments[int]['imageUrl']
                          : ''),
                );
              },
            ),
    );
  }
}
