class FamilyMember {
  final String id;
  final String name;
  final String relationship;
  final int? age;
  final String? gender;
  final bool isAlive;
  final String? profilePic;
  final String? birthDate;
  final String? spouse;
  final String? father;
  final String? mother;
  final List<String> children;

  FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
    this.age,
    this.gender,
    this.isAlive = true,
    this.profilePic,
    this.birthDate,
    this.spouse,
    this.father,
    this.mother,
    this.children = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'relationship': relationship,
    'age': age,
    'gender': gender,
    'isAlive': isAlive,
    'profilePic': profilePic,
    'birthDate': birthDate,
    'spouse': spouse,
    'father': father,
    'mother': mother,
    'children': children,
  };

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
    id: json['id'],
    name: json['name'],
    relationship: json['relationship'],
    age: json['age'],
    gender: json['gender'],
    isAlive: json['isAlive'] ?? true,
    profilePic: json['profilePic'],
    birthDate: json['birthDate'],
    spouse: json['spouse'],
    father: json['father'],
    mother: json['mother'],
    children: List<String>.from(json['children'] ?? []),
  );
}