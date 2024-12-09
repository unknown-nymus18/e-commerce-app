import 'dart:io';
import 'package:e_commerce/services/cloudinary_services.dart';
import 'package:e_commerce/services/product_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductUpload extends StatefulWidget {
  final String businessName;
  const ProductUpload({super.key, required this.businessName});

  @override
  State<ProductUpload> createState() => _ProductUploadState();
}

class _ProductUploadState extends State<ProductUpload> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController description = TextEditingController();

  File? _image;

  @override
  void initState() {
    setState(() {
      if (qtyController.text.isEmpty) {
        qtyController.text = '0';
      }
      if (price.text.isEmpty) {
        price.text = '0';
      }
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

  bool valid() {
    try {
      if (name.text.isEmpty ||
          price.text.isEmpty ||
          double.parse(price.text) <= 0 ||
          int.parse(qtyController.text) == 0 ||
          description.text.isEmpty ||
          _image == null) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void uploadImage() async {
    if (valid()) {
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

      if (url.isNotEmpty) {
        bool uploadProduct = await ProductServices().addProduct(
          name.text,
          double.parse(price.text),
          description.text,
          widget.businessName,
          int.parse(qtyController.text),
          url,
        );

        if (uploadProduct == true) {
          name.clear();
          price.clear();
          description.clear();
          qtyController.clear();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[600],
                ),
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                child: const Text('Product successfuly uploaded'),
              ),
            ),
          );
        } else {
          print("Error");
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber),
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            child: const Text("Failed to upload product"),
          ),
        ),
      );
    }
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
      appBar: AppBar(),
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
            ElevatedButton(
              style: const ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsetsDirectional.all(12)),
                backgroundColor: WidgetStatePropertyAll(Colors.black),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              onPressed: openFilePicker,
              child: _image == null
                  ? const Text("Choose product image")
                  : const Text("Change image"),
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
                  onPressed: uploadImage,
                  color: Colors.amber,
                  minWidth: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    "Upload Product",
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
