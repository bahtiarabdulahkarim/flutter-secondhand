import 'package:flutter/material.dart';
import '../../data/vehicle_data.dart';

class SearchResultsFilterSection extends StatelessWidget {
  const SearchResultsFilterSection({
    super.key,
    required this.selectedBrand,
    required this.onBrandSelected,
    required this.selectedModel,
    required this.onModelSelected,
    required this.selectedPrice,
    required this.selectedYear,
    required this.selectedTransmission,
    required this.selectedOdometer,
    required this.selectedLocation,
  });

  final String selectedBrand;
  final ValueChanged<String> onBrandSelected;

  final String selectedModel;
  final ValueChanged<String> onModelSelected;
  final String selectedPrice;
  final String selectedYear;
final String selectedTransmission;
  final String selectedOdometer;
  final String selectedLocation;

  static const Color textMuted = Color(0xFFA0A0A0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter aktif
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Filter Aktif:',
              style: TextStyle(
                color: textMuted,
                fontSize: 10,
              ),
            ),

            if (selectedBrand != 'Semua Merek')
              _ActiveFilterChip(
                label: 'Merek: $selectedBrand',
              ),

            if (selectedPrice != 'Rp30 Jt - Rp600 Jt')
              _ActiveFilterChip(
                label: 'Harga: $selectedPrice',
              ),

            if (selectedYear != '2019 - 2024')
              _ActiveFilterChip(
                label: 'Tahun: $selectedYear',
              ),

            if (selectedTransmission != 'Semua')
              _ActiveFilterChip(
                label: 'Transmisi: $selectedTransmission',
              ),

            if (selectedOdometer != 'Semua')
              _ActiveFilterChip(
                label: 'Odometer: $selectedOdometer',
              ),

            if (selectedLocation != 'Semua Area')
              _ActiveFilterChip(
                label: 'Lokasi: $selectedLocation',
              ),

            const _ActiveFilterChip(
              label: 'Kondisi: Terinspeksi 175-Titik',
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Pilihan merek kendaraan
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ModelChip(
                label: 'Semua Merek',
                count: VehicleData.vehicles.length,
                selected: selectedBrand == 'Semua Merek',
                onTap: () => onBrandSelected('Semua Merek'),
              ),
              ...VehicleData.availableBrands.map((brand) {
                final count = VehicleData.vehicles
                    .where((vehicle) => vehicle.brand == brand)
                    .length;

                return _ModelChip(
                  label: brand,
                  count: count,
                  selected: selectedBrand == brand,
                  onTap: () => onBrandSelected(brand),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 12),

      ],
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF242932),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.close,
            color: Color(0xFFA0A0A0),
            size: 12,
          ),
        ],
      ),
    );
  }
}

class _ModelChip extends StatelessWidget {
  const _ModelChip({
    required this.label,
    required this.count,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFC9A45C) : const Color(0xFF191D24),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFF191D24) : Colors.white,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 7),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF9D7938)
                    : const Color(0xFF303640),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFFA0A0A0),
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}