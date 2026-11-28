import 'package:flutter/material.dart';

class MotorcycleCategory extends StatelessWidget {
  const MotorcycleCategory({super.key});

  static const Color gold = Color(0xFFD8B45F);
  static const Color muted = Color(0xFFA0A5AE);

  static const List<Map<String, dynamic>> categories = [
    {
      'title': 'Maxi & Matic',
      'description': 'Kenyamanan Harian & Touring Lincah',
      'icon': Icons.electric_moped_outlined,
      'count': '01',
    },
    {
      'title': 'Big Bike & Moge',
      'description': 'Performa Tinggi di Atas 500cc',
      'icon': Icons.motorcycle,
      'count': '02',
    },
    {
      'title': 'Sport Fairing',
      'description': 'Aerodinamis & Adrenalin Sirkuit',
      'icon': Icons.speed,
      'count': '03',
    },
    {
      'title': 'Naked & Neo-Retro',
      'description': 'Gaya Ikonik & Posisi Tegak',
      'icon': Icons.two_wheeler,
      'count': '04',
    },
    {
      'title': 'Trail & Adventure',
      'description': 'Siap Libas Segala Medan & Aspal',
      'icon': Icons.terrain,
      'count': '05',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final crossAxisCount = width >= 1000
            ? 5
            : width >= 650
                ? 3
                : width >= 400
                    ? 2
                    : 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'KLASIFIKASI KENDARAAN',
              style: TextStyle(
                color: gold,
                fontSize: 9,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih Sesuai Karakter Berkendara Anda',
              style: TextStyle(
                color: Color(0xFFE1E3EB),
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 17),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 165,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];

                return _categoryCard(
                  title: category['title'] as String,
                  description: category['description'] as String,
                  icon: category['icon'] as IconData,
                  count: category['count'] as String,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _categoryCard({
    required String title,
    required String description,
    required IconData icon,
    required String count,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2028),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: const Color(0xFF303640),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  icon,
                  color: gold,
                  size: 21,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1118),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  count,
                  style: const TextStyle(
                    color: Color(0xFFE1E3EB),
                    fontSize: 9,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFE1E3EB),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: muted,
              fontSize: 10,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}