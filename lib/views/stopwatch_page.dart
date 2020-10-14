import 'dart:async';
import 'package:clockApp/constants/theme_data.dart';
import 'package:clockApp/models/dependencies.dart';
import 'package:clockApp/widgets/timer_clock.dart';
import 'package:flutter/material.dart';

class StopWatchPage extends StatefulWidget {
  final Dependencies dependencies;

  StopWatchPage({Key key, this.dependencies}) : super(key: key);

  StopWatchPageState createState() => StopWatchPageState();
}

class StopWatchPageState extends State<StopWatchPage> {
  Icon leftButtonIcon;
  Icon rightButtonIcon;

  Color leftButtonColor;
  Color rightButtonColor;

  Timer timer;

  updateTime(Timer timer) {
    if (widget.dependencies.stopwatch.isRunning) {
      setState(() {});
    } else {
      timer.cancel();
    }
  }

  @override
  void initState() {
    if (widget.dependencies.stopwatch.isRunning) {
      timer = new Timer.periodic(new Duration(milliseconds: 20), updateTime);
      leftButtonIcon = Icon(Icons.pause);
      leftButtonColor = Colors.red;
      rightButtonIcon = Icon(
        Icons.fiber_manual_record,
        color: Colors.red,
      );
      rightButtonColor = Colors.white70;
    } else {
      leftButtonIcon = Icon(Icons.play_arrow);
      leftButtonColor = Colors.green;
      rightButtonIcon = Icon(Icons.refresh);
      rightButtonColor = Colors.blue;
    }
    super.initState();
  }

  @override
  void dispose() {
    if (timer.isActive) {
      timer.cancel();
      timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left:24,top: 32),
                child: Text(
                  "Stopwatch",
                  style: TextStyle(
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w700,
                      color: CustomColors.primaryTextColor,
                      fontSize: 24),
                ),
              )),
          Expanded(
            flex: 3,
            child: Container(
              height: 255.0,
              width: 255.0,
              child: TimerClock(widget.dependencies),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                    backgroundColor: leftButtonColor,
                    onPressed: startOrStopWatch,
                    child: leftButtonIcon),
                SizedBox(width: 20.0),
                FloatingActionButton(
                    backgroundColor: rightButtonColor,
                    onPressed: saveOrRefreshWatch,
                    child: rightButtonIcon),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
                itemCount: widget.dependencies.savedTimeList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Container(
                        alignment: Alignment.center,
                        child: Text(
                          createListItemText(
                              widget.dependencies.savedTimeList.length,
                              index,
                              widget.dependencies.savedTimeList
                                  .elementAt(index)),
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        )),
                  );
                }),
          ),
        ],
      ),
    );
  }

  startOrStopWatch() {
    if (widget.dependencies.stopwatch.isRunning) {
      leftButtonIcon = Icon(Icons.play_arrow);
      leftButtonColor = Colors.green;
      rightButtonIcon = Icon(Icons.refresh);
      rightButtonColor = Colors.blue;
      widget.dependencies.stopwatch.stop();
      setState(() {});
    } else {
      leftButtonIcon = Icon(Icons.pause);
      leftButtonColor = Colors.red;
      rightButtonIcon = Icon(
        Icons.fiber_manual_record,
        color: Colors.red,
      );
      rightButtonColor = Colors.white70;
      widget.dependencies.stopwatch.start();
      timer = new Timer.periodic(new Duration(milliseconds: 20), updateTime);
    }
  }

  saveOrRefreshWatch() {
    setState(() {
      if (widget.dependencies.stopwatch.isRunning) {
        widget.dependencies.savedTimeList.insert(
            0,
            widget.dependencies.transformMilliSecondsToString(
                widget.dependencies.stopwatch.elapsedMilliseconds));
      } else {
        widget.dependencies.stopwatch.reset();
        widget.dependencies.savedTimeList.clear();
      }
    });
  }

  String createListItemText(int listSize, int index, String time) {
    index = listSize - index;
    String indexText = index.toString().padLeft(2, '0');
    return 'Lap $indexText ~ $time';
  }
}
