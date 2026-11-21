import 'package:flutter/material.dart';
import 'vehicle_card_item.dart';

class VehicleListingSection extends StatelessWidget {
  const VehicleListingSection({super.key});

  static const List<Map<String, String>> vehicles = [
    {
      'imageUrl': 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=900&q=85',
      'title': '2023 Honda CR-V 1.5 Turbo',
      'specs': '2023 • 19.200 Km • CVT Otomatis',
      'price': 'Rp 485.000.000',
      'grade': 'A+',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=900&q=85',
      'title': '2022 Honda HR-V SE',
      'specs': '2022 • 24.500 Km • CVT Otomatis',
      'price': 'Rp 325.000.000',
      'grade': 'A',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=900&q=85',
      'title': '2023 Honda Civic RS Turbo',
      'specs': '2023 • 12.800 Km • CVT Otomatis',
      'price': 'Rp 535.000.000',
      'grade': 'A+',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=900&q=85',
      'title': '2022 Honda Brio RS',
      'specs': '2022 • 15.000 Km • CVT Otomatis',
      'price': 'Rp 185.000.000',
      'grade': 'A',
    },
  ];

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
              imageUrl: vehicle['imageUrl']!,
              title: vehicle['title']!,
              specs: vehicle['specs']!,
              price: vehicle['price']!,
              grade: vehicle['grade']!,
            );
          },
        );
      },
    );
  }
}
