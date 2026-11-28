import 'package:flutter/material.dart';
import '../../models/vehicle_model.dart';
import 'motorcycle_card.dart';

class MotorcycleListing extends StatelessWidget {
  const MotorcycleListing({
    super.key,
    required this.motorcycles,
    this.isListView = false,
    this.onDetail,
    this.onViewChanged,
  });

  final List<VehicleModel> motorcycles;
  final bool isListView;
  final ValueChanged<VehicleModel>? onDetail;
  final ValueChanged<bool>? onViewChanged;

  static const Color gold = Color(0xFFD8B45F);
  static const Color muted = Color(0xFFA0A5AE);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final crossAxisCount = width >= 1100
            ? 3
            : width >= 700
                ? 2
                : 1;

        final cardWidth =
            (width - (crossAxisCount - 1) * 16) / crossAxisCount;

        final cardHeight = (cardWidth / 1.65) + 300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'KOLEKSI TERSEDIA',
                        style: TextStyle(
                          color: gold,
                          fontSize: 9,
                          letterSpacing: 1.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${motorcycles.length} Motor Ditemukan',
                        style: const TextStyle(
                          color: Color(0xFFE1E3EB),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _viewButton(
                  icon: Icons.grid_view,
                  selected: !isListView,
                  onTap: () => _notifyViewChange(context, false),
                ),
                const SizedBox(width: 7),
                _viewButton(
                  icon: Icons.view_agenda_outlined,
                  selected: isListView,
                  onTap: () => _notifyViewChange(context, true),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (motorcycles.isEmpty)
              _emptyState()
            else if (isListView)
              Column(
                children: motorcycles.map((motorcycle) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MotorcycleCard(
                      motorcycle: motorcycle,
                      onDetail: () => onDetail?.call(motorcycle),
                    ),
                  );
                }).toList(),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: motorcycles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: cardHeight,
                ),
                itemBuilder: (context, index) {
                  final motorcycle = motorcycles[index];

                  return MotorcycleCard(
                    motorcycle: motorcycle,
                    onDetail: () => onDetail?.call(motorcycle),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _viewButton({
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: selected ? gold : const Color(0xFF242932),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 17,
          color: selected ? const Color(0xFF10151D) : muted,
        ),
      ),
    );
  }

  void _notifyViewChange(BuildContext context, bool value) {
    onViewChanged?.call(value);
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 45,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF191D24),
        borderRadius: BorderRadius.circular(7),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off,
            color: gold,
            size: 42,
          ),
          SizedBox(height: 14),
          Text(
            'Motor Tidak Ditemukan',
            style: TextStyle(
              color: Color(0xFFE1E3EB),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Coba ubah kata kunci atau filter pencarian Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}