// lib/models/dish.dart
class Dish {
  final String name;
  final String description;
  final String price;
  final int quantity;

  Dish({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
  });

  Dish copyWith({
    String? name,
    String? description,
    String? price,
    int? quantity,
  }) {
    return Dish(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}