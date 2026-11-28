import 'package:flutter/material.dart';

class MotorcycleHero extends StatelessWidget {
  const MotorcycleHero({super.key});

  static const Color gold = Color(0xFFC9A45C);
  static const Color white = Color(0xFFE5E7EB);
  static const Color muted = Color(0xFFB0B3BA);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BREADCRUMB
            Row(
              children: const [
                Icon(Icons.home_outlined, color: white, size: 12),
                SizedBox(width: 6),
                Text(
                  'Beranda',
                  style: TextStyle(color: white, fontSize: 10),
                ),
                SizedBox(width: 5),
                Text('/', style: TextStyle(color: Colors.white38)),
                SizedBox(width: 5),
                Text(
                  'Motor Bekas',
                  style: TextStyle(color: gold, fontSize: 10),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // HERO CONTENT
            if (isMobile)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroContent(),
                  SizedBox(height: 25),
                  _HeroStats(),
                ],
              )
            else
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 6, child: _HeroContent()),
                  SizedBox(width: 35),
                  Expanded(flex: 4, child: _HeroStats()),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: MotorcycleHero.gold,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            const Text(
              'PASAR MOTOR BEKAS TERKURASI INDONESIA',
              style: TextStyle(
                color: MotorcycleHero.gold,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        const Text(
          'Temukan Motor Impian '
          'dengan Kualitas Terjamin.',
          style: TextStyle(
            color: MotorcycleHero.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1.18,
            letterSpacing: -0.8,
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'Jelajahi koleksi motor bekas pilihan dari berbagai merek '
          'dan kategori. Setiap unit melewati proses pemeriksaan '
          'untuk memberikan pengalaman berkendara yang lebih tenang.',
          style: TextStyle(
            color: MotorcycleHero.muted,
            fontSize: 12,
            height: 1.8,
          ),
        ),

        const SizedBox(height: 20),

        const Wrap(
          spacing: 10,
          runSpacing: 9,
          children: [
            _HeroBadge(
              icon: Icons.verified,
              label: 'Unit Terkurasi',
            ),
            _HeroBadge(
              icon: Icons.shield_outlined,
              label: 'Garansi Pembelian',
            ),
            _HeroBadge(
              icon: Icons.verified_user_outlined,
              label: 'Dokumen Terverifikasi',
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroStats extends StatelessWidget {
  const _HeroStats();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _StatCard(
          icon: Icons.two_wheeler,
          value: '10+',
          label: 'Motor Pilihan',
        ),
        SizedBox(height: 12),
        _StatCard(
          icon: Icons.verified_user_outlined,
          value: '100%',
          label: 'Data Unit Terverifikasi',
        ),
        SizedBox(height: 12),
        _StatCard(
          icon: Icons.support_agent,
          value: '24/7',
          label: 'Layanan Konsultasi',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF191D24),
        border: Border.all(color: const Color(0xFF303640)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: MotorcycleHero.gold, size: 25),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: MotorcycleHero.gold,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: MotorcycleHero.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF252A33),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified,
            color: MotorcycleHero.gold,
            size: 12,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}