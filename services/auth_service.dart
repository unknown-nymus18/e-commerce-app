import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getCurrentUserUid() {
    return auth.currentUser!.uid;
  }

  signIn(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw Exception(e);
    }
  }

  signUp(String email, String password, String name, {String? lastName}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (lastName != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid,
            'email': email,
            'firstName': name,
            'lastName': lastName,
            'type': 'customer'
          },
        );
      } else {
        await _firestore.collection('users').doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid,
            'email': email,
            'name': name,
            'type': 'seller'
          },
        );
      }
      return userCredential;
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<QuerySnapshot> getUsers() {
    return firestore.collection('users').snapshots();
  }

  signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
