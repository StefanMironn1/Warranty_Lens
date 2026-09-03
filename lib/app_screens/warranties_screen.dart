import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/warranty_item.dart';
import '../state/warranty_store.dart';
import '../widgets/app_widgets.dart';
import 'warranty_details_screen.dart';

enum WarrantyFilter { all, active, expiring, expired, favorites }

enum WarrantySort { expiry, newest, name, value }

class WarrantiesScreen extends StatefulWidget {
  const WarrantiesScreen({
    required this.store,
    required this.onAddWarranty,
    super.key,
  });

  final WarrantyStore store;
  final VoidCallback onAddWarranty;

  @override
  State<WarrantiesScreen> createState() => _WarrantiesScreenState();
}

class _WarrantiesScreenState extends State<WarrantiesScreen> {
  final _searchController = TextEditingController();
  WarrantyFilter _filter = WarrantyFilter.all;
  WarrantySort _sort = WarrantySort.expiry;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WarrantyItem> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();
    final now = DateTime.now();
    final items = widget.store.warranties.where((item) {
      final matchesQuery = query.isEmpty ||
          item.productName.toLowerCase().contains(query) ||
          item.brand.toLowerCase().contains(query) ||
          item.retailer.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.serialNumber.toLowerCase().contains(query);
      if (!matchesQuery) return false;

      return switch (_filter) {
        WarrantyFilter.all => true,
        WarrantyFilter.active => item.statusAt(now) == WarrantyStatus.active,
        WarrantyFilter.expiring =>
          item.statusAt(now) == WarrantyStatus.expiringSoon,
        WarrantyFilter.expired => item.statusAt(now) == WarrantyStatus.expired,
        WarrantyFilter.favorites => item.isFavorite,
      };
    }).toList();

    switch (_sort) {
      case WarrantySort.expiry:
        items.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
      case WarrantySort.newest:
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case WarrantySort.name:
        items.sort((a, b) => a.productName.compareTo(b.productName));
      case WarrantySort.value:
        items.sort((a, b) => b.price.compareTo(a.price));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    return AppPageBackground(
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'My warranties',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.7,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${widget.store.warranties.length} purchases in your vault',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<WarrantySort>(
                              tooltip: 'Sort warranties',
                              initialValue: _sort,
                              onSelected: (value) => setState(() => _sort = value),
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  value: WarrantySort.expiry,
                                  child: Text('Expiry date'),
                                ),
                                PopupMenuItem(
                                  value: WarrantySort.newest,
                                  child: Text('Recently added'),
                                ),
                                PopupMenuItem(
                                  value: WarrantySort.name,
                                  child: Text('Product name'),
                                ),
                                PopupMenuItem(
                                  value: WarrantySort.value,
                                  child: Text('Highest value'),
                                ),
                              ],
                              icon: const Icon(Icons.sort_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search products, brands or stores',
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _searchController.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: WarrantyFilter.values.map((filter) {
                              final selected = _filter == filter;
                              return Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: FilterChip(
                                  selected: selected,
                                  label: Text(_filterLabel(filter)),
                                  avatar: filter == WarrantyFilter.favorites
                                      ? Icon(
                                          selected
                                              ? Icons.star_rounded
                                              : Icons.star_border_rounded,
                                          size: 17,
                                        )
                                      : null,
                                  onSelected: (_) =>
                                      setState(() => _filter = filter),
                                  selectedColor:
                                      AppColors.primary.withValues(alpha: 0.16),
                                  side: BorderSide(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.border,
                                  ),
                                  checkmarkColor: AppColors.primary,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'Nothing found',
                  message: _searchController.text.isNotEmpty
                      ? 'Try a different product, brand or store name.'
                      : 'No warranties match this filter yet.',
                  actionLabel: 'Add a warranty',
                  onAction: widget.onAddWarranty,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 112),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 13),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: WarrantyCard(
                          item: item,
                          currency: widget.store.currency,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WarrantyDetailsScreen(
                                store: widget.store,
                                warrantyId: item.id,
                              ),
                            ),
                          ),
                          onFavorite: () => widget.store.toggleFavorite(item.id),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _filterLabel(WarrantyFilter filter) => switch (filter) {
        WarrantyFilter.all => 'All',
        WarrantyFilter.active => 'Active',
        WarrantyFilter.expiring => 'Expiring',
        WarrantyFilter.expired => 'Expired',
        WarrantyFilter.favorites => 'Favorites',
      };
}
