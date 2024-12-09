import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String data;
  const CustomButton({super.key, required this.onPressed, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          minWidth: double.infinity,
          height: 70,
          onPressed: onPressed,
          color: Colors.black,
          elevation: 10,
          textColor: Colors.white,
          child: Text(
            data,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
