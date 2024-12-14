import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:e_commerce/pages/edit_item_page.dart';
import 'package:e_commerce/pages/product_upload.dart';
import 'package:e_commerce/services/auth_service.dart';
import 'package:e_commerce/services/product_services.dart';
import 'package:flutter/material.dart';

class SellerHomePage extends StatefulWidget {
  final String? businessName;
  const SellerHomePage({super.key, required this.businessName});

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductUpload(
                businessName: widget.businessName!,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
      body: StreamBuilder(
        stream: ProductServices().getProducts(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            List products = [];
            snapshots.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final uniqueString =
                  '${data['productName']}-${AuthService().auth.currentUser!.uid}';
              final bytes = utf8.encode(uniqueString);
              final hash = sha256.convert(bytes);
              if (hash.toString() == data['uid']) {
                products.add([
                  data['productName'],
                  data['price'],
                  data['description'],
                  data['quantity'],
                  data['uid']
                ]);
              }
            }).toList();
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditItemPage(
                            uid: products[i][4],
                            description: products[i][2],
                            name: products[i][0],
                            price: products[i][1],
                            quantity: products[i][3],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${products[i][0]}',
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text(
                              'Price: ${products[i][1]}',
                            ),
                            Text(
                              'Description: ${products[i][2]}',
                            ),
                            Text(
                              'Quantity Available: ${products[i][3]}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Text("Hello");
        },
      ),
    );
  }
}
