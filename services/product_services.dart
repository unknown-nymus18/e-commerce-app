import 'dart:async';

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

  final Timestamp timeStamp = Timestamp.now();

  Future<bool> addToCart(
    String productName,
    double price,
    String description,
    String businessName,
    int quantity,
    String image,
    String productId,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(productId + timeStamp.toString())
          .set({
        'productName': productName,
        'price': price,
        'description': description,
        'uid': productId,
        'businessName': businessName,
        'quantity': quantity,
        'image': image,
        'timestamp': timeStamp,
      });

      DocumentSnapshot docQuery =
          await _firestore.collection('products').doc(productId).get();

      if (docQuery.exists) {
        Map<String, dynamic>? data = docQuery.data() as Map<String, dynamic>?;
        if (data == null) return false;
        int? available = data['quantity'];

        if (available == null) return false;

        await _firestore.collection('products').doc(productId).update({
          'quantity': available - quantity,
        });
      }

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
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<bool> deleteFromCart(String productID) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(productID)
          .delete();
      print(_auth.currentUser!.uid);
      print(productID);
      return true;
    } catch (e) {
      return false;
    }
  }
}
