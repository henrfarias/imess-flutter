// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC-cMtzBNPjWzLrdqsSwcZuDLIqT2moUD0',
    appId: '1:975669271669:web:b83e1009b65382c0192c3c',
    messagingSenderId: '975669271669',
    projectId: 'imess-e31b2',
    authDomain: 'imess-e31b2.firebaseapp.com',
    storageBucket: 'imess-e31b2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPdAPLg68HFIiX76YSx6CmLqX-TcsEElQ',
    appId: '1:975669271669:android:57710a1156c81d51192c3c',
    messagingSenderId: '975669271669',
    projectId: 'imess-e31b2',
    storageBucket: 'imess-e31b2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXTNxIiF0CDo2Ni-uaWE1p9rbsplmSS54',
    appId: '1:975669271669:ios:9193b3199f080ad9192c3c',
    messagingSenderId: '975669271669',
    projectId: 'imess-e31b2',
    storageBucket: 'imess-e31b2.appspot.com',
    iosBundleId: 'com.example.imess',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBXTNxIiF0CDo2Ni-uaWE1p9rbsplmSS54',
    appId: '1:975669271669:ios:3bb827212b1869ff192c3c',
    messagingSenderId: '975669271669',
    projectId: 'imess-e31b2',
    storageBucket: 'imess-e31b2.appspot.com',
    iosBundleId: 'com.example.imess.RunnerTests',
  );
}
