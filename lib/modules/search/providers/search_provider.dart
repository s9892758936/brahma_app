import 'package:flutter/material.dart';
import 'dart:math';

class SearchProvider extends ChangeNotifier {
  // ============================================================
  // 📊 DATA STORES
  // ============================================================
  List<SearchResult> _allResults = [];
  List<SearchResult> _filteredResults = [];
  bool _isLoading = false;
  int _totalResults = 0;

  // ============================================================
  // 📤 GETTERS
  // ============================================================
  List<SearchResult> get results => _filteredResults;
  bool get isLoading => _isLoading;
  int get totalResults => _totalResults;

  // ============================================================
  // 🚀 LOAD DATA
  // ============================================================
  void loadSampleData() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      final now = DateTime.now();
      final random = Random();
      
      final userNames = ['Rajesh Kumar', 'Priya Sharma', 'Amit Singh', 'Sneha Patel', 'Vikram Verma'];
      final postContents = [
        '🕉️ जय श्री राम 🙏\nToday I visited the temple with my family.',
        '🎉 Celebrating our family reunion after 5 years!',
        '📚 Just completed my Yoga certification. OM 🙏',
        '🏠 Our new home is finally ready!',
        '🌺 Remembering our ancestors today.',
      ];
      final jobTitles = ['Software Engineer', 'Product Manager', 'Data Scientist', 'DevOps Engineer'];
      final companies = ['Google', 'Microsoft', 'Amazon', 'Meta'];
      final businessNames = ['Sharma Medical Store', 'Patel Law Firm', 'Singh Digital', 'Verma Enterprises'];
      final categories = ['Technology', 'Healthcare', 'Legal', 'Education'];
      
      _allResults = [];
      
      // Users
      for (int i = 0; i < 5; i++) {
        _allResults.add(SearchResult(
          id: 'user_${i + 1}',
          title: userNames[i % userNames.length],
          subtitle: 'Brahmin • ${categories[i % categories.length]}',
          type: 'User',
          date: _formatDate(now.subtract(Duration(days: random.nextInt(30)))),
          rating: (3 + random.nextInt(2)).toDouble(),
          ratingCount: 10 + random.nextInt(50),
          icon: '👤',
        ));
      }
      
      // Posts
      for (int i = 0; i < 5; i++) {
        _allResults.add(SearchResult(
          id: 'post_${i + 1}',
          title: postContents[i % postContents.length],
          subtitle: 'Posted by ${userNames[i % userNames.length]}',
          type: 'Post',
          date: _formatDate(now.subtract(Duration(hours: i * 2 + random.nextInt(5)))),
          rating: null,
          ratingCount: 0,
          icon: '📝',
        ));
      }
      
      // Jobs
      for (int i = 0; i < 4; i++) {
        _allResults.add(SearchResult(
          id: 'job_${i + 1}',
          title: jobTitles[i % jobTitles.length],
          subtitle: '${companies[i % companies.length]} • ${40 + random.nextInt(60)}k/year',
          type: 'Job',
          date: _formatDate(now.subtract(Duration(days: random.nextInt(10)))),
          rating: null,
          ratingCount: 0,
          icon: '💼',
        ));
      }
      
      // Businesses
      for (int i = 0; i < 4; i++) {
        _allResults.add(SearchResult(
          id: 'business_${i + 1}',
          title: businessNames[i % businessNames.length],
          subtitle: '${categories[i % categories.length]} • 4.5★',
          type: 'Business',
          date: _formatDate(now.subtract(Duration(days: random.nextInt(20)))),
          rating: (4 + random.nextInt(1)).toDouble(),
          ratingCount: 20 + random.nextInt(80),
          icon: '🏪',
        ));
      }
      
      _filteredResults = _allResults;
      _totalResults = _filteredResults.length;
      _isLoading = false;
      notifyListeners();
    });
  }

  // ============================================================
  // 🔍 SEARCH
  // ============================================================
  void search(String query) {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (query.isEmpty) {
        _filteredResults = _allResults;
      } else {
        final q = query.toLowerCase();
        _filteredResults = _allResults.where((result) {
          return result.title.toLowerCase().contains(q) ||
              result.subtitle.toLowerCase().contains(q) ||
              result.type.toLowerCase().contains(q);
        }).toList();
      }
      _totalResults = _filteredResults.length;
      _isLoading = false;
      notifyListeners();
    });
  }

  // ============================================================
  // 🔍 FILTER RESULTS
  // ============================================================
  void filterResults(String category, String sort) {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 200), () {
      _filteredResults = _allResults;
      
      // Filter by category
      if (category != 'All') {
        final cat = category.substring(0, category.length - 1); // Remove 's' from end
        _filteredResults = _filteredResults
            .where((r) => r.type.toLowerCase() == cat.toLowerCase())
            .toList();
      }
      
      // Sort
      if (sort == 'Latest') {
        _filteredResults.sort((a, b) => b.date.compareTo(a.date));
      } else if (sort == 'Popular' || sort == 'Rating') {
        _filteredResults.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
      }
      
      _totalResults = _filteredResults.length;
      _isLoading = false;
      notifyListeners();
    });
  }

  // ============================================================
  // 🔧 HELPERS
  // ============================================================
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

// ============================================================
// 📦 SEARCH RESULT MODEL
// ============================================================
class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final String date;
  final double? rating;
  final int ratingCount;
  final String icon;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.date,
    this.rating,
    this.ratingCount = 0,
    this.icon = '📌',
  });
}