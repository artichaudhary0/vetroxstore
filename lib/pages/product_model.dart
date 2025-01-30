class Product {
  final String name;
  final String description;
  final String imageUrl;
  final List<String> benefits;
  int quantity;

  Product({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.benefits,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      benefits: List<String>.from(json['benefits']),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'benefits': benefits,
      'quantity': quantity,
    };
  }
}
