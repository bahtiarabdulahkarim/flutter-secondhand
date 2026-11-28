import 'package:flutter/material.dart';
import '../../models/vehicle_model.dart';

class MotorcycleCard extends StatelessWidget {
  const MotorcycleCard({
    super.key,
    required this.motorcycle,
    this.onDetail,
  });

  final VehicleModel motorcycle;
  final VoidCallback? onDetail;

  static const Color gold = Color(0xFFD8B45F);
  static const Color muted = Color(0xFFA0A5AE);

  String _formatPrice(int price) {
    final value = price.toString();
    final result = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) {
        result.write('.');
      }
      result.write(value[i]);
    }

    return 'Rp${result.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF191D24),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.65,
                child: Image.network(
                  motorcycle.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF242932),
                      child: const Icon(
                        Icons.two_wheeler,
                        color: gold,
                        size: 55,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: _badge(
                  motorcycle.grade,
                  gold,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: _badge(
                  motorcycle.status,
                  const Color(0xFF242932),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${motorcycle.brand} • ${motorcycle.year}',
                  style: const TextStyle(
                    color: gold,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 7),

                Text(
                  motorcycle.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFE1E3EB),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  _formatPrice(motorcycle.price),
                  style: const TextStyle(
                    color: gold,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),

                const Divider(
                  color: Color(0xFF303640),
                  height: 1,
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 12,
                  runSpacing: 9,
                  children: [
                    _infoItem(
                      Icons.speed,
                      '${motorcycle.odometer.toString()} km',
                    ),
                    _infoItem(
                      Icons.settings,
                      motorcycle.transmission,
                    ),
                    _infoItem(
                      Icons.location_on_outlined,
                      motorcycle.location,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: onDetail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: const Color(0xFF10151D),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lihat Detail',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 16),
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

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF10151D).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: gold, size: 13),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: muted,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}