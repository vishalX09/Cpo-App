class User {
  _Data? data;
  String? message;

  User({this.data, this.message});

  factory User.fromJson(Map<String, dynamic> json) => User(
        data: json['user'] == null
            ? null
            : _Data.fromJson(json['user'] as Map<String, dynamic>, 
               json['jwtToken'] as String?,
            ),
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'message': message,
      };
}

class _Data {
  String? phone;
  String? email;
  String? name;
  dynamic profilePic;
  String? token;
  String? id;
  String? stationId;
  String? aadharNo;
  DateTime? shiftEndTime;
  DateTime? shiftStartTime;
  String? language;
  String? vehicleNumber;
  DateTime? lastLogin;

  _Data({
    this.phone,
    this.email,
    this.name,
    this.profilePic,
    this.token,
    this.id,
    this.stationId,
    this.aadharNo,
    this.shiftEndTime,
    this.shiftStartTime,
    this.language,
    this.vehicleNumber,
    this.lastLogin,
  });

  factory _Data.fromJson(Map<String, dynamic> json, String? token) => _Data(
        phone: json['phoneNumber'] as String?,
        email: json['email'] as String?,
        name: json['name'] as String?,
        profilePic: json['profile_pic'] as dynamic,
        token: token,
        id: json['_id'] as String?,
        stationId: json['stationId'] as String? ?? '',
        aadharNo: json['aadhar_no'] as String?,
        shiftEndTime: json['shiftEndTime'] != null
            ? DateTime.parse(json['shiftEndTime'])
            : null,
        shiftStartTime: json['shiftStartTime'] != null
            ? DateTime.parse(json['shiftStartTime'])
            : null,
        language: json['language'] as String?,
        vehicleNumber: json['vehicle_number'] as String?,
        lastLogin: json['lastLoginAt'] != null
            ? DateTime.parse(json['lastLoginAt'])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'email': email,
        'name': name,
        'profile_pic': profilePic,
        'token': token,
        'id': id,
        'stationId': stationId,
        'aadharNo': aadharNo,
        'shiftEndTime': shiftEndTime?.toIso8601String(),
        'shiftStartTime': shiftStartTime?.toIso8601String(),
        'language': language,
        'vehicleNumber': vehicleNumber,
        'lastLoginAt': lastLogin?.toIso8601String()
      };
}
