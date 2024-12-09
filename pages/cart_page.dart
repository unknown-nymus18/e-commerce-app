import 'package:e_commerce/services/product_services.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: ProductServices().getCart(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List products = [];
            snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              products.add([
                data['productName'],
                data['price'],
                data['description'],
                data['businessName'],
                data['quantity'],
                data['image'],
              ]);
            }).toList();

            return ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(products[i][0])],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return const Center(
            child: Text("Ther was an error"),
          );
        },
      ),
    );
  }
}
