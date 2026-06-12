class AppUser {
  final String uid;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String passengerType;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.passengerType,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'passenger_type': passengerType,
      'role': 'passenger',
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['id'] ?? map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['full_name'] ?? map['fullName'] ?? '',
      phoneNumber: map['phone_number'] ?? map['phoneNumber'] ?? '',
      passengerType: map['passenger_type'] ?? map['passengerType'] ?? 'Regular',
      createdAt: DateTime.parse(map['created_at'] ?? map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
