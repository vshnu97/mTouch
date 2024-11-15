import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mtouch/model/product_model.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void loadCart() {
    final storedCart = storage.read<List>('cart') ?? [];
    cartItems.value = storedCart
        .map((item) => CartItem(
              product: Product.fromJson(Map<String, dynamic>.from(item['product'])),
              quantity: item['quantity'],
            ))
        .toList();
  }

  void _saveCart() {
    final cartData = cartItems.map((item) => {
          'product': item.product.toJson(),
          'quantity': item.quantity,
        }).toList();
    storage.write('cart', cartData);
  }

  double get totalAmount {
    return cartItems.fold(
        0, (sum, item) => sum + (item.product.offerPrice * item.quantity));
  }

  void addToCart(Product product, [int quantity = 1]) {
    try {
      if (product.quantity <= 0) {
        Get.snackbar(
          'Error',
          'Product is out of stock',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final existingItemIndex = cartItems
          .indexWhere((item) => item.product.id == product.id);

      if (existingItemIndex >= 0) {
        final existingItem = cartItems[existingItemIndex];
        if (existingItem.quantity + quantity <= product.quantity) {
          existingItem.quantity += quantity;
          cartItems[existingItemIndex] = existingItem;
          cartItems.refresh();
          _saveCart();
          Get.snackbar(
            'Success',
            'Product quantity updated in cart',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            'Cannot add more than available stock',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        if (quantity <= product.quantity) {
          cartItems.add(CartItem(product: product, quantity: quantity));
          _saveCart();
          Get.snackbar(
            'Success',
            'Product added to cart',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add product to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error adding to cart: $e');
    }
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
    _saveCart();
    Get.snackbar(
      'Success',
      'Product removed from cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateQuantity(String productId, int quantity) {
    final itemIndex = cartItems.indexWhere((item) => item.product.id == productId);
    if (itemIndex >= 0) {
      final item = cartItems[itemIndex];
      if (quantity <= item.product.quantity && quantity > 0) {
        item.quantity = quantity;
        cartItems[itemIndex] = item;
        cartItems.refresh();
        _saveCart();
      } else {
        Get.snackbar(
          'Error',
          'Invalid quantity',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void clearCart() {
    cartItems.clear();
    _saveCart();
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}