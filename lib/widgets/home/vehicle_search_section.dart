
import 'package:flutter/material.dart';

class VehicleSearchSection extends StatefulWidget {
  const VehicleSearchSection({super.key});

  @override
  State<VehicleSearchSection> createState() =>
      _VehicleSearchSectionState();
}

class _VehicleSearchSectionState extends State<VehicleSearchSection> {
  static const Color gold = Color(0xFFD8B45F);
  static const Color panel = Color(0xFF242932);
  static const Color card = Color(0xFF1D222B);
  static const Color muted = Color(0xFFA0A5AE);

  // Tab dan jenis kendaraan
  String activeTab = 'Semua Kendaraan';
  String vehicleType = 'Semua Kendaraan';

  // Filter yang sedang dipilih pengguna
  String budget = 'Rp 100 - 300 Juta';
  String year = '2020 - 2024';
  String rating = 'Semua Rating';

  // Filter yang sudah diterapkan
  String appliedBudget = 'Rp 100 - 300 Juta';
  String appliedYear = '2020 - 2024';
  String appliedRating = 'Semua Rating';


  bool isFilterApplied = false;

  final TextEditingController searchController =
    TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TAB KENDARAAN
          Wrap(
            spacing: 5,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _tabButton('Semua Kendaraan'),
              _tabButton('Mobil Bekas'),
              _tabButton('Motor Bekas'),
            ],
          ),

          const SizedBox(height: 22),

          // FORM FILTER
          LayoutBuilder(
            builder: (context, constraints) {
              final mobile = constraints.maxWidth < 750;

              final fields = [
                _filterDropdown(
                  'Jenis Kendaraan',
                  vehicleType,
                  ['Semua Kendaraan', 'Mobil Bekas', 'Motor Bekas'],
                  (value) {
                    setState(() {
                      vehicleType = value!;
                    });
                  },
                ),
                _searchField(),
                _filterDropdown(
                  'Rentang Anggaran',
                  budget,
                  [
                    'Rp 100 - 300 Juta',
                    'Rp 300 - 700 Juta',
                    'Rp 700 Juta - 1 Miliar',
                    'Di atas 1 Miliar',
                  ],
                  (value) => setState(() => budget = value!),
                ),
                _filterDropdown(
                  'Tahun Produksi',
                  year,
                  [
                    '2018 - 2020',
                    '2020 - 2024',
                    '2024 - 2026',
                  ],
                  (value) => setState(() => year = value!),
                ),
                _filterDropdown(
                  'Rating',
                  rating,
                  [
                    'Semua Rating',
                    '4.0 ke Atas',
                    '4.5 ke Atas',
                  ],
                  (value) {
                    setState(() {
                      rating = value!;
                    });
                  },
                ),
                _applyButton(),
                _resetButton(),
              ];

              if (mobile) {
                return Wrap(
                  spacing: 12,
                  runSpacing: 14,
                  children: fields.map((field) {
                    return SizedBox(
                      width: (constraints.maxWidth - 12) / 2,
                      child: field,
                    );
                  }).toList(),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 10, child: fields[0]),
                  const SizedBox(width: 8),

                  Expanded(flex: 19, child: fields[1]),
                  const SizedBox(width: 8),

                  Expanded(flex: 10, child: fields[2]),
                  const SizedBox(width: 8),

                  Expanded(flex: 10, child: fields[3]),
                  const SizedBox(width: 8),

                  Expanded(flex: 10, child: fields[4]),
                  const SizedBox(width: 8),

                  Expanded(flex: 12, child: fields[5]),
                  const SizedBox(width: 8),

                  Expanded(flex: 8, child: fields[6]),
                ],
              );
            },
          ),

          const SizedBox(height: 25),

          // HASIL PENCARIAN
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: gold,
                size: 17,
              ),
              const SizedBox(width: 7),
              const Flexible(
                child: Text(
                  'Hasil Pencarian Instan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _smallChip('3 Unit Ditemukan', gold),
            ],
          ),

          const SizedBox(height: 18),

          // GRID HASIL KENDARAAN
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 600
                  ? 1
                  : constraints.maxWidth < 900
                      ? 2
                      : 3;

              const spacing = 14.0;
              final width =
                  (constraints.maxWidth -
                      spacing * (columns - 1)) /
                  columns;
              
              final vehicles = [
                {
                  'category': 'Mobil Bekas',
                  'title': '2023 Honda CR-V 1.5 Turbo',
                  'specs': '19.200 Km • CVT Otomatis • Jak-Sel',
                  'price': 'Rp 175.000.000',
                  'installment': 'Cicilan Rp 7,9 jt/bln',
                  'image':
                      'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=700&q=85',
                  'tag': '175-PT-LULUS',
                  'type': 'SUV • Turbo',
                  'rating': '4.8',
                },
                {
                  'category': 'Motor Bekas',
                  'title': '2023 Yamaha R1',
                  'specs': '4.500 Km • 1000 CC • Jak-Sel',
                  'price': 'Rp 650.000.000',
                  'installment': 'Cicilan Rp 10,8 jt/bln',
                  'image':
                      'https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=700&q=85',
                  'tag': 'GRADE A+',
                  'type': 'Sport Bike',
                  'rating': '4.7',
                },
                {
                  'category': 'Mobil Bekas',
                  'title': '2022 Honda HR-V 1.5 SE CVT',
                  'specs': '24.500 Km • Bensin • Jak-Bar',
                  'price': 'Rp 340.000.000',
                  'installment': 'Cicilan Rp 5,6 jt/bln',
                  'image':
                      'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?auto=format&fit=crop&w=700&q=85',
                  'tag': 'GRADE A+',
                  'type': 'Crossover',
                  'rating': '4.2',
                },
                {
                  'category': 'Motor Bekas',
                  'title': '2022 Kawasaki Ninja ZX-10R',
                  'specs': '6.000 Km • 1000 CC • Jak-Bar',
                  'price': 'Rp 550.000.000',
                  'installment': 'Cicilan Rp 9,1 jt/bln',
                  'image':
                      'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?auto=format&fit=crop&w=700&q=85',
                  'tag': 'INSPEKSI LULUS',
                  'type': 'Superbike',
                  'rating': '4.9',
                },
                {
                  'category': 'Mobil Bekas',
                  'title': '2021 Honda Civic RS 1.5 Turbo',
                  'specs': '19.800 Km • Tiptronic • SCBD',
                  'price': 'Rp 455.000.000',
                  'installment': 'Cicilan Rp 7,5 jt/bln',
                  'image':
                      'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=700&q=85',
                  'tag': 'GARANSI 1 THN',
                  'type': 'Sedan Sport',
                  'rating': '4.5',
                },
                {
                  'category': 'Motor Bekas',
                  'title': '2023 Honda CBR1000RR',
                  'specs': '3.200 Km • 1000 CC • Jakarta',
                  'price': 'Rp 480.000.000',
                  'installment': 'Cicilan Rp 8 jt/bln',
                  'image':
                      'https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?auto=format&fit=crop&w=700&q=85',
                  'tag': 'GRADE A',
                  'type': 'Sport Bike',
                  'rating': '3.9',
                },
              ];

              // Menentukan kategori kendaraan yang dipilih
              final selectedCategory = activeTab != 'Semua Kendaraan'
                  ? activeTab
                  : vehicleType;

              // Menyaring kendaraan berdasarkan kategori
              final tabFilteredVehicles =
                  activeTab == 'Semua Kendaraan' && vehicleType == 'Semua Kendaraan'
                      ? vehicles
                      : vehicles
                          .where((vehicle) =>
                              vehicle['category'] == selectedCategory)
                          .toList();

              final filteredVehicles = tabFilteredVehicles.where((vehicle) {
                // Mengambil kata yang diketik pengguna
                final searchQuery = searchController.text.trim().toLowerCase();

                // Mengambil nama dan spesifikasi kendaraan
                final title = vehicle['title']!.toLowerCase();
                final specs = vehicle['specs']!.toLowerCase();

                // Memeriksa kecocokan pencarian
                if (searchQuery.isNotEmpty &&
                    !title.contains(searchQuery) &&
                    !specs.contains(searchQuery)) {
                  return false;
                }

                // Filter lainnya hanya berjalan setelah tombol diterapkan
                if (!isFilterApplied) {
                  return true;
                }

                // Mengambil harga kendaraan dan mengubahnya menjadi angka
                final vehiclePrice = int.tryParse(
                  vehicle['price']!.replaceAll(RegExp(r'[^0-9]'), ''),
                ) ?? 0;

                // Memeriksa rentang anggaran
                if (appliedBudget == 'Rp 100 - 300 Juta' &&
                    (vehiclePrice < 100000000 || vehiclePrice > 300000000)) {
                  return false;
                }

                if (appliedBudget == 'Rp 300 - 700 Juta' &&
                    (vehiclePrice < 300000000 || vehiclePrice > 700000000)) {
                  return false;
                }

                if (appliedBudget == 'Rp 700 Juta - 1 Miliar' &&
                    (vehiclePrice < 700000000 || vehiclePrice > 1000000000)) {
                  return false;
                }

                if (appliedBudget == 'Di atas 1 Miliar' &&
                    vehiclePrice <= 1000000000) {
                  return false;
                }

                final vehicleRating =
                    double.tryParse(vehicle['rating'] ?? '0') ?? 0;

                if (appliedRating == '4.0 ke Atas' && vehicleRating < 4.0) {
                  return false;
                }

                if (appliedRating == '4.5 ke Atas' && vehicleRating < 4.5) {
                  return false;
                }

                // Memeriksa tahun produksi kendaraan
                final vehicleTitle = vehicle['title']!;
                final vehicleYear = int.tryParse(vehicleTitle.substring(0, 4)) ?? 0;

                if (appliedYear == '2018 - 2020' &&
                    (vehicleYear < 2018 || vehicleYear > 2020)) {
                  return false;
                }

                if (appliedYear == '2020 - 2024' &&
                    (vehicleYear < 2020 || vehicleYear > 2024)) {
                  return false;
                }

                if (appliedYear == '2024 - 2026' &&
                    (vehicleYear < 2024 || vehicleYear > 2026)) {
                  return false;
                }

                return true;
              }).take(3).toList();

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: filteredVehicles.map((vehicle) {
                  return SizedBox(
                    width: width,
                    child: _resultCard(vehicle),
                  );
                }).toList(),
              );// Memeriksa rating kendaraan
            },
          ),

          const SizedBox(height: 20),

          // BAGIAN BAWAH
          const Divider(color: Color(0xFF353B45)),

          const SizedBox(height: 10),

          Wrap(
            spacing: 5,
            runSpacing: 7,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Saran Pencarian Terkait:',
                style: TextStyle(color: muted, fontSize: 9),
              ),
              _smallChip('CR-V Turbo'),
              _smallChip('Civic RS'),
              _smallChip('HR-V SE'),
              _smallChip('Brio RS'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String title) {
    final selected = activeTab == title;

    final IconData icon = switch (title) {
      'Semua Kendaraan' => Icons.grid_view_rounded,
      'Mobil Bekas' => Icons.directions_car_outlined,
      'Motor Bekas' => Icons.two_wheeler,
      _ => Icons.directions_car,
    };

    return TextButton(
      onPressed: () {
        setState(() {
          activeTab = title;
          vehicleType = title;
        });
      },
      style: TextButton.styleFrom(
        backgroundColor:
            selected ? gold : const Color(0xFF191E26),
        foregroundColor: selected
            ? const Color(0xFF282116)
            : Colors.white70,
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 7),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _filterDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: muted,
            fontSize: 9,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF10151D),
            border: Border.all(color: const Color(0xFF39404A)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: panel,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: gold,
                size: 17,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
              items: options.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(
                    option,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PENCARIAN MEREK & MODEL',
          style: TextStyle(
            color: gold,
            fontSize: 9,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 40,
          child: TextField(
            controller: searchController,

            // Memperbarui hasil pencarian setiap kali pengguna mengetik
            onChanged: (value) {
              setState(() {});
            },
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            decoration: InputDecoration(
              hintText: 'Cari Honda, BMW, Yamaha...',
              hintStyle: const TextStyle(
                color: muted,
                fontSize: 11,
              ),
              filled: true,
              fillColor: const Color(0xFF10151D),
              prefixIcon: const Icon(
                Icons.search,
                color: gold,
                size: 17,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  searchController.clear();
                },
                icon: const Icon(
                  Icons.cancel,
                  color: muted,
                  size: 16,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: Color(0xFF8C7545),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: gold,
                  width: 1.3,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _resetFilter() {
    setState(() {
      budget = 'Rp 100 - 300 Juta';
      year = '2020 - 2024';
      rating = 'Semua Rating';

      appliedBudget = 'Rp 100 - 300 Juta';
      appliedYear = '2020 - 2024';
      appliedRating = 'Semua Rating';

      isFilterApplied = false;
    });
  }

  Widget _applyButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            appliedBudget = budget;
            appliedYear = year;
            appliedRating = rating;

            isFilterApplied = true;
          });
        },
        icon: const Icon(Icons.tune, size: 14),
        label: const Text(
          'Terapkan Filter',
          style: TextStyle(fontSize: 11),
        ),
      ),
    );
  }

  
  Widget _resetButton() {
    return SizedBox(
      height: 40,
      child: OutlinedButton.icon(
        onPressed: _resetFilter,
        icon: const Icon(
          Icons.refresh_rounded,
          size: 16,
          color: gold,
        ),
        label: const Text(
          'Reset',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF303640),
          side: BorderSide(
            color: gold.withValues(alpha: 0.55),
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _smallChip(
    String text, [
    Color color = const Color(0xFF303640),
  ]) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color == gold ? gold : const Color(0xFF303640),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color == gold
              ? const Color(0xFF292116)
              : Colors.white70,
          fontSize: 9,
        ),
      ),
    );
  }

  Widget _resultCard(Map<String, String> vehicle) {
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF363D47)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.85,
                child: Image.network(
                  vehicle['image']!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF151A22),
                      child: const Icon(
                        Icons.directions_car,
                        color: gold,
                        size: 45,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 9,
                left: 9,
                child: _smallChip(vehicle['tag']!, gold),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: _smallChip(vehicle['type']!),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle['title']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  vehicle['specs']!,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(color: Color(0xFF353B45), height: 1),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        vehicle['price']!,
                        style: const TextStyle(
                          color: gold,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF303640),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Detail →',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  vehicle['installment']!,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
