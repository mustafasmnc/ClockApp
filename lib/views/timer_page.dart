import 'dart:async';
import 'package:clockApp/constants/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int hour = 0;
  int min = 0;
  int sec = 0;
  bool started = true;
  bool stopped = true;
  bool checkTimer = true;
  int timeForTimer = 0;
  String timeToDisplay = "";

  void start() {
    setState(() {
      started = false;
      stopped = false;
    });
    timeForTimer = ((hour * 60 * 60) + (min * 60) + sec);
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timeForTimer < 1 || checkTimer == false) {
          t.cancel();
          checkTimer = true;
          timeToDisplay = "";
          started = true;
          stopped = true;
          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TimerPage()));
          if (timeForTimer == 0) {
            print("Stopped by default");
          }
        } else if (timeForTimer < 60) {
          timeToDisplay = timeForTimer.toString();
          timeForTimer = timeForTimer - 1;
        } else if (timeForTimer < 3600) {
          int m = timeForTimer ~/ 60;
          int s = timeForTimer - (60 * m);
          timeToDisplay = m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;
        } else {
          int h = timeForTimer ~/ 3600;
          int t = timeForTimer - (3600 * h);
          int m = t ~/ 60;
          int s = t - (60 * m);
          timeToDisplay =
              h.toString() + ":" + m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;
        }
        //timeToDisplay = timeForTimer.toString();
      });
    });
  }

  void stop() {
    setState(() {
      started = true;
      stopped = true;
      checkTimer = false;
      timeToDisplay = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Text(
                "Timer",
                style: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryTextColor,
                    fontSize: 24),
              )),
          Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          "HH",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                      new NumberPicker.integer(
                          initialValue: hour,
                          minValue: 0,
                          maxValue: 23,
                          listViewWidth: 60,
                          itemExtent: 60,
                          infiniteLoop: true,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white30),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          onChanged: (val) {
                            setState(() {
                              hour = val;
                            });
                          })
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          "MM",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                      NumberPicker.integer(
                          initialValue: min,
                          minValue: 0,
                          maxValue: 59,
                          listViewWidth: 60,
                          itemExtent: 60,
                          infiniteLoop: true,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white30),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          onChanged: (val) {
                            setState(() {
                              min = val;
                            });
                          })
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          "SS",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                      NumberPicker.integer(
                          initialValue: sec,
                          minValue: 0,
                          maxValue: 99,
                          listViewWidth: 60,
                          itemExtent: 60,
                          infiniteLoop: true,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white30),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          onChanged: (val) {
                            setState(() {
                              sec = val;
                            });
                          })
                    ],
                  ),
                ],
              )),
          Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Text(
                  timeToDisplay,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )),
          Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(
                    onPressed: started ? start : null,
                    backgroundColor: started ? Colors.green : Colors.grey,
                    child: Icon(Icons.play_arrow),
                  ),
                  FloatingActionButton(
                    onPressed: stopped ? null : stop,
                    backgroundColor: stopped ? Colors.grey : Colors.red,
                    child: Icon(Icons.stop),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
