import 'package:e_commerce/components/custom_button.dart';
import 'package:e_commerce/components/custom_text_field.dart';
import 'package:e_commerce/pages/sign_up.dart';
import 'package:flutter/material.dart';

class Seller extends StatelessWidget {
  const Seller({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              color: Colors.grey[700],
              size: 100,
            ),
            const Text(
              "Login as Seller",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomTextField(
              hintText: 'Gmail',
              type: 'e',
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomTextField(
              hintText: 'Password',
              type: 'p',
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
              onPressed: () {},
              data: "LOGIN",
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Are you not a member? ",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUp(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign up here',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
