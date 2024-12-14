import 'package:e_commerce/services/product_services.dart';
import 'package:flutter/material.dart';

class CustomerOrdersPage extends StatelessWidget {
  const CustomerOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: ProductServices().getOrders(),
        builder: (context, snapshots) {
          List products = [];
          if (snapshots.hasData) {
            snapshots.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              products.add(
                [
                  data['uid'],
                  data['quantity'],
                  data['price'],
                  data['name'],
                  data['description']
                ],
              );
            }).toList();
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${products[i][3]}',
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            'Price: ${products[i][2]}',
                          ),
                          Text(
                            'Description: ${products[i][4]}',
                          ),
                          Text(
                            'Quantity: ${products[i][1]}',
                          ),
                        ],
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
          return const Center(
            child: Text("An Error occured"),
          );
        },
      ),
    );
  }
}
