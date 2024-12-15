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

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

// Data container model
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
              ?.map((e) => ChargingSession.fromJson(e))
              .toList() ??
          [],
      completedSessions: (json['completedSessions'] as List?)
              ?.map((e) => ChargingSession.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeSessions': activeSessions.map((e) => e.toJson()).toList(),
      'completedSessions': completedSessions.map((e) => e.toJson()).toList(),
    };
  }
}

// Main charging session model
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
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
      invoiceId: json['invoiceId'],
      chargingpoints: ChargingPoint.fromJson(json['chargingpoints'] ?? {}),
      stationDetails: StationDetails.fromJson(json['stationDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'customerId': customerId,
      'from': from,
      'deviceId': deviceId,
      'connectorId': connectorId,
      'transactionId': transactionId,
      'status': status,
      'paymentTrxId': paymentTrxId,
      'orderId': orderId,
      'isActive': isActive,
      'enteredAmount': enteredAmount,
      'refundAmount': refundAmount,
      'chargingAmount': chargingAmount,
      'chargedAmount': chargedAmount,
      'gross_bill': grossBill,
      'energyCap': energyCap,
      'lostEnergyValues': lostEnergyValues,
      'lostAmount': lostAmount,
      'lastMeterValue': lastMeterValue,
      'startMeterValue': startMeterValue,
      'stopMeterValue': stopMeterValue,
      'startReason': startReason,
      'stopReason': stopReason,
      'interpretationReason': interpretationReason,
      'power': power,
      'stoppedBy': stoppedBy,
      'sessionStart': sessionStart,
      'sessionStop': sessionStop,
      'currency': currency,
      'isFaultyMeterValue': isFaultyMeterValue,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'invoiceId': invoiceId,
      'chargingpoints': chargingpoints.toJson(),
      'stationDetails': stationDetails.toJson(),
    };
  }
}

// Charging point model
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'device_id': deviceId,
      'station': station,
      'maxPower': maxPower,
      'chargingPointType': chargingPointType,
      'connectorType': connectorType,
    };
  }
}

// Station details model
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'fullAddress': fullAddress,
    };
  }
}
