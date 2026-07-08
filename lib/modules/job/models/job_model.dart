class Job {
  final String id;
  final String title;
  final String company;
  final String companyLogo;
  final String description;
  final String location;
  final String salary;
  final String jobType;
  final String category;
  final List<String> requirements;
  final List<String> skills;
  final String postedBy;
  final DateTime postedDate;
  final DateTime? deadline;
  final bool isActive;
  final int applicantsCount;
  final bool isApplied;

  Job({
    required this.id,
    required this.title,
    required this.company,
    this.companyLogo = '',
    required this.description,
    required this.location,
    required this.salary,
    required this.jobType,
    required this.category,
    this.requirements = const [],
    this.skills = const [],
    required this.postedBy,
    required this.postedDate,
    this.deadline,
    this.isActive = true,
    this.applicantsCount = 0,
    this.isApplied = false,
  });

  Job copyWith({
    String? id,
    String? title,
    String? company,
    String? companyLogo,
    String? description,
    String? location,
    String? salary,
    String? jobType,
    String? category,
    List<String>? requirements,
    List<String>? skills,
    String? postedBy,
    DateTime? postedDate,
    DateTime? deadline,
    bool? isActive,
    int? applicantsCount,
    bool? isApplied,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      companyLogo: companyLogo ?? this.companyLogo,
      description: description ?? this.description,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      jobType: jobType ?? this.jobType,
      category: category ?? this.category,
      requirements: requirements ?? this.requirements,
      skills: skills ?? this.skills,
      postedBy: postedBy ?? this.postedBy,
      postedDate: postedDate ?? this.postedDate,
      deadline: deadline ?? this.deadline,
      isActive: isActive ?? this.isActive,
      applicantsCount: applicantsCount ?? this.applicantsCount,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}

class JobApplication {
  final String id;
  final String jobId;
  final String jobTitle;
  final String applicantId;
  final String applicantName;
  final String applicantEmail;
  final DateTime appliedDate;
  final ApplicationStatus status;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.applicantId,
    required this.applicantName,
    required this.applicantEmail,
    required this.appliedDate,
    this.status = ApplicationStatus.pending,
  });
}

enum ApplicationStatus {
  pending,
  accepted,
  rejected,
  interviewing,
}