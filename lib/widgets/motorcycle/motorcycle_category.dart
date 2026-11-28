import 'package:flutter/material.dart';

class MotorcycleCategory extends StatelessWidget {
  const MotorcycleCategory({super.key});

  static const Color gold = Color(0xFFD8B45F);
  static const Color muted = Color(0xFFA0A5AE);

  static const List<Map<String, dynamic>> categories = [
    {
      'title': 'Maxi & Matic',
      'description': 'Motor matic premium untuk kenyamanan harian dan perjalanan jauh.',
      'icon': Icons.electric_moped_outlined,
      'count': '01',
    },
    {
      'title': 'Big Bike & Moge',
      'description': 'Pilihan motor berkapasitas besar dengan performa istimewa.',
      'icon': Icons.motorcycle,
      'count': '02',
    },
    {
      'title': 'Sport Fairing',
      'description': 'Motor sport dengan desain aerodinamis dan karakter agresif.',
      'icon': Icons.speed,
      'count': '03',
    },
    {
      'title': 'Naked & Neo-Retro',
      'description': 'Perpaduan gaya klasik dan modern untuk karakter berbeda.',
      'icon': Icons.two_wheeler,
      'count': '04',
    },
    {
      'title': 'Trail & Adventure',
      'description': 'Motor tangguh untuk berbagai medan perjalanan.',
      'icon': Icons.terrain,
      'count': '05',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final crossAxisCount = width >= 1100
            ? 5
            : width >= 700
                ? 3
                : width >= 450
                    ? 2
                    : 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'KLASIFIKASI MOTOR',
              style: TextStyle(
                color: gold,
                fontSize: 9,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Jelajahi Kategori Motor',
              style: TextStyle(
                color: Color(0xFFE1E3EB),
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Temukan motor pilihan berdasarkan gaya berkendara dan kebutuhan perjalanan Anda.',
              style: TextStyle(
                color: muted,
                fontSize: 11,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 22),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 170,
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
        color: const Color(0xFF191D24),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: gold, size: 25),
              Text(
                count,
                style: const TextStyle(
                  color: Color(0xFF555D69),
                  fontSize: 11,
                  letterSpacing: 1,
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
          const SizedBox(height: 6),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: muted,
              fontSize: 9,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}