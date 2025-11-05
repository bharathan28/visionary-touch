import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    // You can add FirebaseAuth.instance, Firestore configs here later
  }
}
