import 'package:e_commerce/components/blur.dart';
import 'package:e_commerce/pages/cart_page.dart';
import 'package:e_commerce/pages/shop_page.dart';
import 'package:e_commerce/services/auth_service.dart';
import 'package:e_commerce/services/customer_orders_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  int index = 0;

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Customer"),
        actions: [
          Text("Orders"),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomerOrdersPage(),
                ),
              );
            },
            child: Image.asset(
              'lib/assets/images/check-out.png',
            ),
          ),
        ],
      ),
      drawer: Drawer(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(child: Center(child: Text("Hello"))),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text("About"),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => Blur(
                      sigmaX: 7,
                      sigmaY: 7,
                      child: AlertDialog(
                        title: const Text("About"),
                        content: SizedBox(
                          height: 60,
                          child: Column(children: [
                            const Text("This e-commerce app is made by Felix."),
                            InkWell(
                              child: const Text(
                                "https://github.com/unknown-nymus18",
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () => _launchURL(
                                "https://github.com/unknown-nymus18",
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) {
                      return Blur(
                        sigmaX: 7,
                        sigmaY: 7,
                        child: AlertDialog(
                          content: const Text("Do you want to logout?"),
                          title: const Text('LOGOUT'),
                          actions: [
                            MaterialButton(
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
                              color: Colors.amber,
                              onPressed: () {
                                AuthService().signOut();
                                Navigator.pop(context);
                              },
                              child: const Text("Logout"),
                            )
                          ],
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
          color: Colors.grey[300],
        ),
        padding: const EdgeInsets.all(12),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (index != 0) {
                    index = 0;
                  }
                });
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: index == 0 ? 50 : 30,
                    width: index == 0 ? 50 : 30,
                    child: Image.asset(
                      'lib/assets/images/home.png',
                      color: index == 0 ? Colors.black : Colors.grey[600],
                    ),
                  ),
                  const Text(
                    "Home",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (index != 1) {
                    index = 1;
                  }
                });
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: index == 1 ? 50 : 30,
                    width: index == 1 ? 50 : 30,
                    child: Image.asset(
                      'lib/assets/images/cart.png',
                      color: index == 1 ? Colors.black : Colors.grey[600],
                    ),
                  ),
                  const Text(
                    'Cart',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: [const ShopPage(), const CartPage()][index],
    );
  }
}
