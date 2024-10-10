import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/product_service.dart';

class EditProductScreen extends StatefulWidget {
  final String docId;
  final String currentName;
  final String currentType;
  final double currentPrice;
  final String? currentImageUrl;

  EditProductScreen({
    required this.docId,
    required this.currentName,
    required this.currentType,
    required this.currentPrice,
    this.currentImageUrl,
  });

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController priceController;
  File? _image;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    typeController = TextEditingController(text: widget.currentType);
    priceController = TextEditingController(text: widget.currentPrice.toString());
  }

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
      appBar: AppBar(title: Text('Edit Product')),
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
                : widget.currentImageUrl != null
                ? Image.network(widget.currentImageUrl!, height: 100)
                : Text('No image selected'),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: () async {
                String? imageUrl = widget.currentImageUrl;
                if (_image != null) {
                  imageUrl = await uploadImage(_image!);
                }

                await updateProduct(
                  widget.docId,
                  nameController.text,
                  typeController.text,
                  double.parse(priceController.text),
                  imageUrl,
                );

                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}