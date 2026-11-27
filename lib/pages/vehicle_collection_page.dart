import 'package:flutter/material.dart';

import '../data/vehicle_data.dart';
import '../models/vehicle_model.dart';
import '../widgets/home/home_navbar.dart';
import '../widgets/vehicle_collection/vehicle_collection_hero.dart';
import '../widgets/vehicle_collection/vehicle_body_category.dart';
import '../widgets/vehicle_collection/vehicle_collection_filter.dart';
import '../widgets/vehicle_collection/vehicle_collection_listing.dart';

class VehicleCollectionPage extends StatefulWidget {
  const VehicleCollectionPage({super.key});

  @override
  State<VehicleCollectionPage> createState() =>
      _VehicleCollectionPageState();
}

class _VehicleCollectionPageState
    extends State<VehicleCollectionPage> {
  static const Color backgroundColor = Color(0xFF0D1015);
  static const Color gold = Color(0xFFC9A45C);

  List<VehicleModel> filteredVehicles = [];

  @override
  void initState() {
    super.initState();

    filteredVehicles = VehicleData.filterVehicles();
  }

  void handleFilterChanged({
    required String keyword,
    String? brand,
    int? minPrice,
    int? maxPrice,
    int? minYear,
    int? maxYear,
    String? transmission,
    String sortBy = 'Tahun Terbaru',
  }) {
    setState(() {
      filteredVehicles = VehicleData.filterVehicles(
        keyword: keyword,
        brand: brand,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minYear: minYear,
        maxYear: maxYear,
        transmission: transmission,
        sortBy: sortBy,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          HomeNavbar(
            activeMenu: 'Mobil',
            onNavigate: (menu) {
              if (menu == 'Beranda') {
                Navigator.pop(context);
              }
            },
            onProfile: () {},
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const VehicleCollectionHero(),

                      const SizedBox(height: 45),

                      VehicleBodyCategory(
                        onCategorySelected: (category) {
                          debugPrint(
                            'Kategori dipilih: $category',
                          );
                        },
                      ),

                      const SizedBox(height: 35),

                      VehicleCollectionFilter(
                        onFilterChanged: handleFilterChanged,
                      ),

                      const SizedBox(height: 25),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = constraints.maxWidth < 600;

                          final countText = Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: 'Menampilkan '),
                                TextSpan(
                                  text: '1-${filteredVehicles.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' dari '),
                                TextSpan(
                                  text: '${filteredVehicles.length}',
                                  style: const TextStyle(
                                    color: gold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' Mobil Terkurasi'),
                              ],
                            ),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          );

                          const testDriveText = Text(
                            '◉ Seluruh unit siap dijalankan (Test Drive)',
                            style: TextStyle(
                              color: gold,
                              fontSize: 11,
                            ),
                          );

                          if (isMobile) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                countText,
                                const SizedBox(height: 8),
                                testDriveText,
                              ],
                            );
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              countText,
                              testDriveText,
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      VehicleCollectionListing(
                        vehicles: filteredVehicles,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
