import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_theme.dart';
import '../core/date_formatters.dart';
import '../models/warranty_item.dart';
import '../state/warranty_store.dart';
import '../widgets/app_widgets.dart';
import 'scan_receipt_screen.dart';

class WarrantyFormScreen extends StatefulWidget {
  const WarrantyFormScreen({
    required this.store,
    this.initialItem,
    super.key,
  });

  final WarrantyStore store;
  final WarrantyItem? initialItem;

  @override
  State<WarrantyFormScreen> createState() => _WarrantyFormScreenState();
}

class _WarrantyFormScreenState extends State<WarrantyFormScreen> {
  static const _categories = [
    'Phone',
    'Computer',
    'Audio',
    'Camera',
    'Home appliance',
    'Gaming',
    'Vehicle',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _productController;
  late final TextEditingController _brandController;
  late final TextEditingController _retailerController;
  late final TextEditingController _serialController;
  late final TextEditingController _priceController;
  late final TextEditingController _notesController;
  late String _category;
  late DateTime _purchaseDate;
  late int _warrantyMonths;
  late int _reminderDays;
  String _receiptFileName = '';
  bool _isSaving = false;

  bool get _isEditing => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _productController = TextEditingController(text: item?.productName ?? '');
    _brandController = TextEditingController(text: item?.brand ?? '');
    _retailerController = TextEditingController(text: item?.retailer ?? '');
    _serialController = TextEditingController(text: item?.serialNumber ?? '');
    _priceController = TextEditingController(
      text: item == null ? '' : item.price.toStringAsFixed(2),
    );
    _notesController = TextEditingController(text: item?.notes ?? '');
    _category = item?.category ?? 'Other';
    _purchaseDate = item?.purchaseDate ?? DateTime.now();
    _warrantyMonths = item?.warrantyMonths ?? 24;
    _reminderDays = item?.reminderDays ?? 30;
    _receiptFileName = item?.receiptFileName ?? '';
  }

