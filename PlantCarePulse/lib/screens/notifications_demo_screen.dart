import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/notification_service.dart';

/// Demo screen for Firebase Cloud Messaging (Push Notifications)
/// 
/// Features demonstrated:
/// - Display FCM device token
/// - Subscribe/unsubscribe to topics
/// - Show received notifications
/// - Test notification permissions
class NotificationsDemoScreen extends StatefulWidget {
  const NotificationsDemoScreen({super.key});

  @override
  State<NotificationsDemoScreen> createState() => _NotificationsDemoScreenState();
}

class _NotificationsDemoScreenState extends State<NotificationsDemoScreen> {
  final NotificationService _notificationService = NotificationService();
  String? _fcmToken;
  final List<RemoteMessage> _receivedMessages = [];
  bool _isSubscribedToPlantCare = false;
  bool _isSubscribedToReminders = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    // Get FCM token
    final token = await _notificationService.getToken();
    setState(() {
      _fcmToken = token;
    });

    // Setup message handlers
    _notificationService.onForegroundMessage = (message) {
      setState(() {
        _receivedMessages.insert(0, message);
      });
      _showNotificationSnackBar(message);
    };

    _notificationService.onMessageOpenedApp = (message) {
      setState(() {
        _receivedMessages.insert(0, message);
      });
      _showNotificationDialog(message);
    };
  }

  void _showNotificationSnackBar(RemoteMessage message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.notification?.body ?? 'New notification'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => _showNotificationDialog(message),
        ),
      ),
    );
  }

  void _showNotificationDialog(RemoteMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.notification?.title ?? 'Notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.notification?.body ?? 'No content'),
            if (message.data.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Data:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(message.data.toString()),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _copyTokenToClipboard() async {
    if (_fcmToken != null) {
      await Clipboard.setData(ClipboardData(text: _fcmToken!));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token copied to clipboard')),
        );
      }
    }
  }

  Future<void> _toggleTopicSubscription(String topic, bool currentState) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Topic subscriptions not supported on web. Use server-side management.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (currentState) {
      await _notificationService.unsubscribeFromTopic(topic);
    } else {
      await _notificationService.subscribeToTopic(topic);
    }

    setState(() {
      if (topic == 'plant_care') {
        _isSubscribedToPlantCare = !currentState;
      } else if (topic == 'reminders') {
        _isSubscribedToReminders = !currentState;
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            currentState
                ? 'Unsubscribed from $topic'
                : 'Subscribed to $topic',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notifications'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FCM Token Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.key, color: Color(0xFF00C853)),
                        const SizedBox(width: 8),
                        Text(
                          'FCM Device Token',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_fcmToken != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          _fcmToken!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _copyTokenToClipboard,
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy Token'),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.warning_amber, color: Colors.orange.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  'Token Not Available',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (kIsWeb)
                              const Text(
                                'Web platform requires VAPID key configuration.\n\n'
                                'Steps to fix:\n'
                                '1. Get VAPID key from Firebase Console\n'
                                '2. Update notification_service.dart\n'
                                '3. Restart the app\n\n'
                                'See WEB_NOTIFICATIONS_SETUP.md for details.',
                                style: TextStyle(fontSize: 12),
                              )
                            else
                              const Text(
                                'Unable to get FCM token. Check:\n'
                                '• Internet connection\n'
                                '• Firebase configuration\n'
                                '• Notification permissions',
                                style: TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Web Platform Warning
            if (kIsWeb)
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.web, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Web Platform Notice',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.orange.shade700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'You are running on web. Please note:\n\n'
                        '• Topic subscriptions must be managed server-side\n'
                        '• Ensure firebase-messaging-sw.js is properly configured\n'
                        '• VAPID key may be required for production\n'
                        '• Test on mobile/desktop for full functionality',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

            if (kIsWeb) const SizedBox(height: 16),

            // Topic Subscriptions Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.topic, color: Color(0xFF00C853)),
                        const SizedBox(width: 8),
                        Text(
                          'Topic Subscriptions',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (!kIsWeb) ...[
                      SwitchListTile(
                        title: const Text('Plant Care Tips'),
                        subtitle: const Text('Receive plant care tips and advice'),
                        value: _isSubscribedToPlantCare,
                        onChanged: (value) =>
                            _toggleTopicSubscription('plant_care', _isSubscribedToPlantCare),
                        activeColor: const Color(0xFF00C853),
                      ),
                      SwitchListTile(
                        title: const Text('Watering Reminders'),
                        subtitle: const Text('Get notified about watering schedules'),
                        value: _isSubscribedToReminders,
                        onChanged: (value) =>
                            _toggleTopicSubscription('reminders', _isSubscribedToReminders),
                        activeColor: const Color(0xFF00C853),
                      ),
                    ] else
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Topic subscriptions are not supported on web.\n'
                          'Use server-side subscription management for web users.',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Received Messages Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications, color: Color(0xFF00C853)),
                        const SizedBox(width: 8),
                        Text(
                          'Received Notifications',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_receivedMessages.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'No notifications received yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _receivedMessages.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final message = _receivedMessages[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFF00C853),
                              child: Icon(Icons.notifications, color: Colors.white),
                            ),
                            title: Text(
                              message.notification?.title ?? 'No title',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              message.notification?.body ?? 'No content',
                            ),
                            onTap: () => _showNotificationDialog(message),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Instructions Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'How to Test',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.blue.shade700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1. Copy your FCM token above\n'
                      '2. Use Firebase Console or a tool like Postman\n'
                      '3. Send a test notification to your token\n'
                      '4. Or subscribe to a topic and send to that topic\n\n'
                      'Example using Firebase Console:\n'
                      '• Go to Firebase Console > Cloud Messaging\n'
                      '• Click "Send your first message"\n'
                      '• Enter title and body\n'
                      '• Select "Single device" and paste your token',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
