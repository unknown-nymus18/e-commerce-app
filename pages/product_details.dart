import 'package:e_commerce/components/blur.dart';
import 'package:e_commerce/pages/add_to_cart.dart';
import 'package:e_commerce/services/product_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final String productId;
  const ProductDetails({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ScrollController controller = ScrollController();
  double scale = 1;
  int qty = 0;
  int availableQty = 0;
  Color containerColor = Colors.transparent;

  @override
  void initState() {
    controller.addListener(() {
      double fraction = (((500 - controller.offset) / 500) * 1);
      if (fraction > 0.7) {
        setState(() {
          scale = fraction;
        });
      }
      if (controller.offset > 300) {
        setState(() {
          containerColor = Colors.white;
        });
      } else {
        setState(() {
          containerColor = Colors.transparent;
        });
      }
    });
    super.initState();
  }

  Widget quantity() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              if (qty != 0) {
                setState(() {
                  qty -= 1;
                });
              }
            },
            icon: const Icon(CupertinoIcons.minus)),
        Text('$qty'),
        IconButton(
          onPressed: () {
            if (qty != availableQty) {
              setState(() {
                qty += 1;
              });
            }
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  void addToCart(
    String productName,
    double price,
    String description,
    String businessName,
    int quantity,
    String image,
    String productId,
    String busId,
  ) async {
    if (await ProductServices().addToCart(productName, price, description,
        businessName, quantity, image, productId, busId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[600]),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("Item added to cart"),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.amber),
                        foregroundColor: WidgetStatePropertyAll(Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddToCart()),
                      );
                    },
                    child: const Text('Open Cart'),
                  )
                ]),
          ),
        ),
      );
      setState(() {
        qty = 0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[600]),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(12),
            child: const Text("Failed to add to cart"),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              StreamBuilder(
                stream: ProductServices().getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List images = [];
                    snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      if (data['uid'] == widget.productId) {
                        images.add(
                          data['image'],
                        );
                        // availableQty = data['quantity'];
                        // if (qty > availableQty) {
                        //   qty = availableQty;
                        // }
                      }
                    }).toList();

                    return AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: scale,
                      child: SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: Image.network(
                          images[0],
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, object, trace) {
                            return const Text("Image cannot be Found");
                          },
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Container(
                    padding: const EdgeInsets.all(8),
                    height: 300,
                    width: double.infinity,
                    child: const Center(
                      child: Text("No image found"),
                    ),
                  );
                },
              )
            ],
          ),
          SingleChildScrollView(
            controller: controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 250,
                ),
                Blur(
                  sigmaX: 10,
                  sigmaY: 10,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                      color: containerColor,
                    ),
                    height: 1000,
                    width: double.infinity,
                    child: StreamBuilder(
                      stream: ProductServices().getProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List products = [];

                          snapshot.data!.docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;

                            if (data['uid'] == widget.productId) {
                              products.add([
                                data['productName'],
                                data['price'],
                                data['description'],
                                data['businessName'],
                                data['quantity'],
                                data['uid'],
                                data['image'],
                                data['busId']
                              ]);
                              availableQty = data['quantity'];
                              if (qty > availableQty) {
                                qty = availableQty;
                              }
                            }
                          }).toList();
                          return Column(
                            children: [
                              Text(
                                products[0][0],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(
                                color: Colors.black,
                              ),
                              ListTile(
                                title: Text('Product: ${products[0][0]}'),
                              ),
                              ListTile(
                                title: Text('Price: GHc${products[0][1]}'),
                              ),
                              ListTile(
                                title: Text('Description: ${products[0][2]}'),
                              ),
                              ListTile(
                                title: Text('Company: ${products[0][3]}'),
                              ),
                              ListTile(
                                title: Text(
                                    'Quantity available: ${products[0][4]}'),
                              ),
                              ListTile(
                                title: Row(
                                  children: [
                                    const Text(
                                      "QTY: ",
                                    ),
                                    quantity()
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              MaterialButton(
                                minWidth: double.infinity,
                                padding: const EdgeInsets.all(15),
                                color: Colors.amber,
                                onPressed: () {
                                  if (qty > 0) {
                                    addToCart(
                                      products[0][0],
                                      products[0][1],
                                      products[0][2],
                                      products[0][3],
                                      qty,
                                      products[0][6],
                                      products[0][5],
                                      products[0][7],
                                    );
                                  }
                                },
                                child: Text(
                                  availableQty != 0
                                      ? 'Add to Cart'
                                      : "Out of Stock",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              const Text(
                                "Other Products",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Divider(
                                color: Colors.black,
                              ),
                              StreamBuilder(
                                stream: ProductServices().getProducts(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List products = [];
                                    List quantity = [];
                                    snapshot.data!.docs.map((doc) {
                                      final data =
                                          doc.data() as Map<String, dynamic>;
                                      if (data['uid'] != widget.productId) {
                                        products.add([
                                          data['productName'],
                                          data['price'],
                                          data['description'],
                                          data['businessName'],
                                          data['uid'],
                                        ]);
                                        quantity.add(
                                            [data['quantity'], data['image']]);
                                        availableQty = data['quantity'];
                                        if (qty > availableQty) {
                                          qty = availableQty;
                                        }
                                      }
                                    }).toList();
                                    if (products.isNotEmpty) {
                                      return SizedBox(
                                        height: 300,
                                        child: ListView.builder(
                                          itemCount: products.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, i) {
                                            return Card(
                                              color: Colors.amberAccent,
                                              elevation: 10,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetails(
                                                          productId: products[i]
                                                              [4],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            9,
                                                          ),
                                                          child: SizedBox(
                                                            height: 110,
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                Image.network(
                                                              quantity[i][1],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          products[i][3],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        const Divider(
                                                          color: Colors.black,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Product: ${products[i][0]}',
                                                              style:
                                                                  const TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Price: Ghc${products[i][1].toString()}',
                                                              style:
                                                                  const TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Description: ${products[i][2]}',
                                                              style:
                                                                  const TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Qty Available: ${quantity[i][0]}',
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      return const Text(
                                          "No Available Products");
                                    }
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  return const Text("An Error Occured");
                                },
                              ),
                            ],
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return const Text("Error");
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
