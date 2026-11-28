import 'package:flutter/material.dart';

import '../data/motorcycle_data.dart';
import '../models/vehicle_model.dart';

import '../widgets/home/home_navbar.dart';
import '../widgets/home/home_footer_section.dart';

import '../widgets/motorcycle/motorcycle_hero.dart';
import '../widgets/motorcycle/motorcycle_category.dart';
import '../widgets/motorcycle/motorcycle_filter.dart';
import '../widgets/motorcycle/motorcycle_listing.dart';

import 'vehicle_collection_page.dart';

class MotorcycleCollectionPage extends StatefulWidget {
  const MotorcycleCollectionPage({super.key});

  @override
  State<MotorcycleCollectionPage> createState() =>
      _MotorcycleCollectionPageState();
}

class _MotorcycleCollectionPageState
    extends State<MotorcycleCollectionPage> {
  static const Color backgroundColor = Color(0xFF0D1015);
  static const Color gold = Color(0xFFC9A45C);
  static const Color muted = Color(0xFFA0A5AE);

  static const int itemsPerPage = 9;

  String selectedBrand = 'Semua Merek';
  String selectedPrice = 'Semua Harga';
  String selectedYear = 'Semua Tahun';
  String selectedTransmission = 'Semua Transmisi';
  String selectedLocation = 'Semua Lokasi';
  String searchKeyword = '';

  bool isListView = false;
  int currentPage = 1;

  List<VehicleModel> filteredMotorcycles = [];

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  void _applyFilters() {
    List<VehicleModel> result = MotorcycleData.motorcycles;

    // Filter kata kunci
    if (searchKeyword.trim().isNotEmpty) {
      final keyword = searchKeyword.toLowerCase().trim();

      result = result.where((motorcycle) {
        return motorcycle.name.toLowerCase().contains(keyword) ||
            motorcycle.brand.toLowerCase().contains(keyword) ||
            motorcycle.model.toLowerCase().contains(keyword) ||
            motorcycle.location.toLowerCase().contains(keyword);
      }).toList();
    }

    // Filter merek
    if (selectedBrand != 'Semua Merek') {
      result = result
          .where((motorcycle) => motorcycle.brand == selectedBrand)
          .toList();
    }

    // Filter harga
    result = result.where((motorcycle) {
      final price = motorcycle.price;

      switch (selectedPrice) {
        case 'Di bawah Rp30 Juta':
          return price < 30000000;

        case 'Rp30 - 60 Juta':
          return price >= 30000000 && price <= 60000000;

        case 'Rp60 - 100 Juta':
          return price > 60000000 && price <= 100000000;

        case 'Rp100 - 200 Juta':
          return price > 100000000 && price <= 200000000;

        case 'Di atas Rp200 Juta':
          return price > 200000000;

        default:
          return true;
      }
    }).toList();

    // Filter tahun
    result = result.where((motorcycle) {
      switch (selectedYear) {
        case '2020 - 2021':
          return motorcycle.year >= 2020 && motorcycle.year <= 2021;

        case '2022 - 2023':
          return motorcycle.year >= 2022 && motorcycle.year <= 2023;

        case '2024 - 2025':
          return motorcycle.year >= 2024 && motorcycle.year <= 2025;

        case '2026':
          return motorcycle.year == 2026;

        default:
          return true;
      }
    }).toList();

    // Filter transmisi
    if (selectedTransmission != 'Semua Transmisi') {
      result = result
          .where((motorcycle) =>
              motorcycle.transmission == selectedTransmission)
          .toList();
    }

    // Filter lokasi
    if (selectedLocation != 'Semua Lokasi') {
      result = result
          .where((motorcycle) => motorcycle.location == selectedLocation)
          .toList();
    }

    // Urutkan tahun terbaru
    result.sort((a, b) => b.year.compareTo(a.year));

    filteredMotorcycles = result;
  }

  void _updateFilters(VoidCallback update) {
    setState(() {
      update();
      currentPage = 1;
      _applyFilters();
    });
  }

  List<VehicleModel> get paginatedMotorcycles {
    final startIndex = (currentPage - 1) * itemsPerPage;

    if (startIndex >= filteredMotorcycles.length) {
      return [];
    }

    final endIndex = (startIndex + itemsPerPage)
        .clamp(0, filteredMotorcycles.length);

    return filteredMotorcycles.sublist(startIndex, endIndex);
  }

  int get totalPages {
    final pages = (filteredMotorcycles.length / itemsPerPage).ceil();
    return pages < 1 ? 1 : pages;
  }

  void _changePage(int page) {
    if (page < 1 || page > totalPages) return;

    setState(() {
      currentPage = page;
    });
  }

  void _resetFilters() {
    _updateFilters(() {
      selectedBrand = 'Semua Merek';
      selectedPrice = 'Semua Harga';
      selectedYear = 'Semua Tahun';
      selectedTransmission = 'Semua Transmisi';
      selectedLocation = 'Semua Lokasi';
      searchKeyword = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          HomeNavbar(
            activeMenu: 'Motor',
            onNavigate: (menu) {
              if (menu == 'Beranda') {
                Navigator.pop(context);
              } else if (menu == 'Mobil') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VehicleCollectionPage(),
                  ),
                );
              }
            },
            onProfile: () {},
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const MotorcycleHero(),

                            const SizedBox(height: 45),

                            const MotorcycleCategory(),

                            const SizedBox(height: 35),

                            MotorcycleFilter(
                              selectedBrand: selectedBrand,
                              selectedPrice: selectedPrice,
                              selectedYear: selectedYear,
                              selectedTransmission: selectedTransmission,
                              selectedLocation: selectedLocation,
                              searchKeyword: searchKeyword,
                              onBrandChanged: (value) {
                                _updateFilters(() {
                                  selectedBrand = value;
                                });
                              },
                              onPriceChanged: (value) {
                                _updateFilters(() {
                                  selectedPrice = value;
                                });
                              },
                              onYearChanged: (value) {
                                _updateFilters(() {
                                  selectedYear = value;
                                });
                              },
                              onTransmissionChanged: (value) {
                                _updateFilters(() {
                                  selectedTransmission = value;
                                });
                              },
                              onLocationChanged: (value) {
                                _updateFilters(() {
                                  selectedLocation = value;
                                });
                              },
                              onSearchChanged: (value) {
                                _updateFilters(() {
                                  searchKeyword = value;
                                });
                              },
                              onReset: _resetFilters,
                            ),

                            const SizedBox(height: 30),

                            _buildResultInfo(),

                            const SizedBox(height: 18),

                            MotorcycleListing(
                              motorcycles: paginatedMotorcycles,
                              isListView: isListView,
                              onViewChanged: (value) {
                                setState(() {
                                  isListView = value;
                                });
                              },
                              onDetail: (motorcycle) {
                                debugPrint(
                                  'Detail motor: ${motorcycle.id}',
                                );
                              },
                            ),

                            const SizedBox(height: 25),

                            _buildPagination(),

                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const HomeFooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultInfo() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        final countText = Text(
          '${filteredMotorcycles.length} motor ditemukan',
          style: const TextStyle(
            color: Color(0xFFE1E3EB),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        );

        const infoText = Text(
          'Pilihan motor bekas berkualitas dan terverifikasi',
          style: TextStyle(
            color: muted,
            fontSize: 11,
          ),
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              countText,
              const SizedBox(height: 5),
              infoText,
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            countText,
            infoText,
          ],
        );
      },
    );
  }

  Widget _buildPagination() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 7,
      runSpacing: 8,
      children: [
        _paginationButton(
          icon: Icons.chevron_left,
          enabled: currentPage > 1,
          onTap: () => _changePage(currentPage - 1),
        ),

        for (int page = 1; page <= totalPages; page++)
          _paginationNumber(page),

        _paginationButton(
          icon: Icons.chevron_right,
          enabled: currentPage < totalPages,
          onTap: () => _changePage(currentPage + 1),
        ),
      ],
    );
  }

  Widget _paginationNumber(int page) {
    final isSelected = currentPage == page;

    return InkWell(
      onTap: () => _changePage(page),
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? gold : const Color(0xFF191D24),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? gold : Colors.white12,
          ),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            color: isSelected ? backgroundColor : muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _paginationButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF191D24),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(
          icon,
          color: enabled ? gold : Colors.white24,
          size: 19,
        ),
      ),
    );
  }
}