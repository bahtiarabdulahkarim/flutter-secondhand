String formatRupiah(int value) {
  final digits = value.toString();

  final formatted = digits.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]}.',
  );

  return 'Rp $formatted';
}