import 'package:clockApp/constants/theme_data.dart';
import 'package:clockApp/data.dart';
import 'package:clockApp/main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alarm',
            style: TextStyle(
                fontFamily: 'avenir',
                fontWeight: FontWeight.w700,
                color: CustomColors.primaryTextColor,
                fontSize: 24),
          ),
          Expanded(
            child: ListView(
              children: alarms.map<Widget>((alarm) {
                return Container(
                  margin: EdgeInsets.only(bottom: 32),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: alarm.gradientColor,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: alarm.gradientColor.last.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(4, 4),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.label, color: Colors.white, size: 24),
                              SizedBox(width: 10),
                              Text('Office',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'avenir',
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          Switch(
                            value: true,
                            activeColor: Colors.white,
                            onChanged: (bool value) {},
                          )
                        ],
                      ),
                      Text('Mon-Fri',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'avenir',
                              fontWeight: FontWeight.w500)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('07:00 AM',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'avenir',
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              )),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 30,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }).followedBy([
                if (alarms.length < 5)
                  DottedBorder(
                    strokeWidth: 3,
                    color: CustomColors.clockOutline,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(25),
                    dashPattern: [5, 4],
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: CustomColors.clockBG,
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: FlatButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        onPressed: () {
                          scheduleAlarm();
                          print("ses calar");
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/add_alarm.png',
                              scale: 1.5,
                            ),
                            SizedBox(height: 8),
                            Text('Add Alarm',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'avenir'))
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Text('Only 5 alarms allowed!'),
              ]).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void scheduleAlarm() async {
    DateTime  scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 10));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'app_logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('app_logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    if (!mounted) return;
    else{
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Office',
        'Good morning! Time for office.',
        scheduledNotificationDateTime,
        platformChannelSpecifics);}
  }
}
