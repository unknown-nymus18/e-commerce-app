import 'package:e_commerce/components/custom_button.dart';
import 'package:e_commerce/components/custom_text_field.dart';
import 'package:e_commerce/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String type = 'Customer';
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController lastName = TextEditingController();

  bool valid() {
    if (type == 'Customer') {
      if (name.text.isNotEmpty &&
          email.text.isNotEmpty &&
          password.text.isNotEmpty &&
          confirmPassword.text.isNotEmpty &&
          lastName.text.isNotEmpty) {
        if (password.text == confirmPassword.text) {
          return true;
        }
        return false;
      }
    }
    if (type == 'Seller') {
      if (name.text.isNotEmpty &&
          email.text.isNotEmpty &&
          password.text.isNotEmpty &&
          confirmPassword.text.isNotEmpty) {
        if (password.text == confirmPassword.text) {
          return true;
        }
        return false;
      }
    }

    return false;
  }

  signUp() async {
    // print('Valid');
    if (valid()) {
      print('Valid');
      if (type == 'Customer') {
        await AuthService().signUp(email.text, password.text, name.text,
            lastName: lastName.text);
        Navigator.pop(context);
      }
      if (type == 'Seller') {
        await AuthService().signUp(
          email.text,
          password.text,
          name.text,
        );
        Navigator.pop(context);
      }
    }
  }

  Widget userInfo() {
    return type == 'Seller'
        ? Column(
            children: [
              CustomTextField(
                hintText: 'Business Name',
                type: 'e',
                controller: name,
              ),
            ],
          )
        : Column(
            children: [
              CustomTextField(
                hintText: 'First Name',
                type: 'e',
                controller: name,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: 'Last Name',
                type: 'e',
                controller: lastName,
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                color: Colors.grey[700],
                size: 100,
              ),
              const Text(
                "Sign Up Here",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              userInfo(),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: 'Email',
                type: 'e',
                controller: email,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: 'Password',
                type: 'p',
                controller: password,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: 'Confirm Password',
                type: 'p',
                controller: confirmPassword,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButton(
                  elevation: 20,
                  selectedItemBuilder: (context) => const [
                    Center(child: Text("Customer")),
                    Center(
                      child: Text("Seller"),
                    ),
                  ],
                  value: type,
                  borderRadius: BorderRadius.circular(12),
                  focusColor: Colors.grey[200],
                  isExpanded: true,
                  dropdownColor: Colors.grey[500],
                  items: ["Customer", 'Seller'].map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Center(
                        child: Text(item),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      type = value!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                onPressed: signUp,
                data: "SIGN UP",
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Are you already a member? ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login im here',
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
      ),
    );
  }
}
