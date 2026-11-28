import 'package:flutter/material.dart';

import '../../models/vehicle_model.dart';
import 'vehicle_collection_card.dart';

class VehicleCollectionListing extends StatefulWidget {
  const VehicleCollectionListing({
    super.key,
    required this.vehicles,
  });

  final List<VehicleModel> vehicles;

  @override
  State<VehicleCollectionListing> createState() =>
      _VehicleCollectionListingState();
}

class _VehicleCollectionListingState
    extends State<VehicleCollectionListing> {
  static const Color gold = Color(0xFFC9A45C);
  static const Color buttonColor = Color(0xFF262B34);

  final Set<String> favoriteVehicleIds = {};

  int currentPage = 1;
  static const int itemsPerPage = 9;

  @override
  void didUpdateWidget(covariant VehicleCollectionListing oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.vehicles != widget.vehicles) {
      currentPage = 1;
    }
  }

  int get totalPages =>
      (widget.vehicles.length / itemsPerPage).ceil();

  List<VehicleModel> get paginatedVehicles {
    if (widget.vehicles.isEmpty) {
      return [];
    }

    final safePage = currentPage.clamp(1, totalPages);

    final startIndex = (safePage - 1) * itemsPerPage;

    final endIndex = (startIndex + itemsPerPage)
        .clamp(0, widget.vehicles.length);

    return widget.vehicles.sublist(
      startIndex,
      endIndex,
    );
  }

  String formatPrice(int price) {
    if (price >= 1000000000) {
      final double billion = price / 1000000000;
      return 'Rp${billion.toStringAsFixed(1)} M';
    }

    final int million = price ~/ 1000000;
    return 'Rp$million Jt';
  }

  String formatOdometer(int odometer) {
    return '$odometer km';
  }

  void toggleFavorite(String vehicleId) {
    setState(() {
      if (favoriteVehicleIds.contains(vehicleId)) {
        favoriteVehicleIds.remove(vehicleId);
      } else {
        favoriteVehicleIds.add(vehicleId);
      }
    });
  }

  List<int?> get visiblePages {
    if (totalPages <= 5) {
      return List.generate(totalPages, (index) => index + 1);
    }

    if (currentPage <= 3) {
      return [1, 2, 3, 4, null, totalPages];
    }

    if (currentPage >= totalPages - 2) {
      return [
        1,
        null,
        totalPages - 3,
        totalPages - 2,
        totalPages - 1,
        totalPages,
      ];
    }

    return [
      1,
      null,
      currentPage - 1,
      currentPage,
      currentPage + 1,
      null,
      totalPages,
    ];
  }
  
  Widget pageButton({
    required String label,
    required VoidCallback onTap,
    bool selected = false,
    bool disabled = false,
    bool wide = false,
  }) {
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: wide ? 110 : 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? gold
              : disabled
                  ? const Color(0xFF20242C)
                  : buttonColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected
                ? const Color(0xFF171A20)
                : disabled
                    ? Colors.white38
                    : Colors.white,
            fontSize: 12,
            fontWeight:
                selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget buildPagination() {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 8,
      children: [
        pageButton(
          label: '‹ Sebelumnya',
          wide: true,
          disabled: currentPage == 1,
          onTap: () {
            setState(() => currentPage--);
          },
        ),

        for (final page in visiblePages)
          if (page == null)
            const SizedBox(
              width: 20,
              height: 36,
              child: Center(
                child: Text(
                  '...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            pageButton(
              label: '$page',
              selected: currentPage == page,
              onTap: () {
                setState(() => currentPage = page);
              },
            ),

        pageButton(
          label: 'Berikutnya ›',
          wide: true,
          disabled: currentPage == totalPages,
          onTap: () {
            setState(() => currentPage++);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vehicles.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: const Color(0xFF191D24),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.search_off,
              color: Colors.white38,
              size: 48,
            ),
            SizedBox(height: 12),
            Text(
              'Mobil Tidak Ditemukan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Coba ubah kata kunci atau filter pencarian.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final int columns =
                constraints.maxWidth >= 1000
                    ? 3
                    : constraints.maxWidth >= 650
                        ? 2
                        : 1;

            final double itemWidth =
                (constraints.maxWidth - (columns - 1) * 18) /
                    columns;

            final double itemHeight =
                (itemWidth * 10 / 16) + 260;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paginatedVehicles.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                mainAxisExtent: itemHeight,
              ),
              itemBuilder: (context, index) {
                final vehicle = paginatedVehicles[index];

                return VehicleCollectionCard(
                  vehicle: vehicle,
                  isFavorite:
                      favoriteVehicleIds.contains(vehicle.id),
                  onFavoriteTap: () {
                    toggleFavorite(vehicle.id);
                  },
                  onDetailTap: () {
                    debugPrint(
                      'Detail kendaraan: ${vehicle.id}',
                    );
                  },
                );
              },
            );
          },
        ),

        const SizedBox(height: 32),

        buildPagination(),
      ],
    );
  }
}
