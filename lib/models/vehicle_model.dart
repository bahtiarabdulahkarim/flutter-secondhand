class VehicleModel {
  final String id;
  final String name;
  final String category;
  final String brand;
  final String model;
  final int year;
  final int price;
  final int odometer;
  final String transmission;
  final String location;
  final String imageUrl;
  final String grade;
  final String status;
  final int? engineCc;

  const VehicleModel({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.model,
    required this.year,
    required this.price,
    required this.odometer,
    required this.transmission,
    required this.location,
    required this.imageUrl,
    required this.grade,
    required this.status,
    this.engineCc,
  });
}