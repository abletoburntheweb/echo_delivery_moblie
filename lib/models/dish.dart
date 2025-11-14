// lib/models/dish.dart
class Dish {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final int categoryId;
  final String categoryName;
  int quantity;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.categoryId,
    required this.categoryName,
    this.quantity = 0,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    print('🟡 Parsing dish JSON: $json');

    double parsePrice(dynamic price) {
      if (price == null) return 0.0;
      if (price is double) return price;
      if (price is int) return price.toDouble();
      if (price is String) {
        String cleaned = price.replaceAll('"', '').trim();
        return double.tryParse(cleaned) ?? 0.0;
      }
      return 0.0;
    }

    Dish dish = Dish(
      id: json['id_dish'] ?? 0,
      name: json['name'] ?? 'Без названия',
      description: json['description'] ?? '',
      price: parsePrice(json['price']),
      image: json['img'] ?? '',
      categoryId: json['id_category'] ?? 0,
      categoryName: json['category_name'] ?? '',
      quantity: json['quantity'] ?? 0,
    );

    print('🟢 Final dish: ${dish.name}, Price: ${dish.price}');
    return dish;
  }

  Map<String, dynamic> toJson() {
    return {
      'id_dish': id,
      'name': name,
      'description': description,
      'price': price,
      'img': image,
      'id_category': categoryId,
      'category_name': categoryName,
      'quantity': quantity,
    };
  }

  String get fullImageUrl {
    if (image.isEmpty) return '';
    if (image.startsWith('http')) return image;
    return 'http://10.0.2.2:8000/media/$image';
  }

  Dish copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? image,
    int? categoryId,
    String? categoryName,
    int? quantity,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      quantity: quantity ?? this.quantity,
    );
  }
}