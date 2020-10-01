import 'package:clockApp/clock_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('HH:mm').format(now);
    var formattedDate = DateFormat('EEEE, d MMMM').format(now);
    var timezoneString = now.timeZoneOffset.toString().split('.').first;
    var offsetSign = '';
    if (!timezoneString.startsWith('-')) {
      offsetSign = '+';
    }
    print(timezoneString);
    return Scaffold(
      backgroundColor: Color(0xFF2D2F41),
      body: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                  onPressed: () {},
                  child: Column(
                    children: [
                      FlutterLogo(),
                      Text(
                        'Clock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ))
            ],
          ),
          VerticalDivider(
            color: Colors.white54,
            width: 1,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
              alignment: Alignment.center,
              color: Color(0xFF2D2F41),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Clock",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      )),
                  SizedBox(height: 32),
                  Text(formattedTime,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                      )),
                  Text(formattedDate,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      )),
                  ClockView(),
                  Text("Timezone",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.language,
                        color: Colors.white,
                      ),
                      SizedBox(width: 16),
                      Text("UTC" + " " + offsetSign + " " + timezoneString,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
