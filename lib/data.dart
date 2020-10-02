import 'package:clockApp/constants/theme_data.dart';
import 'package:clockApp/enums.dart';
import 'package:clockApp/menu_info.dart';

import 'models/alarm_info.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.clock,
      title: 'Clock', imageSource: 'assets/clock_icon.png'),
  MenuInfo(MenuType.alarm,
      title: 'Alarm', imageSource: 'assets/alarm_icon.png'),
  MenuInfo(MenuType.timer,
      title: 'Timer', imageSource: 'assets/timer_icon.png'),
  MenuInfo(MenuType.stopwatch,
      title: 'Stopwatch', imageSource: 'assets/stopwatch_icon.png'),
];

List<AlarmInfo> alarms = [
  AlarmInfo(DateTime.now().add(Duration(hours: 2)), description: 'Office',gradientColor: GradientColors.sky),
  AlarmInfo(DateTime.now().add(Duration(hours: 2)), description: 'Sport',gradientColor: GradientColors.sunset),
];
