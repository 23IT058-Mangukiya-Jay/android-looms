import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Background FCM message handler – must be a top-level function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📩 [FCM Background] Received: ${message.notification?.title}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // ─── Notification Channel IDs ───────────────────────────────────────────────
  static const String _highImportanceChannelId = 'looms_high_importance_channel';
  static const String _scheduledChannelId = 'looms_scheduled_channel';

  // ─── Callback ───────────────────────────────────────────────────────────────
  /// Called when user taps a local notification. Payload is the route string.
  void Function(String? payload)? onNotificationTap;

  // ─── Initialise ─────────────────────────────────────────────────────────────
  Future<void> initialize({void Function(String? payload)? onTap}) async {
    onNotificationTap = onTap;

    // Initialise timezone database
    tz.initializeTimeZones();

    // ── Local notifications setup ──
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('🔔 Notification tapped: ${response.payload}');
        onNotificationTap?.call(response.payload);
      },
    );

    // Create Android notification channels
    await _createNotificationChannels();

    // ── FCM / Push notification setup ──
    await _initFCM();
  }

  // ─── Android Channels ───────────────────────────────────────────────────────
  Future<void> _createNotificationChannels() async {
    final androidPlugin =
        _localPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    // High-importance channel (instant alerts)
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _highImportanceChannelId,
        'Looms Alerts',
        description: 'High-priority notifications for the Looms Management App',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      ),
    );

    // Scheduled reminders channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _scheduledChannelId,
        'Looms Scheduled Reminders',
        description: 'Scheduled reminders for production shifts and tasks',
        importance: Importance.defaultImportance,
        playSound: true,
      ),
    );
  }

  // ─── FCM ────────────────────────────────────────────────────────────────────
  Future<void> _initFCM() async {
    try {
      // Request permission (iOS & Android 13+)
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint('🔑 FCM Permission: ${settings.authorizationStatus}');

      // Background handler is NOT supported on web
      if (!kIsWeb) {
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      }

      // Get and print FCM device token
      // On web (localhost) this may fail — wrap in try/catch
      try {
        String? token = await _fcm.getToken();
        debugPrint('📱 FCM Device Token: $token');
      } catch (e) {
        debugPrint('⚠️ Could not get FCM token (expected on localhost): $e');
      }

      // Foreground FCM messages → show as local notification
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('📩 [FCM Foreground] ${message.notification?.title}');
        if (message.notification != null) {
          showInstantNotification(
            title: message.notification!.title ?? 'Looms Alert',
            body: message.notification!.body ?? '',
            payload: message.data['route'],
          );
        }
      });

      // Notification opened from background (app was minimised)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('🚀 [FCM] Opened from background: ${message.data}');
        onNotificationTap?.call(message.data['route']);
      });

      // Notification that launched the app when it was terminated
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('🚀 [FCM] App launched from notification');
        onNotificationTap?.call(initialMessage.data['route']);
      }
    } catch (e) {
      debugPrint('⚠️ FCM initialization error (non-fatal on web): $e');
    }
  }

  // ─── Request Runtime Permission (Android 13+) ────────────────────────────
  Future<bool> requestPermission() async {
    final androidPlugin =
        _localPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final bool? granted = await androidPlugin.requestPermission();
      return granted ?? true;
    }
    return true; // iOS permission handled in _initFCM
  }

  // ─── STEP 3: Instant Notification ───────────────────────────────────────────
  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _highImportanceChannelId,
      'Looms Alerts',
      channelDescription: 'High-priority notifications for Looms Management',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF4F46E5),
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localPlugin.show(id, title, body, details, payload: payload);
    debugPrint('✅ Instant notification shown: $title');
  }

  // ─── STEP 4: Scheduled Notification ─────────────────────────────────────────
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required Duration delay,
    String? payload,
  }) async {
    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.now(tz.local).add(delay);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _scheduledChannelId,
      'Looms Scheduled Reminders',
      channelDescription: 'Scheduled reminders for Looms',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    debugPrint('⏰ Notification scheduled: $title in ${delay.inMinutes} min');
  }

  // ─── Daily Recurring Notification ────────────────────────────────────────────
  Future<void> scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    await _localPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _scheduledChannelId,
          'Looms Scheduled Reminders',
          channelDescription: 'Daily shift reminders for Looms',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    debugPrint('📅 Daily reminder set at $hour:${minute.toString().padLeft(2, '0')}');
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  // ─── Cancel Notifications ─────────────────────────────────────────────────
  Future<void> cancelNotification(int id) async {
    await _localPlugin.cancel(id);
    debugPrint('❌ Cancelled notification $id');
  }

  Future<void> cancelAllNotifications() async {
    await _localPlugin.cancelAll();
    debugPrint('❌ All notifications cancelled');
  }

  // ─── Get FCM Token ────────────────────────────────────────────────────────
  Future<String?> getFCMToken() async {
    return await _fcm.getToken();
  }

  // ─── Get Pending Notifications ────────────────────────────────────────────
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localPlugin.pendingNotificationRequests();
  }
}
