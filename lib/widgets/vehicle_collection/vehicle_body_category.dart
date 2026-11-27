import 'package:flutter/material.dart';

class VehicleBodyCategory extends StatefulWidget {
  const VehicleBodyCategory({
    super.key,
    this.onCategorySelected,
  });

  final ValueChanged<String>? onCategorySelected;

  @override
  State<VehicleBodyCategory> createState() =>
      _VehicleBodyCategoryState();
}

class _VehicleBodyCategoryState extends State<VehicleBodyCategory> {
  static const Color gold = Color(0xFFC9A45C);
  static const Color cardColor = Color(0xFF191D24);

  String selectedCategory = 'Semua';

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'SUV & Crossover',
      'icon': Icons.directions_car_filled_outlined,
    },
    {
      'name': 'MPV Keluarga',
      'icon': Icons.airport_shuttle_outlined,
    },
    {
      'name': 'Sedan Eksekutif',
      'icon': Icons.directions_car_outlined,
    },
    {
      'name': 'Hatchback & City Car',
      'icon': Icons.directions_car,
    },
    {
      'name': 'EV & Hybrid',
      'icon': Icons.electric_car_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Berdasarkan Tipe Bodi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Temukan kendaraan sesuai kebutuhan dan gaya berkendara Anda.',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 22),

        LayoutBuilder(
          builder: (context, constraints) {
            final int columns =
                constraints.maxWidth >= 900 ? 5 : 2;

            final double itemWidth =
                (constraints.maxWidth - (columns - 1) * 12) /
                    columns;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: categories.map((category) {
                final String name = category['name'];
                final bool isSelected =
                    selectedCategory == name;

                return SizedBox(
                  width: itemWidth,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      setState(() {
                        selectedCategory =
                            isSelected ? 'Semua' : name;
                      });

                      widget.onCategorySelected?.call(
                        selectedCategory,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        vertical: 22,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF332B1E)
                            : cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? gold
                              : Colors.white10,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            category['icon'],
                            color: gold,
                            size: 30,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected
                                  ? gold
                                  : Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
