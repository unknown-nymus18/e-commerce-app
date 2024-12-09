import 'package:e_commerce/pages/customer.dart';
import 'package:e_commerce/pages/seller.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final PageController _pageController = PageController(initialPage: 0);

  int index = 0;

  Widget pagePointer(index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: index == 0 ? 25 : 20,
            height: index == 0 ? 25 : 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == 0 ? Colors.grey[800] : Colors.grey[600],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: index == 1 ? 25 : 20,
            height: index == 1 ? 25 : 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == 1 ? Colors.grey[800] : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                index = value;
              });
            },
            children: [
              Customer(),
              Seller(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [pagePointer(index)],
          )
        ],
      ),
    );
  }
}
