import 'package:flutter/material.dart';
import 'vehicle_search_results_page.dart';

import '../widgets/home/home_navbar.dart';
import '../widgets/home/home_hero_section.dart';
import '../widgets/home/featured_vehicle_section.dart';
import '../widgets/home/vehicle_search_section.dart';
import '../widgets/home/vehicle_category_section.dart';
import '../widgets/home/featured_vehicle_grid_section.dart';
import '../widgets/home/why_choose_us_section.dart';
import '../widgets/home/home_footer_section.dart';
import 'vehicle_collection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Warna tema
  static const Color backgroundColor = Color(0xFF0D1015);

  // State navigasi
  String activeNavMenu = 'Beranda';

  // State pencarian
  String activeSearchTab = 'Semua Kendaraan';
  final TextEditingController searchController =
      TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Navbar
          HomeNavbar(
            activeMenu: activeNavMenu,
            onNavigate: (menu) {
              if (menu == 'Mobil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VehicleCollectionPage(),
                  ),
                );
              } else if (menu == 'Beranda') {
                setState(() {
                  activeNavMenu = 'Beranda';
                });
              }
            },
            onProfile: () {
              // Navigasi profil akan kita hubungkan nanti.
            },
          ),

          // Konten utama
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hero Section
                      HomeHeroSection(),
                      SizedBox(height: 55),

                      // Kendaraan Unggulan
                      FeaturedVehicleSection(),
                      SizedBox(height: 35),

                      // Panel Pencarian dan Katalog
                      VehicleSearchSection(
                        onSearch: (keyword) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VehicleSearchResultsPage(
                                initialKeyword: keyword,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 45),

                      // Kategori Kendaraan
                      VehicleCategorySection(),
                      SizedBox(height: 45),

                      FeaturedVehicleGridSection(),
                      SizedBox(height: 45),

                      WhyChooseUsSection(),
                      SizedBox(height: 55),

                      HomeFooterSection(),
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
