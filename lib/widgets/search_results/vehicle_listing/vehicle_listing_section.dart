import 'package:flutter/material.dart';

import 'vehicle_card_item.dart';
import '../../../utils/currency_formatter.dart';
import '../../../models/vehicle_model.dart';

class VehicleListingSection extends StatelessWidget {
  const VehicleListingSection({
    super.key,
    required this.vehicles,
  });

  final List<VehicleModel> vehicles;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        final columns = screenWidth >= 1100
            ? 3
            : screenWidth >= 700
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vehicles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: 1.05,
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
            );
          },
        );
      },
    );
  }
}