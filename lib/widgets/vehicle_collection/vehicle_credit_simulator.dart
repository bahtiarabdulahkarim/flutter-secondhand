import 'package:flutter/material.dart';

class VehicleCreditSimulator extends StatefulWidget {
  const VehicleCreditSimulator({super.key});

  @override
  State<VehicleCreditSimulator> createState() =>
      _VehicleCreditSimulatorState();
}

class _VehicleCreditSimulatorState
    extends State<VehicleCreditSimulator> {
  static const Color gold = Color(0xFFC9A45C);
  static const Color darkColor = Color(0xFF0D1015);

  double carPrice = 475000000;
  int downPaymentPercent = 20;
  int tenor = 48;

  static const double interestRate = 0.031;

  double get downPayment =>
      carPrice * downPaymentPercent / 100;

  double get loanAmount => carPrice - downPayment;

  double get totalInterest =>
      loanAmount * interestRate * (tenor / 12);

  double get monthlyInstallment =>
      (loanAmount + totalInterest) / tenor;

  String formatRupiah(double value) {
    final formatted = value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );

    return 'Rp $formatted';
  }

  Widget sectionLabel(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: gold,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget optionButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? gold : const Color(0xFF303640),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? darkColor : Colors.white,
              fontSize: 12,
              fontWeight:
                  selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSimulatorControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionLabel(
          'Harga Mobil Bekas',
          formatRupiah(carPrice),
        ),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: gold,
            inactiveTrackColor: Colors.white24,
            thumbColor: gold,
            overlayColor: gold.withValues(alpha: 0.15),
            trackHeight: 4,
          ),
          child: Slider(
            value: carPrice,
            min: 100000000,
            max: 1500000000,
            divisions: 140,
            onChanged: (value) {
              setState(() => carPrice = value);
            },
          ),
        ),

        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rp100 jt',
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
            Text(
              'Rp750 jt',
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
            Text(
              'Rp1,5 M+',
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),

        const SizedBox(height: 24),

        sectionLabel(
          'Uang Muka (DP)',
          '${formatRupiah(downPayment)} ($downPaymentPercent%)',
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            for (final percent in [20, 30, 40, 50]) ...[
              if (percent != 20) const SizedBox(width: 5),
              optionButton(
                label: '$percent%',
                selected: downPaymentPercent == percent,
                onTap: () {
                  setState(() => downPaymentPercent = percent);
                },
              ),
            ],
          ],
        ),

        const SizedBox(height: 24),

        sectionLabel('Jangka Waktu (Tenor)', '$tenor Bulan'),

        const SizedBox(height: 12),

        Row(
          children: [
            for (final month in [12, 24, 36, 48, 60]) ...[
              if (month != 12) const SizedBox(width: 5),
              optionButton(
                label: '$month Bln',
                selected: tenor == month,
                onTap: () {
                  setState(() => tenor = month);
                },
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget buildSimulationResult() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: darkColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ESTIMASI ANGSURAN BULANAN',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Bunga 3.1% Flat',
                  style: TextStyle(
                    color: gold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatRupiah(monthlyInstallment),
              style: const TextStyle(
                color: gold,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            '* Estimasi ini belum termasuk premi asuransi dan biaya lain.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),

          const SizedBox(height: 30),

          detailRow('Pokok Hutang Pembiayaan', loanAmount),
          const SizedBox(height: 12),
          detailRow('Total Bunga Pembiayaan', totalInterest),
          const SizedBox(height: 12),
          detailRow('Uang Muka (DP)', downPayment),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Fitur Pre-Approval akan segera tersedia.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.bolt, size: 18),
              label: const Text(
                'Ajukan Pre-Approval Instan',
                style: TextStyle(fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: darkColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Center(
            child: Text(
              'Tanpa biaya survei awal • Estimasi simulasi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailRow(String title, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          formatRupiah(value),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF252A33),
            Color(0xFF171C24),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          final information = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.calculate_outlined,
                      color: gold, size: 14),
                  SizedBox(width: 8),
                  Text(
                    'SIMULASI KREDIT PRESISI',
                    style: TextStyle(
                      color: gold,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text(
                'Hitung Cicilan Mobil Impian Anda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Rencanakan pembiayaan fleksibel dengan mitra perbankan terpercaya. '
                'Bunga bersaing mulai 2.99% flat p.a.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 25),

              buildSimulatorControls(),
            ],
          );

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                information,
                const SizedBox(height: 30),
                buildSimulationResult(),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: information,
              ),
              const SizedBox(width: 25),
              Expanded(
                flex: 4,
                child: buildSimulationResult(),
              ),
            ],
          );
        },
      ),
    );
  }
}
