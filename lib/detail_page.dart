import 'package:flutter/material.dart';

import 'model/kendaraan_model.dart';

class DetailPage extends StatefulWidget {
  final Kendaraan kendaraan;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const DetailPage({
    super.key,
    required this.kendaraan,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool get favorite => widget.isFavorite;

  Widget specification(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  void contactSeller() {
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
                'Contact Seller',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 8),

              Text(
                'Tertarik dengan ${widget.kendaraan.getNamaKendaraan()}?',
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 20),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0ED),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.chat_outlined),
                ),
                title: const Text(
                  'Chat Seller',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text('Kirim pesan kepada penjual'),
                onTap: () {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chat seller berhasil dibuka.'),
                    ),
                  );
                },
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0ED),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.phone_outlined),
                ),
                title: const Text(
                  'Call Seller',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text('Hubungi penjual langsung'),
                onTap: () {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur panggilan aktif pada tahap demo.'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    widget.onFavoritePressed();

                    setState(() {});

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          favorite
                              ? 'Removed from favorites'
                              : 'Added to favorites',
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: favorite ? Colors.red : Colors.black,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(widget.kendaraan.gambar, fit: BoxFit.cover),

                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.75),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.kendaraan is Mobil ? 'CAR' : 'MOTORCYCLE',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.kendaraan.merk.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    widget.kendaraan.model,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.kendaraan.getHarga(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      specification('YEAR', widget.kendaraan.tahun.toString()),
                      const SizedBox(width: 10),
                      specification(
                        'MILEAGE',
                        '${widget.kendaraan.kilometer} km',
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      specification('COLOR', widget.kendaraan.warna),
                      const SizedBox(width: 10),
                      specification(
                        'TYPE',
                        widget.kendaraan is Mobil ? 'Car' : 'Motorcycle',
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'About this vehicle',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.kendaraan.deskripsi,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 25),

                  if (widget.kendaraan is Mobil)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE8E8E5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.settings_outlined),
                          const SizedBox(width: 12),
                          Text(
                            '${(widget.kendaraan as Mobil).transmisi} • '
                            '${(widget.kendaraan as Mobil).jumlahPintu} doors',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),

                  if (widget.kendaraan is Motor)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE8E8E5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.speed_outlined),
                          const SizedBox(width: 12),
                          Text(
                            '${(widget.kendaraan as Motor).kapasitasMesin} cc • '
                            '${(widget.kendaraan as Motor).jenisMotor}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 57,
                    child: ElevatedButton.icon(
                      onPressed: contactSeller,
                      icon: const Icon(Icons.chat_bubble_outline, size: 19),
                      label: const Text(
                        'Contact Seller',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF171717),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
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
