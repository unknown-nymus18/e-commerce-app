import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class ProductServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getProducts() {
    return _firestore.collection('products').snapshots();
  }

  Future<bool> addProduct(String productName, double price, String description,
      String businessName, int quantity, String image) async {
    try {
      final uniqueString = '$productName-${_auth.currentUser!.uid}';
      final bytes = utf8.encode(uniqueString);
      final hash = sha256.convert(bytes);

      // await _firestore.collection('products').add({
      //   'productName': productName,
      //   'price': price,
      //   'description': description,
      //   'uid': hash.toString(),
      //   'businessName': businessName,
      //   'quantity': quantity,
      //   'image': image
      // });
      _firestore.collection('products').doc(hash.toString()).set({
        'productName': productName,
        'price': price,
        'description': description,
        'uid': hash.toString(),
        'businessName': businessName,
        'quantity': quantity,
        'image': image
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addToCart(
      String productName,
      double price,
      String description,
      String businessName,
      int quantity,
      String image,
      String productId,
      int available) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(productId)
          .set({
        'productName': productName,
        'price': price,
        'description': description,
        'uid': productId,
        'businessName': businessName,
        'quantity': quantity,
        'image': image
      });

      await _firestore.collection('products').doc(productId).update({
        'quantity': available - quantity,
      });
      return true;
    } catch (e) {
      return true;
    }
  }

  Stream<QuerySnapshot> getCart() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('cart')
        .snapshots();
  }
}
