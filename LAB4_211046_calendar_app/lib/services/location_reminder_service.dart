import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';

import '../models/exam_model.dart';

void scheduleLocationBasedReminder(Exam exam) async {
  const double proximityRadius = 1500;


  Geolocator.getPositionStream().listen((Position position) async {
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      exam.latitude,
      exam.longitude,
    );

    if (distance <= proximityRadius) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: exam.timestamp.millisecondsSinceEpoch.hashCode,
          channelKey: 'basic_channel',
          title: 'You are near ${exam.course}!',
          body: 'Your exam at ${exam.location} is nearby. Don’t forget!',
        ),
      );
    }
  });
}
