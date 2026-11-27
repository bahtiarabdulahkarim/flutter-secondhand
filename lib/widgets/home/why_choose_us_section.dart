import 'package:flutter/material.dart';

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  static const Color gold = Color(0xFFD8B45F);
  static const Color panel = Color(0xFF181D25);
  static const Color muted = Color(0xFFA0A5AE);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 650;

        return Container(
          width: double.infinity,
          color: const Color(0xFF10141B),
          padding: EdgeInsets.symmetric(
            horizontal: mobile ? 16 : 38,
            vertical: mobile ? 40 : 65,
          ),
          child: Column(
            children: [
              const Text(
                'NILAI UTAMA KAMI',
                style: TextStyle(
                  color: gold,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Mengapa Memilih SECONDHAND',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFE2E5EC),
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 7),
              
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: Text(
                  'Standar baru jual beli kendaraan bekas di Indonesia dengan transparansi menyeluruh, kelayakan mekanis tanpa kompromi, dan ketenangan pikiran jangka panjang.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 35),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(mobile ? 14 : 25),
                decoration: BoxDecoration(
                  color: panel,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, innerConstraints) {
                    final columns = innerConstraints.maxWidth < 600
                        ? 1
                        : innerConstraints.maxWidth < 950
                            ? 2
                            : 3;

                    const spacing = 18.0;

                    final cardWidth =
                        (innerConstraints.maxWidth -
                                spacing * (columns - 1)) /
                            columns;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: _featureCard(
                            icon: Icons.directions_car_outlined,
                            title: 'Pilihan Kendaraan Beragam',
                            description:
                                'Dari city car yang lincah hingga SUV premium, temukan kendaraan yang sesuai dengan gaya hidup dan kebutuhan Anda.',
                            footer: SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: CustomPaint(
                                painter: VehicleGraphPainter(gold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _featureCard(
                            icon: Icons.verified_outlined,
                            title: 'Informasi Kendaraan Lengkap',
                            description:
                                'Laporan uji kompresi, ketebalan cat, kesehatan aki, kelistrikan, serta keabsahan dokumen hukum BPKB dan STNK tersimpan digital tanpa ada fakta tersembunyi.',
                            footer: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Indeks Transparansi Inspeksi',
                                        style: TextStyle(
                                          color: muted,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '175 / 175',
                                      style: TextStyle(
                                        color: gold,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: const LinearProgressIndicator(
                                    value: 1,
                                    minHeight: 6,
                                    backgroundColor: Color(0xFF303640),
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(gold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _featureCard(
                            icon: Icons.speed,
                            title: 'Pengalaman Pencarian Mudah',
                            description:
                                'Sistem pencarian intuitif dengan komparasi spesifikasi langsung, kalkulator simulasi kredit terintegrasi dari mitra perbankan terpercaya, dan opsi test drive langsung ke rumah.',
                            footer: const Row(
                              children: [
                                Icon(
                                  Icons.headset_mic_outlined,
                                  color: gold,
                                  size: 15,
                                ),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Didukung Personal Concierge 24/7',
                                    style: TextStyle(
                                      color: Color(0xFFE2E5EC),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _featureCard({
    required IconData icon,
    required String title,
    required String description,
    required Widget footer,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1D222B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: gold,
              size: 24,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFE2E5EC),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: muted,
              fontSize: 12,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 25),
          footer,
        ],
      ),
    );
  }
}

class VehicleGraphPainter extends CustomPainter {
  final Color color;

  VehicleGraphPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(0, size.height * 0.72);

    path.cubicTo(
      size.width * 0.18,
      size.height * 0.45,
      size.width * 0.32,
      size.height * 0.42,
      size.width * 0.43,
      size.height * 0.58,
    );

    path.cubicTo(
      size.width * 0.62,
      size.height * 0.78,
      size.width * 0.78,
      size.height * 0.55,
      size.width,
      size.height * 0.12,
    );

    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.43, size.height * 0.58),
      3,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(size.width, size.height * 0.12),
      3,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant VehicleGraphPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}