import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/warranty_item.dart';

class WarrantyStore extends ChangeNotifier {
  WarrantyStore({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  static const _warrantiesKey = 'warranty_lens_items_v1';
  static const _profileKey = 'warranty_lens_profile_v1';
  static const _settingsKey = 'warranty_lens_settings_v1';

  final SharedPreferencesAsync _preferences;
  final List<WarrantyItem> _warranties = [];

  String userName = 'Stefan';
  String email = 'stefan@example.com';
  String currency = 'EUR';
  bool notificationsEnabled = true;
  bool biometricLock = false;

  List<WarrantyItem> get warranties {
    final copy = List<WarrantyItem>.of(_warranties);
    copy.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    return List<WarrantyItem>.unmodifiable(copy);
  }

  int activeCountAt(DateTime now) => _warranties
      .where((item) => item.statusAt(now) == WarrantyStatus.active)
      .length;

  int expiringCountAt(DateTime now) => _warranties
      .where((item) => item.statusAt(now) == WarrantyStatus.expiringSoon)
      .length;

  int expiredCountAt(DateTime now) => _warranties
      .where((item) => item.statusAt(now) == WarrantyStatus.expired)
      .length;

  double get protectedValue => _warranties
      .where((item) => item.statusAt(DateTime.now()) != WarrantyStatus.expired)
      .fold<double>(0, (sum, item) => sum + item.price);

  Future<void> load() async {
    var shouldSeedDemo = false;
    try {
      final rawItems = await _preferences.getString(_warrantiesKey);
      if (rawItems == null) {
        shouldSeedDemo = true;
      } else {
        final decoded = jsonDecode(rawItems) as List<dynamic>;
        _warranties
          ..clear()
          ..addAll(
            decoded.map(
              (item) => WarrantyItem.fromJson(
                Map<String, Object?>.from(item as Map),
              ),
            ),
          );
      }

      final rawProfile = await _preferences.getString(_profileKey);
      if (rawProfile != null) {
        final profile = Map<String, Object?>.from(
          jsonDecode(rawProfile) as Map,
        );
        userName = (profile['userName'] as String?) ?? userName;
        email = (profile['email'] as String?) ?? email;
      }

      final rawSettings = await _preferences.getString(_settingsKey);
      if (rawSettings != null) {
        final settings = Map<String, Object?>.from(
          jsonDecode(rawSettings) as Map,
        );
        currency = (settings['currency'] as String?) ?? currency;
        notificationsEnabled =
            (settings['notificationsEnabled'] as bool?) ?? true;
        biometricLock = (settings['biometricLock'] as bool?) ?? false;
      }
    } catch (_) {
      _warranties.clear();
      shouldSeedDemo = true;
    }

    if (shouldSeedDemo) {
      _warranties.addAll(_demoWarranties());
      await _persistWarranties();
    }
  }

  WarrantyItem? findById(String id) {
    for (final item in _warranties) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<void> addWarranty(WarrantyItem item) async {
    _warranties.add(item);
    notifyListeners();
    await _persistWarranties();
  }

  Future<void> updateWarranty(WarrantyItem item) async {
    final index = _warranties.indexWhere((entry) => entry.id == item.id);
    if (index == -1) return;
    _warranties[index] = item;
    notifyListeners();
    await _persistWarranties();
  }

  Future<void> deleteWarranty(String id) async {
    _warranties.removeWhere((item) => item.id == id);
    notifyListeners();
    await _persistWarranties();
  }

  Future<void> toggleFavorite(String id) async {
    final item = findById(id);
    if (item == null) return;
    await updateWarranty(item.copyWith(isFavorite: !item.isFavorite));
  }

  Future<void> updateProfile({
    required String name,
    required String emailAddress,
  }) async {
    userName = name.trim();
    email = emailAddress.trim();
    notifyListeners();
    await _preferences.setString(
      _profileKey,
      jsonEncode({'userName': userName, 'email': email}),
    );
  }

  Future<void> updateSettings({
    String? selectedCurrency,
    bool? enableNotifications,
    bool? enableBiometricLock,
  }) async {
    currency = selectedCurrency ?? currency;
    notificationsEnabled = enableNotifications ?? notificationsEnabled;
    biometricLock = enableBiometricLock ?? biometricLock;
    notifyListeners();
    await _preferences.setString(
      _settingsKey,
      jsonEncode({
        'currency': currency,
        'notificationsEnabled': notificationsEnabled,
        'biometricLock': biometricLock,
      }),
    );
  }

  Future<void> restoreDemoData() async {
    _warranties
      ..clear()
      ..addAll(_demoWarranties());
    notifyListeners();
    await _persistWarranties();
  }

  String exportJson() => const JsonEncoder.withIndent('  ').convert({
        'profile': {'name': userName, 'email': email},
        'currency': currency,
        'warranties': _warranties.map((item) => item.toJson()).toList(),
      });

  Future<void> _persistWarranties() async {
    await _preferences.setString(
      _warrantiesKey,
      jsonEncode(_warranties.map((item) => item.toJson()).toList()),
    );
  }

  List<WarrantyItem> _demoWarranties() {
    final now = DateTime.now();

    DateTime purchaseForDaysLeft(int months, int daysLeft) {
      final expiry = now.add(Duration(days: daysLeft));
      return addMonths(expiry, -months);
    }

    return [
      WarrantyItem(
        id: 'demo-airpods',
        productName: 'AirPods Pro',
        category: 'Audio',
        brand: 'Apple',
        retailer: 'iStorm Athens',
        serialNumber: 'H2Y6Q19P1059',
        purchaseDate: purchaseForDaysLeft(24, 18),
        warrantyMonths: 24,
        price: 279,
        notes: 'Keep the original charging case with the receipt.',
        receiptFileName: 'airpods_receipt.pdf',
        imageAsset:
            'assets/images/warranty_devices_photos/airpods_photo-removebg-preview.png',
        reminderDays: 30,
        isFavorite: true,
        createdAt: now.subtract(const Duration(days: 380)),
      ),
      WarrantyItem(
        id: 'demo-washer',
        productName: 'Washing Machine',
        category: 'Home appliance',
        brand: 'Samsung',
        retailer: 'Kotsovolos',
        serialNumber: 'WW90T554DAW-21',
        purchaseDate: purchaseForDaysLeft(24, 42),
        warrantyMonths: 24,
        price: 649,
        notes: 'Motor has an additional manufacturer warranty.',
        receiptFileName: 'samsung_washer.jpg',
        imageAsset:
            'assets/images/warranty_devices_photos/washing-machine-isolated-removebg-preview.png',
        reminderDays: 30,
        createdAt: now.subtract(const Duration(days: 520)),
      ),
      WarrantyItem(
        id: 'demo-laptop',
        productName: 'ThinkPad X1 Carbon',
        category: 'Computer',
        brand: 'Lenovo',
        retailer: 'Public',
        serialNumber: 'PF4W2X9L',
        purchaseDate: now.subtract(const Duration(days: 210)),
        warrantyMonths: 36,
        price: 1699,
        receiptFileName: 'thinkpad_invoice.pdf',
        reminderDays: 45,
        createdAt: now.subtract(const Duration(days: 210)),
      ),
      WarrantyItem(
        id: 'demo-phone',
        productName: 'Galaxy S24',
        category: 'Phone',
        brand: 'Samsung',
        retailer: 'Germanos',
        serialNumber: 'R5CX21A8QLT',
        purchaseDate: now.subtract(const Duration(days: 320)),
        warrantyMonths: 24,
        price: 899,
        receiptFileName: 'galaxy_s24_receipt.pdf',
        reminderDays: 30,
        isFavorite: true,
        createdAt: now.subtract(const Duration(days: 320)),
      ),
      WarrantyItem(
        id: 'demo-camera',
        productName: 'Alpha a6400 Camera',
        category: 'Camera',
        brand: 'Sony',
        retailer: 'Plaisio',
        serialNumber: 'S01-4927718',
        purchaseDate: now.subtract(const Duration(days: 790)),
        warrantyMonths: 24,
        price: 929,
        receiptFileName: 'sony_camera_receipt.jpg',
        reminderDays: 30,
        createdAt: now.subtract(const Duration(days: 790)),
      ),
    ];
  }
}
