import 'package:flutter/material.dart';

import '../widgets/search_results/search_results_header.dart';
import '../widgets/search_results/search_results_filter_section.dart';
import '../widgets/search_results/search_results_toolbar.dart';
import '../widgets/search_results/vehicle_listing/vehicle_listing_section.dart';
import '../widgets/search_results/vehicle_listing/vehicle_listing_footer.dart';
import '../widgets/search_results/vehicle_sourcing_banner.dart';
import '../widgets/home/home_footer_section.dart';
import '../widgets/home/home_navbar.dart';
import '../data/vehicle_data.dart';

class VehicleSearchResultsPage extends StatefulWidget {
  const VehicleSearchResultsPage({super.key});

  @override
  State<VehicleSearchResultsPage> createState() =>
      _VehicleSearchResultsPageState();
}

class _VehicleSearchResultsPageState extends State<VehicleSearchResultsPage> {
  static const Color backgroundColor = Color(0xFF0D1015);

  String selectedModel = 'Semua Honda';
  String selectedPrice = 'Rp30 Jt - Rp600 Jt';
  String selectedYear = '2019 - 2024';
  String selectedSort = 'Rekomendasi';
  String selectedTransmission = 'Semua';
  String selectedOdometer = 'Semua';
  String selectedLocation = 'Semua Area';

  int currentPage = 1;
  static const int itemsPerPage = 10;

  void selectModel(String model) {
    setState(() {
      selectedModel = model;
      currentPage = 1;
    });
  }

  void selectPrice(String price) {
    setState(() {
      selectedPrice = price;
      currentPage = 1;
    });
  }

  void selectYear(String year) {
    setState(() {
      selectedYear = year;
      currentPage = 1;
    });
  }

  void selectTransmission(String transmission) {
    setState(() {
      selectedTransmission = transmission;
      currentPage = 1;
    });
  }

  void selectOdometer(String odometer) {
    setState(() {
      selectedOdometer = odometer;
      currentPage = 1;
    });
  }

  void selectLocation(String location) {
    setState(() {
      selectedLocation = location;
      currentPage = 1;
    });
  }

  void resetFilters() {
    setState(() {
      selectedModel = 'Semua Honda';
      selectedPrice = 'Rp30 Jt - Rp600 Jt';
      selectedYear = '2019 - 2024';
      selectedTransmission = 'Semua';
      selectedOdometer = 'Semua';
      selectedLocation = 'Semua Area';
      selectedSort = 'Rekomendasi';
    });
  }

  void selectSort(String sort) {
    setState(() {
      selectedSort = sort;
    });
  }

  void selectPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  Map<String, int?> getPriceRange() {
    switch (selectedPrice) {
      case 'Rp30 Jt - Rp100 Jt':
        return {'min': 30000000, 'max': 100000000};

      case 'Rp100 Jt - Rp300 Jt':
        return {'min': 100000000, 'max': 300000000};

      case 'Rp300 Jt - Rp600 Jt':
        return {'min': 300000000, 'max': 600000000};

      default:
        return {'min': 30000000, 'max': 600000000};
    }
  }

  Map<String, int?> getYearRange() {
    switch (selectedYear) {
      case '2019 - 2020':
        return {'min': 2019, 'max': 2020};

      case '2021 - 2022':
        return {'min': 2021, 'max': 2022};

      case '2023 - 2024':
        return {'min': 2023, 'max': 2024};

      default:
        return {'min': 2019, 'max': 2024};
    }
  }

  Map<String, int?> getOdometerRange() {
    switch (selectedOdometer) {
      case '< 30.000 KM':
        return {'min': null, 'max': 29999};

      case '30.000 - 60.000 KM':
        return {'min': 30000, 'max': 60000};

      case '> 60.000 KM':
        return {'min': 60001, 'max': null};

      default:
        return {'min': null, 'max': null};
    }
  }

  @override
  Widget build(BuildContext context) {
    final priceRange = getPriceRange();
    final yearRange = getYearRange();
    final odometerRange = getOdometerRange();

    final filteredVehicles = VehicleData.filterVehicles(
      brand: 'Honda',
      location: selectedLocation == 'Semua Area'
        ? null
        : selectedLocation,
      model: selectedModel == 'Semua Honda' ? null : selectedModel,
      minPrice: priceRange['min'],
      maxPrice: priceRange['max'],
      minYear: yearRange['min'],
      maxYear: yearRange['max'],
      minOdometer: odometerRange['min'],
      maxOdometer: odometerRange['max'],
      transmission: selectedTransmission == 'Semua'
        ? null
        : selectedTransmission,
      sortBy: selectedSort,
    );
    final totalPages = (filteredVehicles.length / itemsPerPage).ceil();

    final startIndex = (currentPage - 1) * itemsPerPage;

    final endIndex = (startIndex + itemsPerPage) > filteredVehicles.length
        ? filteredVehicles.length
        : startIndex + itemsPerPage;

    final paginatedVehicles = filteredVehicles.sublist(
      startIndex,
      endIndex,
    );

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchResultsHeader(),
                  SizedBox(height: 20),
                  SearchResultsFilterSection(
                    selectedModel: selectedModel,
                    onModelSelected: selectModel,
                  ),
                  SizedBox(height: 20),
                  SearchResultsToolbar(
                    selectedPrice: selectedPrice,
                    onPriceSelected: selectPrice,
                    selectedYear: selectedYear,
                    onYearSelected: selectYear,
                    selectedTransmission: selectedTransmission,
                    onTransmissionSelected: selectTransmission,
                    selectedOdometer: selectedOdometer,
                    onOdometerSelected: selectOdometer,
                    selectedLocation: selectedLocation,
                    onLocationSelected: selectLocation,
                    onResetFilters: resetFilters,
                    selectedSort: selectedSort,
                    onSortSelected: selectSort,
                  ),
                  SizedBox(height: 24),
                  VehicleListingSection(vehicles: paginatedVehicles),
                  SizedBox(height: 20),
                  VehicleListingFooter(
                    currentPage: currentPage,
                    totalPages: totalPages,
                    totalItems: filteredVehicles.length,
                    itemsPerPage: itemsPerPage,
                    onPageSelected: selectPage,
                  ),
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