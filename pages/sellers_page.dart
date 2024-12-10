// import 'package:e_commerce/components/blur.dart';
import 'package:e_commerce/pages/product_upload.dart';
import 'package:e_commerce/services/auth_service.dart';
import 'package:e_commerce/services/product_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SellersPage extends StatefulWidget {
  final String? businessName;
  const SellersPage({super.key, this.businessName});

  @override
  State<SellersPage> createState() => _SellersPageState();
}

class _SellersPageState extends State<SellersPage> {
  TextEditingController productName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  @override
  void initState() {
    if (qtyController.text.isEmpty) {
      qtyController.text = '0';
    }
    super.initState();
  }

  Widget qty() {
    return Row(
      children: [
        const Text("Quantity:"),
        IconButton(
            onPressed: () {
              if (int.parse(qtyController.text) != 0) {
                setState(() {
                  qtyController.text =
                      (int.parse(qtyController.text) - 1).toString();
                });
              }
            },
            icon: const Icon(CupertinoIcons.minus)),
        SizedBox(
          width: 50,
          child: TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                qtyController.text =
                    (int.parse(qtyController.text) + 1).toString();
              });
            },
            icon: const Icon(Icons.add))
      ],
    );
  }

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
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Seller"),
        actions: [
          IconButton(
            onPressed: () {
              AuthService().signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      // body: Center(
      //   child: MaterialButton(
      //     onPressed: () {
      //       AuthService().signOut();
      //     },
      //     child: const Text('SignOut'),
      //   ),
      // ),
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
                  ]);
                }
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
                    );
                  });
            }
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Text("Hello");
          }),
    );
  }
}
