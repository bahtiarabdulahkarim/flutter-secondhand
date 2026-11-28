import 'package:flutter/material.dart';
import '../../data/motorcycle_data.dart';

class MotorcycleFilter extends StatelessWidget {
  const MotorcycleFilter({
    super.key,
    required this.selectedBrand,
    required this.selectedCapacity,
    required this.selectedPrice,
    required this.selectedSort,
    required this.searchKeyword,
    required this.onBrandChanged,
    required this.onCapacityChanged,
    required this.onPriceChanged,
    required this.onSortChanged,
    required this.onSearchChanged,
    required this.onReset,
    required this.resultCount,
    required this.currentPage,
    required this.itemsPerPage,
  });

  final String selectedBrand;
  final String selectedCapacity;
  final String selectedPrice;
  final String selectedSort;
  final String searchKeyword;
  final int resultCount;
  final int currentPage;
  final int itemsPerPage;

  final ValueChanged<String> onBrandChanged;
  final ValueChanged<String> onCapacityChanged;
  final ValueChanged<String> onPriceChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onReset;

  static const Color gold = Color(0xFFD8B45F);
  static const Color muted = Color(0xFFA0A5AE);
  static const Color fieldColor = Color(0xFF242932);

  static const List<String> capacityOptions = [
    'Semua Kapasitas (CC)',
    'Di bawah 150 CC',
    '150 - 250 CC',
    '251 - 500 CC',
    'Di atas 500 CC',
  ];

  static const List<String> priceOptions = [
    'Semua Rentang Harga',
    'Di bawah Rp30 Juta',
    'Rp30 - 60 Juta',
    'Rp60 - 100 Juta',
    'Rp100 - 200 Juta',
    'Di atas Rp200 Juta',
  ];

  static const List<String> sortOptions = [
    'Tahun Terbaru',
    'Tahun Terlama',
    'Harga Terendah',
    'Harga Tertinggi',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 750;

        return Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: const Color(0xFF191D24),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          child: Column(
            children: [  
            if (isMobile)
              Column(
                children: [
                  _searchField(),
                  const SizedBox(height: 10),

                  // Baris pertama: Merek dan Kapasitas
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          value: selectedBrand,
                          options: [
                            'Semua Merek',
                            ...MotorcycleData.availableBrands,
                          ],
                          onChanged: onBrandChanged,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDropdown(
                          value: selectedCapacity,
                          options: capacityOptions,
                          onChanged: onCapacityChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),

                  // Baris kedua: Harga dan Urutan
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          value: selectedPrice,
                          options: priceOptions,
                          onChanged: onPriceChanged,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDropdown(
                          value: selectedSort,
                          options: sortOptions,
                          onChanged: onSortChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),

                  Align(
                    alignment: Alignment.centerRight,
                    child: _resetButton(),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _searchField(),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: _buildDropdown(
                      value: selectedBrand,
                      options: [
                        'Semua Merek',
                        ...MotorcycleData.availableBrands,
                      ],
                      onChanged: onBrandChanged,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: _buildDropdown(
                      value: selectedCapacity,
                      options: capacityOptions,
                      onChanged: onCapacityChanged,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: _buildDropdown(
                      value: selectedPrice,
                      options: priceOptions,
                      onChanged: onPriceChanged,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: _buildDropdown(
                      value: selectedSort,
                      options: sortOptions,
                      onChanged: onSortChanged,
                    ),
                  ),
                  const SizedBox(width: 5),
                  _resetButton(),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                color: Colors.white.withValues(alpha: 0.06),
                height: 1,
              ),
              const SizedBox(height: 10),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isSmall = constraints.maxWidth < 650;

                  final startItem = resultCount == 0
                      ? 0
                      : ((currentPage - 1) * itemsPerPage) + 1;

                  final endItem = (currentPage * itemsPerPage)
                      .clamp(0, resultCount);

                  final resultText = Text(
                    'Menampilkan $startItem-$endItem dari $resultCount '
                    'Motor Terkurasi Siap Kirim',
                    style: const TextStyle(
                      color: Color(0xFFE1E3EB),
                      fontSize: 11,
                    ),
                  );

                  final guaranteeText = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.verified_outlined,
                        color: gold,
                        size: 14,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          'Seluruh unit siap test drive di showroom rekanan resmi',
                          style: TextStyle(
                            color: gold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  );

                  if (isSmall) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        resultText,
                        const SizedBox(height: 8),
                        guaranteeText,
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      resultText,
                      guaranteeText,
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _searchField() {
    return TextFormField(
      initialValue: searchKeyword,
      onChanged: onSearchChanged,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
      ),
      decoration: InputDecoration(
        hintText: 'Cari merek / model motor...',
        hintStyle: const TextStyle(
          color: muted,
          fontSize: 10,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: gold,
          size: 18,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 35,
        ),
        filled: true,
        fillColor: fieldColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    final safeValue = options.contains(value) ? value : options.first;

    return DropdownButtonFormField<String>(
      initialValue: safeValue,
      isExpanded: true,
      dropdownColor: fieldColor,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: muted,
        size: 17,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
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
    );
  }

  Widget _resetButton() {
    return SizedBox(
      height: 43,
      child: OutlinedButton.icon(
        onPressed: onReset,
        icon: const Icon(
          Icons.refresh,
          size: 15,
        ),
        label: const Text(
          'Reset',
          style: TextStyle(fontSize: 10),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: gold,
          side: BorderSide(
            color: gold.withValues(alpha: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}