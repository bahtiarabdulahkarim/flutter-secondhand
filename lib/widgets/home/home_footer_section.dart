import 'package:flutter/material.dart';

class HomeFooterSection extends StatelessWidget {
  final bool showBanner;

  const HomeFooterSection({
    super.key,
    this.showBanner = true,
  });

  static const Color gold = Color(0xFFD8B45F);
  static const Color panel = Color(0xFF242932);
  static const Color muted = Color(0xFFA0A5AE);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF10141B),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width < 700 ? 20 : 48,
        vertical: 32,
      ),
      child: Column(
        children: [
          if (showBanner)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF242932),
                  Color(0xFF303234),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                // BAGIAN KIRI
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label program
                      const Row(
                        children: [
                          Icon(
                            Icons.payments_outlined,
                            color: gold,
                            size: 13,
                          ),
                          SizedBox(width: 7),
                          Text(
                            'PROGRAM INSTANT CASH-OUT RESMI',
                            style: TextStyle(
                              color: gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Judul
                      const Text(
                        'Ingin Menjual Mobil atau Motor Anda dengan Harga Adil?',
                        style: TextStyle(
                          color: Color(0xFFE2E5EC),
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Deskripsi
                      const Text(
                        'Dapatkan taksiran harga instan berdasarkan data pasar terkini dan proses pembayaran aman tuntas dalam 1x24 jam melalui jaringan kurasi inspektur SECONDHAND tanpa ribet.',
                        style: TextStyle(
                          color: muted,
                          fontSize: 13,
                          height: 1.8,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Keunggulan layanan
                      const Wrap(
                        spacing: 18,
                        runSpacing: 10,
                        children: [
                          _BannerBenefit(
                            text: 'Tanpa Biaya Tersembunyi',
                          ),
                          _BannerBenefit(
                            text: 'Petugas Datang ke Lokasi',
                          ),
                          _BannerBenefit(
                            text: 'Pelunasan Seketika',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 35),

                // BAGIAN KANAN
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      // Tombol Ajukan Taksiran Gratis
                      InkWell(
                        onTap: () {
                          
                        },
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          decoration: BoxDecoration(
                            color: gold,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ajukan Taksiran Gratis',
                                style: TextStyle(
                                  color: Color(0xFF242424),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 7),
                              Icon(
                                Icons.open_in_new,
                                color: Color(0xFF242424),
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Tombol Konsultasi WhatsApp
                      InkWell(
                        onTap: () {
                          
                        },
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          decoration: BoxDecoration(
                            color: const Color(0xFF171C24),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_outlined,
                                color: gold,
                                size: 15,
                              ),
                              SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  'Konsultasi WhatsApp Concierge',
                                  style: TextStyle(
                                    color: Color(0xFFE2E5EC),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 55),

          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 700;

              final identityWidth = isMobile
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 95) * 2 / 5;

              final columnWidth = isMobile
                  ? (constraints.maxWidth - 20) / 2
                  : (constraints.maxWidth - 95) / 5;

              return Wrap(
                spacing: 20,
                runSpacing: 30,
                children: [
                  // KOLOM 1: IDENTITAS SECONDHAND
                  SizedBox(
                    width: identityWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SECONDHAND',
                          style: TextStyle(
                            color: gold,
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'DRIVE BETTER. BUY SMARTER.',
                          style: TextStyle(
                            color: muted,
                            fontSize: 9,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Platform marketplace terpercaya di Indonesia untuk jual-beli mobil dan motor bekas berkualitas tinggi dengan inspeksi menyeluruh dan transparansi penuh.',
                          style: TextStyle(
                            color: muted,
                            fontSize: 12,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 7,
                          children: [
                            Icon(
                              Icons.verified_outlined,
                              color: gold,
                              size: 15,
                            ),
                            Text(
                              'VERIFIED 175-PT CHECK GUARANTEE',
                              style: TextStyle(
                                color: gold,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // KOLOM 2: MOBIL BEKAS
                  SizedBox(
                    width: columnWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _footerTitle('MOBIL BEKAS'),
                        const SizedBox(height: 12),
                        _footerLink('Sedan'),
                        _footerLink('SUV'),
                        _footerLink('MPV'),
                        _footerLink('Hatchback'),
                        _footerLink('Mobil Listrik & Hybrid'),
                      ],
                    ),
                  ),

                  // KOLOM 3: MOTOR BEKAS
                  SizedBox(
                    width: columnWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _footerTitle('MOTOR BEKAS'),
                        const SizedBox(height: 12),
                        _footerLink('Matic Premium'),
                        _footerLink('Big Bike & Moge'),
                        _footerLink('Sport Naked'),
                        _footerLink('Trail & Dual Sport'),
                        _footerLink('Motor Klasik'),
                      ],
                    ),
                  ),

                  // KOLOM 4: LAYANAN & KONTAK
                  SizedBox(
                    width: columnWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _footerTitle('LAYANAN & KONTAK'),
                        const SizedBox(height: 12),
                        _footerLink('Jaminan Inspeksi 175 Titik'),
                        _footerLink('Simulasi Kredit'),
                        _footerLink('Cara Pembelian'),
                        _footerLink('Hubungi Kami'),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Icon(
                              Icons.chat_outlined,
                              color: muted,
                              size: 13,
                            ),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'WhatsApp Concierge (24/7)',
                                style: TextStyle(
                                  color: Color(0xFFE2E5EC),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        const Row(
                          children: [
                            Icon(
                              Icons.mail_outline,
                              color: muted,
                              size: 13,
                            ),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'support@secondhand.id',
                                style: TextStyle(
                                  color: Color(0xFFE2E5EC),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _footerTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFE2E5EC),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _footerLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          color: muted,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _BannerBenefit extends StatelessWidget {
  final String text;

  const _BannerBenefit({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check,
          color: Color(0xFFD8B45F),
          size: 12,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFFE2E5EC),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
