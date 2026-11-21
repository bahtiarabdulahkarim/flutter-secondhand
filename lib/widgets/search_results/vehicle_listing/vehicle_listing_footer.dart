import 'package:flutter/material.dart';

class VehicleListingFooter extends StatelessWidget {
  const VehicleListingFooter({super.key});

  static const Color goldColor = Color(0xFFC9A45C);
  static const Color textWhite = Colors.white;
  static const Color textMuted = Color(0xFFA0A0A0);
  static const Color panelColor = Color(0xFF191D24);

  @override
  Widget build(BuildContext context) {
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
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ResultInformation(),
                SizedBox(height: 16),
                _ServiceInformation(),
                SizedBox(height: 16),
                _PaginationControls(),
              ],
            );
          }

          return const Row(
            children: [
              Expanded(
                flex: 4,
                child: _ResultInformation(),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 6,
                child: _ServiceInformation(),
              ),
              SizedBox(width: 20),
              _PaginationControls(),
            ],
          );
        },
      ),
    );
  }
}

class _ResultInformation extends StatelessWidget {
  const _ResultInformation();

  @override
  Widget build(BuildContext context) {
    return const Row(
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
                'Menampilkan 1–18 dari total 18 Unit Honda',
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
  const _PaginationControls();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.chevron_left,
          color: Colors.white30,
          size: 20,
        ),
        SizedBox(width: 12),
        _PageNumber(),
        SizedBox(width: 12),
        Icon(
          Icons.chevron_right,
          color: VehicleListingFooter.textMuted,
          size: 20,
        ),
      ],
    );
  }
}

class _PageNumber extends StatelessWidget {
  const _PageNumber();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: VehicleListingFooter.goldColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        '1',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
