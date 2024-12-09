import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String type;
  final String hintText;
  final TextEditingController? controller;
  const CustomTextField(
      {super.key, required this.hintText, required this.type, this.controller});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscure = false;
  @override
  void initState() {
    if (widget.type == 'p') {
      setState(() {
        obscure = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextField(
        controller: widget.controller,
        obscureText: obscure,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          hintText: widget.hintText,
          fillColor: Colors.grey[400],
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          suffixIcon: widget.type == 'p'
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: !obscure
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('lib/assets/images/eyehide.png'),
                        )
                      : SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('lib/assets/images/eyeview.png'),
                        ),
                )
              : null,
        ),
      ),
    );
  }
}
