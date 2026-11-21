import 'package:flutter/material.dart';

import '../widgets/search_results/search_results_header.dart';
import '../widgets/search_results/search_results_filter_section.dart';
import '../widgets/search_results/search_results_toolbar.dart';
import '../widgets/search_results/vehicle_listing/vehicle_listing_section.dart';
import '../widgets/search_results/vehicle_listing/vehicle_listing_footer.dart';
import '../widgets/search_results/vehicle_sourcing_banner.dart';
import '../widgets/home/home_footer_section.dart';
import '../widgets/home/home_navbar.dart';

class VehicleSearchResultsPage extends StatefulWidget {
  const VehicleSearchResultsPage({super.key});

  @override
  State<VehicleSearchResultsPage> createState() =>
      _VehicleSearchResultsPageState();
}

class _VehicleSearchResultsPageState extends State<VehicleSearchResultsPage> {
  static const Color backgroundColor = Color(0xFF0D1015);
  static const Color goldColor = Color(0xFFC9A45C);
  static const Color textWhite = Colors.white;
  static const Color textMuted = Color(0xFFA0A0A0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          HomeNavbar(
            activeMenu: 'Mobil',
            onNavigate: (destination) {
              debugPrint('Menu dipilih: $destination');
            },
            onProfile: () {
              debugPrint('Profil diklik');
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchResultsHeader(),
                  SizedBox(height: 20),
                  SearchResultsFilterSection(),
                  SizedBox(height: 20),
                  SearchResultsToolbar(),
                  SizedBox(height: 24),
                  VehicleListingSection(),
                  SizedBox(height: 20),
                  VehicleListingFooter(),
                  SizedBox(height: 32),
                  VehicleSourcingBanner(),
                  HomeFooterSection(showBanner: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}