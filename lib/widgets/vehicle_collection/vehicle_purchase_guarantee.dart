import 'package:flutter/material.dart';

class VehiclePurchaseGuarantee extends StatelessWidget {
  const VehiclePurchaseGuarantee({super.key});

  static const Color gold = Color(0xFFC9A45C);
  static const Color cardColor = Color(0xFF191D24);

  Widget guaranteeCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF20252E),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              icon,
              color: gold,
              size: 23,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 45),
      child: Column(
        children: [
          const Text(
            'KETENANGAN MUTLAK (PEACE OF MIND)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: gold,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '4 Jaminan Pembelian Mobil di\nSECONDHAND',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFE0E3ED),
              fontSize: 25,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Kami meredefinisi standar jual beli mobil bekas di Indonesia '
              'dengan transparansi tingkat salon otomotif prestisius.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 28),

          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 18.0;

              final int columns =
                  constraints.maxWidth >= 900
                      ? 4
                      : constraints.maxWidth >= 550
                          ? 2
                          : 1;

              final double cardWidth =
                  (constraints.maxWidth -
                      (columns - 1) * spacing) /
                  columns;

              final cards = [
                guaranteeCard(
                  icon: Icons.water_drop_outlined,
                  title: 'Bebas Banjir & Tabrak Berat',
                  description:
                      'Garansi uang kembali 100% jika unit terbukti '
                      'pernah terendam banjir atau mengalami deformasi '
                      'struktural pada rangka sasis utama.',
                ),
                guaranteeCard(
                  icon: Icons.autorenew,
                  title: 'Garansi 5 Hari Uang Kembali',
                  description:
                      'Uji kendaraan di rute harian Anda. Jika tidak '
                      'cocok karena ketidaksesuaian laporan teknis, '
                      'kembalikan dalam 5 hari tanpa potongan admin.',
                ),
                guaranteeCard(
                  icon: Icons.local_shipping_outlined,
                  title: 'Doorstep Delivery Rapi',
                  description:
                      'Unit dikirim langsung ke garasi rumah Anda '
                      'menggunakan towing tertutup berkeamanan tinggi '
                      'setelah detailing salon menyeluruh.',
                ),
                guaranteeCard(
                  icon: Icons.assignment_turned_in_outlined,
                  title: 'Legalitas SAMSAT Terverifikasi',
                  description:
                      'Semua dokumen fisik (BPKB, STNK, Faktur Asli, '
                      '& Formulir A) diinspeksi keasliannya dan bebas '
                      'blokir tindak tilang elektronik (ETLE).',
                ),
              ];

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: cards.map((card) {
                  return SizedBox(
                    width: cardWidth,
                    child: card,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
