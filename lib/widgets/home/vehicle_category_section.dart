
import 'package:flutter/material.dart';

class VehicleCategorySection extends StatelessWidget {
  const VehicleCategorySection({super.key});

  static const Color gold = Color(0xFFD8B45F);
  static const Color muted = Color(0xFFA0A5AE);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            if (isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerTitle(),
                  const SizedBox(height: 16),
                  _warehouseInfo(),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _headerTitle()),
                  _warehouseInfo(),
                ],
              ),
            const SizedBox(height: 25),

            // KARTU KATEGORI KENDARAAN
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 700;

                final mobil = _vehicleCard(
                  title: 'Koleksi Mobil Bekas',
                  image:
                      'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=1000&q=85',
                  unit: '1.240+ UNIT READY',
                  description:
                      'Mulai dari city car lincah, MPV keluarga terawat, hingga SUV tangguh dan sedan eksekutif siap pakai. Seluruh unit terbebas dari manipulasi odometer dan banjir.',
                  advantages: [
                    'Garansi Mesin & Transmisi 1 Tahun',
                    'Dokumen BPKB Asli',
                  ],
                  categories: [
                    'SUV Premium',
                    'MPV Keluarga',
                    'Sedan Eksekutif',
                    'Hatchback Kota',
                    'Listrik & Hybrid',
                  ],
                  icon: Icons.directions_car_filled_outlined,
                  buttonText: 'Lihat Semua Mobil Bekas',
                );

                final motor = _vehicleCard(
                  title: 'Koleksi Motor Bekas',
                  image:
                      'https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=1000&q=85',
                  unit: '850+ UNIT READY',
                  description:
                      'Pilihan matic premium harian, naked bike bertenaga, adventure tourer, hingga moge sport terverifikasi. Seluruh rangka, mesin, dan kelistrikan diuji presisi.',
                  advantages: [
                    'Bebas Oplosan & Rangka Presisi',
                    'Pajak Hidup & STNK Sah',
                  ],
                  categories: [
                    'Maxi Matic',
                    'Sport & Naked',
                    'Moge & Big Bike',
                    'Retro & Klasik Modern',
                    'Trail & Adventure',
                  ],
                  icon: Icons.two_wheeler,
                  buttonText: 'Lihat Semua Motor Bekas',
                );

                if (isMobile) {
                  return Column(
                    children: [
                      mobil,
                      const SizedBox(height: 18),
                      motor,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: mobil),
                    const SizedBox(width: 18),
                    Expanded(child: motor),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _headerTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KLASIFIKASI PASAR',
          style: TextStyle(
            color: gold,
            fontSize: 9,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Kategori Kendaraan',
          style: TextStyle(
            color: Color(0xFFE1E3EB),
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Pilih jenis kendaraan sesuai kebutuhan mobilitas harian dan ekspresi gaya hidup Anda.',
          style: TextStyle(
            color: muted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _warehouseInfo() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 9,
      children: [
        const Text(
          'DISTRIBUSI GUDANG',
          style: TextStyle(
            color: muted,
            fontSize: 8,
            letterSpacing: 1.5,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 6,
          ),
          color: const Color(0xFF242932),
          child: const Text(
            'Jakarta • Tangerang • Surabaya',
            style: TextStyle(
              color: gold,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }


  Widget _vehicleCard({
    required String title,
    required String image,
    required String unit,
    required String description,
    required List<String> advantages,
    required List<String> categories,
    required IconData icon,
    required String buttonText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF191D24),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.85,
                child: Image.network(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF242932),
                      child: Icon(icon, color: gold, size: 50),
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  color: const Color(0xFF10151D),
                  child: Text(
                    unit,
                    style: const TextStyle(
                      color: gold,
                      fontSize: 9,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFE1E3EB),
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(icon, color: gold, size: 19),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            description,
            style: const TextStyle(
              color: muted,
              fontSize: 11,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 7,
            children: advantages.map((item) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    color: gold,
                    size: 12,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    item,
                    style: const TextStyle(
                      color: gold,
                      fontSize: 9,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 5,
            runSpacing: 6,
            children: categories.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                color: const Color(0xFF242932),
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Color(0xFFD1D3DA),
                    fontSize: 9,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF242932),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: gold,
                    size: 19,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}