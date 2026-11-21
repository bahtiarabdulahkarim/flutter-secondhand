import 'package:flutter/material.dart';

class VehicleCardItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String specs;
  final String price;
  final String grade;

  const VehicleCardItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.specs,
    required this.price,
    required this.grade,
  });

  static const Color goldColor = Color(0xFFC9A45C);
  static const Color cardColor = Color(0xFF191D24);
  static const Color textMuted = Color(0xFFA0A0A0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar kendaraan
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black26,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.directions_car,
                        color: textMuted,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),

              // Badge inspeksi
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF557128),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'TERINSPEKSI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Grade kendaraan
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: goldColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    grade,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Tombol favorit (belum aktif)
              Positioned(
                bottom: 12,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          // Informasi kendaraan
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  specs,
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  price,
                  style: const TextStyle(
                    color: goldColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
