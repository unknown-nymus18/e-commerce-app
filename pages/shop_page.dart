import 'package:e_commerce/pages/product_card.dart';
import 'package:e_commerce/pages/product_details.dart';
import 'package:e_commerce/services/product_services.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: ProductServices().getProducts(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            List products = [];
            snapshots.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              products.add([
                data['productName'],
                data['price'],
                data['description'],
                data['businessName'],
                data['quantity'],
                data['uid'],
                data['image'],
              ]);
            }).toList();
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 330,
              ),
              itemCount: products.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                            productId: products[i][5],
                          ),
                        ),
                      );
                    },
                    child: ProductCard(
                      businessName: products[i][3],
                      name: products[i][0],
                      price: products[i][1].toString(),
                      desc: products[i][2],
                      quantity: products[i][4],
                      image: products[i][6],
                    ),
                  ),
                );
              },
            );
          }
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Text("Hello");
        },
      ),
    );
  }
}
