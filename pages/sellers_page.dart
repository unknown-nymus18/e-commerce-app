import 'package:e_commerce/components/blur.dart';
import 'package:e_commerce/pages/seller_home_page.dart';
import 'package:e_commerce/pages/seller_orders_page.dart';
import 'package:e_commerce/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SellersPage extends StatefulWidget {
  int index = 0;
  final String? businessName;
  SellersPage({super.key, this.businessName});

  @override
  State<SellersPage> createState() => _SellersPageState();
}

class _SellersPageState extends State<SellersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  if (widget.index != 0) {
                    widget.index = 0;
                  }
                });
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: widget.index == 0 ? 50 : 30,
                    width: widget.index == 0 ? 50 : 30,
                    child: Image.asset(
                      'lib/assets/images/home.png',
                      color:
                          widget.index == 0 ? Colors.black : Colors.grey[600],
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
                  if (widget.index != 1) {
                    widget.index = 1;
                  }
                });
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: widget.index == 1 ? 50 : 30,
                    width: widget.index == 1 ? 50 : 30,
                    child: Image.asset(
                      'lib/assets/images/cart.png',
                      color:
                          widget.index == 1 ? Colors.black : Colors.grey[600],
                    ),
                  ),
                  const Text(
                    'Orders',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Seller"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Blur(
                    sigmaX: 7,
                    sigmaY: 7,
                    child: AlertDialog(
                      title: Text("Sign Out"),
                      content: Text("Do you want to cancel?"),
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
                          onPressed: () {
                            Navigator.pop(context);
                            AuthService().signOut();
                          },
                          color: Colors.amber,
                          child: const Text(
                            "Yes",
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: [
        SellerHomePage(
          businessName: widget.businessName,
        ),
        const SellerOrdersPage()
      ][widget.index],
    );
  }
}
