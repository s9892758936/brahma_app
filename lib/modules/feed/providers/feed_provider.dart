import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FeedProvider extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> _filteredPosts = [];
  bool _isLoading = false;
  String? _selectedCategory;

  List<Post> get posts => _filteredPosts;
  List<Post> get allPosts => _posts;
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;

  FeedProvider() {
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('feed_posts');
    if (data != null) {
      try {
        final list = jsonDecode(data) as List;
        _posts = list.map((item) => Post.fromJson(item)).toList();
        _filteredPosts = _posts;
      } catch (e) {
        loadSamplePosts();
      }
    } else {
      loadSamplePosts();
    }
  }

  Future<void> _savePosts() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _posts.map((p) => p.toJson()).toList();
    await prefs.setString('feed_posts', jsonEncode(list));
  }

  void loadSamplePosts() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      final now = DateTime.now();
      final random = Random();
      
      final userNames = ['Rajesh Kumar', 'Priya Sharma', 'Amit Singh', 'Sneha Patel', 'Vikram Verma'];
      final contents = [
        '🕉️ जय श्री राम 🙏\n\nToday I visited the temple with my family.',
        '🎉 Celebrating our family reunion after 5 years!',
        '📚 Just completed my Yoga certification. OM 🙏',
        '🏠 Our new home is finally ready!',
        '🌺 Remembering our ancestors today.',
        '💼 Started my new business. Seeking blessings.',
        '📖 Reading the Bhagavad Gita.',
        '🙏 Attended the Satsang today.',
      ];
      
      _posts = List.generate(15, (index) {
        final userIndex = index % userNames.length;
        final contentIndex = index % contents.length;
        
        return Post(
          id: 'post_${now.millisecondsSinceEpoch}_$index',
          userId: 'user_${1000 + index}',
          userName: userNames[userIndex],
          userAvatar: userNames[userIndex][0],
          content: contents[contentIndex],
          imageUrl: index % 3 == 0 ? 'https://picsum.photos/400/200?random=$index' : null,
          createdAt: now.subtract(Duration(hours: index * 2 + random.nextInt(3))),
          likes: 5 + random.nextInt(50),
          comments: 2 + random.nextInt(20),
          shares: 1 + random.nextInt(10),
          isLiked: random.nextBool(),
          isSaved: random.nextBool(),
        );
      })..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      _filteredPosts = _posts;
      _isLoading = false;
      _savePosts();
      notifyListeners();
    });
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = Post(
        id: post.id,
        userId: post.userId,
        userName: post.userName,
        userAvatar: post.userAvatar,
        content: post.content,
        imageUrl: post.imageUrl,
        createdAt: post.createdAt,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        comments: post.comments,
        shares: post.shares,
        isLiked: !post.isLiked,
        isSaved: post.isSaved,
      );
      _filteredPosts = _posts;
      _savePosts();
      notifyListeners();
    }
  }

  void toggleSave(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = Post(
        id: post.id,
        userId: post.userId,
        userName: post.userName,
        userAvatar: post.userAvatar,
        content: post.content,
        imageUrl: post.imageUrl,
        createdAt: post.createdAt,
        likes: post.likes,
        comments: post.comments,
        shares: post.shares,
        isLiked: post.isLiked,
        isSaved: !post.isSaved,
      );
      _filteredPosts = _posts;
      _savePosts();
      notifyListeners();
    }
  }

  void addComment(String postId, String comment) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = Post(
        id: post.id,
        userId: post.userId,
        userName: post.userName,
        userAvatar: post.userAvatar,
        content: post.content,
        imageUrl: post.imageUrl,
        createdAt: post.createdAt,
        likes: post.likes,
        comments: post.comments + 1,
        shares: post.shares,
        isLiked: post.isLiked,
        isSaved: post.isSaved,
      );
      _filteredPosts = _posts;
      _savePosts();
      notifyListeners();
    }
  }

  void sharePost(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = Post(
        id: post.id,
        userId: post.userId,
        userName: post.userName,
        userAvatar: post.userAvatar,
        content: post.content,
        imageUrl: post.imageUrl,
        createdAt: post.createdAt,
        likes: post.likes,
        comments: post.comments,
        shares: post.shares + 1,
        isLiked: post.isLiked,
        isSaved: post.isSaved,
      );
      _filteredPosts = _posts;
      _savePosts();
      notifyListeners();
    }
  }

  void createPost(String content, String? imageUrl) {
    final now = DateTime.now();
    final newPost = Post(
      id: 'post_${now.millisecondsSinceEpoch}',
      userId: 'current_user',
      userName: 'You',
      userAvatar: 'U',
      content: content,
      imageUrl: imageUrl,
      createdAt: now,
      likes: 0,
      comments: 0,
      shares: 0,
      isLiked: false,
      isSaved: false,
    );
    _posts.insert(0, newPost);
    _filteredPosts = _posts;
    _savePosts();
    notifyListeners();
  }

  void searchPosts(String query) {
    if (query.isEmpty) {
      _filteredPosts = _posts;
    } else {
      final q = query.toLowerCase();
      _filteredPosts = _posts.where((p) =>
        p.content.toLowerCase().contains(q) ||
        p.userName.toLowerCase().contains(q)
      ).toList();
    }
    notifyListeners();
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    if (category == null || category == 'All') {
      _filteredPosts = _posts;
    } else {
      _filteredPosts = _posts.where((p) => p.content.contains(category)).toList();
    }
    notifyListeners();
  }
}

class Post {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isSaved;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
    this.isSaved = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'userAvatar': userAvatar,
    'content': content,
    'imageUrl': imageUrl,
    'createdAt': createdAt.toIso8601String(),
    'likes': likes,
    'comments': comments,
    'shares': shares,
    'isLiked': isLiked,
    'isSaved': isSaved,
  };

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'],
    userId: json['userId'],
    userName: json['userName'],
    userAvatar: json['userAvatar'],
    content: json['content'],
    imageUrl: json['imageUrl'],
    createdAt: DateTime.parse(json['createdAt']),
    likes: json['likes'] ?? 0,
    comments: json['comments'] ?? 0,
    shares: json['shares'] ?? 0,
    isLiked: json['isLiked'] ?? false,
    isSaved: json['isSaved'] ?? false,
  );
}