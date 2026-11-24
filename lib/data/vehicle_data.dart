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
      location: 'Jakarta Selatan',
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
      location: 'Jakarta Selatan',
      imageUrl: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=900&q=85',
      grade: 'A+',
      status: 'Tersedia',
    ),
    VehicleModel(
      id: 'CAR004',
      name: '2022 Honda Brio RS',
      category: 'Mobil',
      brand: 'Honda',
      model: 'Honda Brio RS',
      year: 2022,
      price: 185000000,
      odometer: 15000,
      transmission: 'CVT Otomatis',
      location: 'Jakarta Selatan',
      imageUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=900&q=85',
      grade: 'A',
      status: 'Tersedia',
    ),
  ];
  
  static List<VehicleModel> filterVehicles({
    String? brand,
    String? model,
    int? minPrice,
    int? maxPrice,
    int? minYear,
    int? maxYear,
    String? transmission,
    int? minOdometer,
    int? maxOdometer,
    String? location,
  }) {
    return vehicles.where((vehicle) {
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

      return matchesBrand &&
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
  }
}