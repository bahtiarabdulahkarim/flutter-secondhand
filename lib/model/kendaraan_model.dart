class Kendaraan {
  String _merk;
  String _model;
  int _tahun;
  double _harga;
  String _warna;
  int _kilometer;
  String _gambar;
  String _deskripsi;

  Kendaraan({
    required String merk,
    required String model,
    required int tahun,
    required double harga,
    required String warna,
    required int kilometer,
    required String gambar,
    required String deskripsi,
  }) : _merk = merk,
       _model = model,
       _tahun = tahun,
       _harga = harga,
       _warna = warna,
       _kilometer = kilometer,
       _gambar = gambar,
       _deskripsi = deskripsi;

  // =========================
  // GETTER
  // =========================

  String get merk => _merk;
  String get model => _model;
  int get tahun => _tahun;
  double get harga => _harga;
  String get warna => _warna;
  int get kilometer => _kilometer;
  String get gambar => _gambar;
  String get deskripsi => _deskripsi;

  // =========================
  // SETTER
  // =========================

  set merk(String value) {
    _merk = value;
  }

  set model(String value) {
    _model = value;
  }

  set tahun(int value) {
    _tahun = value;
  }

  set harga(double value) {
    _harga = value;
  }

  set warna(String value) {
    _warna = value;
  }

  set kilometer(int value) {
    _kilometer = value;
  }

  set gambar(String value) {
    _gambar = value;
  }

  set deskripsi(String value) {
    _deskripsi = value;
  }

  // =========================
  // FUNCTION / METHOD
  // =========================

  String getNamaKendaraan() {
    return '$merk $model';
  }

  String getHarga() {
    return 'Rp ${harga.toStringAsFixed(0)}';
  }

  String getInfo() {
    return '$merk $model • $tahun • $kilometer km';
  }

  void ubahHarga(double hargaBaru) {
    _harga = hargaBaru;
  }
}

// =====================================================
// INHERITANCE - MOBIL
// =====================================================

class Mobil extends Kendaraan {
  int _jumlahPintu;
  String _transmisi;

  Mobil({
    required super.merk,
    required super.model,
    required super.tahun,
    required super.harga,
    required super.warna,
    required super.kilometer,
    required super.gambar,
    required super.deskripsi,
    required int jumlahPintu,
    required String transmisi,
  }) : _jumlahPintu = jumlahPintu,
       _transmisi = transmisi;

  int get jumlahPintu => _jumlahPintu;

  String get transmisi => _transmisi;

  set jumlahPintu(int value) {
    _jumlahPintu = value;
  }

  set transmisi(String value) {
    _transmisi = value;
  }

  String getInfoMobil() {
    return '$merk $model • $transmisi • $jumlahPintu pintu';
  }
}

// =====================================================
// INHERITANCE - MOTOR
// =====================================================

class Motor extends Kendaraan {
  String _jenisMotor;
  int _kapasitasMesin;

  Motor({
    required super.merk,
    required super.model,
    required super.tahun,
    required super.harga,
    required super.warna,
    required super.kilometer,
    required super.gambar,
    required super.deskripsi,
    required String jenisMotor,
    required int kapasitasMesin,
  }) : _jenisMotor = jenisMotor,
       _kapasitasMesin = kapasitasMesin;

  String get jenisMotor => _jenisMotor;

  int get kapasitasMesin => _kapasitasMesin;

  set jenisMotor(String value) {
    _jenisMotor = value;
  }

  set kapasitasMesin(int value) {
    _kapasitasMesin = value;
  }

  String getInfoMotor() {
    return '$merk $model • $kapasitasMesin cc • $jenisMotor';
  }
}
