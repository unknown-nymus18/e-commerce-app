import 'package:e_commerce/components/blur.dart';
import 'package:e_commerce/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalPrice = 0;

  Widget cartCard(String businessName, String name, String price, String desc,
      int qty, String img, String id, BuildContext context, String cartId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.17,
          motion: const BehindMotion(),
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.red,
                child: Center(
                  child: IconButton(
                    onPressed: () => deleteFromCart(context, cartId),
                    icon: const Icon(Icons.delete),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.amber,
              ),
              child: Row(
                children: [
                  Container(
                    color: Colors.grey[50],
                    width: 40,
                  ),
                  const SizedBox(
                    width: 90,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Business: $businessName',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Product: $name',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Price: Ghc$price',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Description: $desc',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          "Quantity: $qty",
                          style: const TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              height: 110,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                  errorBuilder: (context, object, track) {
                    return const Text("Could not find Image");
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void deleteFromCart(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return Blur(
          sigmaX: 7,
          sigmaY: 7,
          child: AlertDialog(
            title: const Text("DELETE FROM CART"),
            content: const Text("Do you want to delete from cart?"),
            actions: [
              MaterialButton(
                elevation: 12,
                color: Colors.amber,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              MaterialButton(
                elevation: 12,
                onPressed: () async {
                  print(id);
                  if (await ProductServices().deleteFromCart(id) == true) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: Blur(
                          sigmaX: 10,
                          sigmaY: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            // margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(15),
                            child:
                                const Text("Item has been removed from Cart"),
                          ),
                        ),
                      ),
                    );
                  }
                },
                color: Colors.amber,
                child: const Text("Yes"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder(
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
                  data['uid'],
                  data['cartId'],
                  data['busId'],
                ]);
                totalPrice = 0;
              }).toList();
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, i) {
                  totalPrice += products[i][1] * products[i][4];
                  if (i == products.length - 1) {
                    return Column(
                      children: [
                        cartCard(
                          products[i][3],
                          products[i][0],
                          products[i][1].toString(),
                          products[i][2],
                          products[i][4],
                          products[i][5],
                          products[i][6],
                          context,
                          products[i][7],
                        ),
                        ListTile(
                          leading: const Text(
                            'Total Price',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          trailing: Text(
                            'GHc${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: MaterialButton(
                            padding: const EdgeInsets.all(12),
                            color: Colors.amberAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Blur(
                                    sigmaX: 7,
                                    sigmaY: 7,
                                    child: AlertDialog(
                                      title: const Text("Place Order"),
                                      content: const Text(
                                          'Do you want to order items?'),
                                      actions: [
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          color: Colors.amber,
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        MaterialButton(
                                          color: Colors.amber,
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            if (await ProductServices()
                                                    .placeOrder(products) ==
                                                true) {
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            15),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: const Text(
                                                      "Failed to order items",
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('Yes'),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "Place Order",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  return cartCard(
                    products[i][3],
                    products[i][0],
                    products[i][1].toString(),
                    products[i][2],
                    products[i][4],
                    products[i][5],
                    products[i][6],
                    context,
                    products[i][7],
                  );
                },
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Center(
              child: Text("Ther was an error"),
            );
          },
        ),
      ),
    );
  }
}
