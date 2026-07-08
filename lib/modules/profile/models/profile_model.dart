class ProfileModel {
  // ✅ ADDED id field
  String id;
  String? fullName;
  String? profilePhoto;
  DateTime? dob;
  String? gender;
  String? maritalStatus;
  String? mobileNumber;
  String? email;
  String? bloodGroup;
  
  // Step 2: Brahmin Community Details
  BrahminDetails? brahminDetails;
  
  // Step 3: Address
  Address? presentAddress;
  Address? permanentAddress;
  bool? sameAsPresent;
  
  // Step 4: Education
  EducationDetails? education;
  
  // Step 5: Professional
  ProfessionalDetails? professional;
  
  // Step 6: Family
  List<FamilyMember>? familyMembers;
  
  // Step 7: Social & Personal
  List<String>? hobbies;
  List<String>? interests;
  List<String>? achievements;
  String? socialWork;
  String? aboutYourself;
  List<String>? languagesKnown;
  
  // Step 8: Documents
  List<Document>? documents;
  
  // Status
  String? profileStatus;
  String? rejectionReason;

  // ✅ UPDATED Constructor with id
  ProfileModel({
    required this.id,
    this.fullName,
    this.profilePhoto,
    this.dob,
    this.gender,
    this.maritalStatus,
    this.mobileNumber,
    this.email,
    this.bloodGroup,
    this.brahminDetails,
    this.presentAddress,
    this.permanentAddress,
    this.sameAsPresent = false,
    this.education,
    this.professional,
    this.familyMembers,
    this.hobbies,
    this.interests,
    this.achievements,
    this.socialWork,
    this.aboutYourself,
    this.languagesKnown,
    this.documents,
    this.profileStatus = 'draft',
    this.rejectionReason,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'profilePhoto': profilePhoto,
    'dob': dob?.toIso8601String(),
    'gender': gender,
    'maritalStatus': maritalStatus,
    'mobileNumber': mobileNumber,
    'email': email,
    'bloodGroup': bloodGroup,
    'brahminDetails': brahminDetails?.toJson(),
    'presentAddress': presentAddress?.toJson(),
    'permanentAddress': permanentAddress?.toJson(),
    'sameAsPresent': sameAsPresent,
    'education': education?.toJson(),
    'professional': professional?.toJson(),
    'familyMembers': familyMembers?.map((e) => e.toJson()).toList(),
    'hobbies': hobbies,
    'interests': interests,
    'achievements': achievements,
    'socialWork': socialWork,
    'aboutYourself': aboutYourself,
    'languagesKnown': languagesKnown,
    'documents': documents?.map((e) => e.toJson()).toList(),
    'profileStatus': profileStatus,
    'rejectionReason': rejectionReason,
  };

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
    fullName: json['fullName'],
    profilePhoto: json['profilePhoto'],
    dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
    gender: json['gender'],
    maritalStatus: json['maritalStatus'],
    mobileNumber: json['mobileNumber'],
    email: json['email'],
    bloodGroup: json['bloodGroup'],
    brahminDetails: json['brahminDetails'] != null 
        ? BrahminDetails.fromJson(json['brahminDetails']) 
        : null,
    presentAddress: json['presentAddress'] != null 
        ? Address.fromJson(json['presentAddress']) 
        : null,
    permanentAddress: json['permanentAddress'] != null 
        ? Address.fromJson(json['permanentAddress']) 
        : null,
    sameAsPresent: json['sameAsPresent'] ?? false,
    education: json['education'] != null 
        ? EducationDetails.fromJson(json['education']) 
        : null,
    professional: json['professional'] != null 
        ? ProfessionalDetails.fromJson(json['professional']) 
        : null,
    familyMembers: json['familyMembers'] != null 
        ? (json['familyMembers'] as List).map((e) => FamilyMember.fromJson(e)).toList() 
        : null,
    hobbies: json['hobbies'] != null ? List<String>.from(json['hobbies']) : null,
    interests: json['interests'] != null ? List<String>.from(json['interests']) : null,
    achievements: json['achievements'] != null ? List<String>.from(json['achievements']) : null,
    socialWork: json['socialWork'],
    aboutYourself: json['aboutYourself'],
    languagesKnown: json['languagesKnown'] != null ? List<String>.from(json['languagesKnown']) : null,
    documents: json['documents'] != null 
        ? (json['documents'] as List).map((e) => Document.fromJson(e)).toList() 
        : null,
    profileStatus: json['profileStatus'] ?? 'draft',
    rejectionReason: json['rejectionReason'],
  );
}

