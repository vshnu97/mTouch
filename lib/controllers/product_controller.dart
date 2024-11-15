import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/product_model.dart';

class ProductController extends GetxController {
  final products = <Product>[].obs;
  final searchQuery = ''.obs;
  final storage = GetStorage();
  
  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() {
    final storedProducts = storage.read<List>('products') ?? [];
    products.value = storedProducts
        .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  void addProduct(Product product) {
    product.id = DateTime.now().toString();
    products.add(product);
    _saveProducts();
  }

  void updateProduct(Product product) {
    final index = products.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      products[index] = product;
      _saveProducts();
    }
  }

  void deleteProduct(String id) {
    products.removeWhere((product) => product.id == id);
    _saveProducts();
  }

  void _saveProducts() {
    storage.write('products', products.map((p) => p.toJson()).toList());
  }

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) return products;
    return products
        .where((p) =>
            p.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }
}