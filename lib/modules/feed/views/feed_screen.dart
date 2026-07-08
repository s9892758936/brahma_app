import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/feed/providers/feed_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;
  String? _selectedFilter;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FeedProvider>(context, listen: false).loadSamplePosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '🕉️',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Feed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.loadSamplePosts();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', _selectedFilter == null),
                  _buildFilterChip('Family', _selectedFilter == 'Family'),
                  _buildFilterChip('Spiritual', _selectedFilter == 'Spiritual'),
                  _buildFilterChip('Celebration', _selectedFilter == 'Celebration'),
                  _buildFilterChip('Announcement', _selectedFilter == 'Announcement'),
                ],
              ),
            ),
          ),
          // Feed List
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.posts.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.post_add,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No posts yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Be the first to share!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          provider.loadSamplePosts();
                        },
                        color: AppTheme.primaryColor,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.posts.length,
                          itemBuilder: (context, index) {
                            final post = provider.posts[index];
                            return _buildPostCard(context, post);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? label : null;
            final provider = Provider.of<FeedProvider>(context, listen: false);
            provider.filterByCategory(selected ? label : null);
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[700],
        ),
        checkmarkColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, Post post) {
    final timeAgo = _getTimeAgo(post.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                  child: Text(
                    post.userAvatar,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'report',
                      child: Text('Report Post'),
                    ),
                    const PopupMenuItem(
                      value: 'hide',
                      child: Text('Hide Post'),
                    ),
                  ],
                  onSelected: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🕉️ Post ${value == 'report' ? 'reported' : 'hidden'}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Content
            Text(
              post.content,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            
            // Image
            if (post.imageUrl != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(post.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            // Actions
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    Provider.of<FeedProvider>(context, listen: false)
                        .toggleLike(post.id);
                  },
                ),
                Text('${post.likes}'),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    _showCommentDialog(context, post.id);
                  },
                  color: Colors.blue,
                ),
                Text('${post.comments}'),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Provider.of<FeedProvider>(context, listen: false)
                        .sharePost(post.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🕉️ Post shared!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  color: Colors.green,
                ),
                Text('${post.shares}'),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: post.isSaved ? AppTheme.primaryColor : null,
                  ),
                  onPressed: () {
                    Provider.of<FeedProvider>(context, listen: false)
                        .toggleSave(post.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔍 Search Posts'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search by keyword...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            final provider = Provider.of<FeedProvider>(context, listen: false);
            provider.searchPosts(value);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<FeedProvider>(context, listen: false);
              provider.searchPosts(_searchController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🕉️'),
            SizedBox(width: 8),
            Text('Create Post'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _postController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'What\'s on your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                  color: AppTheme.primaryColor,
                ),
                IconButton(
                  icon: const Icon(Icons.video_library),
                  onPressed: () {},
                  color: AppTheme.primaryColor,
                ),
                IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: () {},
                  color: AppTheme.primaryColor,
                ),
                if (_selectedImage != null)
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearPostDialog();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_postController.text.isNotEmpty) {
                final provider = Provider.of<FeedProvider>(context, listen: false);
                provider.createPost(_postController.text, null);
                _clearPostDialog();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🕉️ Post shared successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  void _showCommentDialog(BuildContext context, String postId) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💬 Add Comment'),
        content: TextField(
          controller: commentController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Write a comment...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                Provider.of<FeedProvider>(context, listen: false)
                    .addComment(postId, commentController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🕉️ Comment added!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Comment'),
          ),
        ],
      ),
    );
  }

  void _clearPostDialog() {
    _postController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📸 Image selected!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
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