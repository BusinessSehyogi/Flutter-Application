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
    apiKey: 'AIzaSyAbZHN7lAKXQNV4aQcGl9W6sSjpPCgKVT0',
    appId: '1:780888034585:web:8b44f036a8c66570df4988',
    messagingSenderId: '780888034585',
    projectId: 'business-sehyogi',
    authDomain: 'business-sehyogi.firebaseapp.com',
    storageBucket: 'business-sehyogi.appspot.com',
    measurementId: 'G-ZBK29X70KK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCiNUVDuC1BxksLqdvF3dvweVYTeZSnvNo',
    appId: '1:780888034585:android:a58ca206d4740a6bdf4988',
    messagingSenderId: '780888034585',
    projectId: 'business-sehyogi',
    storageBucket: 'business-sehyogi.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjV9rqo9iSxPcimlAY0_yAC_AJjtofCJE',
    appId: '1:780888034585:ios:bcbd61a10394574ddf4988',
    messagingSenderId: '780888034585',
    projectId: 'business-sehyogi',
    storageBucket: 'business-sehyogi.appspot.com',
    iosBundleId: 'com.example.businessSehyogi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBjV9rqo9iSxPcimlAY0_yAC_AJjtofCJE',
    appId: '1:780888034585:ios:bcbd61a10394574ddf4988',
    messagingSenderId: '780888034585',
    projectId: 'business-sehyogi',
    storageBucket: 'business-sehyogi.appspot.com',
    iosBundleId: 'com.example.businessSehyogi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAbZHN7lAKXQNV4aQcGl9W6sSjpPCgKVT0',
    appId: '1:780888034585:web:5bf084afded0cb6fdf4988',
    messagingSenderId: '780888034585',
    projectId: 'business-sehyogi',
    authDomain: 'business-sehyogi.firebaseapp.com',
    storageBucket: 'business-sehyogi.appspot.com',
    measurementId: 'G-MR72JX4342',
  );
}
