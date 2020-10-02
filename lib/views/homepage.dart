import 'package:clockApp/constants/theme_data.dart';
import 'package:clockApp/data.dart';
import 'package:clockApp/enums.dart';
import 'package:clockApp/menu_info.dart';
import 'package:clockApp/views/clock_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
            children: menuItems
                .map((currentMenuInfo) => buildMenuButton(currentMenuInfo))
                .toList(),
          ),
          VerticalDivider(
            color: Colors.white54,
            width: 1,
          ),
          Expanded(
            child: Consumer<MenuInfo>(
                builder: (BuildContext context, MenuInfo value, Widget child) {
              if (value.menuType != MenuType.clock) {
                return Container(
                  child: RichText(
                      text: TextSpan(style: TextStyle(fontSize: 20), children: [
                    TextSpan(text: value.title, style: TextStyle(fontSize: 48)),
                  ])),
                );
              }
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
                alignment: Alignment.center,
                color: Color(0xFF2D2F41),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text("Clock",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'avenir',
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formattedTime,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 64,
                                fontFamily: 'avenir',
                              )),
                          Text(formattedDate,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'avenir',
                                fontWeight: FontWeight.w300,
                              )),
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: Align(
                          alignment: Alignment.center,
                          child: ClockView(
                            //CLOCK
                            size: MediaQuery.of(context).size.height / 3,
                          ),
                        )),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          Text("Timezone",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'avenir',
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(
                                Icons.language,
                                color: Colors.white,
                              ),
                              SizedBox(width: 16),
                              Text(
                                  "UTC" +
                                      " " +
                                      offsetSign +
                                      " " +
                                      timezoneString,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'avenir',
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget child) {
        return FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(32))),
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
            color: currentMenuInfo.menuType == value.menuType
                ? CustomColors.menuBackgroundColor
                : Colors.transparent,
            onPressed: () {
              var menuInfo = Provider.of<MenuInfo>(context, listen: false);
              menuInfo.updateMenu(currentMenuInfo);
            },
            child: Column(
              children: [
                Image.asset(
                  currentMenuInfo.imageSource,
                  scale: 1.5,
                ),
                SizedBox(height: 10),
                Text(
                  currentMenuInfo.title ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'avenir',
                  ),
                ),
              ],
            ));
      },
    );
  }
}
