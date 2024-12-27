import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:calendar_app/screens/main_list.dart';
import 'package:flutter/material.dart';
import 'models/exam_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
void scheduleLocationReminder(Exam exam) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: 'Reminder for ${exam.course}',
      body: 'Exam at ${exam.location} is approaching!',
    ),
    schedule: NotificationCalendar.fromDate(date: exam.timestamp),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainListScreen(),

      },
    );
  }
}
