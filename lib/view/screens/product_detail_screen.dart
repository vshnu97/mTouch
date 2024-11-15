// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtouch/model/product_model.dart';
import 'package:mtouch/routes/app_routes.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/cart_controller.dart';
import '../widgets/image_carousel.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductController productController = Get.find();
  final CartController cartController = Get.find();
  
  @override
  Widget build(BuildContext context) {
    final Product product = Get.arguments;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Get.toNamed(
              AppRoutes.ADD_EDIT_PRODUCT,
              arguments: product,
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Get.defaultDialog(
                title: 'Delete Product',
                middleText: 'Are you sure you want to delete this product?',
                textConfirm: 'Delete',
                textCancel: 'Cancel',
                confirmTextColor: Colors.white,
                onConfirm: () {
                  productController.deleteProduct(product.id!);
                  Get.back();
                  Get.back();
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageCarousel(images: product.images),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\₹${product.offerPrice}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        '\₹${product.price}',
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Category: ${product.category}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Available Quantity: ${product.quantity}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: product.quantity > 0
              ? () {
                  cartController.addToCart(product);
                  Get.snackbar(
                    'Success',
                    'Product added to cart',
                    snackPosition: SnackPosition.TOP,
                  );
                }
              : null,
          child: Text('Add to Cart'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}