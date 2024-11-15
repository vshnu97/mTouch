// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtouch/model/product_model.dart';
import 'package:mtouch/view/widgets/image_carousel.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../routes/app_routes.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({super.key});

  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          CartBadge(),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => productController.searchQuery.value = value,
              decoration: const InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Expanded(
            child: ProductGrid(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.ADD_EDIT_PRODUCT),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CartBadge extends GetView<CartController> {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Badge(
          label: Text('${controller.cartItems.length}'),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Get.toNamed(AppRoutes.CART),
          ),
        ));
  }
}

class ProductGrid extends GetView<ProductController> {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = switch (constraints.maxWidth) {
          > 1200 => 6,
          > 900 => 5,
          > 600 => 4,
          > 400 => 3,
          _ => 2,
        };

        return Obx(() {
          final products = controller.filteredProducts;
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: (){
                
              },
              child: ProductCard(
                product: products[index],
              ),
            ),
          );
        });
      },
    );
  }
}

class ProductCard extends GetView<CartController> {
  final Product product;

  const ProductCard({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 32) / 2;
    final imageHeight = cardWidth * 0.7;

    return Card(
      elevation: 12,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: imageHeight,
            child: ImageCarousel(images: product.images),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        '\₹${product.offerPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\₹${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stock: ${product.quantity}',
                    style: TextStyle(
                      fontSize: 12,
                      color: product.quantity > 0 ? Colors.black54 : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                      onPressed: product.quantity > 0
                          ? () => controller.addToCart(product)
                          : null,
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
