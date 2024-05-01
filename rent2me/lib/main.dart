import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart';
import 'package:rent2me/auth/login.dart';
import 'package:rent2me/auth/register_page.dart';
import 'package:rent2me/constants.dart';
import 'package:rent2me/screens/add_apartment.dart';
import 'package:rent2me/screens/admin_home_page.dart';
import 'package:rent2me/screens/chat_page.dart';
import 'package:rent2me/screens/chat_page2.dart';
import 'package:rent2me/screens/chats_list.dart';
import 'package:rent2me/screens/edit_apartment.dart';
import 'package:rent2me/screens/my_apartments.dart';
import 'package:rent2me/screens/owner_home_page.dart';
import 'package:rent2me/screens/pending_apartment.dart';
import 'package:rent2me/screens/rental_home_page.dart';
import 'firebase_options.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const rent2me(),
  );
}

class rent2me extends StatefulWidget {
  const rent2me({super.key});

  @override
  State<rent2me> createState() => _rent2meState();
}

class _rent2meState extends State<rent2me> {
  bool flag = false;
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        flag = true;
        print('User is currently signed out!');
      } else {
        flag = false;
        print('User is signed in!');
      }
    });
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return MaterialApp(
          routes: {
            LoginPage.id: (context) => LoginPage(),
            OwnerHomePage.id: (context) => OwnerHomePage(),
            RegisterPage.id: (context) => RegisterPage(),
            RentalHomePage.id: (context) => RentalHomePage(),
            AdminHomePage.id: (context) => AdminHomePage(),
            MyApartments.id: (context) => MyApartments(),
            AddApartment.id: (context) => AddApartment(),
            EditApartment.id: (Context) => EditApartment(),
            chatPage.id: (context) => chatPage(),
            chatList.id: (context) => chatList(),
            chatPage2.id: (context) => chatPage2(),
            pendingApartment.id: (context) => pendingApartment(),
          },
          debugShowCheckedModeBanner: false,
          home: AnimatedSplashScreen(
            duration: 2500,
            splash: Image.asset('assets/images/car-1024.png'),
            nextScreen: LoginPage(),
            backgroundColor: kPrimaryBackgroundColor,
          ),
        );
      },
    );
  }
}
