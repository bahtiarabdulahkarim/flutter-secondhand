import 'package:flutter/material.dart';

class VehicleListingFooter extends StatelessWidget {
  const VehicleListingFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageSelected,
  });

  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final ValueChanged<int> onPageSelected;

  static const Color goldColor = Color(0xFFC9A45C);
  static const Color textWhite = Colors.white;
  static const Color textMuted = Color(0xFFA0A0A0);
  static const Color panelColor = Color(0xFF191D24);

  @override
  Widget build(BuildContext context) {
    final safeTotalPages = totalPages < 1 ? 1 : totalPages;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ResultInformation(
                  currentPage: currentPage,
                  totalItems: totalItems,
                  itemsPerPage: itemsPerPage,
                ),
                const SizedBox(height: 16),
                const _ServiceInformation(),
                const SizedBox(height: 16),
                _PaginationControls(
                  currentPage: currentPage,
                  totalPages: safeTotalPages,
                  onPageSelected: onPageSelected,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                flex: 4,
                child: _ResultInformation(
                  currentPage: currentPage,
                  totalItems: totalItems,
                  itemsPerPage: itemsPerPage,
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                flex: 6,
                child: _ServiceInformation(),
              ),
              const SizedBox(width: 20),
              _PaginationControls(
                currentPage: currentPage,
                totalPages: safeTotalPages,
                onPageSelected: onPageSelected,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ResultInformation extends StatelessWidget {
  const _ResultInformation({
    required this.currentPage,
    required this.totalItems,
    required this.itemsPerPage,
  });

  final int currentPage;
  final int totalItems;
  final int itemsPerPage;

  @override
  Widget build(BuildContext context) {

    final startItem = totalItems == 0
        ? 0
        : (currentPage - 1) * itemsPerPage + 1;

    final endItem = (currentPage * itemsPerPage) > totalItems
        ? totalItems
        : currentPage * itemsPerPage;

    return Row(
      children: [
        Icon(
          Icons.verified_outlined,
          color: VehicleListingFooter.goldColor,
          size: 17,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Menampilkan $startItem–$endItem dari total $totalItems Unit Honda',
                style: TextStyle(
                  color: VehicleListingFooter.textMuted,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Terverifikasi!',
                style: TextStyle(
                  color: VehicleListingFooter.textWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ServiceInformation extends StatelessWidget {
  const _ServiceInformation();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.business_outlined,
          color: VehicleListingFooter.textMuted,
          size: 16,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Semua unit siap inspeksi mandiri di bengkel resmi atau test drive di rumah tanpa komitmen pembelian.',
            style: TextStyle(
              color: VehicleListingFooter.textMuted,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: currentPage > 1
              ? () => onPageSelected(currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left),
          color: VehicleListingFooter.textMuted,
          disabledColor: Colors.white30,
        ),
        const SizedBox(width: 8),
        _PageNumber(
          currentPage: currentPage,
          totalPages: totalPages,
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: currentPage < totalPages && totalPages > 1
            ? () => onPageSelected(currentPage + 1)
            : null,
          icon: const Icon(Icons.chevron_right),
          color: VehicleListingFooter.textMuted,
          disabledColor: Colors.white30,
        ),
      ],
    );
  }
}

class _PageNumber extends StatelessWidget {
  const _PageNumber({
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: VehicleListingFooter.goldColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        '$currentPage / $totalPages',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}