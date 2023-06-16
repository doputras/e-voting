import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDgaQPK0Gbpuqo_9bB4e5UAZORtLZDZuOk',
    appId: '1:1023440542110:web:fc6d1bf81495f0003fde8f',
    messagingSenderId: '1023440542110',
    projectId: 'tubes-uts-53c84',
    authDomain: 'tubes-uts-53c84.firebaseapp.com',
    storageBucket: 'tubes-uts-53c84.appspot.com',
    measurementId: 'G-J534ZKH6F3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAflq_YAimrXj-t5lUUxp2gtWLiG6T1gpA',
    appId: '1:1023440542110:android:26c4de68cf66b6b33fde8f',
    messagingSenderId: '1023440542110',
    projectId: 'tubes-uts-53c84',
    storageBucket: 'tubes-uts-53c84.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBrV1lWaXft26DsyAMfSef2ynYQYZamkzg',
    appId: '1:1023440542110:ios:4d7ee47af1a1b1d43fde8f',
    messagingSenderId: '1023440542110',
    projectId: 'tubes-uts-53c84',
    storageBucket: 'tubes-uts-53c84.appspot.com',
    iosClientId:
        '1023440542110-1pfoq0nfeei7is1p9n67a7uvji8r24mn.apps.googleusercontent.com',
    iosBundleId: 'com.example.tubesuts',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBrV1lWaXft26DsyAMfSef2ynYQYZamkzg',
    appId: '1:1023440542110:ios:4d7ee47af1a1b1d43fde8f',
    messagingSenderId: '1023440542110',
    projectId: 'tubes-uts-53c84',
    storageBucket: 'tubes-uts-53c84.appspot.com',
    iosClientId:
        '1023440542110-1pfoq0nfeei7is1p9n67a7uvji8r24mn.apps.googleusercontent.com',
    iosBundleId: 'com.example.tubesuts',
  );
}
