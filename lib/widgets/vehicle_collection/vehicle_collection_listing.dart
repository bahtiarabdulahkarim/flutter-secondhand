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
  final Set<String> favoriteVehicleIds = {};

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

    return LayoutBuilder(
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
          itemCount: widget.vehicles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            mainAxisExtent: itemHeight,
          ),
          itemBuilder: (context, index) {
            final vehicle = widget.vehicles[index];

            return VehicleCollectionCard(
              vehicle: vehicle,
              isFavorite: favoriteVehicleIds.contains(vehicle.id),
              onFavoriteTap: () {
                toggleFavorite(vehicle.id);
              },
              onDetailTap: () {
                debugPrint('Detail kendaraan: ${vehicle.id}');
              },
            );
          },
        );
      },
    );
  }
}