class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profilePic;
  final String? profession;
  final String? state;
  final String? district;
  final String? role;
  final bool isVerified;
  final bool isApproved;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePic,
    this.profession,
    this.state,
    this.district,
    this.role = 'user',
    this.isVerified = false,
    this.isApproved = false,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'profilePic': profilePic,
    'profession': profession,
    'state': state,
    'district': district,
    'role': role,
    'isVerified': isVerified,
    'isApproved': isApproved,
    'createdAt': createdAt?.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    profilePic: json['profilePic'],
    profession: json['profession'],
    state: json['state'],
    district: json['district'],
    role: json['role'] ?? 'user',
    isVerified: json['isVerified'] ?? false,
    isApproved: json['isApproved'] ?? false,
    createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt']) 
        : null,
  );
}