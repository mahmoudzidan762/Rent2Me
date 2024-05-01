import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent2me/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rent2me/auth/login.dart';
import 'package:rent2me/components/apartment_widget.dart';
import 'package:rent2me/components/custom_button.dart';
import 'package:rent2me/components/custom_text_form_field.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});
  static String id = 'AdminHomePage';

  @override
  State<AdminHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<AdminHomePage> {
  bool isLoading = true;

  bool search = false;

  List<QueryDocumentSnapshot> pendding = [];
  List<QueryDocumentSnapshot> filtred = [];
  TextEditingController searchField = TextEditingController();

  getPendding() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('pendding').get();
    pendding.addAll(querySnapshot.docs);
    setState(() {});
  }

  bind1() {
    filtred = pendding
        .where((element) =>
            (element['car brand'] as String).contains(searchField.text))
        .toList();
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
      drawer: Drawer(
        backgroundColor: kPrimaryColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  'Rent2Me',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.sp),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPage.id, (route) => false);
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_right,
                          color: Colors.black,
                        ),
                        Icon(
                          Icons.exit_to_app_rounded,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Text(
                          'Logout',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                Navigator.popAndPushNamed(context, AdminHomePage.id);
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
        title: Center(
          child: Text(
            'Rent2Me',
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: kPrimaryBackgroundColor,
      ),
      body: pendding.length == 0
          ? Center(
              child: Text(
              'no pending cars available',
              style: TextStyle(fontSize: 18.sp),
            ))
          : Column(
              children: [
                customTextFormField(
                  icon: Icons.search,
                  textSize: 17.sp,
                  text: 'Search',
                  controller: searchField,
                  onChanged: (p0) {
                    if (p0.isEmpty) {
                      search = false;
                      filtred.clear();
                    } else {
                      search = true;
                    }
                    bind1();
                  },
                ),
                Expanded(
                  child: (!search)
                      ? penddingList(pendding: pendding)
                      : filtredList(filtred: filtred),
                ),
              ],
            ),
    );
  }
}

class penddingList extends StatelessWidget {
  const penddingList({
    super.key,
    required this.pendding,
  });

  final List<QueryDocumentSnapshot<Object?>> pendding;

  void moveDocument(String sourceCollection, String sourceDocumentId,
      String destinationCollection, int int) async {
    try {
      // Get the document you want to move
      DocumentSnapshot sourceDocumentSnapshot = await FirebaseFirestore.instance
          .collection('pendding')
          .doc(pendding[int].id)
          .get();

      if (sourceDocumentSnapshot.exists) {
        // Create a copy of the document data
        Map<String, dynamic> documentData =
            sourceDocumentSnapshot.data() as Map<String, dynamic>;

        // Delete the document from the source collection
        await FirebaseFirestore.instance
            .collection('pendding')
            .doc(pendding[int].id)
            .delete();

        // Write the copied document data to the destination collection
        await FirebaseFirestore.instance
            .collection('apartments')
            .doc(pendding[int].id)
            .set(documentData);

        print('Document moved successfully.');
      } else {
        print('Document does not exist in the source collection.');
      }
    } catch (e) {
      print('An error occurred while moving the document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pendding.length,
      itemBuilder: (BuildContext, int) {
        return GestureDetector(
          onTap: () {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.question,
              animType: AnimType.rightSlide,
              title: 'Warning',
              desc: 'do you want to accept or deny ?',
              btnCancelText: 'Deny',
              btnOkText: 'Accept',
              btnOkOnPress: () async {
                moveDocument('pendding', pendding[int].id, 'apartments', int);
              },
              btnCancelOnPress: () async {
                await FirebaseFirestore.instance
                    .collection('pendding')
                    .doc(pendding[int].id)
                    .delete();
              },
            ).show();
          },
          child: Apartment(
              userId: pendding[int]['id'],
              docId: pendding[int].id,
              color: pendding[int]['color'],
              year: pendding[int]['year'],
              fuelType: pendding[int]['fuel type'],
              lisencePlate: pendding[int]['lisence Plate'],
              description: pendding[int]['description'],
              price: pendding[int]['Price'],
              matloop: pendding[int]['المطلوب'],
              carBrand: pendding[int]['car brand'],
              carModel: pendding[int]['car model'],
              imageUrl: pendding[int]['imageUrl'] != null
                  ? pendding[int]['imageUrl']
                  : ''),
        );
      },
    );
  }
}

class filtredList extends StatelessWidget {
  const filtredList({
    super.key,
    required this.filtred,
  });

  final List<QueryDocumentSnapshot<Object?>> filtred;

  void moveDocument(String sourceCollection, String sourceDocumentId,
      String destinationCollection, int int) async {
    try {
      // Get the document you want to move
      DocumentSnapshot sourceDocumentSnapshot = await FirebaseFirestore.instance
          .collection('pendding')
          .doc(filtred[int].id)
          .get();

      if (sourceDocumentSnapshot.exists) {
        // Create a copy of the document data
        Map<String, dynamic> documentData =
            sourceDocumentSnapshot.data() as Map<String, dynamic>;

        // Delete the document from the source collection
        await FirebaseFirestore.instance
            .collection('pendding')
            .doc(filtred[int].id)
            .delete();

        // Write the copied document data to the destination collection
        await FirebaseFirestore.instance
            .collection('apartments')
            .doc(filtred[int].id)
            .set(documentData);

        print('Document moved successfully.');
      } else {
        print('Document does not exist in the source collection.');
      }
    } catch (e) {
      print('An error occurred while moving the document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2000,
      child: ListView.builder(
        itemCount: filtred.length,
        itemBuilder: (BuildContext, int) {
          return GestureDetector(
              onTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  animType: AnimType.rightSlide,
                  title: 'Warning',
                  desc: 'do you want to accept or deny ?',
                  btnCancelText: 'Deny',
                  btnOkText: 'Accept',
                  btnOkOnPress: () async {
                    moveDocument(
                        'pendding', filtred[int].id, 'apartments', int);
                  },
                  btnCancelOnPress: () async {
                    await FirebaseFirestore.instance
                        .collection('filtred')
                        .doc(filtred[int].id)
                        .delete();
                  },
                ).show();
              },
              child: Apartment(
                  userId: filtred[int]['id'],
                  docId: filtred[int].id,
                  color: filtred[int]['color'],
                  year: filtred[int]['year'],
                  fuelType: filtred[int]['fuel type'],
                  lisencePlate: filtred[int]['lisence Plate'],
                  description: filtred[int]['description'],
                  price: filtred[int]['Price'],
                  matloop: filtred[int]['المطلوب'],
                  carBrand: filtred[int]['car brand'],
                  carModel: filtred[int]['car model'],
                  imageUrl: filtred[int]['imageUrl'] != null
                      ? filtred[int]['imageUrl']
                      : ''));
        },
      ),
    );
  }
}