// ============================================================
// ✅ BRAHMIN DETAILS
// ============================================================
class BrahminDetails {
  String? brahminType;
  String? subCategory;
  String? gotra;
  String? pravara;
  String? pur;
  String? kul;
  String? kuldevta;
  String? nativeVillage;
  String? nativeDistrict;
  String? nativeState;
  String? vedicTradition;
  String? sampradaya;
  String? familyPriest;
  String? lineageDescription;

  BrahminDetails({
    this.brahminType,
    this.subCategory,
    this.gotra,
    this.pravara,
    this.pur,
    this.kul,
    this.kuldevta,
    this.nativeVillage,
    this.nativeDistrict,
    this.nativeState,
    this.vedicTradition,
    this.sampradaya,
    this.familyPriest,
    this.lineageDescription,
  });

  Map<String, dynamic> toJson() => {
    'brahminType': brahminType,
    'subCategory': subCategory,
    'gotra': gotra,
    'pravara': pravara,
    'pur': pur,
    'kul': kul,
    'kuldevta': kuldevta,
    'nativeVillage': nativeVillage,
    'nativeDistrict': nativeDistrict,
    'nativeState': nativeState,
    'vedicTradition': vedicTradition,
    'sampradaya': sampradaya,
    'familyPriest': familyPriest,
    'lineageDescription': lineageDescription,
  };

  factory BrahminDetails.fromJson(Map<String, dynamic> json) => BrahminDetails(
    brahminType: json['brahminType'],
    subCategory: json['subCategory'],
    gotra: json['gotra'],
    pravara: json['pravara'],
    pur: json['pur'],
    kul: json['kul'],
    kuldevta: json['kuldevta'],
    nativeVillage: json['nativeVillage'],
    nativeDistrict: json['nativeDistrict'],
    nativeState: json['nativeState'],
    vedicTradition: json['vedicTradition'],
    sampradaya: json['sampradaya'],
    familyPriest: json['familyPriest'],
    lineageDescription: json['lineageDescription'],
  );
}

// ============================================================
// ✅ ADDRESS
// ============================================================
class Address {
  String? houseNo;
  String? area;
  String? city;
  String? district;
  String? state;
  String? pincode;

  Address({
    this.houseNo,
    this.area,
    this.city,
    this.district,
    this.state,
    this.pincode,
  });

  Map<String, dynamic> toJson() => {
    'houseNo': houseNo,
    'area': area,
    'city': city,
    'district': district,
    'state': state,
    'pincode': pincode,
  };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    houseNo: json['houseNo'],
    area: json['area'],
    city: json['city'],
    district: json['district'],
    state: json['state'],
    pincode: json['pincode'],
  );
}

// ============================================================
// ✅ EDUCATION
// ============================================================
class EducationDetails {
  bool? is10thPassed;
  String? tenthBoard;
  String? tenthMarks;
  String? tenthYear;
  bool? is12thPassed;
  String? twelfthBoard;
  String? twelfthMarks;
  String? twelfthYear;
  String? graduation;
  String? degree;
  String? college;
  String? university;
  String? marks;
  String? graduationYear;
  String? higherStudies;
  String? higherStudiesInstitution;
  String? higherStudiesYear;

  EducationDetails({
    this.is10thPassed,
    this.tenthBoard,
    this.tenthMarks,
    this.tenthYear,
    this.is12thPassed,
    this.twelfthBoard,
    this.twelfthMarks,
    this.twelfthYear,
    this.graduation,
    this.degree,
    this.college,
    this.university,
    this.marks,
    this.graduationYear,
    this.higherStudies,
    this.higherStudiesInstitution,
    this.higherStudiesYear,
  });

  Map<String, dynamic> toJson() => {
    'is10thPassed': is10thPassed,
    'tenthBoard': tenthBoard,
    'tenthMarks': tenthMarks,
    'tenthYear': tenthYear,
    'is12thPassed': is12thPassed,
    'twelfthBoard': twelfthBoard,
    'twelfthMarks': twelfthMarks,
    'twelfthYear': twelfthYear,
    'graduation': graduation,
    'degree': degree,
    'college': college,
    'university': university,
    'marks': marks,
    'graduationYear': graduationYear,
    'higherStudies': higherStudies,
    'higherStudiesInstitution': higherStudiesInstitution,
    'higherStudiesYear': higherStudiesYear,
  };

