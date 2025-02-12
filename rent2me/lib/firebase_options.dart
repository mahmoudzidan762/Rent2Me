// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDIRriT4adBsA4L84tsOnKE9qBsp5tk9GA',
    appId: '1:940175439524:web:e81e596180a6d141719831',
    messagingSenderId: '940175439524',
    projectId: 'rent2me-47c45',
    authDomain: 'rent2me-47c45.firebaseapp.com',
    storageBucket: 'rent2me-47c45.appspot.com',
    measurementId: 'G-1P3S4MPW77',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZjIi11Silzv7FE0ZRL4FMu-U60f4G4KU',
    appId: '1:940175439524:android:a56dfd849858c929719831',
    messagingSenderId: '940175439524',
    projectId: 'rent2me-47c45',
    storageBucket: 'rent2me-47c45.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDB0wbJpp0Z0XQuZoKba8DjExIOuhA5E2Q',
    appId: '1:940175439524:ios:664fe4ebd6670f01719831',
    messagingSenderId: '940175439524',
    projectId: 'rent2me-47c45',
    storageBucket: 'rent2me-47c45.appspot.com',
    iosBundleId: 'com.example.rent2me',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDB0wbJpp0Z0XQuZoKba8DjExIOuhA5E2Q',
    appId: '1:940175439524:ios:664fe4ebd6670f01719831',
    messagingSenderId: '940175439524',
    projectId: 'rent2me-47c45',
    storageBucket: 'rent2me-47c45.appspot.com',
    iosBundleId: 'com.example.rent2me',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDIRriT4adBsA4L84tsOnKE9qBsp5tk9GA',
    appId: '1:940175439524:web:336701c7b8cb02a0719831',
    messagingSenderId: '940175439524',
    projectId: 'rent2me-47c45',
    authDomain: 'rent2me-47c45.firebaseapp.com',
    storageBucket: 'rent2me-47c45.appspot.com',
    measurementId: 'G-CELGY8NZ5W',
  );
}
