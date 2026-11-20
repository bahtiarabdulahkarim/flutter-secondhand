import 'package:flutter/material.dart';

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  static const Color gold = Color(0xFFD8B45F);
  static const Color panel = Color(0xFF181D25);
  static const Color muted = Color(0xFFA0A5AE);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF10141B),
      padding: const EdgeInsets.symmetric(
        horizontal: 38,
        vertical: 65,
      ),
      child: Column(
        children: [
          // Label kecil
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

          // Judul utama
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

          // Deskripsi
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const Text(
              'Standar baru jual beli kendaraan bekas di Indonesia dengan transparansi menyeluruh, kelayakan mekanis tanpa kompromi, dan ketenangan pikiran jangka panjang.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: muted,
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 45),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KARTU 1
                    Expanded(
                      child: Container(
                        height: 300,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: panel,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: gold.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.directions_car_outlined,
                                color: gold,
                                size: 24,
                              ),
                            ),

                            const SizedBox(height: 22),

                            const Text(
                              'Pilihan Kendaraan Beragam',
                              style: TextStyle(
                                color: Color(0xFFE2E5EC),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              'Dari city car yang lincah hingga SUV premium, temukan kendaraan yang sesuai dengan gaya hidup dan kebutuhan Anda.',
                              style: TextStyle(
                                color: muted,
                                fontSize: 12,
                                height: 1.7,
                              ),
                            ),

                            const Spacer(),

                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: CustomPaint(
                                painter: VehicleGraphPainter(gold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),

                    // KARTU 2
                    Expanded(
                      child: Container(
                        height: 300,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: panel,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: gold.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.verified_outlined,
                                color: gold,
                                size: 24,
                              ),
                            ),

                            const SizedBox(height: 22),

                            const Text(
                              'Informasi Kendaraan Lengkap',
                              style: TextStyle(
                                color: Color(0xFFE2E5EC),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              'Laporan uji kompresi, ketebalan cat, kesehatan aki, kelistrikan, serta keabsahan dokumen hukum BPKB dan STNK tersimpan digital tanpa ada fakta tersembunyi.',
                              style: TextStyle(
                                color: muted,
                                fontSize: 12,
                                height: 1.7,
                              ),
                            ),
                            const Spacer(),

                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Text(
                                  '175 / 175 Poin',
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
                                valueColor: AlwaysStoppedAnimation<Color>(gold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),

                    // KARTU 3
                    Expanded(
                      child: Container(
                        height: 300,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: panel,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: gold.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.speed,
                                color: gold,
                                size: 24,
                              ),
                            ),

                            const SizedBox(height: 22),

                            const Text(
                              'Pengalaman Pencarian Mudah',
                              style: TextStyle(
                                color: Color(0xFFE2E5EC),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              'Sistem pencarian intuitif dengan komparasi spesifikasi langsung, kalkulator simulasi kredit terintegrasi dari mitra perbankan terpercaya, dan opsi test drive langsung ke rumah.',
                              style: TextStyle(
                                color: muted,
                                fontSize: 12,
                                height: 1.7,
                              ),
                            ),
                            const Spacer(),

                            const Row(
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ),
          ),    
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

    // Lengkungan pertama: naik perlahan
    path.cubicTo(
      size.width * 0.18,
      size.height * 0.45,
      size.width * 0.32,
      size.height * 0.42,
      size.width * 0.43,
      size.height * 0.58,
    );

    // Lengkungan kedua: turun sedikit lalu naik
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

    // Dua titik bulat
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
