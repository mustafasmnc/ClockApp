import 'package:clockApp/alarm_helper.dart';
import 'package:clockApp/constants/theme_data.dart';
import 'package:clockApp/main.dart';
import 'package:clockApp/models/alarm_info.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime _alarmTime;
  String _alarmTimeString;
  TextEditingController _alarmTitle = TextEditingController();
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>> _alarms;
  List<AlarmInfo> _currentAlarm;
  bool timeSelected = false;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Alarm',
            style: TextStyle(
                fontFamily: 'avenir',
                fontWeight: FontWeight.w700,
                color: CustomColors.primaryTextColor,
                fontSize: 24),
          ),
          Expanded(
            child: FutureBuilder<List<AlarmInfo>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentAlarm = snapshot.data;
                  return ListView(
                    children: snapshot.data.map<Widget>((alarm) {
                      var alarmTime =
                          DateFormat('hh:mm aa').format(alarm.alarmDateTime);
                      var timeType =
                          DateFormat('aa').format(alarm.alarmDateTime);
                      var gradientColor = GradientTemplate
                          .gradientTemplate[alarm.gradientColorIndex].colors;
                      return GestureDetector(
                        onTap: () {
                          //UPDATE
                          _alarmTimeString =
                              DateFormat('HH:mm').format(DateTime.now());
                          setState(() {
                            timeSelected = false;
                          });
                          showModalBottomSheet(
                            isScrollControlled: true,
                            useRootNavigator: true,
                            context: context,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            builder: (context) {
                              return SingleChildScrollView(
                                child: StatefulBuilder(
                                  builder: (context, setModalState) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: Container(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(
                                          children: [
                                            FlatButton(
                                              onPressed: () async {
                                                var selectedTime =
                                                    await showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            //TimeOfDay.now()
                                                            TimeOfDay.fromDateTime(
                                                                alarm
                                                                    .alarmDateTime));
                                                if (selectedTime != null) {
                                                  setState(() {
                                                    timeSelected = true;
                                                  });
                                                  final now = DateTime.now();
                                                  var selectedDateTime =
                                                      DateTime(
                                                          now.year,
                                                          now.month,
                                                          now.day,
                                                          selectedTime.hour,
                                                          selectedTime.minute);
                                                  _alarmTime = selectedDateTime;
                                                  setModalState(() {
                                                    _alarmTimeString =
                                                        DateFormat('HH:mm')
                                                            .format(
                                                                selectedDateTime);
                                                  });
                                                } else {
                                                  setState(() {
                                                    timeSelected = false;
                                                  });
                                                }
                                              },
                                              child: Text(
                                                timeSelected
                                                    ? _alarmTimeString
                                                    : DateFormat('HH:mm')
                                                        .format(alarm
                                                            .alarmDateTime),
                                                style: TextStyle(fontSize: 32),
                                              ),
                                            ),
                                            SizedBox(height: 5.00),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                  labelText: "Title",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      borderSide:
                                                          BorderSide())),
                                              //initialValue: alarm.title,
                                              controller:
                                                  TextEditingController()
                                                    ..text = alarm.title,
                                              onChanged: (text) {
                                                alarm.title = text;
                                              },
                                              //controller: _alarmTitle,
                                            ),
                                            SizedBox(height: 20.00),
                                            FloatingActionButton.extended(
                                              onPressed: () {
                                                updateAlarm(
                                                    alarm.id, alarm.title);
                                              },
                                              icon: Icon(Icons.alarm),
                                              label: Text('Save'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColor,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColor.last.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(4, 4),
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.label,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        alarm.title,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'avenir'),
                                      ),
                                    ],
                                  ),
                                  // Switch(
                                  //   onChanged: (bool value) {
                                  //     setState(() {
                                  //       alarm.isPending = value;
                                  //     });
                                  //   },
                                  //   value: alarm.isPending != null
                                  //       ? alarm.isPending
                                  //       : true,
                                  //   activeColor: Colors.white,
                                  // ),

                                  Image.asset(
                                    timeType == 'PM'
                                        ? 'assets/moon.png'
                                        : 'assets/sun.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                ],
                              ),
                              Text(
                                'Mon-Fri',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'avenir'),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    alarmTime,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'avenir',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.white,
                                    onPressed: () {
                                      deleteAlarm(alarm.id);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).followedBy([
                      if (_currentAlarm.length < 5)
                        DottedBorder(
                          strokeWidth: 2,
                          color: CustomColors.clockOutline,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(24),
                          dashPattern: [5, 4],
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: CustomColors.clockBG,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            child: FlatButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              onPressed: () {
                                _alarmTimeString =
                                    DateFormat('HH:mm').format(DateTime.now());
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  useRootNavigator: true,
                                  context: context,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (context) {
                                    return SingleChildScrollView(
                                      child: StatefulBuilder(
                                        builder: (context, setModalState) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: Container(
                                              padding: const EdgeInsets.all(32),
                                              child: Column(
                                                children: [
                                                  FlatButton(
                                                    onPressed: () async {
                                                      var selectedTime =
                                                          await showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      );
                                                      if (selectedTime !=
                                                          null) {
                                                        final now =
                                                            DateTime.now();
                                                        var selectedDateTime =
                                                            DateTime(
                                                                now.year,
                                                                now.month,
                                                                now.day,
                                                                selectedTime
                                                                    .hour,
                                                                selectedTime
                                                                    .minute);
                                                        _alarmTime =
                                                            selectedDateTime;
                                                        setModalState(() {
                                                          _alarmTimeString =
                                                              DateFormat(
                                                                      'HH:mm')
                                                                  .format(
                                                                      selectedDateTime);
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                      _alarmTimeString,
                                                      style: TextStyle(
                                                          fontSize: 32),
                                                    ),
                                                  ),
                                                  // ListTile(
                                                  //   title: Text('Repeat'),
                                                  //   trailing: Icon(Icons
                                                  //       .arrow_forward_ios),
                                                  // ),
                                                  // ListTile(
                                                  //   title: Text('Sound'),
                                                  //   trailing: Icon(Icons
                                                  //       .arrow_forward_ios),
                                                  //   onTap: () {},
                                                  // ),
                                                  // ListTile(
                                                  //   title: Text('Title'),
                                                  //   trailing: Icon(
                                                  //       Icons.arrow_forward_ios),
                                                  //       onTap: (){
                                                  //         TextField();
                                                  //       },
                                                  // ),
                                                  SizedBox(height: 5.00),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                        labelText: "Title",
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            borderSide:
                                                                BorderSide())),
                                                    controller: _alarmTitle,
                                                  ),
                                                  SizedBox(height: 20.00),

                                                  FloatingActionButton.extended(
                                                    onPressed: onSaveAlarm,
                                                    icon: Icon(Icons.alarm),
                                                    label: Text('Save'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                                // scheduleAlarm();
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/add_alarm.png',
                                    scale: 1.5,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Add Alarm',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'avenir'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        Center(
                            child: Text(
                          'Only 5 alarms allowed!',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )),
                    ]).toList(),
                  );
                }
                return Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void scheduleAlarm(
      DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo) async {
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
    await flutterLocalNotificationsPlugin.schedule(0, alarmInfo.title, '',
        scheduledNotificationDateTime, platformChannelSpecifics);
    // await flutterLocalNotificationsPlugin.show(
    //     0,
    //     'Office',
    //     alarmInfo.title,
    //     platformChannelSpecifics,
    //     payload: 'Custom_Sound');
  }

  void onSaveAlarm() {
    DateTime scheduleAlarmDateTime;
    if (_alarmTime.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _alarmTime;
    else
      scheduleAlarmDateTime = _alarmTime.add(Duration(days: 1));

    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarm.length,
      title: _alarmTitle.text,
    );
    _alarmHelper.insertAlarm(alarmInfo);
    scheduleAlarm(scheduleAlarmDateTime, alarmInfo);
    Navigator.pop(context);
    loadAlarms();
    setState(() {
      _alarmTitle.clear();
    });
  }

  void deleteAlarm(int id) {
    _alarmHelper.delete(id);
    //unsubscribe for notifications
    loadAlarms();
  }

  void updateAlarm(int id, String alarmTitle) {
    var alarmInfo = AlarmInfo(
      id: id,
      alarmDateTime: _alarmTime,
      gradientColorIndex: _currentAlarm.length,
      title: alarmTitle,
    );
    _alarmHelper.update(alarmInfo);
    Navigator.pop(context);
    loadAlarms();
  }
}
