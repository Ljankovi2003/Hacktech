import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi{
  static final _notifications=FlutterLocalNotificationsPlugin();
  static Future _notificationDetails()async{
    final sound= "alert.mp3";
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id 1',
        'channel name',
        channelDescription: "channel description",
        icon: 'mipmap/ic_launcher',
        priority: Priority.max,
        playSound: true,
        sound:RawResourceAndroidNotificationSound(sound.split('.').first),
        enableVibration: true,
        importance: Importance.max,
        timeoutAfter: 4000
        
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future showNotification({
    int id=0,
    String title,
    String body,
    String payload,

  })async =>
  _notifications.show(
    id,
   title,
    body, 
    await _notificationDetails(),
    payload: payload,
    );


}
