import 'package:flutter/material.dart';

import 'vehicle_card_item.dart';
import '../../../utils/currency_formatter.dart';
import '../../../models/vehicle_model.dart';

class VehicleListingSection extends StatelessWidget {
  const VehicleListingSection({
    super.key,
    required this.vehicles,
    this.isListView = false,
  });

  final List<VehicleModel> vehicles;
  final bool isListView;

  @override
  Widget build(BuildContext context) {
    // Cek jika hasil pencarian kosong
    if (vehicles.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 48,
          horizontal: 24,
        ),
        child: Column(
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 56,
              color: Color(0xFFA0A0A0),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kendaraan Tidak Ditemukan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coba ubah atau reset filter pencarian kamu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFA0A0A0),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        final columns = screenWidth >= 1100
            ? 3
            : screenWidth >= 700
                ? 2
                : 1;

        if (isListView) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: vehicles.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 18),
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];

              return VehicleCardItem(
                imageUrl: vehicle.imageUrl,
                title: vehicle.name,
                specs:
                    '${vehicle.year} • ${vehicle.odometer} Km • ${vehicle.transmission}',
                price: formatRupiah(vehicle.price),
                grade: vehicle.grade,
                isListView: true,
              );
            },
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vehicles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: screenWidth < 700 ? 0.95 : 1.05,
          ),
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];

            return VehicleCardItem(
              imageUrl: vehicle.imageUrl,
              title: vehicle.name,
              specs:
                  '${vehicle.year} • ${vehicle.odometer} Km • ${vehicle.transmission}',
              price: formatRupiah(vehicle.price),
              grade: vehicle.grade,
              isListView: isListView,
            );
          },
        );
      },
    );
  }
}