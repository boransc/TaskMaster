import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvFirebaseOptions {
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
        throw UnsupportedError('No Firebase config for macOS.');
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError('No Firebase config for Linux.');
      default:
        throw UnsupportedError('Unsupported platform.');
    }
  }

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: dotenv.env['ANDROID_API_KEY']!,
    appId: dotenv.env['ANDROID_APP_ID']!,
    messagingSenderId: dotenv.env['ANDROID_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['ANDROID_PROJECT_ID']!,
    storageBucket: dotenv.env['ANDROID_STORAGE_BUCKET']!,
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: dotenv.env['IOS_API_KEY']!,
    appId: dotenv.env['IOS_APP_ID']!,
    messagingSenderId: dotenv.env['IOS_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['IOS_PROJECT_ID']!,
    storageBucket: dotenv.env['IOS_STORAGE_BUCKET']!,
    iosBundleId: dotenv.env['IOS_BUNDLE_ID']!,
  );

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: dotenv.env['WEB_API_KEY']!,
    appId: dotenv.env['WEB_APP_ID']!,
    messagingSenderId: dotenv.env['WEB_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['WEB_PROJECT_ID']!,
    authDomain: dotenv.env['WEB_AUTH_DOMAIN']!,
    storageBucket: dotenv.env['WEB_STORAGE_BUCKET']!,
    measurementId: dotenv.env['WEB_MEASUREMENT_ID']!,
  );

  static FirebaseOptions get windows => FirebaseOptions(
    apiKey: dotenv.env['WEB_API_KEY']!, // Same as web
    appId: dotenv.env['WINDOWS_APP_ID']!,
    messagingSenderId: dotenv.env['WEB_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['WEB_PROJECT_ID']!,
    authDomain: dotenv.env['WEB_AUTH_DOMAIN']!,
    storageBucket: dotenv.env['WEB_STORAGE_BUCKET']!,
    measurementId: dotenv.env['WINDOWS_MEASUREMENT_ID']!,
  );
}
