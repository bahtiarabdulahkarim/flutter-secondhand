import '../models/vehicle_model.dart';

class VehicleData {
  static const List<VehicleModel> vehicles = [
    VehicleModel(
      id: 'CAR001',
      name: '2023 Honda CR-V 1.5 Turbo',
      category: 'Mobil',
      brand: 'Honda',
      model: 'Honda CR-V',
      year: 2023,
      price: 485000000,
      odometer: 19200,
      transmission: 'CVT Otomatis',
      location: 'Jakarta Selatan',
      imageUrl: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=900&q=85',
      grade: 'A+',
      status: 'Tersedia',
    ),
    VehicleModel(
      id: 'CAR002',
      name: '2022 Honda HR-V SE',
      category: 'Mobil',
      brand: 'Honda',
      model: 'Honda HR-V',
      year: 2022,
      price: 325000000,
      odometer: 24500,
      transmission: 'CVT Otomatis',
      location: 'Jakarta Pusat',
      imageUrl: 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=900&q=85',
      grade: 'A',
      status: 'Tersedia',
    ),
    VehicleModel(
      id: 'CAR003',
      name: '2023 Honda Civic RS Turbo',
      category: 'Mobil',
      brand: 'Honda',
      model: 'Honda Civic RS & Turbo',
      year: 2023,
      price: 535000000,
      odometer: 12800,
      transmission: 'CVT Otomatis',
      location: 'Jakarta Barat',
      imageUrl: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=900&q=85',
      grade: 'A+',
      status: 'Tersedia',
    ),
    VehicleModel(
      id: 'CAR004',
      name: '2022 Honda Brio RS',
      category: 'Mobil',
      brand: 'Honda',
      model: 'Honda Brio',
      year: 2022,
      price: 185000000,
      odometer: 15000,
      transmission: 'CVT Otomatis',
      location: 'Jakarta Selatan',
      imageUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=900&q=85',
      grade: 'A',
      status: 'Tersedia',
    ),
    VehicleModel(
      id: 'CAR005',
      name: '2022 Toyota Camry 2.5 V',
      category: 'Mobil',
      brand: 'Toyota',
      model: 'Toyota Camry',
      year: 2022,
      price: 525000000,
      odometer: 18000,
      transmission: 'CVT Otomatis',
      location: 'Jakarta Utara',
      imageUrl: 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?auto=format&fit=crop&w=900&q=85',
      grade: 'A+',
      status: 'Tersedia',
    ),
    VehicleModel(
      id: 'CAR006',
      name: '2023 Toyota Fortuner 2.8 VRZ',
      category: 'Mobil',
      brand: 'Toyota',
      model: 'Toyota Fortuner',
      year: 2023,
      price: 585000000,
      odometer: 15000,
      transmission: 'Otomatis',
      location: '	Tangerang',
      imageUrl: 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=900&q=85',
      grade: 'A+',
      status: 'Tersedia',
    ),
    VehicleModel(
      id: 'CAR007',
      name: '2022 BMW 320i Sport',
      category: 'Mobil',
      brand: 'BMW',
      model: 'BMW 320i',
      year: 2022,
      price: 695000000,
      odometer: 12000,
      transmission: 'Otomatis',
      location: 'Bekasi',
      imageUrl: 'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=900&q=85',
      grade: 'A+',
      status: 'Tersedia',
    ),
    VehicleModel(
      id: 'CAR008',
      name: '2023 BMW X3 xDrive20i',
      category: 'Mobil',
      brand: 'BMW',
      model: 'BMW X3',
      year: 2023,
      price: 875000000,
      odometer: 10000,
      transmission: 'Otomatis',
      location: 'Depok',
      imageUrl: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=900&q=85',
      grade: 'A+',
      status: 'Tersedia',
    ),
    VehicleModel(
      id: 'CAR009',
      name: '2022 Audi A4 2.0 TFSI',
      category: 'Mobil',
      brand: 'Audi',
      model: 'Audi A4',
      year: 2022,
      price: 625000000,
      odometer: 14000,
      transmission: 'Otomatis',
      location: 'Jakarta Selatan',
      imageUrl: 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?auto=format&fit=crop&w=900&q=85',
      grade: 'A+',
      status: 'Tersedia',
    ),
    VehicleModel(
      id: 'CAR010',
      name: '2023 Audi Q5 2.0 TFSI',
      category: 'Mobil',
      brand: 'Audi',
      model: 'Audi Q5',
      year: 2023,
      price: 825000000,
      odometer: 11000,
      transmission: 'Otomatis',
      location: 'Jakarta Pusat',
      imageUrl: 'https://images.unsplash.com/photo-1603584173870-7f23fdae1b7a?auto=format&fit=crop&w=900&q=85',
      grade: 'A+',
      status: 'Tersedia',
    ),
    VehicleModel(
      id: 'CAR011',
      name: '2022 Ferrari Roma 3.9 V8',
      category: 'Mobil',
      brand: 'Ferrari',
      model: 'Ferrari Roma',
      year: 2022,
      price: 5500000000,
      odometer: 5000,
      transmission: 'Otomatis',
      location: 'Tangerang',
      imageUrl: 'https://images.unsplash.com/photo-1592198084033-aade902d1aae?auto=format&fit=crop&w=900&q=85',
      grade: 'A+',
      status: 'Tersedia',
    ),
    VehicleModel(
      id: 'CAR012',
      name: '2023 Ferrari 296 GTB',
      category: 'Mobil',
      brand: 'Ferrari',
      model: 'Ferrari 296 GTB',
      year: 2023,
      price: 7500000000,
      odometer: 3000,
      transmission: 'Otomatis',
      location: 'Bekasi',
      imageUrl: 'https://images.unsplash.com/photo-1583121274602-3e2820c69888?auto=format&fit=crop&w=900&q=85',
      grade: 'A+',
      status: 'Tersedia',
    ),
  ];

