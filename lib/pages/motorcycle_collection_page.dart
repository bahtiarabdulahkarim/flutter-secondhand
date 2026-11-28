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
  String selectedCapacity = 'Semua Kapasitas (CC)';
  String selectedPrice = 'Semua Rentang Harga';
  String selectedSort = 'Tahun Terbaru';
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

    // Filter kapasitas mesin
    result = result.where((motorcycle) {
      final cc = motorcycle.engineCc ?? 0;

      switch (selectedCapacity) {
        case 'Di bawah 150 CC':
          return cc > 0 && cc < 150;
        case '150 - 250 CC':
          return cc >= 150 && cc <= 250;
        case '251 - 500 CC':
          return cc >= 251 && cc <= 500;
        case 'Di atas 500 CC':
          return cc > 500;
        default:
          return true;
      }
    }).toList();    

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

    // Urutkan hasil
    switch (selectedSort) {
      case 'Tahun Terlama':
        result.sort((a, b) => a.year.compareTo(b.year));
        break;
      case 'Harga Terendah':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Harga Tertinggi':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
        result.sort((a, b) => b.year.compareTo(a.year));
    }

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
      selectedCapacity = 'Semua Kapasitas (CC)';
      selectedPrice = 'Semua Rentang Harga';
      selectedSort = 'Tahun Terbaru';
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
                              selectedCapacity: selectedCapacity,
                              selectedPrice: selectedPrice,
                              selectedSort: selectedSort,
                              searchKeyword: searchKeyword,

                              resultCount: filteredMotorcycles.length,
                              currentPage: currentPage,
                              itemsPerPage: itemsPerPage,

                              onBrandChanged: (value) {
                                _updateFilters(() => selectedBrand = value);
                              },
                              onCapacityChanged: (value) {
                                _updateFilters(() => selectedCapacity = value);
                              },
                              onPriceChanged: (value) {
                                _updateFilters(() => selectedPrice = value);
                              },
                              onSortChanged: (value) {
                                _updateFilters(() => selectedSort = value);
                              },
                              onSearchChanged: (value) {
                                _updateFilters(() => searchKeyword = value);
                              },
                              onReset: _resetFilters,
                            ),

                            const SizedBox(height: 30),

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