import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB8Q7vVn0YsAS5kpDGb7LSVWz27mC3u5BM",
            authDomain: "distracted-driving-oix5fw.firebaseapp.com",
            projectId: "distracted-driving-oix5fw",
            storageBucket: "distracted-driving-oix5fw.appspot.com",
            messagingSenderId: "197589592344",
            appId: "1:197589592344:web:25ac233be77a819c45966d"));
  } else {
    await Firebase.initializeApp();
  }
}
