enum WarrantyStatus { active, expiringSoon, expired }

class WarrantyItem {
  const WarrantyItem({
    required this.id,
    required this.productName,
    required this.category,
    required this.brand,
    required this.retailer,
    required this.purchaseDate,
    required this.warrantyMonths,
    required this.price,
    required this.createdAt,
    this.serialNumber = '',
    this.notes = '',
    this.receiptFileName = '',
    this.imageAsset,
    this.reminderDays = 30,
    this.isFavorite = false,
  });

  final String id;
  final String productName;
  final String category;
  final String brand;
  final String retailer;
  final String serialNumber;
  final DateTime purchaseDate;
  final int warrantyMonths;
  final double price;
  final String notes;
  final String receiptFileName;
  final String? imageAsset;
  final int reminderDays;
  final bool isFavorite;
  final DateTime createdAt;

  DateTime get expiryDate => addMonths(purchaseDate, warrantyMonths);

  int daysRemainingAt(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiry.difference(today).inDays;
  }

  WarrantyStatus statusAt(DateTime now) {
    final days = daysRemainingAt(now);
    if (days < 0) return WarrantyStatus.expired;
    if (days <= reminderDays) return WarrantyStatus.expiringSoon;
    return WarrantyStatus.active;
  }

  double progressAt(DateTime now) {
    final total = expiryDate.difference(purchaseDate).inDays;
    if (total <= 0) return 0;
    final elapsed = now.difference(purchaseDate).inDays;
    return (1 - elapsed / total).clamp(0.0, 1.0).toDouble();
  }

  WarrantyItem copyWith({
    String? id,
    String? productName,
    String? category,
    String? brand,
    String? retailer,
    String? serialNumber,
    DateTime? purchaseDate,
    int? warrantyMonths,
    double? price,
    String? notes,
    String? receiptFileName,
    String? imageAsset,
    int? reminderDays,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return WarrantyItem(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      retailer: retailer ?? this.retailer,
      serialNumber: serialNumber ?? this.serialNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      warrantyMonths: warrantyMonths ?? this.warrantyMonths,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      receiptFileName: receiptFileName ?? this.receiptFileName,
      imageAsset: imageAsset ?? this.imageAsset,
      reminderDays: reminderDays ?? this.reminderDays,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'productName': productName,
        'category': category,
        'brand': brand,
        'retailer': retailer,
        'serialNumber': serialNumber,
        'purchaseDate': purchaseDate.toIso8601String(),
        'warrantyMonths': warrantyMonths,
        'price': price,
        'notes': notes,
        'receiptFileName': receiptFileName,
        'imageAsset': imageAsset,
        'reminderDays': reminderDays,
        'isFavorite': isFavorite,
        'createdAt': createdAt.toIso8601String(),
      };

  factory WarrantyItem.fromJson(Map<String, Object?> json) {
    return WarrantyItem(
      id: json['id']! as String,
      productName: json['productName']! as String,
      category: json['category']! as String,
      brand: (json['brand'] as String?) ?? '',
      retailer: (json['retailer'] as String?) ?? '',
      serialNumber: (json['serialNumber'] as String?) ?? '',
      purchaseDate: DateTime.parse(json['purchaseDate']! as String),
      warrantyMonths: (json['warrantyMonths']! as num).toInt(),
      price: (json['price']! as num).toDouble(),
      notes: (json['notes'] as String?) ?? '',
      receiptFileName: (json['receiptFileName'] as String?) ?? '',
      imageAsset: json['imageAsset'] as String?,
      reminderDays: (json['reminderDays'] as num?)?.toInt() ?? 30,
      isFavorite: (json['isFavorite'] as bool?) ?? false,
      createdAt: DateTime.parse(json['createdAt']! as String),
    );
  }

  static DateTime addMonths(DateTime date, int months) {
    final targetMonth = date.year * 12 + date.month - 1 + months;
    final year = targetMonth ~/ 12;
    final month = targetMonth % 12 + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = date.day > lastDay ? lastDay : date.day;
    return DateTime(year, month, day);
  }
}

DateTime addMonths(DateTime date, int months) =>
    WarrantyItem.addMonths(date, months);
