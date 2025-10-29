import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final ProductCategory category;
  final int stock;
  final String imageUrl;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
    this.imageUrl = '',
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: ProductCategory.values.firstWhere(
        (e) => e.toString() == 'ProductCategory.${map['category']}',
        orElse: () => ProductCategory.makananUtama,
      ),
      stock: map['stock'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category.toString().split('.').last,
      'stock': stock,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    ProductCategory? category,
    int? stock,
    String? imageUrl,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum ProductCategory {
  makananUtama,
  appetizer,
  minuman,
}

extension ProductCategoryExtension on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.makananUtama:
        return 'Makanan Utama';
      case ProductCategory.appetizer:
        return 'Appetizer';
      case ProductCategory.minuman:
        return 'Minuman';
    }
  }

  IconData get icon {
    switch (this) {
      case ProductCategory.makananUtama:
        return Icons.restaurant;
      case ProductCategory.appetizer:
        return Icons.local_dining;
      case ProductCategory.minuman:
        return Icons.local_drink;
    }
  }

  String get emoji {
    switch (this) {
      case ProductCategory.makananUtama:
        return '🍽️';
      case ProductCategory.appetizer:
        return '🥗';
      case ProductCategory.minuman:
        return '🥤';
    }
  }
}
