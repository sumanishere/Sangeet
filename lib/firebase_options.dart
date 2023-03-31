import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

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
    apiKey: 'AIzaSyDqmOnu4x4B1c6Ff-RDF8doDdaUp9zySxA',
    appId: '1:938273869324:android:b1484d29d2195f7217a829',
    messagingSenderId: '938273869324',
    projectId: 'sangeet-b4b33',
    storageBucket: 'sangeet-b4b33.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNtMVg_Dcf2_j82jFhRtnKRxDIpIHqd0o',
    appId: '1:938273869324:ios:d3436db9801821fa17a829',
    messagingSenderId: '938273869324',
    projectId: 'sangeet-b4b33',
    storageBucket: 'sangeet-b4b33.appspot.com',
    iosClientId: '938273869324-4jum6vqrp42fidvse6t8ni3unmgp7lq9.apps.googleusercontent.com',
    iosBundleId: 'com.suman.sangeet1150.ios',
  );
}
