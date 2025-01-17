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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
            'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgTytZJKMMM-TOkS8YC_HtwnqvQ8DNGAk',
    appId: '1:501045250179:android:0734a50fe48ee01adef3b6',
    messagingSenderId: '501045250179',
    projectId: 'movie-app-sk',
    storageBucket: 'movie-app-sk.firebasestorage.app',
  );


  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFvl1vHIH6XzPf66SiL6XZAG9ALphmc6s',
    appId: '1:501045250179:ios:a2bdb1c47255b2d6def3b6',
    messagingSenderId: '501045250179',
    projectId: 'movie-app-sk',
    storageBucket: 'movie-app-sk.firebasestorage.app',
    iosBundleId: 'com.example.movieApp',
  );
}
