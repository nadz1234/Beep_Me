class VehicleListViewModel {
  String status;
  String message;
  String identity;
  List<Vehicle> vehicle;

  VehicleListViewModel(
      {required this.status,
      required this.message,
      required this.identity,
      required this.vehicle});

  factory VehicleListViewModel.fromJson(Map<String, dynamic> json) {
    return VehicleListViewModel(
        status: json['status'],
        message: json['message'],
        identity: json['identity'],
        vehicle: json['vehicle']);
  }
}

class Vehicle {
  String friendlyName;
  String vehicleStockId;
  String stockCode;
  String image;
  String allImages;

  Vehicle(
      {required this.friendlyName,
      required this.vehicleStockId,
      required this.stockCode,
      required this.image,
      required this.allImages});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
        friendlyName: json['friendlyName'],
        vehicleStockId: json['vehicleStockId'],
        stockCode: json['stockCode'],
        image: json['image'],
        allImages: json['allImages']);
  }
}