  factory EducationDetails.fromJson(Map<String, dynamic> json) => EducationDetails(
    is10thPassed: json['is10thPassed'],
    tenthBoard: json['tenthBoard'],
    tenthMarks: json['tenthMarks'],
    tenthYear: json['tenthYear'],
    is12thPassed: json['is12thPassed'],
    twelfthBoard: json['twelfthBoard'],
    twelfthMarks: json['twelfthMarks'],
    twelfthYear: json['twelfthYear'],
    graduation: json['graduation'],
    degree: json['degree'],
    college: json['college'],
    university: json['university'],
    marks: json['marks'],
    graduationYear: json['graduationYear'],
    higherStudies: json['higherStudies'],
    higherStudiesInstitution: json['higherStudiesInstitution'],
    higherStudiesYear: json['higherStudiesYear'],
  );
}

// ============================================================
// ✅ PROFESSIONAL
// ============================================================
class ProfessionalDetails {
  bool? isEmployed;
  String? employmentType;
  String? profession;
  String? designation;
  String? organization;
  String? department;
  String? workLocation;
  String? experience;
  String? pastExperience;
  List<String>? skills;
  String? serviceType;
  String? batchYear;
  String? employeeId;

  ProfessionalDetails({
    this.isEmployed,
    this.employmentType,
    this.profession,
    this.designation,
    this.organization,
    this.department,
    this.workLocation,
    this.experience,
    this.pastExperience,
    this.skills,
    this.serviceType,
    this.batchYear,
    this.employeeId,
  });

  Map<String, dynamic> toJson() => {
    'isEmployed': isEmployed,
    'employmentType': employmentType,
    'profession': profession,
    'designation': designation,
    'organization': organization,
    'department': department,
    'workLocation': workLocation,
    'experience': experience,
    'pastExperience': pastExperience,
    'skills': skills,
    'serviceType': serviceType,
    'batchYear': batchYear,
    'employeeId': employeeId,
  };

  factory ProfessionalDetails.fromJson(Map<String, dynamic> json) => ProfessionalDetails(
    isEmployed: json['isEmployed'],
    employmentType: json['employmentType'],
    profession: json['profession'],
    designation: json['designation'],
    organization: json['organization'],
    department: json['department'],
    workLocation: json['workLocation'],
    experience: json['experience'],
    pastExperience: json['pastExperience'],
    skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
    serviceType: json['serviceType'],
    batchYear: json['batchYear'],
    employeeId: json['employeeId'],
  );
}

// ============================================================
// ✅ FAMILY MEMBER
// ============================================================
class FamilyMember {
  String? id;
  String? relation;
  String? name;
  DateTime? dob;
  String? gender;
  String? occupation;
  String? education;
  String? mobileNumber;
  String? maritalStatus;

  FamilyMember({
    this.id,
    this.relation,
    this.name,
    this.dob,
    this.gender,
    this.occupation,
    this.education,
    this.mobileNumber,
    this.maritalStatus,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'relation': relation,
    'name': name,
    'dob': dob?.toIso8601String(),
    'gender': gender,
    'occupation': occupation,
    'education': education,
    'mobileNumber': mobileNumber,
    'maritalStatus': maritalStatus,
  };

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
    id: json['id'],
    relation: json['relation'],
    name: json['name'],
    dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
    gender: json['gender'],
    occupation: json['occupation'],
    education: json['education'],
    mobileNumber: json['mobileNumber'],
    maritalStatus: json['maritalStatus'],
  );
}

// ============================================================
// ✅ DOCUMENT
// ============================================================
class Document {
  String? id;
  String? name;
  String? filePath;
  String? fileType;
  DateTime? uploadDate;

  Document({
    this.id,
    this.name,
    this.filePath,
    this.fileType,
    this.uploadDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'filePath': filePath,
    'fileType': fileType,
    'uploadDate': uploadDate?.toIso8601String(),
  };

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json['id'],
    name: json['name'],
    filePath: json['filePath'],
    fileType: json['fileType'],
    uploadDate: json['uploadDate'] != null ? DateTime.parse(json['uploadDate']) : null,
  );
}