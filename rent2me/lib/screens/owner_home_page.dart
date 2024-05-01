import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rent2me/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rent2me/components/apartment_widget.dart';
import 'package:rent2me/components/custom_button.dart';
import 'package:rent2me/components/custom_text_form_field.dart';
import 'package:rent2me/auth/login.dart';
import 'package:rent2me/screens/chats_list.dart';
import 'package:rent2me/screens/my_apartments.dart';
import 'package:rent2me/screens/pending_apartment.dart';

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({super.key});
  static String id = 'OwnerHomePage';

  @override
  State<OwnerHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<OwnerHomePage> {
  bool search = false;
  TextEditingController searchField = TextEditingController();
  List<QueryDocumentSnapshot> apartments = [];
  List<QueryDocumentSnapshot> filtred = [];

  bind() {
    filtred = apartments
        .where((e) => (e['car brand'] as String).contains(searchField.text))
        .toList();
    setState(() {});
  }

  getApartments() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('apartments').get();
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
                  onTap: () {
                    Navigator.pushNamed(context, MyApartments.id);
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.car_crash,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Text(
                          'My cars',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, pendingApartment.id);
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Text(
                          'On Pending',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, chatList.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.chat,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Text(
                          'Chats',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
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
                Navigator.popAndPushNamed(context, OwnerHomePage.id);
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
      body: apartments.length == 0
          ? Center(
              child: Text(
              'no cars available',
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
                    bind();
                  },
                ),
                Expanded(
                  child: (!search)
                      ? apartmentList(apartments: apartments)
                      : filtredList(filtred: filtred),
                ),
              ],
            ),
    );
  }
}

class apartmentList extends StatelessWidget {
  const apartmentList({
    super.key,
    required this.apartments,
  });

  final List<QueryDocumentSnapshot<Object?>> apartments;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: apartments.length,
      itemBuilder: (BuildContext, int) {
        return Apartment(
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
                : '');
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: filtred.length,
      itemBuilder: (BuildContext, int) {
        return Apartment(
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
                : '');
      },
    );
  }
}
