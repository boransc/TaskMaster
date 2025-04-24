import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
  FlutterLocalNotificationsPlugin();
  //initialise the notification plugin
  static Future<void> initialise() async {
    const AndroidInitializationSettings initialisationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initialisationSettingsAndroid
    );

    await notifications.initialize(initializationSettings);
    tz.initializeTimeZones();
  }
  //schedule reminder
  static Future<void> scheduleReminder({
    required int id, required String title,
    required String body, required DateTime scheduledDate
  }) async {
    final tz.TZDateTime tzScheduledDate =
    tz.TZDateTime.from(scheduledDate, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Reminders',
      channelDescription: 'Task deadline reminders',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: DefaultStyleInformation(true, true)
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );
    await notifications.zonedSchedule(
      id, title, body, tzScheduledDate, notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime
    );
  }
}


