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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDstLv-PL5DpwvSOV-wGwuezUogi4e8LNo',
    appId: '1:153323615895:web:6e7e341d315e19921b1bd2',
    messagingSenderId: '153323615895',
    projectId: 'koinonia-c5163',
    authDomain: 'koinonia-c5163.firebaseapp.com',
    storageBucket: 'koinonia-c5163.appspot.com',
    measurementId: 'G-708M618KQD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmrnnd_Ouy99rZwAMof9P6MuT4UgTqHPg',
    appId: '1:153323615895:android:18f41f75d7a52eba1b1bd2',
    messagingSenderId: '153323615895',
    projectId: 'koinonia-c5163',
    storageBucket: 'koinonia-c5163.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBysux3-GWJGb-fubxc0C8pELx9HEgPwCY',
    appId: '1:153323615895:ios:ba8fa59e69f381be1b1bd2',
    messagingSenderId: '153323615895',
    projectId: 'koinonia-c5163',
    storageBucket: 'koinonia-c5163.appspot.com',
    iosClientId: '153323615895-vkl0l9kk2cob9ne8iui6vd4a3iqu2fsr.apps.googleusercontent.com',
    iosBundleId: 'com.koinonia.connect',
  );
}
