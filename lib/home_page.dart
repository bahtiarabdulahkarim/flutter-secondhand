import 'dart:async';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:expandable_page_view/expandable_page_view.dart';
=======
import 'package:redacted/redacted.dart';
import 'package:lottie/lottie.dart';
>>>>>>> origin

import 'detail_page.dart';
import 'main.dart';
import 'model/kendaraan_model.dart';
import 'profile_page.dart';
import 'about_page.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  
  int _currentPage = 0;
  bool _isAutoPlayActive = true;
  
  final int _jumlahBanner = 3;

  // Diubah dari final agar bisa diubah saat filter diklik
  String _kategoriAktif = 'Semua';
  String _urutanHarga = 'Default';
  final Set<String> _favoritNama = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _startAutoPlayLoop();
  }

  void _startAutoPlayLoop() async {
    while (_isAutoPlayActive && mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!_isAutoPlayActive || !mounted) break;

      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % _jumlahBanner;
        await _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _isAutoPlayActive = false;
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
=======

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    });
>>>>>>> origin
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
          mainAxisSize: MainAxisSize.min,
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
            const Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'SECONDHAND MOTORS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
<<<<<<< HEAD
=======
          // Tombol Chat
          IconButton(
            tooltip: 'Chat Admin',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatPage()),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          ),
          // Tombol Dark Mode
>>>>>>> origin
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
            padding: const EdgeInsets.only(left: 4),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutPage()),
                );
              },
              icon: const Icon(Icons.info_outline_rounded, size: 18),
              label: const Text('About'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
              ),
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
                        // --- Banner Bergambar & Auto-Play Dinamis ---
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MouseRegion(
                              onEnter: (_) => setState(() => _isAutoPlayActive = false),
                              onExit: (_) {
                                setState(() => _isAutoPlayActive = true);
                                _startAutoPlayLoop();
                              },
                              child: GestureDetector(
                                onTapDown: (_) => setState(() => _isAutoPlayActive = false),
                                child: ExpandablePageView(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  children: [
                                    // BANNER 1
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                            'assets/images/banner.jpg',
                                            width: double.infinity,
                                            height: 180,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Container(height: 180, color: isDark ? const Color(0xFF1D2219) : const Color(0xFF1A1E17)),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 180,
                                            color: Colors.black.withValues(alpha: 0.45),
                                            padding: EdgeInsets.all(width < 600 ? 24 : 34),
                                            child: const Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'VERIFIED PRE-OWNED SELECTION',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xFFB6D477),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Koleksi Mobil & Motor Bekas Premium',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // BANNER 2
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                            'assets/images/banner2.jpg',
                                            width: double.infinity,
                                            height: 180,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Container(height: 180, color: const Color(0xFF789449)),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 180,
                                            color: Colors.black.withValues(alpha: 0.45),
                                            padding: EdgeInsets.all(width < 600 ? 24 : 34),
                                            child: const Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'PROMO SPESIAL',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Cicilan Ringan & Garansi Mesin',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // BANNER 3
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                            'assets/images/banner3.jpg',
                                            width: double.infinity,
                                            height: 180,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Container(height: 180, color: const Color(0xFF2C3E50)),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 180,
                                            color: Colors.black.withValues(alpha: 0.45),
                                            padding: EdgeInsets.all(width < 600 ? 24 : 34),
                                            child: const Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'LAYANAN TRADE-IN',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xFFB6D477),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Tukar Tambah Kendaraan Semudah Kilat',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_jumlahBanner, (index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: _currentPage == index ? 20 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index
                                        ? const Color(0xFF789449)
                                        : theme.colorScheme.outlineVariant
                                            .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                          ],
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

                        // Filter Kategori Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildChip('Semua', Icons.grid_view_rounded, theme),
                              const SizedBox(width: 8),
                              _buildChip('Mobil', Icons.directions_car_filled_rounded, theme),
                              const SizedBox(width: 8),
                              _buildChip('Motor', Icons.two_wheeler_rounded, theme),
                              const SizedBox(width: 8),
                              _buildChip('Unggulan', Icons.verified_rounded, theme),
                              const SizedBox(width: 8),
                              _buildChip('Favorit (${_favoritNama.length})', Icons.favorite_rounded, theme, keyName: 'Favorit'),
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

                if (!_isLoading && _kendaraanTampil.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 30,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: Lottie.asset(
                                'assets/animations/no_search_results.json',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Kendaraan Tidak Ditemukan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Maaf, kendaraan yang kamu cari belum tersedia.',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _kategoriAktif = 'Semua';
                                  _urutanHarga = 'Default';
                                });
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Reset Pencarian'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF789449),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                        final daftarUntukDitampilkan = _isLoading
                            ? daftarKendaraan
                            : _kendaraanTampil;

                        if (daftarUntukDitampilkan.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final kendaraan =
                            daftarUntukDitampilkan[index %
                                daftarUntukDitampilkan.length];

                        final isFav = _favoritNama.contains(kendaraan.nama);

                        return ShowroomCard(
                          kendaraan: kendaraan,
                          isFavorite: isFav,
<<<<<<< HEAD
                          onFavoriteToggle: () => _toggleFavorit(kendaraan.nama),
=======
                          isLoading: _isLoading,
                          onFavoriteToggle: () =>
                              _toggleFavorit(kendaraan.nama),
>>>>>>> origin
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(kendaraan: kendaraan),
                              ),
                            );
                          },
                        ).redacted(
                          context: context,
                          redact: _isLoading,
                          configuration: RedactedConfiguration(
                            animationDuration: const Duration(
                              milliseconds: 1500,
                            ),
                          ),
                        );
                      }, childCount: _isLoading ? 6 : _kendaraanTampil.length),
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
      onSelected: (_) {
        setState(() {
          _kategoriAktif = val;
          _isLoading = true;
        });

        Future.delayed(const Duration(milliseconds: 700), () {
          if (!mounted) return;

          setState(() {
            _isLoading = false;
          });
        });
      },
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

class ShowroomCard extends StatelessWidget {
  final Kendaraan kendaraan;
  final bool isFavorite;
  final bool isLoading;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const ShowroomCard({
    super.key,
    required this.kendaraan,
    required this.isFavorite,
    required this.isLoading,
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
                      ).redacted(context: context, redact: isLoading),
                    ),
<<<<<<< HEAD
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
=======
                    // Badge Certified ala Referensi
                    if (!isLoading)
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
>>>>>>> origin
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
<<<<<<< HEAD
                    ),
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
=======
                    // Tombol Favorit
                    if (!isLoading)
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
>>>>>>> origin
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
                      ).redacted(context: context, redact: isLoading),
                      const SizedBox(height: 3),
                      Text(
                        kendaraan.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ).redacted(context: context, redact: isLoading),
                      const SizedBox(height: 6),
                      Text(
                        kendaraan.hargaFormat,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF789449),
                        ),
                      ).redacted(context: context, redact: isLoading),
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