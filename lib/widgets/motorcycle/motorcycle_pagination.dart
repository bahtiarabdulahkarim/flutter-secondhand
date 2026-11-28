import 'package:flutter/material.dart';

class MotorcyclePagination extends StatelessWidget {
  const MotorcyclePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  static const Color gold = Color(0xFFD8B45F);
  static const Color muted = Color(0xFFA0A5AE);

  List<int> get _visiblePages {
    if (totalPages <= 5) {
      return List.generate(totalPages, (index) => index + 1);
    }

    if (currentPage <= 3) {
      return [1, 2, 3, 4, 5];
    }

    if (currentPage >= totalPages - 2) {
      return List.generate(
        5,
        (index) => totalPages - 4 + index,
      );
    }

    return [
      currentPage - 2,
      currentPage - 1,
      currentPage,
      currentPage + 1,
      currentPage + 2,
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;

        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 7,
          runSpacing: 10,
          children: [
            _navigationButton(
              label: isMobile ? '‹' : 'Sebelumnya',
              enabled: currentPage > 1,
              onTap: () => onPageChanged(currentPage - 1),
              width: isMobile ? 38 : 105,
            ),

            ..._visiblePages.map((page) {
              return _pageButton(page);
            }),

            _navigationButton(
              label: isMobile ? '›' : 'Selanjutnya',
              enabled: currentPage < totalPages,
              onTap: () => onPageChanged(currentPage + 1),
              width: isMobile ? 38 : 105,
            ),
          ],
        );
      },
    );
  }

  Widget _pageButton(int page) {
    final isActive = currentPage == page;

    return InkWell(
      onTap: () => onPageChanged(page),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? gold : const Color(0xFF242932),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isActive
                ? gold
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            color: isActive
                ? const Color(0xFF10151D)
                : muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _navigationButton({
    required String label,
    required bool enabled,
    required VoidCallback onTap,
    required double width,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: width,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF242932),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: enabled ? gold : muted.withValues(alpha: 0.4),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}