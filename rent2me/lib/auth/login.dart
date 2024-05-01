import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rent2me/auth/register_page.dart';
import 'package:rent2me/components/custom_button.dart';
import 'package:rent2me/components/custom_text_form_field.dart';
import 'package:rent2me/constants.dart';
import 'package:rent2me/screens/admin_home_page.dart';
import 'package:rent2me/screens/owner_home_page.dart';
import 'package:rent2me/screens/rental_home_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoaing = false;
  bool? isOwner;
  bool? isRental;
  bool? isAdmin;
  TextEditingController? email = TextEditingController();
  TextEditingController? password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 206, 217, 220),
      body: (isLoaing)
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formState,
                  child: ListView(
                    children: [
                      Container(
                        height: 70.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Log in',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.sp,
                                  color:
                                      const Color.fromARGB(255, 143, 139, 139)),
                            ),
                            customTextFormField(
                              icon: Icons.mail,
                              validator: (p0) {
                                if (p0 == '') return 'shouldn\'t empty';
                              },
                              controller: email,
                              text: 'Email Address',
                              textSize: 17.sp,
                            ),
                            customTextFormField(
                              icon: Icons.lock,
                              validator: (p0) {
                                if (p0 == '') return 'shouldn\'t empty';
                              },
                              controller: password,
                              obscureText: true,
                              text: 'password',
                              textSize: 17.sp,
                            ),
                            Row(
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
                                              isAdmin = false;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 15),
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
                                              isAdmin = false;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 15),
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
                                              isRental = false;
                                              isOwner = false;
                                              isAdmin = true;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 15),
                                            width: 7.w,
                                            height: 4.h,
                                            decoration: BoxDecoration(
                                                color: isAdmin != null
                                                    ? ((isAdmin!)
                                                        ? kPrimaryColor
                                                        : Colors.white)
                                                    : Colors.white,
                                                shape: BoxShape.rectangle,
                                                border: Border.all()),
                                          ),
                                        ),
                                        Text('admin'),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  'Choose Your Type',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.sp,
                                      color: const Color.fromARGB(
                                          255, 143, 139, 139)),
                                ),
                              ],
                            ),
                            customButton(
                              onPressed: () async {
                                if (formState.currentState!.validate()) {
                                  if (isOwner != null) {
                                    try {
                                      isLoaing = true;
                                      setState(() {});
                                      final credential = await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                              email: email!.text,
                                              password: password!.text);

                                      QuerySnapshot<Map<String, dynamic>> state;
                                      state = await FirebaseFirestore.instance
                                          .collection('users')
                                          .where('id',
                                              isEqualTo: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .get();
                                      if ((state.docs[0]['state'] == 'renter' &&
                                              isRental != true) ||
                                          (state.docs[0]['state'] == 'owner' &&
                                              isOwner != true) ||
                                          (state.docs[0]['state'] == 'admin' &&
                                              isAdmin != true)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'wrong type please choose your type correctly'),
                                          ),
                                        );
                                        isLoaing = false;
                                        setState(() {});
                                      } else {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            (isAdmin!)
                                                ? AdminHomePage.id
                                                : (isOwner!)
                                                    ? OwnerHomePage.id
                                                    : RentalHomePage.id,
                                            (route) => false);
                                        isLoaing = false;
                                        setState(() {});
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      isLoaing = false;
                                      setState(() {});
                                      if (e.code == 'user-not-found') {
                                        print('No user found for that email.');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'No user found for that email.')));
                                      } else if (e.code == 'wrong-password') {
                                        print(
                                            'Wrong password provided for that user.');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Wrong password provided for that user.')));
                                      } else {
                                        print('${e.toString()}');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'incorrect email or password')));
                                      }
                                    } catch (e) {
                                      isLoaing = false;
                                      setState(() {});
                                      print('${e.toString()}');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'No user found for that email.')));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'you should choose if you are an owner or a renter or an admin?')));
                                  }
                                }
                              },
                              texts: [
                                Text(
                                  'submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                              color: Colors.black,
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Need A new account ?   '),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RegisterPage.id);
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (email!.text != '') {
                                  try {
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: email!.text);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'check your email to change your password')));
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Please enter your email first')));
                                }
                              },
                              child: Text(
                                'Forget password ?',
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
