
import 'package:flutter/material.dart';

class HomeStatsCard extends StatelessWidget {
  const HomeStatsCard({super.key});

  static const Color gold = Color(0xFFC9A45C);

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'value': '1.200+',
        'label': 'Kendaraan Tersedia',
        'icon': Icons.directions_car_outlined,
      },
      {
        'value': '850+',
        'label': 'Transaksi Berhasil',
        'icon': Icons.verified_outlined,
      },
      {
        'value': '500+',
        'label': 'Pengguna Terdaftar',
        'icon': Icons.people_outline,
      },
      {
        'value': '98%',
        'label': 'Kepuasan Pengguna',
        'icon': Icons.star_outline,
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 25,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF191D24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return Wrap(
            alignment: WrapAlignment.spaceAround,
            runSpacing: 25,
            spacing: 20,
            children: stats.map((stat) {
              return SizedBox(
                width: isMobile
                    ? constraints.maxWidth / 2 - 20
                    : 200,
                child: Row(
                  children: [
                    Icon(
                      stat['icon'] as IconData,
                      color: gold,
                      size: 30,
                    ),
                    const SizedBox(width: 13),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stat['value'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            stat['label'] as String,
                            style: const TextStyle(
                              color: Color(0xFFA0A0A0),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
