// lib/models/dish.dart
class Dish {
  final String name;
  final String description;
  final String price;
  final String? imagePath;
  final int quantity;

  Dish({
    required this.name,
    required this.description,
    required this.price,
    this.imagePath,
    required this.quantity,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      imagePath: json['imagePath'] as String?,
      quantity: json['quantity'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'quantity': quantity,
    };
  }

  Dish copyWith({
    String? name,
    String? description,
    String? price,
    String? imagePath,
    int? quantity,
  }) {
    return Dish(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      quantity: quantity ?? this.quantity,
    );
  }
}