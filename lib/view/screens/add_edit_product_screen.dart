// ignore_for_file: sort_child_properties_last

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mtouch/model/product_model.dart';
import '../../controllers/product_controller.dart';

// ignore: use_key_in_widget_constructors
class AddEditProductScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final ProductController productController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController offerPriceController;
  late TextEditingController quantityController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  
  List<String> images = [];
  Product? editingProduct;

  @override
  void initState() {
    super.initState();
    editingProduct = Get.arguments as Product?;
    
    nameController = TextEditingController(text: editingProduct?.name ?? '');
    priceController = TextEditingController(
        text: editingProduct?.price.toString() ?? '');
    offerPriceController = TextEditingController(
        text: editingProduct?.offerPrice.toString() ?? '');
    quantityController = TextEditingController(
        text: editingProduct?.quantity.toString() ?? '');
    descriptionController = TextEditingController(
        text: editingProduct?.description ?? '');
    categoryController = TextEditingController(
        text: editingProduct?.category ?? '');
    
    images = editingProduct?.images ?? [];
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    
    if (image != null) {
      setState(() {
        images.add(image.path);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate() && images.isNotEmpty) {
      final product = Product(
        id: editingProduct?.id,
        name: nameController.text,
        price: double.parse(priceController.text),
        offerPrice: double.parse(offerPriceController.text),
        quantity: int.parse(quantityController.text),
        description: descriptionController.text,
        category: categoryController.text,
        images: images,
      );

      if (editingProduct != null) {
        productController.updateProduct(product);
      } else {
        productController.addProduct(product);
      }

      Get.back();
    } else if (images.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editingProduct != null ? 'Edit Product' : 'Add Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Product Images',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length + 1,
                  itemBuilder: (context, index) {
                    if (index == images.length) {
                      return GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add_photo_alternate, size: 40),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(File(images[index])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => _removeImage(index),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: offerPriceController,
                decoration: const InputDecoration(
                  labelText: 'Offer Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter offer price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  final offerPrice = double.parse(value);
                  final price = double.parse(priceController.text);
                  if (offerPrice >= price) {
                    return 'Offer price must be less than regular price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveProduct,
          child: Text(editingProduct != null ? 'Update Product' : 'Add Product'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    offerPriceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.dispose();
  }
}