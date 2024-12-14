import 'dart:io';

import 'package:e_commerce/components/blur.dart';
import 'package:e_commerce/services/cloudinary_services.dart';
import 'package:e_commerce/services/product_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditItemPage extends StatefulWidget {
  final String uid;
  final String name;
  final double price;
  final String description;
  final int quantity;
  const EditItemPage({
    super.key,
    required this.uid,
    required this.description,
    required this.name,
    required this.price,
    required this.quantity,
  });

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  TextEditingController name = TextEditingController();

  TextEditingController price = TextEditingController();

  TextEditingController qtyController = TextEditingController();

  TextEditingController description = TextEditingController();

  File? _image;

  @override
  void initState() {
    setState(() {
      qtyController.text = widget.quantity.toString();
      price.text = widget.price.toString();
      name.text = widget.name;
      description.text = widget.description;
    });
    super.initState();
  }

  void openFilePicker() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void openCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  bool valid() {
    try {
      if (name.text.isEmpty ||
          price.text.isEmpty ||
          double.parse(price.text) <= 0 ||
          int.parse(qtyController.text) == 0 ||
          description.text.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void updateProduct() async {
    bool? uploaded;
    if (_image != null) {
      final platformFile = PlatformFile(
        name: _image!.path.split('/').last,
        size: _image!.lengthSync(),
        path: _image!.path,
        bytes: _image!.readAsBytesSync(),
      );
      FilePickerResult filePickerResult = FilePickerResult(
        [platformFile],
      );

      String url = await uploadToCloudinary(filePickerResult);
      uploaded = await ProductServices().editProduct(
          widget.uid,
          name.text,
          description.text,
          double.parse(price.text),
          int.parse(qtyController.text),
          url);
    } else {
      uploaded = await ProductServices().editProduct(
        widget.uid,
        name.text,
        description.text,
        double.parse(price.text),
        int.parse(qtyController.text),
      );
    }

    if (uploaded == true) {
      Navigator.pop(context);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.grey[600]),
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(12),
          child: Text(uploaded ? 'Edited successfully' : "There was a errr"),
        ),
      ),
    );
  }

  Widget field(
      String name, TextInputType type, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            width: 220,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: type,
            ),
          ),
        ],
      ),
    );
  }

  Widget qty() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          "Quantity:",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        IconButton(
            onPressed: () {
              if (int.parse(qtyController.text) != 0) {
                setState(() {
                  qtyController.text =
                      (int.parse(qtyController.text) - 1).toString();
                });
              }
            },
            icon: const Icon(CupertinoIcons.minus)),
        SizedBox(
          width: 50,
          child: TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                qtyController.text =
                    (int.parse(qtyController.text) + 1).toString();
              });
            },
            icon: const Icon(Icons.add))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit information"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            field('Product Name', TextInputType.text, name),
            field('Product Price', TextInputType.number, price),
            field('Description', TextInputType.text, description),
            qty(),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: _image != null
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      height: 300,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _image!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    padding:
                        WidgetStatePropertyAll(EdgeInsetsDirectional.all(12)),
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: openFilePicker,
                  child: _image == null
                      ? const Text("Choose product image")
                      : const Text("Change image"),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    padding:
                        WidgetStatePropertyAll(EdgeInsetsDirectional.all(12)),
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: openCamera,
                  child: _image == null
                      ? const Text("Take Photo")
                      : const Text("Take new photo"),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MaterialButton(
                  textColor: Colors.white,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Blur(
                            sigmaX: 7,
                            sigmaY: 7,
                            child: AlertDialog(
                              title: const Text('Update Product'),
                              content: const Text(
                                  "Do you want to update the project?"),
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
                                    Navigator.pop(context);
                                    updateProduct();
                                  },
                                  child: const Text(
                                    "Yes",
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  color: Colors.amber,
                  minWidth: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    "Update Product",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
