import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/modules/splash/views/splash_screen.dart';
import 'package:brahma_app/modules/auth/views/login_screen.dart';
import 'package:brahma_app/modules/auth/views/otp_screen.dart';
import 'package:brahma_app/modules/profile/views/personal_info_screen.dart';
import 'package:brahma_app/modules/profile/views/brahmin_details_screen.dart';
import 'package:brahma_app/modules/profile/views/address_screen.dart';
import 'package:brahma_app/modules/profile/views/education_screen.dart';
import 'package:brahma_app/modules/profile/views/professional_screen.dart';
import 'package:brahma_app/modules/profile/views/family_screen.dart';
import 'package:brahma_app/modules/profile/views/social_screen.dart';
import 'package:brahma_app/modules/profile/views/document_screen.dart';
import 'package:brahma_app/modules/profile/views/review_screen.dart';
import 'package:brahma_app/modules/profile/views/user_profile_view.dart';
import 'package:brahma_app/modules/dashboard/views/dashboard_screen.dart';
import 'package:brahma_app/modules/admin/views/admin_dashboard.dart';
import 'package:brahma_app/modules/admin/views/admin_login_screen.dart';
import 'package:brahma_app/modules/feed/views/feed_screen.dart';
import 'package:brahma_app/modules/chat/views/chat_list_screen.dart';
import 'package:brahma_app/modules/chat/views/chat_screen.dart';
import 'package:brahma_app/modules/settings/views/settings_screen.dart';
import 'package:brahma_app/modules/notifications/views/notification_screen.dart';
import 'package:brahma_app/modules/search/views/search_screen.dart';
import 'package:brahma_app/modules/family_tree/views/family_tree_screen.dart';
import 'package:brahma_app/modules/job/views/job_list_screen.dart';
import 'package:brahma_app/modules/business/views/business_list_screen.dart';
import 'package:brahma_app/modules/analytics/views/analytics_dashboard.dart';
import 'package:brahma_app/modules/reports/views/reports_screen.dart';
import 'package:brahma_app/modules/groups/views/groups_screen.dart';
import 'package:brahma_app/modules/admin/views/admin_review_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    
    // Auth
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      name: 'otp',
      builder: (context, state) => const OTPScreen(),
    ),
    
    // Admin Login
    GoRoute(
      path: '/admin_login',
      name: 'admin_login',
      builder: (context, state) => const AdminLoginScreen(),
    ),
    
    // Profile Steps
    GoRoute(
      path: '/personal_info',
      name: 'personal_info',
      builder: (context, state) => const PersonalInfoScreen(),
    ),
    GoRoute(
      path: '/brahmin_details',
      name: 'brahmin_details',
      builder: (context, state) => const BrahminDetailsScreen(),
    ),
    GoRoute(
      path: '/address',
      name: 'address',
      builder: (context, state) => const AddressScreen(),
    ),
    GoRoute(
      path: '/education',
      name: 'education',
      builder: (context, state) => const EducationScreen(),
    ),
    GoRoute(
      path: '/professional',
      name: 'professional',
      builder: (context, state) => const ProfessionalScreen(),
    ),
    GoRoute(
      path: '/family',
      name: 'family',
      builder: (context, state) => const FamilyScreen(),
    ),
    GoRoute(
      path: '/social',
      name: 'social',
      builder: (context, state) => const SocialScreen(),
    ),
    GoRoute(
      path: '/documents',
      name: 'documents',
      builder: (context, state) => const DocumentScreen(),
    ),
    GoRoute(
      path: '/review',
      name: 'review',
      builder: (context, state) => const ReviewScreen(),
    ),
    
    // User Profile
    GoRoute(
      path: '/user_profile/:userId',
      name: 'user_profile',
      builder: (context, state) {
        final userId = state.pathParameters['userId'] ?? '';
        return UserProfileView(userId: userId);
      },
    ),
    
    // Dashboard
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    
    // Admin
    GoRoute(
      path: '/admin',
      name: 'admin',
      builder: (context, state) => const AdminDashboard(),
    ),
    
    // Feed
    GoRoute(
      path: '/feed',
      name: 'feed',
      builder: (context, state) => const FeedScreen(),
    ),
    
    // Chat
    GoRoute(
      path: '/chat',
      name: 'chat_list',
      builder: (context, state) => const ChatListScreen(),
    ),
    GoRoute(
      path: '/chat/:userId',
      name: 'chat',
      builder: (context, state) {
        final userId = state.pathParameters['userId'] ?? '';
        return ChatScreen(userId: userId);
      },
    ),
    
    // Settings
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    
    // Notifications
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    
    // Search
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),
    
    // Family Tree
    GoRoute(
      path: '/family_tree',
      name: 'family_tree',
      builder: (context, state) => const FamilyTreeScreen(),
    ),
    
    // Jobs
    GoRoute(
      path: '/jobs',
      name: 'jobs',
      builder: (context, state) => const JobListScreen(),
    ),
    
    // Business
    GoRoute(
      path: '/business',
      name: 'business',
      builder: (context, state) => const BusinessListScreen(),
    ),
    
    // Analytics
    GoRoute(
      path: '/analytics',
      name: 'analytics',
      builder: (context, state) => const AnalyticsDashboard(),
    ),
    
    // Reports
    GoRoute(
      path: '/reports',
      name: 'reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    
    // Groups
    GoRoute(
      path: '/groups',
      name: 'groups',
      builder: (context, state) => const GroupsScreen(),
    ),
GoRoute(
  path: '/admin_review',
  name: 'admin_review',
  builder: (context, state) => const AdminReviewScreen(),
),
  ],
);