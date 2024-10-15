import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:nandini_beauty_store/Homescreen/HomePage.dart';

class EditProductPage extends StatefulWidget {
  final QueryDocumentSnapshot product;
  final Function refreshHomePage;

  const EditProductPage({super.key, required this.product, required this.refreshHomePage});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dimensionsController = TextEditingController();
  String? _imageUrl;
  XFile? _newImage;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.product['title'];
    _priceController.text = widget.product['price'].toString();
    _weightController.text = widget.product['weight'].toString();
    _quantityController.text = widget.product['quantity'].toString();
    _dimensionsController.text = widget.product['dimensions'];
    _getImageUrl();
  }

  Future<void> _getImageUrl() async {
    try {
      final storageRef = FirebaseStorage.instance.ref('Images/${widget.product['image']}');
      final url = await storageRef.getDownloadURL();
      setState(() {
        _imageUrl = url;
      });
    } catch (e) {
      print('Error getting image URL: $e');
    }
  }

  Future<void> _selectNewImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _newImage = image;
    });
  }

  Future<void> _updateProduct() async {
    try {
      if (_newImage != null) {
        // Delete the existing image
        await FirebaseStorage.instance.ref('Images/${widget.product['image']}').delete();

        // Upload the new image
        await FirebaseStorage.instance.ref('Images/${_newImage!.name}').putFile(File(_newImage!.path));

        // Get the download URL of the new image
        final newImageUrl = await FirebaseStorage.instance.ref('Images/${_newImage!.name}').getDownloadURL();

        // Update the product with the new image URL
        await FirebaseFirestore.instance.collection('products').doc(widget.product.id).update({
          'title': _titleController.text,
          'price': double.parse(_priceController.text),
          'weight': double.parse(_weightController.text),
          'quantity': int.parse(_quantityController.text),
          'dimensions': _dimensionsController.text,
          'image': _newImage!.name,
        });

        setState(() {
          _imageUrl = newImageUrl;
        });
      } else {
        // Update the product without changing the image
        await FirebaseFirestore.instance.collection('products').doc(widget.product.id).update({
          'title': _titleController.text,
          'price': double.parse(_priceController.text),
          'weight': double.parse(_weightController.text),
          'quantity': int.parse(_quantityController.text),
          'dimensions': _dimensionsController.text,
        });
      }
      widget.refreshHomePage();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      Navigator.pop(context);
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product", style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Product Title',
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price (₹)',
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the weight';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _dimensionsController,
                  decoration: InputDecoration(
                    labelText: 'Dimensions (cm)',
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the dimensions';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _newImage != null
                        ? Image.file(File(_newImage!.path))
                        : _imageUrl != null
                        ? Image.network(_imageUrl!)
                        : Center(
                      child: Text('No image selected '),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _selectNewImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      elevation: 5,
                    ),
                    child: Text('Select New Image', style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _updateProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      elevation: 5,
                    ),
                    child: Text('Update Product', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}