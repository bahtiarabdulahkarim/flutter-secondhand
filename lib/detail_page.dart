import 'package:flutter/material.dart';

import 'model/kendaraan_model.dart';

class DetailPage extends StatelessWidget {
  final Kendaraan kendaraan;

  const DetailPage({super.key, required this.kendaraan});

  void _showActionDialog(BuildContext context, String actionType) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          actionType == 'purchase'
              ? 'Proses Pembelian Unit'
              : 'Jadwal Test Drive',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        content: Text(
          actionType == 'purchase'
              ? 'Anda akan terhubung dengan sales eksekutif untuk pemesanan ${kendaraan.nama}.'
              : 'Pilih jadwal kunjungan showroom untuk test drive unit ${kendaraan.nama}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Berhasil memproses permintaan $actionType!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF789449),
            ),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Simulasi cicilan bulanan kasar berdasarkan harga
    final estimasiCicilan =
        'Rp ${(kendaraan.harga ~/ 36).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} / bulan';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          kendaraan.nama,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;

            final imagePreview = ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AspectRatio(
                aspectRatio: isWide ? 1.1 : 1.35,
                child: Hero(
                  tag: 'veh-${kendaraan.nama}',
                  child: Image.asset(
                    kendaraan.gambar,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFEEF0E9),
                        child: const Icon(
                          Icons.directions_car_rounded,
                          size: 65,
                          color: Color(0xFF789449),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );

            final detailsContent = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge SM Certified
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2B3422)
                        : const Color(0xFFEAF0DF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 13,
                        color: Color(0xFF789449),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'SM CERTIFIED SHOWROOM',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF789449),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  kendaraan.nama,
                  style: const TextStyle(
                    fontSize: 28,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'LUXURY LINE • READY STOCK',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  kendaraan.hargaFormat,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF789449),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Estimasi cicilan $estimasiCicilan',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),

                // Grid Spesifikasi Rapi ala Referensi
                Row(
                  children: [
                    Expanded(
                      child: _SpecBlock(label: 'TAHUN', value: kendaraan.tahun),
                    ),
                    Expanded(
                      child: _SpecBlock(
                        label: 'TRANSMISI',
                        value: kendaraan.transmisi,
                      ),
                    ),
                    Expanded(
                      child: _SpecBlock(
                        label: 'KILOMETER',
                        value: kendaraan.kilometer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _SpecBlock(
                        label: 'BAHAN BAKAR',
                        value: kendaraan.bahanBakar,
                      ),
                    ),
                    Expanded(
                      child: _SpecBlock(
                        label: 'KATEGORI',
                        value: kendaraan.kategori,
                      ),
                    ),
                    Expanded(
                      child: _SpecBlock(
                        label: 'STATUS',
                        value: 'Inspeksi Lulus',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Tombol Utama (Purchase Now & Book Test Drive)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () =>
                              _showActionDialog(context, 'purchase'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFD32F2F,
                            ), // Merah aksen tegas seperti referensi
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Purchase Now!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () =>
                              _showActionDialog(context, 'testdrive'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFD32F2F),
                              width: 1.5,
                            ),
                            foregroundColor: const Color(0xFFD32F2F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Book Test Drive',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Text(
                  'Deskripsi & Catatan Showroom',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  kendaraan.deskripsi,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.6,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );

            return SingleChildScrollView(
              padding: EdgeInsets.all(isWide ? 32 : 18),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 12, child: imagePreview),
                            const SizedBox(width: 32),
                            Expanded(flex: 10, child: detailsContent),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imagePreview,
                            const SizedBox(height: 24),
                            detailsContent,
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SpecBlock extends StatelessWidget {
  final String label;
  final String value;

  const _SpecBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E231B) : const Color(0xFFF1F4EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
