class Location {
  final String type;
  final List<num> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
      coordinates: List<num>.from(json['coordinates'] ?? [0, 0]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class Charger {
  final String id;
  final String deviceId;
  final String chargingPointType;
  final String type;
  final num minCharges;
  final int connectorId;
  final String connectorType;
  final num maxPower;
  final String status;

  Charger({
    required this.id,
    required this.deviceId,
    required this.chargingPointType,
    required this.type,
    required this.minCharges,
    required this.connectorId,
    required this.connectorType,
    required this.maxPower,
    required this.status,
  });

  factory Charger.fromJson(Map<String, dynamic> json) {
    return Charger(
      id: json['_id'] ?? '',
      deviceId: json['device_id'] ?? '',
      chargingPointType: json['chargingPointType'] ?? '',
      type: json['type'] ?? '',
      minCharges: json['minCharges'] ?? 0,
      connectorId: json['connectorId'] ?? 0,
      connectorType: json['connectorType'] ?? '',
      maxPower: json['maxPower'] ?? 0,
      status: json['status'] ?? 'Inactive',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'device_id': deviceId,
      'chargingPointType': chargingPointType,
      'type': type,
      'minCharges': minCharges,
      'connectorId': connectorId,
      'connectorType': connectorType,
      'maxPower': maxPower,
      'status': status,
    };
  }
}

class ChargingStation {
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
  final String? openingTime;
  final String? closingTime;
  final String contactNumber;
  final String stationType;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? locationId;
  final bool isHubStation;
  final String? stationIncharge;
  final bool? owerSessionAlert;
  final String? ownerName;
  final String? ownerPhoneNumber;
  final num? parkingFee;
  final num? parkingGracePeriod;
  final List<Charger> chargers;

  ChargingStation({
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
    this.openingTime,
    this.closingTime,
    required this.contactNumber,
    required this.stationType,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.locationId,
    required this.isHubStation,
    this.stationIncharge,
    this.owerSessionAlert,
    this.ownerName,
    this.ownerPhoneNumber,
    this.parkingFee,
    this.parkingGracePeriod,
    required this.chargers,
  });

  factory ChargingStation.fromJson(Map<String, dynamic> json) {
    return ChargingStation(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      org: json['org'] ?? '',
      status: json['status'] ?? 'Inactive',
      powerCapacity: json['powerCapacity']?.toString() ?? '0',
      gridPhase: json['gridPhase'] ?? 'Unknown',
      pinCode: json['pinCode'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      loc: Location.fromJson(json['loc'] ??
          {
            'type': 'Point',
            'coordinates': [0, 0]
          }),
      fullAddress: json['fullAddress'] ?? '',
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
      contactNumber: json['contactNumber'] ?? '',
      stationType: json['stationType'] ?? 'Unknown',
      createdBy: json['createdBy'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      locationId: json['locationId'],
      isHubStation: json['isHubStation'] ?? false,
      stationIncharge: json['stationIncharge'],
      owerSessionAlert: json['owerSessionAlert'],
      ownerName: json['ownerName'],
      ownerPhoneNumber: json['ownerPhoneNumber'],
      parkingFee: json['parkingFee'],
      parkingGracePeriod: json['parkingGracePeriod'],
      chargers: (json['chargers'] as List? ?? [])
          .map((charger) => Charger.fromJson(charger))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'org': org,
      'status': status,
      'powerCapacity': powerCapacity,
      'gridPhase': gridPhase,
      'pinCode': pinCode,
      'city': city,
      'state': state,
      'country': country,
      'loc': loc.toJson(),
      'fullAddress': fullAddress,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'contactNumber': contactNumber,
      'stationType': stationType,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'locationId': locationId,
      'isHubStation': isHubStation,
      'stationIncharge': stationIncharge,
      'owerSessionAlert': owerSessionAlert,
      'ownerName': ownerName,
      'ownerPhoneNumber': ownerPhoneNumber,
      'parkingFee': parkingFee,
      'parkingGracePeriod': parkingGracePeriod,
      'chargers': chargers.map((charger) => charger.toJson()).toList(),
    };
  }
}

// Model for the main response
class ChargingSessionResponse {
  final bool success;
  final String message;
  final ChargingSessionData data;

  ChargingSessionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChargingSessionResponse.fromJson(Map<String, dynamic> json) {
    return ChargingSessionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ChargingSessionData.fromJson(json['data'] ?? {}),
    );
  }
}

// Model for the data containing active and completed sessions
class ChargingSessionData {
  final List<ChargingSession> activeSessions;
  final List<ChargingSession> completedSessions;

  ChargingSessionData({
    required this.activeSessions,
    required this.completedSessions,
  });

  factory ChargingSessionData.fromJson(Map<String, dynamic> json) {
    return ChargingSessionData(
      activeSessions: (json['activeSessions'] as List?)
              ?.map((session) => ChargingSession.fromJson(session))
              .toList() ??
          [],
      completedSessions: (json['completedSessions'] as List?)
              ?.map((session) => ChargingSession.fromJson(session))
              .toList() ??
          [],
    );
  }
}

// Model for individual charging session
class ChargingSession {
  final String id;
  final String customerId;
  final String from;
  final String deviceId;
  final int connectorId;
  final int transactionId;
  final String status;
  final String paymentTrxId;
  final String orderId;
  final bool isActive;
  final double enteredAmount;
  final double? refundAmount;
  final double chargingAmount;
  final double chargedAmount;
  final double grossBill;
  final double energyCap;
  final double lostEnergyValues;
  final double lostAmount;
  final double lastMeterValue;
  final double startMeterValue;
  final double stopMeterValue;
  final String startReason;
  final String stopReason;
  final String interpretationReason;
  final double power;
  final String stoppedBy;
  final int sessionStart;
  final int sessionStop;
  final String currency;
  final bool isFaultyMeterValue;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? invoiceId;
  final ChargingPoint chargingpoints;
  final StationDetails stationDetails;

  ChargingSession({
    required this.id,
    required this.customerId,
    required this.from,
    required this.deviceId,
    required this.connectorId,
    required this.transactionId,
    required this.status,
    required this.paymentTrxId,
    required this.orderId,
    required this.isActive,
    required this.enteredAmount,
    this.refundAmount,
    required this.chargingAmount,
    required this.chargedAmount,
    required this.grossBill,
    required this.energyCap,
    required this.lostEnergyValues,
    required this.lostAmount,
    required this.lastMeterValue,
    required this.startMeterValue,
    required this.stopMeterValue,
    required this.startReason,
    required this.stopReason,
    required this.interpretationReason,
    required this.power,
    required this.stoppedBy,
    required this.sessionStart,
    required this.sessionStop,
    required this.currency,
    required this.isFaultyMeterValue,
    required this.createdAt,
    required this.updatedAt,
    this.invoiceId,
    required this.chargingpoints,
    required this.stationDetails,
  });

  factory ChargingSession.fromJson(Map<String, dynamic> json) {
    return ChargingSession(
      id: json['_id'] ?? '',
      customerId: json['customerId'] ?? '',
      from: json['from'] ?? '',
      deviceId: json['deviceId'] ?? '',
      connectorId: json['connectorId'] ?? 0,
      transactionId: json['transactionId'] ?? 0,
      status: json['status'] ?? '',
      paymentTrxId: json['paymentTrxId'] ?? '',
      orderId: json['orderId'] ?? '',
      isActive: json['isActive'] ?? false,
      enteredAmount: (json['enteredAmount'] ?? 0).toDouble(),
      refundAmount: json['refundAmount']?.toDouble(),
      chargingAmount: (json['chargingAmount'] ?? 0).toDouble(),
      chargedAmount: (json['chargedAmount'] ?? 0).toDouble(),
      grossBill: (json['gross_bill'] ?? 0).toDouble(),
      energyCap: (json['energyCap'] ?? 0).toDouble(),
      lostEnergyValues: (json['lostEnergyValues'] ?? 0).toDouble(),
      lostAmount: (json['lostAmount'] ?? 0).toDouble(),
      lastMeterValue: (json['lastMeterValue'] ?? 0).toDouble(),
      startMeterValue: (json['startMeterValue'] ?? 0).toDouble(),
      stopMeterValue: (json['stopMeterValue'] ?? 0).toDouble(),
      startReason: json['startReason'] ?? '',
      stopReason: json['stopReason'] ?? '',
      interpretationReason: json['interpretationReason'] ?? '',
      power: (json['power'] ?? 0).toDouble(),
      stoppedBy: json['stoppedBy'] ?? '',
      sessionStart: json['sessionStart'] ?? 0,
      sessionStop: json['sessionStop'] ?? 0,
      currency: json['currency'] ?? '',
      isFaultyMeterValue: json['isFaultyMeterValue'] ?? false,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      invoiceId: json['invoiceId'],
      chargingpoints: ChargingPoint.fromJson(json['chargingpoints'] ?? {}),
      stationDetails: StationDetails.fromJson(json['stationDetails'] ?? {}),
    );
  }
}

// Model for charging point details
class ChargingPoint {
  final String id;
  final String deviceId;
  final String station;
  final double maxPower;
  final String chargingPointType;
  final String connectorType;

  ChargingPoint({
    required this.id,
    required this.deviceId,
    required this.station,
    required this.maxPower,
    required this.chargingPointType,
    required this.connectorType,
  });

  factory ChargingPoint.fromJson(Map<String, dynamic> json) {
    return ChargingPoint(
      id: json['_id'] ?? '',
      deviceId: json['device_id'] ?? '',
      station: json['station'] ?? '',
      maxPower: (json['maxPower'] ?? 0).toDouble(),
      chargingPointType: json['chargingPointType'] ?? '',
      connectorType: json['connectorType'] ?? '',
    );
  }
}

// Model for station details
class StationDetails {
  final String id;
  final String name;
  final String fullAddress;

  StationDetails({
    required this.id,
    required this.name,
    required this.fullAddress,
  });

  factory StationDetails.fromJson(Map<String, dynamic> json) {
    return StationDetails(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
    );
  }
}
