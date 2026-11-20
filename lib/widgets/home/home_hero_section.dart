import 'package:flutter/material.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  static const Color gold = Color(0xFFD8B45F);
  static const Color textWhite = Color(0xFFE5E7EF);
  static const Color textMuted = Color(0xFFC0C1C5);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 36,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF202020),
            Color(0xFF15191F),
            Color(0xFF0B0F15),
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF292D35),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  '● MARKETPLACE KENDARAAN TERKURASI • INDONESIA',
                  style: TextStyle(
                    color: gold,
                    fontSize: 9,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Judul utama
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Temukan Kendaraan\n'
                          'yang Tepat untuk\n',
                      style: TextStyle(
                        color: textWhite,
                        fontSize: 43,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.5,
                      ),
                    ),
                    TextSpan(
                      text: 'Perjalananmu.',
                      style: TextStyle(
                        color: gold,
                        fontSize: 43,
                        height: 1.2,
                        fontFamily: 'Georgia',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 17),

              // Deskripsi
              const Text(
                'Jelajahi pilihan mobil dan motor bekas dengan informasi '
                'kendaraan yang jelas dan lengkap. Transparansi inspeksi '
                '175-titik, riwayat servis terverifikasi, dan transaksi '
                'bergansi resmi.',
                style: TextStyle(
                  color: textMuted,
                  fontSize: 13,
                  height: 1.7,
                  letterSpacing: 0.1,
                ),
              ),

              const SizedBox(height: 22),

              // Tombol
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward, size: 17),
                label: const Text('Jelajahi Kendaraan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: const Color(0xFF282116),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 19,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          );

          // Tampilan desktop
          if (!isMobile) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 7,
                  child: content,
                ),
                const SizedBox(width: 35),
                const Expanded(
                  flex: 3,
                  child: _HeroStats(),
                ),
              ],
            );
          }

          // Tampilan mobile
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              content,
              const SizedBox(height: 30),
              const _HeroStats(),
            ],
          );
        },
      ),
    );
  }
}

class _HeroStats extends StatelessWidget {
  const _HeroStats();

  static const Color gold = Color(0xFFD8B45F);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF191D24),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STANDAR KURASI KAMI',
                style: TextStyle(
                  color: Color(0xFFB6B0A5),
                  fontSize: 9,
                  letterSpacing: 1.7,
                ),
              ),
              Icon(
                Icons.verified_user_outlined,
                color: gold,
                size: 15,
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Row(
            children: [
              Expanded(
                child: _StatItem(
                  value: '2.090+',
                  label: 'Unit Lulus Uji Kelayakan',
                ),
              ),
              Expanded(
                child: _StatItem(
                  value: '100%',
                  label: 'Bebas Banjir & Tabrakan',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFD8B45F),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFD0D0D0),
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