  @override
  void dispose() {
    _productController.dispose();
    _brandController.dispose();
    _retailerController.dispose();
    _serialController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _scanReceipt() async {
    final result = await Navigator.of(context).push<ReceiptScanResult>(
      MaterialPageRoute(builder: (_) => const ScanReceiptScreen()),
    );
    if (result == null || !mounted) return;
    setState(() {
      _productController.text = result.productName;
      _brandController.text = result.brand;
      _retailerController.text = result.retailer;
      _priceController.text = result.price.toStringAsFixed(2);
      _purchaseDate = result.purchaseDate;
      _receiptFileName = result.receiptFileName;
      _category = 'Other';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receipt details added to the form.')),
    );
  }

  Future<void> _selectPurchaseDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'SELECT PURCHASE DATE',
    );
    if (result != null && mounted) setState(() => _purchaseDate = result);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final existing = widget.initialItem;
    final item = WarrantyItem(
      id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      productName: _productController.text.trim(),
      category: _category,
      brand: _brandController.text.trim(),
      retailer: _retailerController.text.trim(),
      serialNumber: _serialController.text.trim(),
      purchaseDate: _purchaseDate,
      warrantyMonths: _warrantyMonths,
      price: double.parse(_priceController.text.replaceAll(',', '.')),
      notes: _notesController.text.trim(),
      receiptFileName: _receiptFileName,
      imageAsset: existing?.imageAsset,
      reminderDays: _reminderDays,
      isFavorite: existing?.isFavorite ?? false,
      createdAt: existing?.createdAt ?? DateTime.now(),
    );

    if (_isEditing) {
      await widget.store.updateWarranty(item);
    } else {
      await widget.store.addWarranty(item);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(_isEditing ? Icons.arrow_back_rounded : Icons.close_rounded),
        ),
        title: Text(_isEditing ? 'Edit warranty' : 'Add warranty'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: const Text('Save'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AppPageBackground(
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!_isEditing) ...[
                          _ReceiptImportCard(
                            receiptFileName: _receiptFileName,
                            onTap: _scanReceipt,
                          ),
                          const SizedBox(height: 24),
                        ],
                        const _FormSectionTitle(
                          title: 'Product details',
                          icon: Icons.inventory_2_outlined,
                        ),
                        const SizedBox(height: 13),
                        TextFormField(
                          controller: _productController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Product name *',
                            hintText: 'e.g. MacBook Air',
                            prefixIcon: Icon(Icons.devices_other_rounded),
                          ),
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 13),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _brandController,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Brand',
                                  prefixIcon: Icon(Icons.business_rounded),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _category,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Category',
                                ),
                                items: _categories
                                    .map(
                                      (category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(
                                          category,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) _category = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
                        TextFormField(
                          controller: _serialController,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Serial number',
                            prefixIcon: Icon(Icons.qr_code_2_rounded),
                          ),
                        ),
                        const SizedBox(height: 25),
                        const _FormSectionTitle(
                          title: 'Purchase information',
                          icon: Icons.receipt_long_outlined,
                        ),
                        const SizedBox(height: 13),
                        TextFormField(
                          controller: _retailerController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Retailer *',
                            hintText: 'Store or website',
                            prefixIcon: Icon(Icons.storefront_outlined),
                          ),
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 13),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: _selectPurchaseDate,
                                borderRadius: BorderRadius.circular(16),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Purchase date',
                                    prefixIcon: Icon(Icons.calendar_today_outlined),
                                  ),
                                  child: Text(formatDate(_purchaseDate)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _priceController,
                                keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9,.]'),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Price *',
                                  prefixText: _currencySymbol(widget.store.currency),
                                ),
                                validator: (value) {
                                  final parsed = double.tryParse(
                                    (value ?? '').replaceAll(',', '.'),
                                  );
                                  if (parsed == null || parsed < 0) {
                                    return 'Invalid price';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        const _FormSectionTitle(
                          title: 'Coverage',
                          icon: Icons.shield_outlined,
                        ),
                        const SizedBox(height: 13),
                        Text(
                          'Warranty duration',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 9),
                        Wrap(
                          spacing: 9,
                          runSpacing: 9,
                          children: [6, 12, 24, 36, 60]
                              .map(
                                (months) => ChoiceChip(
                                  label: Text(
                                    months < 12
                                        ? '$months months'
                                        : '${months ~/ 12} ${months == 12 ? 'year' : 'years'}',
                                  ),
                                  selected: _warrantyMonths == months,
                                  onSelected: (_) =>
                                      setState(() => _warrantyMonths = months),
                                  selectedColor:
                                      AppColors.primary.withValues(alpha: 0.16),
                                  side: BorderSide(
                                    color: _warrantyMonths == months
                                        ? AppColors.primary
                                        : AppColors.border,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 17),
                        DropdownButtonFormField<int>(
                          initialValue: _reminderDays,
                          decoration: const InputDecoration(
                            labelText: 'Remind me before expiry',
                            prefixIcon: Icon(Icons.notifications_active_outlined),
                          ),
                          items: const [
                            DropdownMenuItem(value: 7, child: Text('7 days before')),
                            DropdownMenuItem(value: 14, child: Text('14 days before')),
                            DropdownMenuItem(value: 30, child: Text('30 days before')),
                            DropdownMenuItem(value: 45, child: Text('45 days before')),
                            DropdownMenuItem(value: 60, child: Text('60 days before')),
                          ],
                          onChanged: (value) {
                            if (value != null) _reminderDays = value;
                          },
                        ),
                        const SizedBox(height: 25),
                        const _FormSectionTitle(
                          title: 'Documents & notes',
                          icon: Icons.folder_copy_outlined,
                        ),
                        const SizedBox(height: 13),
                        _AttachmentTile(
                          fileName: _receiptFileName,
                          onAdd: _scanReceipt,
                          onRemove: () => setState(() => _receiptFileName = ''),
                        ),
                        const SizedBox(height: 13),
                        TextFormField(
                          controller: _notesController,
                          minLines: 3,
                          maxLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Notes',
                            alignLabelWithHint: true,
                            hintText: 'Coverage details, accessories or conditions',
                          ),
                        ),
                        const SizedBox(height: 28),
                        ElevatedButton.icon(
                          onPressed: _isSaving ? null : _save,
                          icon: _isSaving
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.shield_rounded),
                          label: Text(
                            _isEditing ? 'Save changes' : 'Add to warranty vault',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) => value == null || value.trim().isEmpty
      ? 'This field is required'
      : null;

  String _currencySymbol(String currency) => switch (currency) {
        'USD' => r'$ ',
        'GBP' => '£ ',
        _ => '€ ',
      };
}

class _FormSectionTitle extends StatelessWidget {
  const _FormSectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 21),
        const SizedBox(width: 9),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _ReceiptImportCard extends StatelessWidget {
  const _ReceiptImportCard({
    required this.receiptFileName,
    required this.onTap,
  });

  final String receiptFileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        gradient: const LinearGradient(
          colors: [Color(0xFF073454), Color(0xFF222B6A)],
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.55)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(23),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: AppColors.primary.withValues(alpha: 0.11),
                  ),
                  child: const Icon(
                    Icons.document_scanner_outlined,
                    color: AppColors.primary,
                    size: 29,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receiptFileName.isEmpty
                            ? 'Scan receipt with smart fill'
                            : 'Receipt details imported',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        receiptFileName.isEmpty
                            ? 'Extract store, product, date and price'
                            : receiptFileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
    required this.fileName,
    required this.onAdd,
    required this.onRemove,
  });

  final String fileName;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (fileName.isEmpty) {
      return OutlinedButton.icon(
        onPressed: onAdd,
        icon: const Icon(Icons.add_photo_alternate_outlined),
        label: const Text('Attach a receipt'),
      );
    }

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0x1F2EDAF1),
            child: Icon(Icons.receipt_long_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            tooltip: 'Remove receipt',
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}
