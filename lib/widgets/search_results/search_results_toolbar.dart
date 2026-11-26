import 'package:flutter/material.dart';
import '../../data/vehicle_data.dart';

class SearchResultsToolbar extends StatefulWidget {
  const SearchResultsToolbar({
    super.key,
    required this.selectedPrice,
    required this.onPriceSelected,
    required this.selectedYear,
    required this.onYearSelected,
    required this.selectedTransmission,
    required this.onTransmissionSelected,
    required this.selectedOdometer,
    required this.onOdometerSelected,
    required this.selectedLocation,
    required this.onLocationSelected,
    required this.onResetFilters,
    required this.selectedSort,
    required this.onSortSelected,
    required this.isListView,
    required this.onViewModeChanged,
  });

  final String selectedPrice;
  final ValueChanged<String> onPriceSelected;
  final String selectedYear;
  final ValueChanged<String> onYearSelected;
  final String selectedTransmission;
  final ValueChanged<String> onTransmissionSelected;
  final String selectedOdometer;
  final ValueChanged<String> onOdometerSelected;
  final String selectedLocation;
  final ValueChanged<String> onLocationSelected;
  final VoidCallback onResetFilters;
  final String selectedSort;
  final ValueChanged<String> onSortSelected;
  final bool isListView;
  final ValueChanged<bool> onViewModeChanged;
  
  @override
  State<SearchResultsToolbar> createState() => _SearchResultsToolbarState();
}

class _SearchResultsToolbarState extends State<SearchResultsToolbar> {
  String selectedYear = '2019 - 2024';
  String selectedTransmission = 'Semua';
  String selectedOdometer = 'Semua';
  String selectedLocation = 'Semua Area';

