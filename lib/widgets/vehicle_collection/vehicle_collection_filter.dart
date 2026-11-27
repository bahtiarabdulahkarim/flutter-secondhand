import 'package:flutter/material.dart';
import '../../data/vehicle_data.dart';

typedef VehicleCollectionFilterCallback = void Function({
  required String keyword,
  String? brand,
  int? minPrice,
  int? maxPrice,
  int? minYear,
  int? maxYear,
  String? transmission,
  String sortBy,
});

class VehicleCollectionFilter extends StatefulWidget {
  const VehicleCollectionFilter({
    super.key,
    required this.onFilterChanged,
  });

  final VehicleCollectionFilterCallback onFilterChanged;

  @override
  State<VehicleCollectionFilter> createState() =>
      _VehicleCollectionFilterState();
}

class _VehicleCollectionFilterState
    extends State<VehicleCollectionFilter> {
  static const Color gold = Color(0xFFC9A45C);
  static const Color fieldColor = Color(0xFF262B34);

  String selectedBrand = 'Semua Merek';
  String selectedPrice = 'Rentang Harga';
  String selectedYear = 'Tahun (Semua)';
  String selectedTransmission = 'Transmisi';
  String selectedSort = 'Tahun Terbaru';

  final List<String> priceOptions = [
    'Rentang Harga',
    'Di bawah Rp100 Jt',
    'Rp100 Jt - Rp300 Jt',
    'Rp300 Jt - Rp600 Jt',
    'Di atas Rp600 Jt',
  ];

  final List<String> yearOptions = [
    'Tahun (Semua)',
    '2019 - 2020',
    '2021 - 2022',
    '2023 - 2024',
  ];

  final List<String> transmissionOptions = [
    'Transmisi',
    'CVT',
    'Otomatis',
  ];

  final List<String> sortOptions = [
    'Tahun Terbaru',
    'Rekomendasi',
    'Harga Termurah',
    'Harga Termahal',
    'Odometer Terendah',
  ];

  void applyFilter() {
    int? minPrice;
    int? maxPrice;
    int? minYear;
    int? maxYear;

    switch (selectedPrice) {
      case 'Di bawah Rp100 Jt':
        maxPrice = 100000000;
        break;
      case 'Rp100 Jt - Rp300 Jt':
        minPrice = 100000000;
        maxPrice = 300000000;
        break;
      case 'Rp300 Jt - Rp600 Jt':
        minPrice = 300000000;
        maxPrice = 600000000;
        break;
      case 'Di atas Rp600 Jt':
        minPrice = 600000000;
        break;
    }

    switch (selectedYear) {
      case '2019 - 2020':
        minYear = 2019;
        maxYear = 2020;
        break;
      case '2021 - 2022':
        minYear = 2021;
        maxYear = 2022;
        break;
      case '2023 - 2024':
        minYear = 2023;
        maxYear = 2024;
        break;
    }

    widget.onFilterChanged(
      keyword: '',
      brand: selectedBrand == 'Semua Merek'
          ? null
          : selectedBrand,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minYear: minYear,
      maxYear: maxYear,
      transmission: selectedTransmission == 'Transmisi'
          ? null
          : selectedTransmission,
      sortBy: selectedSort,
    );
  }

  void resetFilter() {
    setState(() {
      selectedBrand = 'Semua Merek';
      selectedPrice = 'Rentang Harga';
      selectedYear = 'Tahun (Semua)';
      selectedTransmission = 'Transmisi';
      selectedSort = 'Tahun Terbaru';
    });

    applyFilter();
  }

  Widget buildDropdown({
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      dropdownColor: const Color(0xFF191D24),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white70,
        size: 17,
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldColor,
        constraints: const BoxConstraints.tightFor(
          height: 48,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: gold,
            width: 1,
          ),
        ),
      ),
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(
            option,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget buildSortButton({
    required double width,
  }) {
    return SizedBox(
      width: width,
      height: 48,
      child: PopupMenuButton<String>(
        tooltip: 'Urutkan kendaraan',
        padding: EdgeInsets.zero,
        color: const Color(0xFF191D24),
        onSelected: (value) {
          setState(() => selectedSort = value);
          applyFilter();
        },
        itemBuilder: (context) {
          return sortOptions.map((option) {
            return PopupMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: TextStyle(
                  color: selectedSort == option
                      ? gold
                      : Colors.white,
                  fontSize: 12,
                ),
              ),
            );
          }).toList();
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: fieldColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Urutkan: $selectedSort',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: gold,
                    fontSize: 10,
                  ),
                ),
              ),
              const Icon(
                Icons.sort,
                color: gold,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int columns =
            constraints.maxWidth >= 850 ? 5 : 2;

        const double spacing = 8;

        final double itemWidth =
            (constraints.maxWidth -
                (columns - 1) * spacing) /
            columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: itemWidth,
                  child: buildDropdown(
                    value: selectedBrand,
                    options: [
                      'Semua Merek',
                      ...VehicleData.availableBrands,
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => selectedBrand = value);
                      applyFilter();
                    },
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: buildDropdown(
                    value: selectedPrice,
                    options: priceOptions,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => selectedPrice = value);
                      applyFilter();
                    },
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: buildDropdown(
                    value: selectedYear,
                    options: yearOptions,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => selectedYear = value);
                      applyFilter();
                    },
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: buildDropdown(
                    value: selectedTransmission,
                    options: transmissionOptions,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedTransmission = value;
                      });
                      applyFilter();
                    },
                  ),
                ),
                buildSortButton(width: itemWidth),
              ],
            ),
            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: resetFilter,
                icon: const Icon(
                  Icons.refresh,
                  size: 15,
                ),
                label: const Text(
                  'Reset Filter',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: gold,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                ),
              ),
            ),
          ],
        );
      },  
    );
  }
}