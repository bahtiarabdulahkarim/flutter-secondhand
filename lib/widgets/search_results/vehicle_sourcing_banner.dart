import 'package:flutter/material.dart';

class VehicleSourcingBanner extends StatelessWidget {
  const VehicleSourcingBanner({super.key});

  static const Color goldColor = Color(0xFFC9A45C);
  static const Color textWhite = Colors.white;
  static const Color textMuted = Color(0xFFA0A0A0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF242932),
            Color(0xFF343434),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 650;

          if (isMobile) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SourcingInformation(),
                SizedBox(height: 24),
                _ConciergeButton(),
              ],
            );
          }

          return const Row(
            children: [
              Expanded(
                flex: 7,
                child: _SourcingInformation(),
              ),
              SizedBox(width: 30),
              Expanded(
                flex: 3,
                child: _ConciergeButton(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SourcingInformation extends StatelessWidget {
  const _SourcingInformation();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label layanan
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF191D24),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                color: VehicleSourcingBanner.goldColor,
                size: 12,
              ),
              SizedBox(width: 7),
              Text(
                'LAYANAN BESPOKE SOURCING',
                style: TextStyle(
                  color: VehicleSourcingBanner.goldColor,
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Judul
        const Text(
          'Mencari Tipe atau Warna Honda Tertentu?',
          style: TextStyle(
            color: VehicleSourcingBanner.textWhite,
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        // Deskripsi
        const Text(
          'Tim Concierge SECONDHAND memiliki akses langsung ke inventaris privat dan kolektor terpercaya se-Indonesia. Beritahu spesifikasi Honda impian Anda—kami inspeksi 175-titik dan garansi bebas banjir serta benturan struktural dalam tempo 24 jam.',
          style: TextStyle(
            color: VehicleSourcingBanner.textMuted,
            fontSize: 12,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 14),

        // Keunggulan layanan
        const Wrap(
          spacing: 16,
          runSpacing: 10,
          children: [
            _BenefitItem(
              text: '100% Bebas Tabrakan & Banjir',
            ),
            _BenefitItem(
              text: 'Kelengkapan Dokumen BPKB Asli',
            ),
            _BenefitItem(
              text: 'Garansi Mesin & Transmisi 1 Tahun',
            ),
          ],
        ),
      ],
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final String text;

  const _BenefitItem({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: VehicleSourcingBanner.goldColor,
          size: 14,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: VehicleSourcingBanner.textWhite,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _ConciergeButton extends StatelessWidget {
  const _ConciergeButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            onPressed: null,
            icon: const Icon(
              Icons.support_agent,
              size: 17,
            ),
            label: const Text(
              'Hubungi Concierge Honda',
              style: TextStyle(fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: VehicleSourcingBanner.goldColor,
              foregroundColor: Colors.black,
              disabledBackgroundColor: VehicleSourcingBanner.goldColor,
              disabledForegroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Respons rata-rata: < 5 menit via WhatsApp Prioritas',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: VehicleSourcingBanner.textMuted,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
