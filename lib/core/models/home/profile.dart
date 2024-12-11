class CPOResponse {
  final bool success;
  final String message;
  final CPOData data;

  CPOResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CPOResponse.fromJson(Map<String, dynamic> json) => CPOResponse(
        success: json['success'] as bool,
        message: json['message'] as String,
        data: CPOData.fromJson(json['data'] as Map<String, dynamic>),
      );
}

class CPOData {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String org;
  final String role;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool stayLoggedIn;
  final Organization organization;
  final List<Station> stations;

  CPOData({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.org,
    required this.role,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.stayLoggedIn,
    required this.organization,
    required this.stations,
  });

  factory CPOData.fromJson(Map<String, dynamic> json) => CPOData(
        id: json['_id'] as String,
        name: json['name'] as String,
        phoneNumber: json['phoneNumber'] as String,
        email: json['email'] as String,
        org: json['org'] as String,
        role: json['role'] as String,
        active: json['active'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        stayLoggedIn: json['stayLoggedIn'] as bool,
        organization: Organization.fromJson(json['organization'] as Map<String, dynamic>),
        stations: (json['stations'] as List<dynamic>)
            .map((station) => Station.fromJson(station as Map<String, dynamic>))
            .toList(),
      );
}

class Organization {
  final String id;
  final String name;
  final String phoneNo;
  final String email;
  final String billingFullAddress;

  Organization({
    required this.id,
    required this.name,
    required this.phoneNo,
    required this.email,
    required this.billingFullAddress,
  });

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json['_id'] as String,
        name: json['name'] as String,
        phoneNo: json['phoneNo'] as String,
        email: json['email'] as String,
        billingFullAddress: json['billingFullAddress'] as String,
      );
}

class Station {
  final String id;
  final String name;
  final String org;
  final String status;
  final String powerCapacity;
  final String gridPhase;
  final String pinCode;
  final String city;
  final String state;
  final String country;
  final Location loc;
  final String fullAddress;
  final String openingTime;
  final String closingTime;
  final String contactNumber;
  final String stationType;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String locationId;
  final int totalConnectorCount;
  final int availableConnectorCount;
  final String? stationIncharge;
  final bool? isHubStation;

  Station({
    required this.id,
    required this.name,
    required this.org,
    required this.status,
    required this.powerCapacity,
    required this.gridPhase,
    required this.pinCode,
    required this.city,
    required this.state,
    required this.country,
    required this.loc,
    required this.fullAddress,
    required this.openingTime,
    required this.closingTime,
    required this.contactNumber,
    required this.stationType,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.locationId,
    required this.totalConnectorCount,
    required this.availableConnectorCount,
    this.stationIncharge,
    this.isHubStation,
  });

  factory Station.fromJson(Map<String, dynamic> json) => Station(
        id: json['_id'] as String,
        name: json['name'] as String,
        org: json['org'] as String,
        status: json['status'] as String,
        powerCapacity: json['powerCapacity'] as String,
        gridPhase: json['gridPhase'] as String,
        pinCode: json['pinCode'] as String,
        city: json['city'] as String,
        state: json['state'] as String,
        country: json['country'] as String,
        loc: Location.fromJson(json['loc'] as Map<String, dynamic>),
        fullAddress: json['fullAddress'] as String,
        openingTime: json['openingTime'] as String,
        closingTime: json['closingTime'] as String,
        contactNumber: json['contactNumber'] as String,
        stationType: json['stationType'] as String,
        createdBy: json['createdBy'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        locationId: json['locationId'] as String,
        totalConnectorCount: json['totalConnectorCount'] as int,
        availableConnectorCount: json['availableConnectorCount'] as int,
        stationIncharge: json['stationIncharge'] as String?,
        isHubStation: json['isHubStation'] as bool?,
      );
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json['type'] as String,
        coordinates: (json['coordinates'] as List<dynamic>)
            .map((coord) => double.tryParse(coord.toString()) ?? 0.0)
            .toList(),
      );
}