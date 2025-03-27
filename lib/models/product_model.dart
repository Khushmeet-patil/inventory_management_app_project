class Product {
  final int id;
  final String barcode;
  final String name;
  int quantity;
  final double pricePerQuantity;
  final DateTime createdAt;
  DateTime updatedAt;

  Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.quantity,
    required this.pricePerQuantity,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap({bool includeId = true}) {
    final map = {
      'barcode': barcode,
      'name': name,
      'quantity': quantity,
      'price_per_quantity': pricePerQuantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
    if (includeId) {
      map['id'] = id;
    }
    return map;
  }

  Product copyWith({
    int? id,
    String? barcode,
    String? name,
    int? quantity,
    double? pricePerQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      pricePerQuantity: pricePerQuantity ?? this.pricePerQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      barcode: map['barcode'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      pricePerQuantity: (map['price_per_quantity'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}