import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatUser> _contacts = [];
  List<ChatMessage> _messages = [];
  ChatUser? _currentChatUser;
  bool _isLoading = false;

  List<ChatUser> get contacts => _contacts;
  List<ChatMessage> get messages => _messages;
  ChatUser? get currentChatUser => _currentChatUser;
  bool get isLoading => _isLoading;

  ChatProvider() {
    _loadChats();
  }

  Future<void> _loadChats() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('chat_contacts');
    if (data != null) {
      try {
        final list = jsonDecode(data) as List;
        _contacts = list.map((item) => ChatUser(
          id: item['id'],
          name: item['name'],
          avatar: item['avatar'],
          lastMessage: item['lastMessage'],
          lastMessageTime: DateTime.parse(item['lastMessageTime']),
          unreadCount: item['unreadCount'] ?? 0,
          isOnline: item['isOnline'] ?? false,
        )).toList();
      } catch (e) {
        loadSampleChats();
      }
    } else {
      loadSampleChats();
    }
  }

  Future<void> _saveChats() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _contacts.map((c) => ({
      'id': c.id,
      'name': c.name,
      'avatar': c.avatar,
      'lastMessage': c.lastMessage,
      'lastMessageTime': c.lastMessageTime.toIso8601String(),
      'unreadCount': c.unreadCount,
      'isOnline': c.isOnline,
    })).toList();
    await prefs.setString('chat_contacts', jsonEncode(list));
  }

  void loadSampleChats() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      final now = DateTime.now();
      final random = Random();
      
      final names = ['Father', 'Mother', 'Brother', 'Sister', 'Grandfather', 'Grandmother'];
      final emojis = ['👨', '👩', '👦', '👧', '👴', '👵'];
      final lastMessages = [
        'How are you?', 'Family dinner tonight?', 'Happy Birthday! 🎉',
        'Can you please call me?', 'I love you! ❤️', 'See you tomorrow!',
      ];
      
      _contacts = List.generate(6, (index) {
        final lastMessage = lastMessages[random.nextInt(lastMessages.length)];
        final timeAgo = now.subtract(Duration(minutes: random.nextInt(120)));
        
        return ChatUser(
          id: 'user_${1000 + index}',
          name: names[index],
          avatar: emojis[index],
          lastMessage: lastMessage,
          lastMessageTime: timeAgo,
          unreadCount: random.nextInt(5),
          isOnline: random.nextBool(),
        );
      })..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      
      _isLoading = false;
      _saveChats();
      notifyListeners();
    });
  }

  void selectChat(String userId) {
    _isLoading = true;
    notifyListeners();
    
    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        _currentChatUser = _contacts.firstWhere((c) => c.id == userId);
        _messages = [];
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void markAsRead(String userId) {
    final index = _contacts.indexWhere((c) => c.id == userId);
    if (index != -1) {
      _contacts[index] = ChatUser(
        id: _contacts[index].id,
        name: _contacts[index].name,
        avatar: _contacts[index].avatar,
        lastMessage: _contacts[index].lastMessage,
        lastMessageTime: _contacts[index].lastMessageTime,
        unreadCount: 0,
        isOnline: _contacts[index].isOnline,
      );
      _saveChats();
      notifyListeners();
    }
  }

  Future<void> sendMessage(String content, {String? imageUrl}) async {
    if (_currentChatUser == null) return;
    
    final message = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'current_user',
      senderName: 'You',
      content: content,
      timestamp: DateTime.now(),
      isMe: true,
      isRead: true,
      type: imageUrl != null ? MessageType.image : MessageType.text,
      imageUrl: imageUrl,
    );
    
    _messages.add(message);
    
    final chatIndex = _contacts.indexWhere((c) => c.id == _currentChatUser!.id);
    if (chatIndex != -1) {
      _contacts[chatIndex] = ChatUser(
        id: _contacts[chatIndex].id,
        name: _contacts[chatIndex].name,
        avatar: _contacts[chatIndex].avatar,
        lastMessage: content,
        lastMessageTime: DateTime.now(),
        unreadCount: _contacts[chatIndex].unreadCount,
        isOnline: _contacts[chatIndex].isOnline,
      );
      _currentChatUser = _contacts[chatIndex];
    }
    
    _saveChats();
    notifyListeners();
    
    _simulateReply();
  }

  void _simulateReply() {
    Future.delayed(Duration(seconds: 1 + Random().nextInt(2)), () {
      if (_currentChatUser == null) return;
      
      final replies = [
        'That\'s great! 👍', 'I agree with you.', 'Let me think about that.',
        'Sure, I\'ll do that.', 'Thanks for sharing!', 'Interesting point!',
        'I\'ll get back to you.', 'Sounds good to me!',
      ];
      
      final reply = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: _currentChatUser!.id,
        senderName: _currentChatUser!.name,
        content: replies[Random().nextInt(replies.length)],
        timestamp: DateTime.now(),
        isMe: false,
        isRead: true,
        type: MessageType.text,
      );

      _messages.add(reply);
      
      final chatIndex = _contacts.indexWhere((c) => c.id == _currentChatUser!.id);
      if (chatIndex != -1) {
        _contacts[chatIndex] = ChatUser(
          id: _contacts[chatIndex].id,
          name: _contacts[chatIndex].name,
          avatar: _contacts[chatIndex].avatar,
          lastMessage: reply.content,
          lastMessageTime: DateTime.now(),
          unreadCount: _contacts[chatIndex].unreadCount + 1,
          isOnline: _contacts[chatIndex].isOnline,
        );
        _currentChatUser = _contacts[chatIndex];
        _saveChats();
      }

      notifyListeners();
    });
  }

  void clearCurrentChat() {
    _currentChatUser = null;
    _messages = [];
    notifyListeners();
  }

  int getUnreadCount() {
    return _contacts.fold(0, (sum, chat) => sum + chat.unreadCount);
  }
}

class ChatUser {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  ChatUser({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  final bool isRead;
  final MessageType type;
  final String? imageUrl;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.isMe = false,
    this.isRead = false,
    this.type = MessageType.text,
    this.imageUrl,
  });
}

enum MessageType {
  text,
  image,
  file,
}