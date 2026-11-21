import 'package:flutter/material.dart';

class SearchResultsHeader extends StatelessWidget {
  const SearchResultsHeader({
    super.key,
    this.keyword = 'Honda',
    this.totalVehicles = 18,
    this.totalCars = 11,
    this.totalMotors = 7,
  });

  final String keyword;
  final int totalVehicles;
  final int totalCars;
  final int totalMotors;

  static const Color goldColor = Color(0xFFC9A45C);
  static const Color textWhite = Colors.white;
  static const Color textMuted = Color(0xFFA0A0A0);
  static const Color panelColor = Color(0xFF191D24);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          children: [
            const Icon(
              Icons.home_outlined,
              color: textMuted,
              size: 13,
            ),
            const Text(
              'Beranda',
              style: TextStyle(color: textMuted, fontSize: 11),
            ),
            const Text('/', style: TextStyle(color: textMuted)),
            const Text(
              'Pencarian Kendaraan',
              style: TextStyle(color: textMuted, fontSize: 11),
            ),
            const Text('/', style: TextStyle(color: textMuted)),
            Text(
              'Merek: $keyword',
              style: const TextStyle(
                color: goldColor,
                fontSize: 11,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Judul dan informasi layanan
        Wrap(
          spacing: 24,
          runSpacing: 20,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Informasi hasil pencarian
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: panelColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '● KURASI ATELIER OTOMOTIF JEPANG',
                    style: TextStyle(
                      color: goldColor,
                      fontSize: 9,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Hasil Pencarian: ',
                        style: TextStyle(color: textWhite),
                      ),
                      TextSpan(
                        text: keyword,
                        style: const TextStyle(color: goldColor),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Ditemukan $totalVehicles Unit Terverifikasi '
                  '($totalCars Mobil, $totalMotors Motor) — '
                  'Siap Test Drive Langsung di Rumah & Pengiriman Khusus.',
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            // Informasi layanan
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                _ServiceBadge(
                  icon: Icons.verified,
                  title: 'GARANSI RESMI',
                  subtitle: '175-Point Check',
                ),
                _ServiceBadge(
                  icon: Icons.support_agent,
                  title: 'LAYANAN',
                  subtitle: 'Doorstep Trial',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _ServiceBadge extends StatelessWidget {
  const _ServiceBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  static const Color goldColor = Color(0xFFC9A45C);
  static const Color textWhite = Colors.white;
  static const Color textMuted = Color(0xFFA0A0A0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF191D24),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: goldColor, size: 19),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textMuted,
                  fontSize: 9,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: textWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
