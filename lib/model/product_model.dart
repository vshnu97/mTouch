class Product {
  String? id;
  String name;
  double price;
  double offerPrice;
  int quantity;
  String description;
  List<String> images;
  String category;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.offerPrice,
    required this.quantity,
    required this.description,
    required this.images,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'offerPrice': offerPrice,
      'quantity': quantity,
      'description': description,
      'images': images,
      'category': category,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      offerPrice: json['offerPrice'],
      quantity: json['quantity'],
      description: json['description'],
      images: List<String>.from(json['images']),
      category: json['category'],
    );
  }
}