class SessionResponse {
  final bool success;
  final String message;
  final ChargingSessionData data;

  SessionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      success: json['success'],
      message: json['message'],
      data: ChargingSessionData.fromJson(json['data']),
    );
  }
}

class ChargingSessionData {
  final List<ChargingSession> activeSessions;
  final List<ChargingSession> completedSessions;

  ChargingSessionData({
    required this.activeSessions,
    required this.completedSessions,
  });

  factory ChargingSessionData.fromJson(Map<String, dynamic> json) {
    return ChargingSessionData(
      activeSessions: (json['activeSessions'] as List)
          .map((x) => ChargingSession.fromJson(x))
          .toList(),
      completedSessions: (json['completedSessions'] as List)
          .map((x) => ChargingSession.fromJson(x))
          .toList(),
    );
  }
}

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
  final int v;
  final String? invoiceId;
  final DateTime? updatedAtTimestamp;
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
    required this.v,
    this.invoiceId,
    this.updatedAtTimestamp,
    required this.chargingpoints,
    required this.stationDetails,
  });

  factory ChargingSession.fromJson(Map<String, dynamic> json) {
    return ChargingSession(
      id: json['_id'],
      customerId: json['customerId'],
      from: json['from'],
      deviceId: json['deviceId'],
      connectorId: json['connectorId'],
      transactionId: json['transactionId'],
      status: json['status'],
      paymentTrxId: json['paymentTrxId'],
      orderId: json['orderId'],
      isActive: json['isActive'],
      enteredAmount: json['enteredAmount'].toDouble(),
      refundAmount: json['refundAmount']?.toDouble(),
      chargingAmount: json['chargingAmount'].toDouble(),
      chargedAmount: json['chargedAmount'].toDouble(),
      grossBill: json['gross_bill'].toDouble(),
      energyCap: json['energyCap'].toDouble(),
      lostEnergyValues: json['lostEnergyValues'].toDouble(),
      lostAmount: json['lostAmount'].toDouble(),
      lastMeterValue: json['lastMeterValue'].toDouble(),
      startMeterValue: json['startMeterValue'].toDouble(),
      stopMeterValue: json['stopMeterValue'].toDouble(),
      startReason: json['startReason'],
      stopReason: json['stopReason'],
      interpretationReason: json['interpretationReason'],
      power: json['power'].toDouble(),
      stoppedBy: json['stoppedBy'],
      sessionStart: json['sessionStart'],
      sessionStop: json['sessionStop'],
      currency: json['currency'],
      isFaultyMeterValue: json['isFaultyMeterValue'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      v: json['__v'],
      invoiceId: json['invoiceId'],
      updatedAtTimestamp:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      chargingpoints: ChargingPoint.fromJson(json['chargingpoints']),
      stationDetails: StationDetails.fromJson(json['stationDetails']),
    );
  }
}

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
      id: json['_id'],
      deviceId: json['device_id'],
      station: json['station'],
      maxPower: json['maxPower'].toDouble(),
      chargingPointType: json['chargingPointType'],
      connectorType: json['connectorType'],
    );
  }
}

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
      id: json['_id'],
      name: json['name'],
      fullAddress: json['fullAddress'],
    );
  }
}
