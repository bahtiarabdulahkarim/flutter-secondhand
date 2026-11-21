
import 'package:flutter/material.dart';

class SearchResultsToolbar extends StatelessWidget {
  const SearchResultsToolbar({super.key});

  static const Color panelColor = Color(0xFF191D24);
  static const Color fieldColor = Color(0xFF242932);
  static const Color textWhite = Colors.white;
  static const Color textMuted = Color(0xFFA0A0A0);
  static const Color goldColor = Color(0xFFC9A45C);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 14,
      ),
      color: panelColor,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // Filter kendaraan
          Wrap(
            spacing: 5,
            runSpacing: 8,
            children: const [
              _FilterDropdown(label: 'Harga: Rp30 Jt - Rp600 Jt'),
              _FilterDropdown(label: 'Tahun: 2019 - 2024'),
              _FilterDropdown(label: 'Transmisi: Semua (CVT/AT/MT)'),
              _FilterDropdown(label: 'Odometer: < 30.000 KM'),
              _FilterDropdown(label: 'Lokasi Hub: Semua Area'),
            ],
          ),

          // Pengurutan dan pilihan tampilan
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              Text(
                'Urutkan:',
                style: TextStyle(
                  color: textMuted,
                  fontSize: 10,
                ),
              ),
              _SortDropdown(),
              _ViewModeButton(
                icon: Icons.grid_view,
                selected: true,
              ),
              _ViewModeButton(
                icon: Icons.view_list,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF242932),
        borderRadius: BorderRadius.circular(5),
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
          const SizedBox(width: 7),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFFA0A0A0),
            size: 15,
          ),
        ],
      ),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  const _SortDropdown();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF242932),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Rekomendasi Inspeksi Terbaik',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          SizedBox(width: 7),
          Icon(
            Icons.sort,
            color: Color(0xFFC9A45C),
            size: 15,
          ),
        ],
      ),
    );
  }
}

class _ViewModeButton extends StatelessWidget {
  const _ViewModeButton({
    required this.icon,
    this.selected = false,
  });

  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF303640)
            : const Color(0xFF191D24),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(
        icon,
        color: selected ? const Color(0xFFC9A45C) : Colors.white,
        size: 16,
      ),
    );
  }
}
