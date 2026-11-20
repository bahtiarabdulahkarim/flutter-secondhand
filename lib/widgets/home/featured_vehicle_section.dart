
import 'package:flutter/material.dart';
import 'vehicle_card.dart';

class FeaturedVehicleSection extends StatelessWidget {
  const FeaturedVehicleSection({super.key});

  final List<Map<String, String>> vehicles = const [
    {
      'title': 'BMW M3 Competition 2022',
      'specs': '9.400 KM • Twin-Turbo 503 HP • Garansi Resmi Aktif',
      'price': 'Rp 2,15 M',
      'installment': 'Cicilan Rp 34,5 jt/bln',
      'category': 'Sorotan Mobil Minggu Ini',
      'badge': 'INSPEKSI 100% LULUS',
      'imageUrl':
          'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=900&q=85',
    },
    {
      'title': 'Ducati Panigale V4 S 2023',
      'specs': '2.100 KM • Akrapovic Full Exhaust • Tangan Pertama',
      'price': 'Rp 890 Jt',
      'installment': 'Cicilan Rp 15,2 jt/bln',
      'category': 'Sorotan Motor Minggu Ini',
      'badge': 'INSPEKSI 100% LULUS',
      'imageUrl':
          'https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=900&q=85',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Marketplace Mobil & Motor Bekas',
          style: TextStyle(
            color: Color(0xFFA0A0A0),
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),

        const SizedBox(height: 12),

        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 650;
            final columns = isMobile ? 1 : 2;
            const spacing = 20.0;

            final cardWidth = isMobile
                ? constraints.maxWidth
                : (constraints.maxWidth - spacing) / 2;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: vehicles.map((vehicle) {
                return SizedBox(
                  width: cardWidth,
                  child: VehicleCard(
                    title: vehicle['title']!,
                    specs: vehicle['specs']!,
                    price: vehicle['price']!,
                    installment: vehicle['installment']!,
                    imageUrl: vehicle['imageUrl']!,
                    category: vehicle['category']!,
                    badgeText: vehicle['badge']!,
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