import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/job_model.dart';
import 'dart:math';

class JobProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<Job> _jobs = [];
  List<Job> _filteredJobs = [];
  List<JobApplication> _applications = [];
  Job? _selectedJob;
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String _selectedJobType = 'All';

  List<Job> get jobs => _filteredJobs;
  List<Job> get allJobs => _jobs;
  List<JobApplication> get applications => _applications;
  Job? get selectedJob => _selectedJob;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get selectedJobType => _selectedJobType;

  JobProvider() {
    _listenToJobs();
    _loadApplications();
  }

  // ============================================================
  // 🔥 REAL-TIME JOBS LISTENER
  // ============================================================
  void _listenToJobs() {
    _firestore
        .collection('jobs')
        .orderBy('postedDate', descending: true)
        .snapshots()
        .listen((snapshot) {
          _jobs = [];
          for (var doc in snapshot.docs) {
            final data = doc.data();
            _jobs.add(Job(
              id: doc.id,
              title: data['title'] ?? '',
              company: data['company'] ?? '',
              companyLogo: data['companyLogo'] ?? '',
              description: data['description'] ?? '',
              location: data['location'] ?? '',
              salary: data['salary'] ?? '',
              jobType: data['jobType'] ?? '',
              category: data['category'] ?? '',
              requirements: List<String>.from(data['requirements'] ?? []),
              skills: List<String>.from(data['skills'] ?? []),
              postedBy: data['postedBy'] ?? '',
              postedDate: (data['postedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              deadline: (data['deadline'] as Timestamp?)?.toDate(),
              isActive: data['isActive'] ?? true,
              applicantsCount: data['applicantsCount'] ?? 0,
              isApplied: data['applicants']?.contains(_auth.currentUser?.uid) ?? false,
            ));
          }
          _filteredJobs = _jobs;
          _isLoading = false;
          notifyListeners();
        });
  }

  // ============================================================
  // 🔥 LOAD APPLICATIONS
  // ============================================================
  void _loadApplications() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _firestore
        .collection('users')
        .doc(userId)
        .collection('applications')
        .orderBy('appliedDate', descending: true)
        .snapshots()
        .listen((snapshot) {
          _applications = [];
          for (var doc in snapshot.docs) {
            final data = doc.data();
            _applications.add(JobApplication(
              id: doc.id,
              jobId: data['jobId'] ?? '',
              jobTitle: data['jobTitle'] ?? '',
              applicantId: data['applicantId'] ?? '',
              applicantName: data['applicantName'] ?? '',
              applicantEmail: data['applicantEmail'] ?? '',
              appliedDate: (data['appliedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              status: _parseApplicationStatus(data['status'] ?? 'pending'),
            ));
          }
          notifyListeners();
        });
  }

  ApplicationStatus _parseApplicationStatus(String status) {
    switch (status) {
      case 'accepted': return ApplicationStatus.accepted;
      case 'rejected': return ApplicationStatus.rejected;
      case 'interviewing': return ApplicationStatus.interviewing;
      default: return ApplicationStatus.pending;
    }
  }

  // ============================================================
  // 🔍 FILTER JOBS
  // ============================================================
  void filterJobs({
    String? category,
    String? jobType,
    String? query,
  }) {
    _filteredJobs = _jobs.where((job) {
      bool matches = true;
      
      if (category != null && category != 'All') {
        matches = matches && job.category == category;
      }
      
      if (jobType != null && jobType != 'All') {
        matches = matches && job.jobType == jobType;
      }
      
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        matches = matches && (
          job.title.toLowerCase().contains(q) ||
          job.company.toLowerCase().contains(q) ||
          job.category.toLowerCase().contains(q)
        );
      }
      
      return matches;
    }).toList();
    
    _selectedCategory = category ?? 'All';
    _selectedJobType = jobType ?? 'All';
    notifyListeners();
  }

  // ============================================================
  // 📝 SELECT JOB
  // ============================================================
  void selectJob(String jobId) {
    try {
      _selectedJob = _jobs.firstWhere((j) => j.id == jobId);
      notifyListeners();
    } catch (e) {
      _selectedJob = null;
      notifyListeners();
    }
  }

  void clearSelectedJob() {
    _selectedJob = null;
    notifyListeners();
  }

  // ============================================================
  // ✅ APPLY FOR JOB - FIREBASE
  // ============================================================
  Future<void> applyForJob(String jobId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    final job = _jobs[jobIndex];
    
    try {
      // Update job applicants count
      await _firestore.collection('jobs').doc(jobId).update({
        'applicantsCount': FieldValue.increment(1),
        'applicants': FieldValue.arrayUnion([userId]),
      });

      // Add application
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('applications')
          .add({
        'jobId': jobId,
        'jobTitle': job.title,
        'applicantId': userId,
        'applicantName': _auth.currentUser?.displayName ?? 'User',
        'applicantEmail': _auth.currentUser?.email ?? '',
        'appliedDate': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      // Update local
      _jobs[jobIndex] = job.copyWith(
        isApplied: true,
        applicantsCount: job.applicantsCount + 1,
      );
      _filteredJobs = _jobs;
      notifyListeners();
      
    } catch (e) {
      print('Error applying for job: $e');
    }
  }

  // ============================================================
  // ❌ WITHDRAW APPLICATION - FIREBASE
  // ============================================================
  Future<void> withdrawApplication(String jobId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    final job = _jobs[jobIndex];
    
    try {
      // Update job applicants count
      await _firestore.collection('jobs').doc(jobId).update({
        'applicantsCount': FieldValue.increment(-1),
        'applicants': FieldValue.arrayRemove([userId]),
      });

      // Delete application
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('applications')
          .where('jobId', isEqualTo: jobId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Update local
      _jobs[jobIndex] = job.copyWith(
        isApplied: false,
        applicantsCount: job.applicantsCount - 1,
      );
      _filteredJobs = _jobs;
      notifyListeners();
      
    } catch (e) {
      print('Error withdrawing application: $e');
    }
  }

  // ============================================================
  // 📊 GET CATEGORIES
  // ============================================================
  List<String> getCategories() {
    final categories = _jobs.map((j) => j.category).toSet();
    return ['All', ...categories];
  }

  List<String> getJobTypes() {
    final types = _jobs.map((j) => j.jobType).toSet();
    return ['All', ...types];
  }

  // ============================================================
  // 📝 LOAD SAMPLE JOBS (For testing)
  // ============================================================
  void loadSampleJobs() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      final random = Random();
      _jobs = List.generate(10, (index) {
        final companies = ['Google', 'Microsoft', 'Amazon', 'Meta', 'Apple', 'Netflix', 'Tesla', 'IBM'];
        final titles = ['Software Engineer', 'Product Manager', 'Data Scientist', 'DevOps Engineer', 'UI/UX Designer'];
        final categories = ['Technology', 'Finance', 'Healthcare', 'Education', 'Consulting'];
        final jobTypes = ['Full-time', 'Remote', 'Part-time', 'Contract', 'Internship'];
        final locations = ['New York, NY', 'San Francisco, CA', 'Austin, TX', 'Remote', 'London, UK'];
        final skills = ['Flutter', 'React', 'Node.js', 'Python', 'Java', 'SQL', 'AWS', 'Docker'];
        
        final company = companies[random.nextInt(companies.length)];
        final title = titles[random.nextInt(titles.length)];
        final category = categories[random.nextInt(categories.length)];
        final jobType = jobTypes[random.nextInt(jobTypes.length)];
        final location = locations[random.nextInt(locations.length)];
        
        final skillCount = 3 + random.nextInt(3);
        final shuffledSkills = List<String>.from(skills)..shuffle();
        final selectedSkills = shuffledSkills.take(skillCount).toList();
        
        final requirementCount = 2 + random.nextInt(3);
        final requirements = List.generate(requirementCount, (i) {
          final templates = [
            '${random.nextInt(5) + 1}+ years of experience',
            "Bachelor's degree in related field",
            'Strong problem-solving skills',
            'Excellent communication skills',
            'Experience in agile development',
          ];
          return templates[random.nextInt(templates.length)];
        });

        return Job(
          id: 'job_${DateTime.now().millisecondsSinceEpoch}_$index',
          title: title,
          company: company,
          companyLogo: 'https://ui-avatars.com/api/?name=${company[0]}&background=6C63FF&color=fff&size=100',
          description: '$company is looking for a $title to join our team.',
          location: location,
          salary: '\$${40 + random.nextInt(100)}k - \$${60 + random.nextInt(120)}k',
          jobType: jobType,
          category: category,
          requirements: requirements,
          skills: selectedSkills,
          postedBy: 'recruiter_${index + 1}',
          postedDate: DateTime.now().subtract(Duration(days: random.nextInt(30))),
          deadline: DateTime.now().add(Duration(days: 15 + random.nextInt(30))),
          isActive: random.nextBool(),
          applicantsCount: random.nextInt(50),
          isApplied: random.nextBool(),
        );
      })..sort((a, b) => b.postedDate.compareTo(a.postedDate));

      _filteredJobs = _jobs;
      _isLoading = false;
      notifyListeners();
    });
  }
}