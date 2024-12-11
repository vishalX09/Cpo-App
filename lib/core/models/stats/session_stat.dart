class StationStatsResponse {
  final bool success;
  final String message;
  final List<StationData> data;

  StationStatsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StationStatsResponse.fromJson(Map<String, dynamic> json) {
    return StationStatsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => StationData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class StationData {
  final Station station;
  final List<SessionDetail> sessionDetails;

  StationData({
    required this.station,
    required this.sessionDetails,
  });

  factory StationData.fromJson(Map<String, dynamic> json) {
    return StationData(
      station: Station.fromJson(json['station']),
      sessionDetails: (json['sessionDetails'] as List<dynamic>?)
              ?.map((e) => SessionDetail.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'station': station.toJson(),
      'sessionDetails': sessionDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class Station {
  final String id;
  final String name;
  final String address;

  Station({
    required this.id,
    required this.name,
    required this.address,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'address': address,
    };
  }
}

class SessionDetail {
  final String? id;
  final CurrentSessionData currentSessionData;

  SessionDetail({
    this.id,
    required this.currentSessionData,
  });

  factory SessionDetail.fromJson(Map<String, dynamic> json) {
    return SessionDetail(
      id: json['_id'],
      currentSessionData:
          CurrentSessionData.fromJson(json['currentSessionData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'currentSessionData': currentSessionData.toJson(),
    };
  }
}

class CurrentSessionData {
  final double totalChargedAmount;
  final double totalMeterValue;
  final int totalSessions;
  final int totalAppSessions;
  final int totalDirectSessions;
  final int totalWebSessions;
  final int totalHubSessions;

  CurrentSessionData({
    required this.totalChargedAmount,
    required this.totalMeterValue,
    required this.totalSessions,
    required this.totalAppSessions,
    required this.totalDirectSessions,
    required this.totalWebSessions,
    required this.totalHubSessions,
  });

  factory CurrentSessionData.fromJson(Map<String, dynamic> json) {
    return CurrentSessionData(
      totalChargedAmount: (json['totalChargedAmount'] ?? 0.0).toDouble(),
      totalMeterValue: (json['totalMeterValue'] ?? 0.0).toDouble(),
      totalSessions: json['totalSessions'] ?? 0,
      totalAppSessions: json['totalAppSessions'] ?? 0,
      totalDirectSessions: json['totalDirectSessions'] ?? 0,
      totalWebSessions: json['totalWebSessions'] ?? 0,
      totalHubSessions: json['totalHubSessions'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalChargedAmount': totalChargedAmount,
      'totalMeterValue': totalMeterValue,
      'totalSessions': totalSessions,
      'totalAppSessions': totalAppSessions,
      'totalDirectSessions': totalDirectSessions,
      'totalWebSessions': totalWebSessions,
      'totalHubSessions': totalHubSessions,
    };
  }
}
