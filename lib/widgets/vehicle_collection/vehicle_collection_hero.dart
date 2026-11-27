
import 'package:flutter/material.dart';

class VehicleCollectionHero extends StatelessWidget {
  const VehicleCollectionHero({super.key});

  static const Color gold = Color(0xFFC9A45C);
  static const Color white = Color(0xFFE5E7EB);
  static const Color muted = Color(0xFFB0B3BA);
  static const Color badgeBackground = Color(0xFF252A33);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BREADCRUMB
            Row(
              children: [
                const Icon(
                  Icons.home_outlined,
                  color: white,
                  size: 12,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Beranda',
                  style: TextStyle(
                    color: white,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  '/',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'Mobil Bekas',
                  style: TextStyle(
                    color: gold,
                    fontSize: 10,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 17),

            // LABEL
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: gold,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                const Text(
                  'PASAR MOBIL BEKAS TERKURASI INDONESIA',
                  style: TextStyle(
                    color: gold,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // JUDUL
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Text(
                'Eksplorasi Koleksi Mobil '
                'Impian dengan Ketenangan Mutlak.',
                style: TextStyle(
                  color: white,
                  fontSize: isMobile ? 30 : 38,
                  fontWeight: FontWeight.bold,
                  height: 1.18,
                  letterSpacing: -0.8,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // DESKRIPSI
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: const Text(
                '1.120+ unit mobil bekas tersertifikasi bebas banjir, '
                'bebas tabrakan berat, dan lulus uji inspeksi 175 '
                'titik menyeluruh oleh teknisi bersertifikasi nasional.',
                style: TextStyle(
                  color: muted,
                  fontSize: 11,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 17),

            // BADGE KEUNGGULAN
            Wrap(
              spacing: 10,
              runSpacing: 9,
              children: const [
                _HeroBadge(
                  icon: Icons.verified,
                  label: '1.120+ Mobil Lulus Uji',
                ),
                _HeroBadge(
                  icon: Icons.shield_outlined,
                  label: 'Garansi 5 Tahun Mesin & Transmisi',
                ),
                _HeroBadge(
                  icon: Icons.verified_user_outlined,
                  label: '100% Lolos Odometer & Rangka Asli',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroBadge({
    required this.icon,
    required this.label,
  });

  static const Color gold = Color(0xFFC9A45C);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF252A33),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: gold,
            size: 12,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
