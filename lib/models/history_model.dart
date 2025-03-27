enum HistoryType { rental, return_product, added_stock }

class ProductHistory {
  final int id;
  final int productId;
  final String productName;
  final String barcode;
  final int quantity;
  final HistoryType type;
  final String? givenTo;
  final String? agency;
  final DateTime rentedDate;
  final DateTime? returnDate;
  final int? rentalDays;
  final String? notes;
  final DateTime createdAt;

  ProductHistory({
    required this.id,
    required this.productId,
    required this.productName,
    required this.barcode,
    required this.quantity,
    required this.type,
    this.givenTo,
    this.agency,
    required this.rentedDate,
    this.returnDate,
    this.rentalDays,
    this.notes,
    required this.createdAt,
  });

  factory ProductHistory.fromMap(Map<String, dynamic> map) {
    return ProductHistory(
      id: map['id'] as int,
      productId: map['product_id'] as int,
      productName: map['product_name'] as String,
      barcode: map['barcode'] as String,
      quantity: map['quantity'] as int,
      type: HistoryType.values[map['type'] as int],
      givenTo: map['given_to'] as String?,
      agency: map['agency'] as String?,
      rentedDate: DateTime.parse(map['rented_date'] as String),
      returnDate: map['return_date'] != null ? DateTime.parse(map['return_date'] as String) : null,
      rentalDays: map['rental_days'] as int?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'barcode': barcode,
      'quantity': quantity,
      'type': type.index,
      'given_to': givenTo,
      'agency': agency,
      'rented_date': rentedDate.toIso8601String(),
      'return_date': returnDate?.toIso8601String(),
      'rental_days': rentalDays,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}