# Firebase Push Notifications Implementation

## Overview

This document explains the Firebase Cloud Messaging (FCM) push notifications implementation in the PlantCarePulse app.

## Why Push Notifications Are Important

- **Real-time Communication**: Send alerts, updates, and reminders instantly
- **User Engagement**: Keep users informed and engaged with timely notifications
- **Critical Functionality**: Support features like watering reminders, plant care tips, and alerts
- **Works Offline**: Notifications are delivered even when the app is not running

## Implementation Details

### 1. Dependencies Added

```yaml
firebase_messaging: ^16.1.1
```

### 2. Files Created

- `lib/services/notification_service.dart` - Core notification service
- `lib/screens/notifications_demo_screen.dart` - Demo screen to test notifications

### 3. Service Features

The `NotificationService` class provides:

- ✅ Request notification permissions
- ✅ Handle foreground notifications (app is open)
- ✅ Handle background notifications (app is in background)
- ✅ Handle notifications when app is terminated
- ✅ Get and manage FCM device tokens
- ✅ Subscribe/unsubscribe to topics
- ✅ Token refresh handling

### 4. Notification States Handled

#### Foreground (App is Open)
```dart
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  // Handle notification while app is in foreground
});
```

#### Background (App is Minimized)
```dart
FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
```

#### Terminated (App is Closed)
```dart
final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
```

#### Notification Tap
```dart
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  // Handle when user taps notification
});
```

## Usage

### Initialize Notifications

Notifications are automatically initialized in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize push notifications
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  runApp(const PlantCarePulseApp());
}
```

### Get FCM Token

```dart
final notificationService = NotificationService();
final token = await notificationService.getToken();
print('FCM Token: $token');
```

### Subscribe to Topics

```dart
await notificationService.subscribeToTopic('plant_care');
await notificationService.subscribeToTopic('reminders');
```

### Custom Message Handlers

```dart
notificationService.onForegroundMessage = (message) {
  // Custom handling for foreground messages
  print('Received: ${message.notification?.title}');
};

notificationService.onMessageOpenedApp = (message) {
  // Navigate to specific screen based on notification data
  Navigator.pushNamed(context, '/plant-detail', arguments: message.data);
};
```

## Testing Notifications

### Using the Demo Screen

1. Navigate to `/notifications-demo` route
2. Copy your FCM token
3. Use Firebase Console or Postman to send test notifications

### Method 1: Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Cloud Messaging**
4. Click **Send your first message**
5. Enter notification details:
   - Title: "Plant Care Reminder"
   - Body: "Time to water your plants!"
6. Select **Single device** and paste your FCM token
7. Click **Send**

### Method 2: Using Postman

Send a POST request to:
```
https://fcm.googleapis.com/fcm/send
```

Headers:
```
Content-Type: application/json
Authorization: key=YOUR_SERVER_KEY
```

Body:
```json
{
  "to": "YOUR_FCM_TOKEN",
  "notification": {
    "title": "Plant Care Reminder",
    "body": "Time to water your Monstera!",
    "sound": "default"
  },
  "data": {
    "plantId": "123",
    "action": "water"
  }
}
```

### Method 3: Topic Notifications

Send to all subscribers of a topic:

```json
{
  "to": "/topics/plant_care",
  "notification": {
    "title": "Plant Care Tip",
    "body": "Did you know? Overwatering is the #1 cause of plant death."
  }
}
```

## Platform-Specific Setup

### Android Setup

1. **Add google-services.json**
   - Download from Firebase Console
   - Place in `android/app/google-services.json`

2. **Update AndroidManifest.xml** (if needed)
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   ```

3. **No additional configuration needed** - FCM works out of the box on Android

### iOS Setup

1. **Add GoogleService-Info.plist**
   - Download from Firebase Console
   - Place in `ios/Runner/GoogleService-Info.plist`

2. **Enable Push Notifications**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select Runner target
   - Go to **Signing & Capabilities**
   - Click **+ Capability**
   - Add **Push Notifications**
   - Add **Background Modes** and enable:
     - Remote notifications

3. **Configure APNs**
   - Generate APNs certificate or key in Apple Developer Portal
   - Upload to Firebase Console under Project Settings > Cloud Messaging

