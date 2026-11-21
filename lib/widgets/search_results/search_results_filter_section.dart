import 'package:flutter/material.dart';

class SearchResultsFilterSection extends StatelessWidget {
  const SearchResultsFilterSection({super.key});

  static const Color goldColor = Color(0xFFC9A45C);
  static const Color panelColor = Color(0xFF191D24);
  static const Color chipColor = Color(0xFF242932);
  static const Color textWhite = Colors.white;
  static const Color textMuted = Color(0xFFA0A0A0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter aktif
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Filter Aktif:',
              style: TextStyle(
                color: textMuted,
                fontSize: 10,
              ),
            ),
            _ActiveFilterChip(label: 'Merek: Honda'),
            _ActiveFilterChip(label: 'Semua Model (8 Unit)'),
            _ActiveFilterChip(label: 'Kondisi: Terinspeksi 175-Titik'),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Reset Semua Filter',
                style: TextStyle(
                  color: textMuted,
                  fontSize: 10,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Pilihan model kendaraan
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ModelChip(
                label: 'Semua Honda',
                count: 18,
                selected: true,
              ),
              _ModelChip(label: 'Honda CR-V', count: 4),
              _ModelChip(label: 'Honda HR-V', count: 3),
              _ModelChip(label: 'Honda Civic RS & Turbo', count: 3),
              _ModelChip(label: 'Honda Brio RS', count: 1),
              _ModelChip(label: 'Honda Forza 250', count: 1),
              _ModelChip(label: 'Honda CBR250RR SP', count: 2),
              _ModelChip(label: 'Honda ADV', count: 4),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF242932),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.close,
            color: Color(0xFFA0A0A0),
            size: 12,
          ),
        ],
      ),
    );
  }
}

class _ModelChip extends StatelessWidget {
  const _ModelChip({
    required this.label,
    required this.count,
    this.selected = false,
  });

  final String label;
  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFC9A45C) : const Color(0xFF191D24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFF191D24) : Colors.white,
              fontSize: 10,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 7),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF9D7938)
                  : const Color(0xFF303640),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFFA0A0A0),
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}