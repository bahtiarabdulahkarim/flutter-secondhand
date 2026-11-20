
import 'package:flutter/material.dart';

class FeaturedVehicleGridSection extends StatefulWidget {
  const FeaturedVehicleGridSection({super.key});

  @override
  State<FeaturedVehicleGridSection> createState() =>
      _FeaturedVehicleGridSectionState();
}

class _FeaturedVehicleGridSectionState
    extends State<FeaturedVehicleGridSection> {
  static const Color gold = Color(0xFFD8B45F);
  static const Color muted = Color(0xFFA0A5AE);

  String activeTab = 'Semua';


  final List<Map<String, String>> vehicles = [
    {
      'category': 'Mobil',
      'badge': 'LULUS INSPEKSI 175 TITIK',
      'title': 'Honda CR-V 1.5 Prestige Turbo',
      'location': 'Jakarta Selatan',
      'status': 'Servis Bengkel Resmi',
      'year': '2022',
      'mileage': '28.500 km',
      'transmission': 'Otomatis (CVT)',
      'price': '465.000.000',
      'installment': '7,8 jt/bln',
      'image': 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=900&q=85',
    },
    {
      'category': 'Motor',
      'badge': 'KILOMETER SANGAT RENDAH',
      'title': 'Vespa GTS 300 Super Sport HPE',
      'location': 'Jakarta Barat',
      'status': 'Pajak Hidup Panjang',
      'year': '2023',
      'mileage': '4.200 km',
      'transmission': 'Otomatis CVT',
      'price': '148.000.000',
      'installment': '3,2 jt/bln',
      'image': 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=900&q=85',
    },
    {
      'category': 'Mobil',
      'badge': 'TANGAN PERTAMA DARI BARU',
      'title': 'Toyota Fortuner 2.8 GR Sport 4x2',
      'location': 'Tangerang Kota',
      'status': 'Bebas Cat Ulang',
      'year': '2023',
      'mileage': '19.000 km',
      'transmission': 'Otomatis 6-Speed',
      'price': '585.000.000',
      'installment': '9,9 jt/bln',
      'image': 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=900&q=85',
    },
    {
      'category': 'Motor',
      'badge': 'SERVIS RUTIN BENGKEL RESMI',
      'title': 'Kawasaki Ninja Sport',
      'location': 'Surabaya',
      'status': 'Riwayat Servis Lengkap',
      'year': '2022',
      'mileage': '8.500 km',
      'transmission': 'Manual',
      'price': '125.000.000',
      'installment': '2,8 jt/bln',
      'image': 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=900&q=85',
    },
    {
      'category': 'Mobil',
      'badge': 'GARANSI RESMI AKTIF',
      'title': 'BMW 320i Sport',
      'location': 'Jakarta Selatan',
      'status': 'Bebas Kecelakaan',
      'year': '2022',
      'mileage': '15.000 km',
      'transmission': 'Otomatis',
      'price': '720.000.000',
      'installment': '12 jt/bln',
      'image': 'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=900&q=85',
    },
    {
      'category': 'Motor',
      'badge': 'AKSESORIS FULL ORIGINAL',
      'title': 'BMW R 1250 GS Adventure',
      'location': 'Tangerang',
      'status': 'Kondisi Terawat',
      'year': '2023',
      'mileage': '6.700 km',
      'transmission': 'Manual',
      'price': '650.000.000',
      'installment': '11 jt/bln',
      'image': 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=900&q=85',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER SECTION
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;

            final header = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'INSPEKSI TERAKREDITASI',
                  style: TextStyle(
                    color: gold,
                    fontSize: 9,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Kendaraan Pilihan Unggulan',
                  style: TextStyle(
                    color: Color(0xFFE1E3EB),
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Unit kurasi teratas minggu ini dengan riwayat paling bersih dan kondisi siap pakai langsung.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 11,
                  ),
                ),
              ],
            );

            final tabs = Wrap(
              spacing: 4,
              children: [
                _tabButton('Semua', '6'),
                _tabButton('Mobil Unggulan', '3'),
                _tabButton('Motor Unggulan', '3'),
              ],
            );

            if (isMobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header,
                  const SizedBox(height: 18),
                  tabs,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: header),
                const SizedBox(width: 15),
                tabs,
              ],
            );
          },
        ),
        const SizedBox(height: 22),

        LayoutBuilder(
          builder: (context, constraints) {
            final int columns =
                constraints.maxWidth < 600
                    ? 1
                    : constraints.maxWidth < 900
                        ? 2
                        : 3;

            final filteredVehicles = vehicles.where((vehicle) {
              if (activeTab == 'Mobil Unggulan') {
                return vehicle['category'] == 'Mobil';
              }

              if (activeTab == 'Motor Unggulan') {
                return vehicle['category'] == 'Motor';
              }

              return true;
            }).toList();

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredVehicles.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                return _vehicleCard(filteredVehicles[index]);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _tabButton(String title, String count) {
    final isActive = activeTab == title;

    return InkWell(
      onTap: () {
        setState(() {
          activeTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF242932)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: isActive
                ? const Color(0xFF303640)
                : Colors.transparent,
          ),
        ),
        child: Text(
          '$title ($count)',
          style: TextStyle(
            color: isActive ? gold : const Color(0xFFD1D3DA),
            fontSize: 11,
            fontWeight:
                isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
  
  Widget _vehicleCard(Map<String, String> vehicle) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF191D24),
        borderRadius: BorderRadius.circular(7),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FOTO KENDARAAN
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.55,
                child: Image.network(
                  vehicle['image']!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF242932),
                      child: const Icon(
                        Icons.directions_car,
                        color: gold,
                        size: 45,
                      ),
                    );
                  },
                ),
              ),

              // LABEL INSPEKSI
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  color: const Color(0xDD10151D),
                  child: Text(
                    vehicle['badge']!,
                    style: const TextStyle(
                      color: gold,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // TOMBOL FAVORIT
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xDD10151D),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 17,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 34,
                      minHeight: 34,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),

          // INFORMASI KENDARAAN
          Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle['category']} • ${vehicle['title']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFE1E3EB),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: muted,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        vehicle['location']!,
                        style: const TextStyle(
                          color: muted,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    Text(
                      '• ${vehicle['status']}',
                      style: const TextStyle(
                        color: gold,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // SPESIFIKASI
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 5,
                  ),
                  color: const Color(0xFF20252E),
                  child: Row(
                    children: [
                      _specification('TAHUN', vehicle['year']!),
                      _specification('JARAK TEMPUH', vehicle['mileage']!),
                      _specification('TRANSMISI', vehicle['transmission']!),
                    ],
                  ),
                ),

                const SizedBox(height: 17),

                // HARGA
                const Text(
                  'HARGA TUNAI',
                  style: TextStyle(
                    color: muted,
                    fontSize: 8,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Rp ${vehicle['price']}',
                  style: const TextStyle(
                    color: gold,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // ESTIMASI ANGSURAN
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'ESTIMASI ANGSURAN',
                        style: TextStyle(
                          color: muted,
                          fontSize: 8,
                        ),
                      ),
                    ),
                    Text(
                      'Rp ${vehicle['installment']}',
                      style: const TextStyle(
                        color: Color(0xFFE1E3EB),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // TOMBOL DETAIL
                SizedBox(
                  width: double.infinity,
                  height: 37,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF292E38),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lihat Detail Inspeksi',
                          style: TextStyle(fontSize: 10),
                        ),
                        SizedBox(width: 7),
                        Icon(Icons.chevron_right, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _specification(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: muted,
              fontSize: 7,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFE1E3EB),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}