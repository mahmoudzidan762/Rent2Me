import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rent2me/auth/login.dart';
import 'package:rent2me/components/custom_button.dart';
import 'package:rent2me/components/custom_text_form_field.dart';
import 'package:rent2me/constants.dart';
import 'package:rent2me/screens/owner_home_page.dart';
import 'package:rent2me/screens/rental_home_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String id = 'RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoaing = false;
  bool? isRental;
  bool? isOwner;
  TextEditingController? email = TextEditingController();
  TextEditingController? phone = TextEditingController();
  TextEditingController? name = TextEditingController();
  TextEditingController? SSN = TextEditingController();
  TextEditingController? gender = TextEditingController();
  TextEditingController? password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addapartment() async {
    return await users
        .add({
          'name': name!.text,
          'email': email!.text,
          'password': password!.text,
          'phone': phone!.text,
          'state': (isOwner!) ? 'owner' : 'renter',
          'id': FirebaseAuth.instance.currentUser!.uid,
          'SSN': SSN!.text,
          'gender': gender!.text,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 206, 217, 220),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 206, 217, 220),
        toolbarHeight: 10.h,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Rent2Me',
            style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: (isLoaing)
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Form(
                  key: formState,
                  child: ListView(
                    children: [
                      Center(
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 143, 139, 139)),
                        ),
                      ),
                      customTextFormField(
                        icon: Icons.medical_information,
                        controller: SSN,
                        validator: (p0) {
                          if (p0 == '') return 'Shouldn\'t empty';
                        },
                        text: 'Your SSN',
                        textSize: 17.sp,
                      ),
                      customTextFormField(
                        icon: Icons.person,
                        controller: name,
                        validator: (p0) {
                          if (p0 == '') return 'Shouldn\'t empty';
                        },
                        text: 'Your Name',
                        textSize: 17.sp,
                      ),
                      customTextFormField(
                        icon: Icons.arrow_circle_up,
                        controller: gender,
                        validator: (p0) {
                          if (p0 == '') return 'Shouldn\'t empty';
                        },
                        text: 'Your Gender',
                        textSize: 17.sp,
                      ),
                      customTextFormField(
                        icon: Icons.phone,
                        validator: (p0) {
                          if (p0 == '') return 'Shouldn\'t empty';
                        },
                        controller: phone,
                        text: 'Phone',
                        textSize: 17.sp,
                      ),
                      customTextFormField(
                        icon: Icons.mail,
                        validator: (p0) {
                          if (p0 == '') return 'Shouldn\'t empty';
                        },
                        controller: email,
                        text: 'Your Mail',
                        textSize: 17.sp,
                      ),
                      customTextFormField(
                        icon: Icons.lock,
                        validator: (p0) {
                          if (p0 == '') return 'Shouldn\'t empty';
                        },
                        controller: password,
                        obscureText: true,
                        text: 'Password',
                        textSize: 17.sp,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_right,
                                      color: kPrimaryColor,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isOwner = true;
                                          isRental = false;
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 15),
                                        width: 7.w,
                                        height: 4.h,
                                        decoration: BoxDecoration(
                                            color: isOwner != null
                                                ? ((isOwner!)
                                                    ? kPrimaryColor
                                                    : Colors.white)
                                                : Colors.white,
                                            shape: BoxShape.rectangle,
                                            border: Border.all()),
                                      ),
                                    ),
                                    Text('owner'),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_right,
                                      color: kPrimaryColor,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isRental = true;
                                          isOwner = false;
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 15),
                                        width: 7.w,
                                        height: 4.h,
                                        decoration: BoxDecoration(
                                            color: isRental != null
                                                ? ((isRental!)
                                                    ? kPrimaryColor
                                                    : Colors.white)
                                                : Colors.white,
                                            shape: BoxShape.rectangle,
                                            border: Border.all()),
                                      ),
                                    ),
                                    Text('renter'),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              'Choose Your Type',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
                                  color:
                                      const Color.fromARGB(255, 143, 139, 139)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: customButton(
                          height: 5.h,
                          width: 50.w,
                          color: Colors.black,
                          onPressed: () async {
                            if (formState.currentState!.validate()) {
                              if (isOwner != null) {
                                try {
                                  isLoaing = true;
                                  setState(() {});
                                  final credential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: email!.text,
                                    password: password!.text,
                                  )
                                      .then((value) {
                                    value.user!.updateDisplayName(name!.text);
                                    addapartment();
                                  });

                                  isLoaing = false;
                                  setState(() {});

                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      (isOwner!)
                                          ? OwnerHomePage.id
                                          : RentalHomePage.id,
                                      (route) => false);
                                } on FirebaseAuthException catch (e) {
                                  isLoaing = false;
                                  setState(() {});
                                  if (e.code == 'weak-password') {
                                    print('The password provided is too weak.');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'The password provided is too weak.')));
                                  } else if (e.code == 'email-already-in-use') {
                                    print(
                                        'The account already exists for that email.');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'The account already exists for that email.')));
                                  } else {
                                    print('${e.toString()}');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error')));
                                  }
                                } catch (e) {
                                  isLoaing = false;
                                  setState(() {});
                                  print(e);
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'you should choose if you are an owner or a renter or an admin?')));
                              }
                            }
                          },
                          texts: [
                            Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already Have An Account?    '),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, LoginPage.id, (route) => false);
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