4. **Update Info.plist**
   ```xml
   <key>FirebaseAppDelegateProxyEnabled</key>
   <false/>
   ```

### Web Setup

1. **Add firebase-messaging-sw.js** in `web/` folder
2. **Configure VAPID key** in Firebase Console
3. **Request notification permission** in browser

## Common Issues and Solutions

### Issue: Notifications not received

**Solutions:**
- ✅ Check notification permissions are granted
- ✅ Verify `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is present
- ✅ Ensure FCM is enabled in Firebase Console
- ✅ Check device has internet connection
- ✅ Verify FCM token is valid and not expired

### Issue: Background handler not working

**Solution:**
- ✅ Ensure `firebaseMessagingBackgroundHandler` is a top-level function
- ✅ Add `@pragma('vm:entry-point')` annotation
- ✅ Don't use UI code in background handler

### Issue: iOS notifications not working

**Solutions:**
- ✅ Configure APNs certificate/key in Firebase Console
- ✅ Enable Push Notifications capability in Xcode
- ✅ Enable Background Modes > Remote notifications
- ✅ Test on physical device (not simulator)

### Issue: Token is null

**Solutions:**
- ✅ Wait for Firebase initialization to complete
- ✅ Check internet connection
- ✅ Verify Firebase configuration files are correct

## Best Practices

1. **Request Permissions Wisely**
   - Ask for permissions at the right time
   - Explain why notifications are needed
   - Provide value before asking

2. **Handle All States**
   - Foreground, background, and terminated states
   - Notification tap events
   - Token refresh events

3. **Use Topics for Groups**
   - Subscribe users to relevant topics
   - Send targeted notifications
   - Reduce unnecessary notifications

4. **Include Data Payload**
   - Add custom data for navigation
   - Include IDs for deep linking
   - Keep payload small (<4KB)

5. **Test Thoroughly**
   - Test on both Android and iOS
   - Test all notification states
   - Test with different payload sizes

6. **Monitor Token Changes**
   - Listen to token refresh events
   - Update backend with new tokens
   - Handle token deletion on logout

## Notification Payload Structure

### Notification-only Message
```json
{
  "notification": {
    "title": "Plant Care Reminder",
    "body": "Time to water your plants!",
    "image": "https://example.com/plant.jpg"
  }
}
```

### Data-only Message (Silent)
```json
{
  "data": {
    "type": "water_reminder",
    "plantId": "123",
    "action": "water"
  }
}
```

### Combined Message
```json
{
  "notification": {
    "title": "Plant Care Reminder",
    "body": "Time to water your Monstera!"
  },
  "data": {
    "plantId": "123",
    "screen": "/plant-detail"
  }
}
```

## Integration with PlantCarePulse Features

### Watering Reminders
```dart
// Subscribe to watering reminders
await notificationService.subscribeToTopic('watering_reminders');
```

### Plant Care Tips
```dart
// Subscribe to care tips
await notificationService.subscribeToTopic('plant_care_tips');
```

### Custom Plant Notifications
```dart
// Handle notification tap to navigate to plant detail
notificationService.onMessageOpenedApp = (message) {
  final plantId = message.data['plantId'];
  Navigator.pushNamed(context, '/plant-detail', arguments: plantId);
};
```

## Next Steps

1. **Backend Integration**
   - Store FCM tokens in Firestore
   - Create Cloud Functions to send notifications
   - Implement scheduled notifications

2. **Advanced Features**
   - Rich notifications with images
   - Action buttons on notifications
   - Notification channels (Android)
   - Notification grouping

3. **Analytics**
   - Track notification delivery
   - Monitor open rates
   - A/B test notification content

## Resources

- [Firebase Cloud Messaging Documentation](https://firebase.google.com/docs/cloud-messaging)
- [FlutterFire Messaging Plugin](https://firebase.flutter.dev/docs/messaging/overview)
- [FCM HTTP v1 API](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages)
- [Testing FCM](https://firebase.google.com/docs/cloud-messaging/flutter/first-message)

## Support

For issues or questions:
1. Check the demo screen at `/notifications-demo`
2. Review console logs for FCM token and errors
3. Verify Firebase Console configuration
4. Test with Firebase Console's test message feature
