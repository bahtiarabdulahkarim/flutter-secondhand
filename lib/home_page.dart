import 'package:flutter/material.dart';

import 'detail_page.dart';
import 'profile_page.dart';
import 'model/kendaraan_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  String selectedCategory = 'All';
  String searchQuery = '';

  String filterType = 'All';
  double maxPrice = 500000000;
  int minYear = 2018;

  final Set<String> favoriteVehicles = {};

  final TextEditingController searchController = TextEditingController();

  final List<Kendaraan> dataKendaraan = [
    Mobil(
      merk: 'Toyota',
      model: 'Avanza',
      tahun: 2022,
      harga: 215000000,
      warna: 'Hitam',
      kilometer: 35000,
      gambar: 'assets/mobil1.png',
      deskripsi: 'Toyota Avanza tahun 2022 dengan kondisi terawat, interior bersih, dan siap digunakan.',
      jumlahPintu: 5,
      transmisi: 'Manual',
    ),
    Mobil(
      merk: 'Honda',
      model: 'Civic',
      tahun: 2021,
      harga: 325000000,
      warna: 'Putih',
      kilometer: 28000,
      gambar: 'assets/mobil2.png',
      deskripsi: 'Honda Civic tahun 2021 dengan desain sporty, interior nyaman, dan kondisi sangat baik.',
      jumlahPintu: 4,
      transmisi: 'Automatic',
    ),
    Mobil(
      merk: 'Toyota',
      model: 'Fortuner',
      tahun: 2020,
      harga: 410000000,
      warna: 'Silver',
      kilometer: 45000,
      gambar: 'assets/mobil3.png',
      deskripsi: 'Toyota Fortuner tahun 2020 dengan kondisi baik dan cocok untuk perjalanan keluarga.',
      jumlahPintu: 5,
      transmisi: 'Automatic',
    ),
    Motor(
      merk: 'Honda',
      model: 'Vario 160',
      tahun: 2023,
      harga: 23000000,
      warna: 'Merah',
      kilometer: 12000,
      gambar: 'assets/motor1.png',
      deskripsi: 'Honda Vario 160 tahun 2023 dengan kondisi mesin terawat dan siap digunakan.',
      jenisMotor: 'Matic',
      kapasitasMesin: 160,
    ),
    Motor(
      merk: 'Yamaha',
      model: 'NMAX',
      tahun: 2022,
      harga: 28000000,
      warna: 'Hitam',
      kilometer: 15000,
      gambar: 'assets/motor2.png',
      deskripsi:
          'Yamaha NMAX tahun 2022 dengan kondisi nyaman dan perawatan rutin.',
      jenisMotor: 'Matic',
      kapasitasMesin: 155,
    ),
    Motor(
      merk: 'Honda',
      model: 'CBR 150R',
      tahun: 2021,
      harga: 31000000,
      warna: 'Merah',
      kilometer: 18000,
      gambar: 'assets/motor3.png',
      deskripsi: 'Honda CBR 150R dengan desain sporty dan performa yang masih sangat baik.',
      jenisMotor: 'Sport',
      kapasitasMesin: 150,
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Kendaraan> get filteredVehicles {
    return dataKendaraan.where((kendaraan) {
      final nama = kendaraan.getNamaKendaraan().toLowerCase();

      final queryMatch = nama.contains(searchQuery.toLowerCase());

      bool categoryMatch = true;

      if (selectedCategory == 'Cars') {
        categoryMatch = kendaraan is Mobil;
      } else if (selectedCategory == 'Motorcycles') {
        categoryMatch = kendaraan is Motor;
      } else if (selectedCategory == 'SUV') {
        categoryMatch =
            kendaraan is Mobil && kendaraan.model.toLowerCase() == 'fortuner';
      } else if (selectedCategory == 'Sport') {
        categoryMatch =
            kendaraan is Motor && kendaraan.model.toLowerCase() == 'cbr 150r';
      }

      bool typeMatch = true;

      if (filterType == 'Cars') {
        typeMatch = kendaraan is Mobil;
      } else if (filterType == 'Motorcycles') {
        typeMatch = kendaraan is Motor;
      }

      final priceMatch = kendaraan.harga <= maxPrice;

      final yearMatch = kendaraan.tahun >= minYear;

      return queryMatch &&
          categoryMatch &&
          typeMatch &&
          priceMatch &&
          yearMatch;
    }).toList();
  }

  String compactPrice(double price) {
    if (price >= 1000000000) {
      return 'Rp ${(price / 1000000000).toStringAsFixed(1)} M';
    }

    if (price >= 1000000) {
      return 'Rp ${(price / 1000000).toStringAsFixed(0)} jt';
    }

    return 'Rp ${price.toStringAsFixed(0)}';
  }

  bool isFavorite(Kendaraan kendaraan) {
    return favoriteVehicles.contains(kendaraan.getNamaKendaraan());
  }

  void toggleFavorite(Kendaraan kendaraan) {
    setState(() {
      final key = kendaraan.getNamaKendaraan();

      if (favoriteVehicles.contains(key)) {
        favoriteVehicles.remove(key);
      } else {
        favoriteVehicles.add(key);
      }
    });
  }

  void openVehicle(Kendaraan kendaraan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          kendaraan: kendaraan,
          isFavorite: isFavorite(kendaraan),
          onFavoritePressed: () {
            toggleFavorite(kendaraan);
          },
        ),
      ),
    );
  }

  Widget categoryChip(String title) {
    final active = selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 9),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF171717) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: active ? const Color(0xFF171717) : const Color(0xFFE2E2DF),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF555555),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ==================================================
  // NOTIFICATION
  // ==================================================

  void showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 18),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0ED),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_offer_outlined),
                ),
                title: const Text(
                  'New vehicle available',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text('Honda Civic 2021 baru saja ditambahkan.'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0ED),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.favorite_border),
                ),
                title: const Text(
                  'Favorites',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${favoriteVehicles.length} kendaraan tersimpan.',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================================================
  // FILTER
  // ==================================================

  void openFilter() {
    String tempType = filterType;
    double tempPrice = maxPrice;
    double tempYear = minYear.toDouble();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                22,
                20,
                22,
                MediaQuery.of(context).viewInsets.bottom + 25,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Vehicle type',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    children: [
                      filterChoice('All', tempType, () {
                        setModalState(() {
                          tempType = 'All';
                        });
                      }),
                      filterChoice('Cars', tempType, () {
                        setModalState(() {
                          tempType = 'Cars';
                        });
                      }),
                      filterChoice('Motorcycles', tempType, () {
                        setModalState(() {
                          tempType = 'Motorcycles';
                        });
                      }),
                    ],
                  ),

                  const SizedBox(height: 22),

                  Text(
                    'Maximum price: ${compactPrice(tempPrice)}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),

                  Slider(
                    value: tempPrice,
                    min: 20000000,
                    max: 500000000,
                    divisions: 48,
                    activeColor: const Color(0xFF171717),
                    onChanged: (value) {
                      setModalState(() {
                        tempPrice = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Minimum year: ${tempYear.toInt()}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),

                  Slider(
                    value: tempYear,
                    min: 2018,
                    max: 2025,
                    divisions: 7,
                    activeColor: const Color(0xFF171717),
                    onChanged: (value) {
                      setModalState(() {
                        tempYear = value;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filterType = tempType;
                          maxPrice = tempPrice;
                          minYear = tempYear.toInt();
                        });

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF171717),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Apply Filter',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget filterChoice(String title, String selected, VoidCallback onTap) {
    final active = title == selected;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF171717) : const Color(0xFFF3F3F0),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ==================================================
  // FEATURED
  // ==================================================

  Widget buildFeatured() {
    final vehicles = filteredVehicles;

    if (vehicles.isEmpty) {
      return Container(
        height: 235,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF171717),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            'No vehicle found',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }

    final kendaraan = vehicles.first;

    return Container(
      height: 245,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // ============================
          // TEXT AREA
          // ============================

          Expanded(
            flex: 44,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 8, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8FF3E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'FEATURED',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Text(
                    kendaraan.merk,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.55),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    kendaraan.model,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${kendaraan.tahun} • ${kendaraan.kilometer} km',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.5),
                      fontSize: 10,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    compactPrice(kendaraan.harga),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFD8FF3E),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============================
          // IMAGE AREA
          // ============================
          Expanded(
            flex: 56,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  kendaraan.gambar,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),

                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 35,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(0xFF171717).withOpacity(.45),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: 15,
                  bottom: 15,
                  child: GestureDetector(
                    onTap: () {
                      openVehicle(kendaraan);
                    },
                    child: Container(
                      width: 43,
                      height: 43,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward, size: 19),
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

  // ==================================================
  // VEHICLE CARD
  // ==================================================

  Widget buildVehicleCard(Kendaraan kendaraan) {
    final favorite = isFavorite(kendaraan);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E7E4)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          openVehicle(kendaraan);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.asset(
                  kendaraan.gambar,
                  width: 120,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            kendaraan.merk,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            toggleFavorite(kendaraan);
                          },
                          child: Icon(
                            favorite ? Icons.favorite : Icons.favorite_border,
                            color: favorite ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    Text(
                      kendaraan.model,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      '${kendaraan.tahun} • ${kendaraan.kilometer} km • ${kendaraan.warna}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Text(
                      compactPrice(kendaraan.harga),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // HOME
  // ==================================================

  Widget buildHome() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GOOD MORNING',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'Hi, Bahtiar.',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -.7,
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: showNotifications,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE5E5E2)),
                        ),
                        child: const Icon(Icons.notifications_none, size: 21),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 23),

                // SEARCH
                Container(
                  height: 53,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFE5E5E2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade500, size: 21),

                      const SizedBox(width: 10),

                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search cars, motorcycles...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: openFilter,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1EE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.tune, size: 17),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // BROWSE
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: [
                const Text(
                  'Browse',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),

                const Spacer(),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = 'All';
                      searchQuery = '';
                      searchController.clear();
                    });
                  },
                  child: Text(
                    'View all',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // CATEGORY
        SliverToBoxAdapter(
          child: SizedBox(
            height: 45,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                categoryChip('All'),
                categoryChip('Cars'),
                categoryChip('Motorcycles'),
                categoryChip('SUV'),
                categoryChip('Sport'),
              ],
            ),
          ),
        ),

        // FEATURED TITLE
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
            child: Row(
              children: [
                const Text(
                  'Featured',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),

                const Spacer(),

                Text(
                  '${filteredVehicles.isEmpty ? 0 : 1} / ${filteredVehicles.length}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),

        // FEATURED
        SliverToBoxAdapter(child: buildFeatured()),

        // LATEST TITLE
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 14),
            child: Row(
              children: [
                const Text(
                  'Latest listings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),

                const Spacer(),

                Text(
                  '${filteredVehicles.length} vehicles',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
              ],
            ),
          ),
        ),

        // ==================================================
        // LISTVIEW.BUILDER
        // ==================================================
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: filteredVehicles.isEmpty
                ? Container(
                    height: 180,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 42,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Vehicle not found',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredVehicles.length,
                    itemBuilder: (context, index) {
                      return buildVehicleCard(filteredVehicles[index]);
                    },
                  ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),

      body: IndexedStack(
        index: selectedIndex,
        children: [
          buildHome(),
          ProfilePage(
            favoriteVehicles: dataKendaraan.where((kendaraan) {
              return isFavorite(kendaraan);
            }).toList(),
            onFavoritePressed: toggleFavorite,
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEAEAE7))),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFEDEDE9),
          elevation: 0,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
