import 'package:flutter/material.dart';
import '../../data/motorcycle_data.dart';

class MotorcycleFilter extends StatelessWidget {
  const MotorcycleFilter({
    super.key,
    required this.selectedBrand,
    required this.selectedPrice,
    required this.selectedYear,
    required this.selectedTransmission,
    required this.selectedLocation,
    required this.searchKeyword,
    required this.onBrandChanged,
    required this.onPriceChanged,
    required this.onYearChanged,
    required this.onTransmissionChanged,
    required this.onLocationChanged,
    required this.onSearchChanged,
    required this.onReset,
  });

  final String selectedBrand;
  final String selectedPrice;
  final String selectedYear;
  final String selectedTransmission;
  final String selectedLocation;
  final String searchKeyword;

  final ValueChanged<String> onBrandChanged;
  final ValueChanged<String> onPriceChanged;
  final ValueChanged<String> onYearChanged;
  final ValueChanged<String> onTransmissionChanged;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onReset;

  static const Color gold = Color(0xFFD8B45F);
  static const Color muted = Color(0xFFA0A5AE);
  static const Color fieldColor = Color(0xFF242932);

  static const List<String> priceOptions = [
    'Semua Harga',
    'Di bawah Rp30 Juta',
    'Rp30 - 60 Juta',
    'Rp60 - 100 Juta',
    'Rp100 - 200 Juta',
    'Di atas Rp200 Juta',
  ];

  static const List<String> yearOptions = [
    'Semua Tahun',
    '2020 - 2021',
    '2022 - 2023',
    '2024 - 2025',
    '2026',
  ];

  static const List<String> transmissionOptions = [
    'Semua Transmisi',
    'CVT Otomatis',
    'Manual',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF191D24),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.tune, color: gold, size: 19),
                  const SizedBox(width: 9),
                  const Expanded(
                    child: Text(
                      'Filter Pencarian Motor',
                      style: TextStyle(
                        color: Color(0xFFE1E3EB),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onReset,
                    child: const Text(
                      'Reset Filter',
                      style: TextStyle(
                        color: gold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _searchField(),
              const SizedBox(height: 14),

              if (isMobile)
                Column(
                  children: [
                    _buildDropdown(
                      label: 'Merek Motor',
                      value: selectedBrand,
                      options: [
                        'Semua Merek',
                        ...MotorcycleData.availableBrands,
                      ],
                      onChanged: onBrandChanged,
                    ),
                    _buildDropdown(
                      label: 'Rentang Harga',
                      value: selectedPrice,
                      options: priceOptions,
                      onChanged: onPriceChanged,
                    ),
                    _buildDropdown(
                      label: 'Tahun Produksi',
                      value: selectedYear,
                      options: yearOptions,
                      onChanged: onYearChanged,
                    ),
                    _buildDropdown(
                      label: 'Transmisi',
                      value: selectedTransmission,
                      options: transmissionOptions,
                      onChanged: onTransmissionChanged,
                    ),
                    _buildDropdown(
                      label: 'Lokasi',
                      value: selectedLocation,
                      options: [
                        'Semua Lokasi',
                        ...MotorcycleData.availableLocations,
                      ],
                      onChanged: onLocationChanged,
                    ),
                  ],
                )
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _dropdownBox(
                      label: 'Merek Motor',
                      value: selectedBrand,
                      options: [
                        'Semua Merek',
                        ...MotorcycleData.availableBrands,
                      ],
                      onChanged: onBrandChanged,
                    ),
                    _dropdownBox(
                      label: 'Rentang Harga',
                      value: selectedPrice,
                      options: priceOptions,
                      onChanged: onPriceChanged,
                    ),
                    _dropdownBox(
                      label: 'Tahun Produksi',
                      value: selectedYear,
                      options: yearOptions,
                      onChanged: onYearChanged,
                    ),
                    _dropdownBox(
                      label: 'Transmisi',
                      value: selectedTransmission,
                      options: transmissionOptions,
                      onChanged: onTransmissionChanged,
                    ),
                    _dropdownBox(
                      label: 'Lokasi',
                      value: selectedLocation,
                      options: [
                        'Semua Lokasi',
                        ...MotorcycleData.availableLocations,
                      ],
                      onChanged: onLocationChanged,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _searchField() {
    return TextField(
      onChanged: onSearchChanged,
      controller: TextEditingController(text: searchKeyword)
        ..selection = TextSelection.collapsed(
          offset: searchKeyword.length,
        ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
      decoration: InputDecoration(
        hintText: 'Cari nama atau merek motor...',
        hintStyle: const TextStyle(color: muted, fontSize: 12),
        prefixIcon: const Icon(Icons.search, color: gold, size: 19),
        filled: true,
        fillColor: fieldColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdownBox({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      width: 175,
      child: _buildDropdown(
        label: label,
        value: value,
        options: options,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    final safeValue = options.contains(value) ? value : options.first;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: muted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 7),
          DropdownButtonFormField<String>(
            initialValue: safeValue,
            isExpanded: true,
            dropdownColor: fieldColor,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: gold,
              size: 18,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: fieldColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
            ),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}