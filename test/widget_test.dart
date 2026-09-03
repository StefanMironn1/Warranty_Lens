import 'package:flutter_test/flutter_test.dart';
import 'package:warranty_lens/models/warranty_item.dart';

void main() {
  group('WarrantyItem', () {
    test('calculates expiry at the end of short months', () {
      final item = WarrantyItem(
        id: '1',
        productName: 'Camera',
        category: 'Camera',
        brand: 'Sony',
        retailer: 'Store',
        purchaseDate: DateTime(2025, 1, 31),
        warrantyMonths: 1,
        price: 500,
        createdAt: DateTime(2025, 1, 31),
      );

      expect(item.expiryDate, DateTime(2025, 2, 28));
    });

    test('returns active, expiring and expired states', () {
      final item = WarrantyItem(
        id: '2',
        productName: 'Laptop',
        category: 'Computer',
        brand: 'Lenovo',
        retailer: 'Store',
        purchaseDate: DateTime(2025, 1, 1),
        warrantyMonths: 12,
        price: 1000,
        reminderDays: 30,
        createdAt: DateTime(2025, 1, 1),
      );

      expect(item.statusAt(DateTime(2025, 6, 1)), WarrantyStatus.active);
      expect(
        item.statusAt(DateTime(2025, 12, 15)),
        WarrantyStatus.expiringSoon,
      );
      expect(item.statusAt(DateTime(2026, 1, 2)), WarrantyStatus.expired);
    });

    test('round-trips through JSON', () {
      final original = WarrantyItem(
        id: '3',
        productName: 'Headphones',
        category: 'Audio',
        brand: 'Bose',
        retailer: 'Online store',
        serialNumber: 'ABC123',
        purchaseDate: DateTime(2026, 4, 4),
        warrantyMonths: 24,
        price: 299.99,
        receiptFileName: 'receipt.pdf',
        isFavorite: true,
        createdAt: DateTime(2026, 4, 4),
      );

      final decoded = WarrantyItem.fromJson(original.toJson());

      expect(decoded.productName, original.productName);
      expect(decoded.serialNumber, original.serialNumber);
      expect(decoded.price, original.price);
      expect(decoded.isFavorite, isTrue);
      expect(decoded.expiryDate, original.expiryDate);
    });
  });
}
