import 'package:flutter/material.dart';

import 'detail_page.dart';
import 'main.dart';
import 'model/kendaraan_model.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _kategoriAktif = 'Semua';
  String _urutanHarga = 'Default';
  final Set<String> _favoritNama = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorit(String nama) {
    setState(() {
      if (_favoritNama.contains(nama)) {
        _favoritNama.remove(nama);
      } else {
        _favoritNama.add(nama);
      }
    });
  }

  List<Kendaraan> get _kendaraanTampil {
    final query = _searchController.text.toLowerCase().trim();

    final hasil = daftarKendaraan.where((kendaraan) {
      final cocokKategori = switch (_kategoriAktif) {
        'Semua' => true,
        'Unggulan' => kendaraan.unggulan,
        'Favorit' => _favoritNama.contains(kendaraan.nama),
        _ => kendaraan.kategori.toLowerCase() == _kategoriAktif.toLowerCase(),
      };

      final cocokPencarian =
          kendaraan.nama.toLowerCase().contains(query) ||
          kendaraan.tahun.toLowerCase().contains(query) ||
          kendaraan.transmisi.toLowerCase().contains(query);

      return cocokKategori && cocokPencarian;
    }).toList();

    if (_urutanHarga == 'Termurah') {
      hasil.sort((a, b) => a.harga.compareTo(b.harga));
    } else if (_urutanHarga == 'Termahal') {
      hasil.sort((a, b) => b.harga.compareTo(a.harga));
    }

    return hasil;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFF789449),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.directions_car_filled_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'SECONDHAND MOTORS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: AppTheme.isDark ? 'Mode Terang' : 'Mode Gelap',
            onPressed: AppTheme.toggle,
            icon: Icon(
              AppTheme.isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14, left: 4),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
              icon: const Icon(Icons.person_outline_rounded, size: 18),
              label: const Text('Profil'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final columns = width >= 1100
                ? 4
                : width >= 750
                ? 3
                : 2;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      width < 600 ? 18 : 32,
                      16,
                      width < 600 ? 18 : 32,
                      18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banner Premium ala Showroom Kelas Atas
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(width < 600 ? 24 : 34),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1D2219)
                                : const Color(0xFF1A1E17),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFB6D477),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'VERIFIED PRE-OWNED SELECTION',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                      color: Color(0xFFB6D477),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Koleksi Mobil & Motor Bekas Premium',
                                style: TextStyle(
                                  fontSize: 26,
                                  height: 1.15,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Garansi mesin, surat lengkap, dan siap pakai.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Search & Sorting Bar
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'Cari merek, tipe, atau model...',
                                  prefixIcon: const Icon(Icons.search_rounded),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {});
                                          },
                                          icon: const Icon(Icons.close_rounded),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            PopupMenuButton<String>(
                              tooltip: 'Urutkan Harga',
                              initialValue: _urutanHarga,
                              onSelected: (val) =>
                                  setState(() => _urutanHarga = val),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'Default',
                                  child: Text('Urutan Standar'),
                                ),
                                const PopupMenuItem(
                                  value: 'Termurah',
                                  child: Text('Harga Termurah'),
                                ),
                                const PopupMenuItem(
                                  value: 'Termahal',
                                  child: Text('Harga Tertinggi'),
                                ),
                              ],
                              child: Container(
                                height: 52,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: theme.colorScheme.outlineVariant
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.tune_rounded, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Filter Kategori
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildChip(
                                'Semua',
                                Icons.grid_view_rounded,
                                theme,
                              ),
                              const SizedBox(width: 8),
                              _buildChip(
                                'Mobil',
                                Icons.directions_car_filled_rounded,
                                theme,
                              ),
                              const SizedBox(width: 8),
                              _buildChip(
                                'Motor',
                                Icons.two_wheeler_rounded,
                                theme,
                              ),
                              const SizedBox(width: 8),
                              _buildChip(
                                'Unggulan',
                                Icons.verified_rounded,
                                theme,
                              ),
                              const SizedBox(width: 8),
                              _buildChip(
                                'Favorit (${_favoritNama.length})',
                                Icons.favorite_rounded,
                                theme,
                                keyName: 'Favorit',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            const Text(
                              'Daftar Kendaraan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${_kendaraanTampil.length} unit',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (_kendaraanTampil.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text('Tidak ada kendaraan yang sesuai.'),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      width < 600 ? 18 : 32,
                      0,
                      width < 600 ? 18 : 32,
                      32,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final kendaraan = _kendaraanTampil[index];
                        final isFav = _favoritNama.contains(kendaraan.nama);

                        return _ShowroomCard(
                          kendaraan: kendaraan,
                          isFavorite: isFav,
                          onFavoriteToggle: () =>
                              _toggleFavorit(kendaraan.nama),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailPage(kendaraan: kendaraan),
                              ),
                            );
                          },
                        );
                      }, childCount: _kendaraanTampil.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 16,
                        childAspectRatio: width < 420 ? 0.65 : 0.74,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChip(
    String label,
    IconData icon,
    ThemeData theme, {
    String? keyName,
  }) {
    final val = keyName ?? label;
    final selected = _kategoriAktif == val;

    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 16,
        color: selected ? Colors.white : theme.colorScheme.onSurfaceVariant,
      ),
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => setState(() => _kategoriAktif = val),
      selectedColor: const Color(0xFF789449),
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(
        color: selected
            ? Colors.transparent
            : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 13,
        color: selected ? Colors.white : theme.colorScheme.onSurface,
      ),
    );
  }
}

class _ShowroomCard extends StatelessWidget {
  final Kendaraan kendaraan;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const _ShowroomCard({
    required this.kendaraan,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 11,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'veh-${kendaraan.nama}',
                      child: Image.asset(
                        kendaraan.gambar,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: const Color(0xFFEEF0E9)),
                      ),
                    ),
                    // Badge Certified ala Referensi
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 11,
                              color: Color(0xFFB6D477),
                            ),
                            SizedBox(width: 3),
                            Text(
                              'SM CERTIFIED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Tombol Favorit
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onFavoriteToggle,
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 16,
                              color: isFavorite
                                  ? const Color(0xFFFF5252)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LUXURY LINE • ${kendaraan.tahun}',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurfaceVariant,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        kendaraan.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        kendaraan.hargaFormat,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF789449),
                        ),
                      ),
                      const Spacer(),
                      const Divider(height: 10, thickness: 0.5),
                      Row(
                        children: [
                          Text(
                            '${kendaraan.kilometer} • ${kendaraan.transmisi}',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_rounded, size: 14),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
