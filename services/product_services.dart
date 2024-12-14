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
        'image': image,
        'busId': _auth.currentUser!.uid,
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
      String busId) async {
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
        'cartId': productId + timeStamp.toString(),
        'busId': busId
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
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<bool> deleteFromCart(String cartId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(cartId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> placeOrder(List items) async {
    try {
      for (int i = 0; i < items.length; i++) {
        String busId = items[i][8];
        double price = items[i][1];
        String cartId = items[i][7];
        int quantity = items[i][4];
        String uid = items[i][6];
        String name = items[i][0];
        String desc = items[i][2];
        await _firestore
            .collection('users')
            .doc(busId)
            .collection('orders')
            .doc(cartId)
            .set({
          'name': name,
          'uid': uid,
          'price': price,
          'quantity': quantity,
          'description': desc,
        });

        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('orders')
            .doc(cartId)
            .set({
          'name': name,
          'uid': uid,
          'price': price,
          'quantity': quantity,
          'description': desc,
        });

        DocumentSnapshot docQuery =
            await _firestore.collection('products').doc(uid).get();

        if (docQuery.exists) {
          Map<String, dynamic>? data = docQuery.data() as Map<String, dynamic>?;
          if (data == null) return false;
          int? available = data['quantity'];

          if (available == null) return false;
          if (available - quantity <= 0) return false;

          await _firestore.collection('products').doc(uid).update({
            'quantity': available - quantity,
          });
        }
        bool clearCart = await deleteFromCart(cartId);
        if (clearCart == false) return clearCart;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> getOrders() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('orders')
        .snapshots();
  }

  Future<bool> editProduct(
      String productId, String name, String desc, double price, int quantiy,
      [String? imgUrl]) async {
    try {
      if (imgUrl != null) {
        await _firestore.collection('products').doc(productId).update({
          'name': name,
          'description': desc,
          'price': price,
          'quantity': quantiy,
          'image': imgUrl,
        });
      } else {
        await _firestore.collection('products').doc(productId).update({
          'name': name,
          'description': desc,
          'price': price,
          'quantity': quantiy,
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
