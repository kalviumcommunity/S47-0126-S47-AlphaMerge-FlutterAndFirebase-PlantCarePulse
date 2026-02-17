import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Top-level function to handle background messages
/// This must be a top-level function (not inside a class)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
}

/// Service to handle Firebase Cloud Messaging (FCM) push notifications
/// 
/// Features:
/// - Request notification permissions
/// - Handle foreground notifications
/// - Handle background notifications
/// - Handle notifications when app is opened from terminated state
/// - Get and manage FCM device tokens
/// - Platform-aware (handles web limitations)
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  /// Callback for foreground notifications
  Function(RemoteMessage)? onForegroundMessage;
  
  /// Callback for when app is opened from notification
  Function(RemoteMessage)? onMessageOpenedApp;
  
  /// Initialize the notification service
  /// 
  /// This method:
  /// 1. Requests notification permissions
  /// 2. Sets up foreground message handler
  /// 3. Sets up background message handler
  /// 4. Sets up notification tap handler
  /// 5. Checks for initial message (app opened from terminated state)
  Future<void> initialize() async {
    try {
      // Request notification permissions
      final settings = await requestPermission();
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ Notification permissions granted');
        
        // Get and print FCM token
        final token = await getToken();
        debugPrint('📱 FCM Token: $token');
        
        // Setup message handlers
        _setupForegroundHandler();
        _setupBackgroundHandler();
        _setupNotificationTapHandler();
        
        // Check for initial message (app opened from terminated state)
        await _checkInitialMessage();
        
        // Listen for token refresh
        _messaging.onTokenRefresh.listen((newToken) {
          debugPrint('🔄 FCM Token refreshed: $newToken');
          // TODO: Send new token to your backend
        });
        
      } else {
        debugPrint('❌ Notification permissions denied');
      }
    } catch (e) {
      debugPrint('❌ Error initializing notifications: $e');
    }
  }
  
  /// Request notification permissions from the user
  Future<NotificationSettings> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    debugPrint('Notification permission status: ${settings.authorizationStatus}');
    return settings;
  }
  
  /// Get the FCM device token
  /// This token is used to send notifications to this specific device
  /// 
  /// For web: Requires VAPID key from Firebase Console
  /// Get it from: Firebase Console > Project Settings > Cloud Messaging > Web Push certificates
  Future<String?> getToken() async {
    try {
      String? token;
      
      if (kIsWeb) {
        // For web, you need to provide VAPID key
        // TODO: Replace with your VAPID key from Firebase Console
        // Get it from: Firebase Console > Project Settings > Cloud Messaging > Web Push certificates
        token = await _messaging.getToken(
          vapidKey: 'YOUR_VAPID_KEY_HERE', // Replace with your actual VAPID key
        );
      } else {
        token = await _messaging.getToken();
      }
      
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }
  
  /// Delete the FCM token
  /// Useful when user logs out
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      debugPrint('FCM token deleted');
    } catch (e) {
      debugPrint('Error deleting FCM token: $e');
    }
  }
  
  /// Setup handler for foreground messages
  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📬 Foreground message received');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Data: ${message.data}');
      
      // Call custom callback if provided
      onForegroundMessage?.call(message);
    });
  }
  
  /// Setup handler for background messages
  void _setupBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
  
  /// Setup handler for when notification is tapped
  void _setupNotificationTapHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🔔 App opened from notification');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Data: ${message.data}');
      
      // Call custom callback if provided
      onMessageOpenedApp?.call(message);
    });
  }
  
  /// Check if app was opened from a notification while terminated
  Future<void> _checkInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    
    if (initialMessage != null) {
      debugPrint('🚀 App opened from terminated state via notification');
      debugPrint('Title: ${initialMessage.notification?.title}');
      debugPrint('Body: ${initialMessage.notification?.body}');
      debugPrint('Data: ${initialMessage.data}');
      
      // Call custom callback if provided
      onMessageOpenedApp?.call(initialMessage);
    }
  }
  
  /// Subscribe to a topic
  /// Useful for sending notifications to groups of users
  /// Note: Not supported on web - use server-side subscription management
  Future<void> subscribeToTopic(String topic) async {
    if (kIsWeb) {
      debugPrint('⚠️ Topic subscriptions not supported on web');
      debugPrint('Use server-side subscription management for web users');
      return;
    }
    
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('✅ Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('❌ Error subscribing to topic: $e');
    }
  }
  
  /// Unsubscribe from a topic
  /// Note: Not supported on web - use server-side subscription management
  Future<void> unsubscribeFromTopic(String topic) async {
    if (kIsWeb) {
      debugPrint('⚠️ Topic unsubscriptions not supported on web');
      debugPrint('Use server-side subscription management for web users');
      return;
    }
    
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('❌ Error unsubscribing from topic: $e');
    }
  }
}