  // Daftar merek kendaraan secara otomatis
  static List<String> get availableBrands {
    return vehicles
        .map((vehicle) => vehicle.brand)
        .toSet()
        .toList()
      ..sort();
  }
  
  // Daftar lokasi kendaraan secara otomatis
  static List<String> get availableLocations {
    return vehicles
        .map((vehicle) => vehicle.location)
        .toSet()
        .toList()
      ..sort();
  }

  static List<VehicleModel> filterVehicles({
  String? brand,
  String? model,
  String? keyword,
    int? minPrice,
    int? maxPrice,
    int? minYear,
    int? maxYear,
    String? transmission,
    int? minOdometer,
    int? maxOdometer,
    String? location,
    String sortBy = 'Rekomendasi',
  }) {
    final filteredVehicles = vehicles.where((vehicle) {
      final searchText = keyword?.trim().toLowerCase() ?? '';

      final matchesKeyword = searchText.isEmpty ||
          vehicle.name.toLowerCase().contains(searchText) ||
          vehicle.brand.toLowerCase().contains(searchText) ||
          vehicle.model.toLowerCase().contains(searchText);
      final matchesBrand =
          brand == null || vehicle.brand == brand;

      final matchesLocation =
        location == null || vehicle.location == location;

      final matchesModel =
          model == null || vehicle.model == model;

      final matchesMinPrice =
          minPrice == null || vehicle.price >= minPrice;

      final matchesMaxPrice =
          maxPrice == null || vehicle.price <= maxPrice;

      final matchesMinYear =
          minYear == null || vehicle.year >= minYear;

      final matchesMaxYear =
          maxYear == null || vehicle.year <= maxYear;
      
      final matchesTransmission =
        transmission == null ||
        vehicle.transmission.toLowerCase().contains(
          transmission.toLowerCase(),
        );
      
      final matchesMinOdometer =
          minOdometer == null || vehicle.odometer >= minOdometer;

      final matchesMaxOdometer =
          maxOdometer == null || vehicle.odometer <= maxOdometer;

      return matchesKeyword &&
        matchesBrand &&
        matchesLocation &&
        matchesModel &&
        matchesMinPrice &&
        matchesMaxPrice &&
        matchesMinYear &&
        matchesMaxYear &&
        matchesTransmission &&
        matchesMinOdometer &&
        matchesMaxOdometer;
    }).toList();
    switch (sortBy) {
      case 'Harga Termurah':
        filteredVehicles.sort((a, b) => a.price.compareTo(b.price));
        break;

      case 'Harga Termahal':
        filteredVehicles.sort((a, b) => b.price.compareTo(a.price));
        break;

      case 'Tahun Terbaru':
        filteredVehicles.sort((a, b) => b.year.compareTo(a.year));
        break;

      case 'Odometer Terendah':
        filteredVehicles.sort((a, b) => a.odometer.compareTo(b.odometer));
        break;

      case 'Rekomendasi':
      default:
        break;
    }

    return filteredVehicles;
  }
}