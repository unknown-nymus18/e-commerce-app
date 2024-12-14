import 'package:e_commerce/pages/customer_page.dart';
import 'package:e_commerce/pages/sellers_page.dart';
import 'package:e_commerce/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: AuthService().getUsers(),
          builder: (context, snapshots) {
            bool? isCustomer;
            String? firstName;
            if (snapshots.hasData) {
              snapshots.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                if (data['uid'] == AuthService().auth.currentUser!.uid) {
                  isCustomer = data['type'] == 'customer';
                  firstName = data['name'];
                }
              }).toList();

              if (isCustomer!) {
                return CustomerPage();
              } else {
                return SellersPage(
                  businessName: firstName ?? '',
                );
              }
            }
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return MaterialButton(
              onPressed: () {
                AuthService().signOut();
              },
              child: const Text('SignOut'),
            );
          },
        ),
      ),
    );
  }
}
