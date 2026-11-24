class Kendaraan {
  final String nama;
  final String kategori;
  final int harga;
  final String tahun;
  final String transmisi;
  final String kilometer;
  final String bahanBakar;
  final String gambar;
  final String deskripsi;
  final bool unggulan;

  const Kendaraan({
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.tahun,
    required this.transmisi,
    required this.kilometer,
    required this.bahanBakar,
    required this.gambar,
    required this.deskripsi,
    this.unggulan = false,
  });

  String get hargaFormat {
    final value = harga.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      buffer.write(value[i]);

      final remaining = value.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
    }

    return 'Rp ${buffer.toString()}';
  }
}

final List<Kendaraan> daftarKendaraan = [
  const Kendaraan(
    nama: 'Toyota Avanza',
    kategori: 'Mobil',
    harga: 165000000,
    tahun: '2022',
    transmisi: 'Manual',
    kilometer: '35.000 km',
    bahanBakar: 'Bensin',
    gambar: 'assets/mobil1.png',
    deskripsi:
        'Mobil keluarga dengan kabin luas dan nyaman untuk perjalanan harian. '
        'Silakan hubungi showroom untuk informasi kondisi, kelengkapan, '
        'dan jadwal pengecekan unit.',
    unggulan: true,
  ),
  const Kendaraan(
    nama: 'Honda Brio',
    kategori: 'Mobil',
    harga: 142000000,
    tahun: '2021',
    transmisi: 'Automatic',
    kilometer: '28.000 km',
    bahanBakar: 'Bensin',
    gambar: 'assets/mobil2.png',
    deskripsi:
        'Mobil kompak yang praktis untuk aktivitas sehari-hari. '
        'Hubungi showroom untuk memastikan kondisi dan ketersediaan unit.',
    unggulan: true,
  ),
  const Kendaraan(
    nama: 'Mitsubishi Xpander',
    kategori: 'Mobil',
    harga: 198000000,
    tahun: '2022',
    transmisi: 'Automatic',
    kilometer: '32.000 km',
    bahanBakar: 'Bensin',
    gambar: 'assets/mobil3.png',
    deskripsi:
        'Pilihan mobil keluarga dengan ruang kabin yang lega. '
        'Detail kendaraan dan riwayat perawatan dapat ditanyakan langsung.',
  ),
  const Kendaraan(
    nama: 'Honda Vario',
    kategori: 'Motor',
    harga: 18500000,
    tahun: '2023',
    transmisi: 'Automatic',
    kilometer: '8.000 km',
    bahanBakar: 'Bensin',
    gambar: 'assets/motor1.png',
    deskripsi:
        'Motor untuk mobilitas harian. Hubungi showroom untuk informasi '
        'kondisi unit, dokumen, dan jadwal melihat kendaraan.',
    unggulan: true,
  ),
  const Kendaraan(
    nama: 'Yamaha NMAX',
    kategori: 'Motor',
    harga: 24500000,
    tahun: '2022',
    transmisi: 'Automatic',
    kilometer: '12.000 km',
    bahanBakar: 'Bensin',
    gambar: 'assets/motor2.png',
    deskripsi:
        'Motor dengan posisi berkendara yang nyaman. '
        'Silakan tanyakan ketersediaan dan detail unit kepada showroom.',
  ),
  const Kendaraan(
    nama: 'Honda Beat',
    kategori: 'Motor',
    harga: 14500000,
    tahun: '2022',
    transmisi: 'Automatic',
    kilometer: '10.000 km',
    bahanBakar: 'Bensin',
    gambar: 'assets/motor3.png',
    deskripsi:
        'Motor yang praktis untuk kebutuhan sehari-hari. '
        'Pastikan kondisi dan kelengkapan kendaraan dengan pihak showroom.',
  ),
];
