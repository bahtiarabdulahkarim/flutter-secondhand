
import 'package:flutter/material.dart';
import '../../models/vehicle_model.dart';

class VehicleCollectionCard extends StatelessWidget {
  const VehicleCollectionCard({
    super.key,
    required this.vehicle,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onDetailTap,
  });

  final VehicleModel vehicle;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onDetailTap;

  static const Color gold = Color(0xFFC9A45C);
  static const Color cardColor = Color(0xFF191D24);
  static const Color muted = Color(0xFFA0A0A0);

  String formatPrice(int price) {
    return 'Rp${price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }

  Widget buildSpec(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: muted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto dan badge kendaraan
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  vehicle.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const ColoredBox(
                      color: Color(0xFF252B34),
                      child: Center(
                        child: Icon(
                          Icons.directions_car,
                          color: Colors.white38,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
              ),

              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF191D24),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '✧ 175-PT CHECK',
                    style: TextStyle(
                      color: gold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: gold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    vehicle.grade,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  onPressed: onFavoriteTap,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor:
                        isFavorite ? Colors.red : Colors.white,
                  ),
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: muted,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        vehicle.location.trim(),
                        style: const TextStyle(
                          color: muted,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Text(
                      vehicle.transmission,
                      style: const TextStyle(
                        color: gold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  vehicle.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222832),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      buildSpec('Tahun', '${vehicle.year}'),
                      buildSpec(
                        'Jarak',
                        '${vehicle.odometer} km',
                      ),
                      buildSpec(
                        'Transmisi',
                        vehicle.transmission,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Harga Tunai',
                  style: TextStyle(
                    color: muted,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  formatPrice(vehicle.price),
                  style: const TextStyle(
                    color: gold,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 13),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onDetailTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Lihat Detail Mobil  →',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
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
}
