import 'package:flutter/material.dart';
import 'package:redline/authenticationScreen/birthdaycal.dart';
import 'package:redline/calendar/EightChar.dart';
import 'package:redline/calendar/Lunar.dart' as lunar;

// import 'package:redline/calendar/Lunar.dart' as Lunar;
import 'package:redline/calendar/eightchar/DaYun.dart';
import 'package:redline/calendar/eightchar/Yun.dart';
import 'package:redline/calendar/gods.dart';
import 'package:redline/calendar/util/LunarUtil.dart';
import 'package:redline/calendar/util/LunarUtil.dart';

import '../calendar/Lunar.dart' as Lunar;

class BaxiDetailsScreen extends StatefulWidget {
  final String birthday;
  final String time;
  final String sex;

  const BaxiDetailsScreen(
      {Key? key, required this.birthday, required this.time, required this.sex})
      : super(key: key);

  @override
  _BaxiDetailsScreenState createState() => _BaxiDetailsScreenState();
}

class _BaxiDetailsScreenState extends State<BaxiDetailsScreen> {
  late DateTime combinedDateTime;
  DateTime now = DateTime.now();
  late Lunar.Lunar lunarDate;
  //increment for taps usage
  late int year;
  int month = 1;
  int liunenIntholder = 0;
  late String age;
  late int ageInt;

  late DateTime dateLiunen = DateTime(year, 5, 2);
  // late Lunar.Lunar.fromDate(date);
  // late String age;

  // static TimeOfDay? stringToTimeOfDay(String? time) {
  //   if (time == null || time.isEmpty) return null;
  //   final parts = time.split(':');
  //   final hour = int.parse(parts[0]);
  //   final minute = int.parse(parts[1]);
  //   return TimeOfDay(hour: hour, minute: minute);
  // }

  late String tianShiShenTime;
  late String tianShiShenMonth;
  late String tianShiShenYear;

  late List<String> yearZhi;
  late List<String> monthZhi;
  late List<String> dayZhi;
  late List<String> timeZhi;

  late List<String> happened;

  @override
  void initState() {
    // 所有十神

    super.initState();
    TimeOfDay? parsedTime = stringToTimeOfDay(widget.time);

    print('Parsed Time: $parsedTime');

    final birthdayDate = DateTime.parse(widget.birthday);
    final year = birthdayDate.year;
    final month = birthdayDate.month;
    final day = birthdayDate.day;

    combinedDateTime = DateTime(
      year,
      month,
      day,
      parsedTime?.hour ?? 2,
      parsedTime?.minute ?? 2,
    );

    print(combinedDateTime);
    lunarDate = lunar.Lunar.fromDate(combinedDateTime);

    // year = combinedDateTime.year;

    // Do other initializations like calculating age or setting other values.
    age = calculateAge(combinedDateTime).toString();
    ageInt = calculateAge(combinedDateTime);
    tianShiShenTime = lunarDate.getBaZiShiShenGan()[3];
    tianShiShenMonth = lunarDate.getBaZiShiShenGan()[1];
    // tianShiShenMonth =
    //     getDayunGanShishen(lunarDate.getDayGan(), lunarDate.getMonthGan());

    tianShiShenYear = lunarDate.getBaZiShiShenGan()[0];

    List<String> yearZhi = lunarDate.getBaZiShiShenYearZhi();

    // List<String> monthZhi = lunarDate.getBaZiShiShenMonthZhi();
    List<String> monthZhi = lunarDate.getBaZiShiShenMonthZhi();
    // getDayunGanShishenZhi(lunarDate.getDayGan(), lunarDate.getMonthZhi());

    List<String> dayZhi = lunarDate.getBaZiShiShenDayZhi();
    List<String> timeZhi = lunarDate.getBaZiShiShenTimeZhi();
    // firstCharacter = lunarDate.getBaZiShiShenTimeZhi()[0];

    print(tianShiShenTime);
    print(tianShiShenMonth);

    print(tianShiShenYear);
    print(timeZhi);
    print(yearZhi);
    print(monthZhi);

    print(dayZhi);
    print(timeZhi);

    List<String> result = calculateMissingChineseCharacters(
      tianShiShenTime,
      tianShiShenMonth,
      tianShiShenYear,
      timeZhi,
      yearZhi,
      monthZhi,
      dayZhi,
    );

    happened = happedHistory(ageInt, tianShiShenMonth, tianShiShenYear, timeZhi,
        yearZhi, monthZhi, dayZhi, 1);
  }

  int calculateAge(DateTime birthDate) {
    int years = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      years--;
    }
    return years;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baxi Details'),
      ),
      body: Column(
        children: [
          Text('Birthday: ${widget.birthday}'),
          Text('Birthday: ${widget.time}'),
          Text('Age: $age'),
          Text('Sex: ${widget.sex}'),
          Text('Daytop: ${lunarDate.getBaZi()}'),
          Text(
              "diziCom: ${gods.diziCom(lunarDate.getTimeZhi(), lunarDate.getDayZhi(), lunarDate.getMonthZhi(), lunarDate.getYearZhi())}"),
          Text(
              "diziCom: ${gods.tianganCombine(lunarDate.getTimeGan(), lunarDate.getDayGan(), lunarDate.getMonthGan(), lunarDate.getYearGan())}"),
          Text(happened[0])
        ],
      ),
    );
  }
}
//  TimeOfDay? parsedTime = NewMember.stringToTimeOfDay(widget.time);
//     combinedDateTime = DateTime(
//       widget.birthday!.year,
//       widget.birthday!.month,
//       widget.birthday!.day,
//       parsedTime?.hour ?? 0,
//       parsedTime?.minute ?? 0,
//     );

//     age = calculateAge(combinedDateTime).toString();
//     ageInt = calculateAge(combinedDateTime);
//     lunarDate = lunar.Lunar.fromDate(combinedDateTime);

//     naYingTime = lunarDate.getTimeNaYin();
//     naYingDay = lunarDate.getDayNaYin();
//     naYingMonth = lunarDate.getMonthNaYin();
//     naYingYear = lunarDate.getYearNaYin();

//     // 算今年大運
//     lunar.Lunar toDay = lunar.Lunar.fromDate(now);

//   static TimeOfDay? stringToTimeOfDay(String? time) {
//     if (time == null || time.isEmpty) return null;
//     final parts = time.split(':');
//     final hour = int.parse(parts[0]);
//     final minute = int.parse(parts[1]);
//     return TimeOfDay(hour: hour, minute: minute);
//   }
// }