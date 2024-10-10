import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/product_service.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Product Type'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            _image != null
                ? Image.file(_image!, height: 100)
                : Text('No image selected'),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: () async {
                String? imageUrl;
                if (_image != null) {
                  imageUrl = await uploadImage(_image!);
                }

                await addProduct(
                  nameController.text,
                  typeController.text,
                  double.parse(priceController.text),
                  imageUrl,
                );

                // Pop and return product info
                Navigator.pop(context, {
                  'name': nameController.text,
                  'type': typeController.text,
                  'price': priceController.text,
                  'imageUrl': imageUrl,
                });
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}