  static const Color panelColor = Color(0xFF191D24);
  static const Color textMuted = Color(0xFFA0A0A0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 6,
            vertical: isMobile ? 16 : 14,
          ),
          color: panelColor,
          child: Wrap(
            spacing: isMobile ? 12 : 10,
            runSpacing: isMobile ? 14 : 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: isMobile
                ? WrapAlignment.start
                : WrapAlignment.spaceBetween,
            children: [
              // Filter kendaraan
              Wrap(
                spacing: 5,
                runSpacing: 8,
                children: [
                  _PriceFilterDropdown(
                    label: 'Harga: ${widget.selectedPrice}',
                    onSelected: widget.onPriceSelected,
                  ),
                  _YearFilterDropdown(
                    label: 'Tahun: ${widget.selectedYear}',
                    onSelected: widget.onYearSelected,
                  ),
                  _TransmissionFilterDropdown(
                    label: 'Transmisi: ${widget.selectedTransmission}',
                    onSelected: widget.onTransmissionSelected,
                  ),
                  _OdometerFilterDropdown(
                    label: 'Odometer: ${widget.selectedOdometer}',
                    onSelected: widget.onOdometerSelected,
                  ),
                  _LocationFilterDropdown(
                    label: 'Lokasi: ${widget.selectedLocation}',
                    onSelected: widget.onLocationSelected,
                  ),
                ],
              ),

              // Pengurutan dan pilihan tampilan
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TextButton(
                    onPressed: widget.onResetFilters,
                    child: const Text(
                      'Reset Filter',
                      style: TextStyle(
                        color: Color(0xFFC9A45C),
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Text(
                    'Urutkan:',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 10,
                    ),
                  ),
                  _SortDropdown(
                    selectedSort: widget.selectedSort,
                    onSelected: widget.onSortSelected,
                  ),
                  _ViewModeButton(
                    icon: Icons.grid_view,
                    selected: !widget.isListView,
                    onTap: () => widget.onViewModeChanged(false),
                  ),
                  _ViewModeButton(
                    icon: Icons.view_list,
                    selected: widget.isListView,
                    onTap: () => widget.onViewModeChanged(true),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PriceFilterDropdown extends StatelessWidget {
  const _PriceFilterDropdown({
    required this.label,
    required this.onSelected,
  });

  final String label;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      color: const Color(0xFF242932),
      offset: const Offset(0, 40),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'Rp30 Jt - Rp100 Jt',
          child: Text(
            'Rp30 Jt - Rp100 Jt',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const PopupMenuItem(
          value: 'Rp100 Jt - Rp300 Jt',
          child: Text(
            'Rp100 Jt - Rp300 Jt',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const PopupMenuItem(
          value: 'Rp300 Jt - Rp600 Jt',
          child: Text(
            'Rp300 Jt - Rp600 Jt',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      child: Container(
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
      ),
    );
  }
}

class _YearFilterDropdown extends StatelessWidget {
  const _YearFilterDropdown({
    required this.label,
    required this.onSelected,
  });

  final String label;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      color: const Color(0xFF242932),
      offset: const Offset(0, 40),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: '2019 - 2020',
          child: Text(
            '2019 - 2020',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const PopupMenuItem(
          value: '2021 - 2022',
          child: Text(
            '2021 - 2022',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const PopupMenuItem(
          value: '2023 - 2024',
          child: Text(
            '2023 - 2024',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      child: Container(
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
      ),
    );
  }
}

class _TransmissionFilterDropdown extends StatelessWidget {
  const _TransmissionFilterDropdown({
    required this.label,
    required this.onSelected,
  });

  final String label;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      color: const Color(0xFF242932),
      offset: const Offset(0, 40),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'Semua',
          child: Text(
            'Semua Transmisi',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const PopupMenuItem(
          value: 'CVT',
          child: Text('CVT', style: TextStyle(color: Colors.white)),
        ),
        const PopupMenuItem(
          value: 'AT',
          child: Text('Otomatis (AT)', style: TextStyle(color: Colors.white)),
        ),
        const PopupMenuItem(
          value: 'MT',
          child: Text('Manual (MT)', style: TextStyle(color: Colors.white)),
        ),
      ],
      child: Container(
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
      ),
    );
  }
}

class _OdometerFilterDropdown extends StatelessWidget {
  const _OdometerFilterDropdown({
    required this.label,
    required this.onSelected,
  });

  final String label;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      color: const Color(0xFF242932),
      offset: const Offset(0, 40),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'Semua',
          child: Text('Semua Odometer',
              style: TextStyle(color: Colors.white)),
        ),
        const PopupMenuItem(
          value: '< 30.000 KM',
          child: Text('< 30.000 KM',
              style: TextStyle(color: Colors.white)),
        ),
        const PopupMenuItem(
          value: '30.000 - 60.000 KM',
          child: Text('30.000 - 60.000 KM',
              style: TextStyle(color: Colors.white)),
        ),
        const PopupMenuItem(
          value: '> 60.000 KM',
          child: Text('> 60.000 KM',
              style: TextStyle(color: Colors.white)),
        ),
      ],
      child: Container(
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
      ),
    );
  }
}

class _LocationFilterDropdown extends StatelessWidget {
  const _LocationFilterDropdown({
    required this.label,
    required this.onSelected,
  });

  final String label;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      color: const Color(0xFF242932),
      offset: const Offset(0, 40),
      
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'Semua Area',
          child: Text(
            'Semua Area',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ...VehicleData.availableLocations.map(
          (location) => PopupMenuItem<String>(
            value: location,
            child: Text(
              location,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
      child: Container(
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
      ),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  const _SortDropdown({
    required this.selectedSort,
    required this.onSelected,
  });

  final String selectedSort;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      color: const Color(0xFF242932),
      offset: const Offset(0, 40),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'Rekomendasi',
          child: Text(
            'Rekomendasi',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const PopupMenuItem(
          value: 'Harga Termurah',
          child: Text(
            'Harga Termurah',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const PopupMenuItem(
          value: 'Harga Termahal',
          child: Text(
            'Harga Termahal',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const PopupMenuItem(
          value: 'Tahun Terbaru',
          child: Text(
            'Tahun Terbaru',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const PopupMenuItem(
          value: 'Odometer Terendah',
          child: Text(
            'Odometer Terendah',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      child: Container(
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
              selectedSort,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            const SizedBox(width: 7),
            const Icon(
              Icons.sort,
              color: Color(0xFFC9A45C),
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewModeButton extends StatelessWidget {
  const _ViewModeButton({
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
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
      ),
    );
  }
}
