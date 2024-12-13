import 'package:flutter/material.dart';
import 'package:redline/authenticationScreen/birthdaycal.dart';

import 'package:redline/calendar/Lunar.dart' as lunar;

// import 'package:redline/calendar/Lunar.dart' as Lunar;

import 'package:redline/calendar/gods.dart';
import 'package:redline/calendar/util/LunarUtil.dart';
import '../calendar/Lunar.dart' as Lunar;
import 'package:geolocator/geolocator.dart';

class BaxiDetailsScreen extends StatefulWidget {
  final String birthday;
  final String time;
  final String sex;
  final String sure;

  const BaxiDetailsScreen(
      {Key? key,
      required this.birthday,
      required this.time,
      required this.sex,
      required this.sure})
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

  String? tianShiShenTime;
  late String tianShiShenMonth;
  late String tianShiShenYear;
  late String dayTop;
  late List<String> yearZhi;
  late List<String> monthZhi;
  late List<String> dayZhi;
  List<String>? timeZhi;

  // 缺少十神 2段式 沒有確認時間不用
  List<String> MissingChineseCharacters = [];

  List<String>? happened;
  // 天干3奇
  List<String>? tiangan3top;
  // 天干冲
  List<String>? tianganAttk;

  List<String>? diziAttk;
  List<String>? attkOneSelf;

  // 喜用
  List<String>? favorGods;
  // 喜用屬性
  String? preferElements;
  String? preferElements2;
  String? preferElements3;

  Map<String, int>? elementOccur;

  String dummyyeartop = "庚";
  String dummyyearbot = "午";
  String dummyMonthtop = "庚";
  String dummyMonthbot = "辰";
  String dummydaytop = "辛";
  String dummydaybot = "亥";
  String dummytimetop = "乙";
  String dummytimebot = "未";

  String? dummyyeartopEle;
  String? dummyyearbotEle;
  String? dummyMonthtopEle;
  String? dummyMonthbotEle;
  String? dummydaytopEle;
  String? dummydaybotEle;
  String? dummytimetopEle;
  String? dummytimebotEle;

  late int bodystrength;

  String? xingXuo;

  String locationMessage = "location";

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
    dayTop = lunarDate.getDayGan();
    // year = combinedDateTime.year;

    // Do other initializations like calculating age or setting other values.
    age = calculateAge(combinedDateTime).toString();
    ageInt = calculateAge(combinedDateTime);
    tianShiShenTime = lunarDate.getBaZiShiShenGan()[3];
    tianShiShenMonth = lunarDate.getBaZiShiShenGan()[1];

    tianShiShenYear = lunarDate.getBaZiShiShenGan()[0];

    yearZhi = lunarDate.getBaZiShiShenYearZhi();

    // List<String> monthZhi = lunarDate.getBaZiShiShenMonthZhi();
    monthZhi = lunarDate.getBaZiShiShenMonthZhi();
    // getDayunGanShishenZhi(lunarDate.getDayGan(), lunarDate.getMonthZhi());

    dayZhi = lunarDate.getBaZiShiShenDayZhi();
    timeZhi = lunarDate.getBaZiShiShenTimeZhi();

    bodystrength = bodyStrength(
        yeartop: dummyyeartop,
        yearbot: dummyyearbot,
        monthtop: dummyMonthtop,
        monthbot: dummyMonthbot,
        daytop: dummydaytop,
        daybot: dummydaybot,
        timetop: dummytimetop,
        timebot: dummytimebot);
    print("bodystrength:$bodystrength");

    print(tianShiShenTime);
    print(tianShiShenMonth);

    print(tianShiShenYear);
    print(timeZhi);
    print(yearZhi);
    print(monthZhi);

    print(dayZhi);
    print(timeZhi);

    dummyyeartopEle = getWuXing(dummyyeartop);
    print("dummyyeartopEle:$dummyyeartopEle");
    dummyyearbotEle = getWuXing(dummyyearbot);
    print("dummyyearbotEle:$dummyyearbotEle");
    dummyMonthtopEle = getWuXing(dummyMonthtop);
    print("dummyMonthtopEle:$dummyMonthtopEle");
    dummyMonthbotEle = getWuXing(dummyMonthbot);
    print("dummyMonthbotEle:$dummyMonthbotEle");
    dummydaytopEle = getWuXing(dummydaytop);
    print("dummydaytopEle :$dummydaytopEle ");
    dummydaybotEle = getWuXing(dummydaybot);
    print("dummydaybotEle:$dummydaybotEle");
    dummytimetopEle = getWuXing(dummytimetop);
    print("dummytimetopEle :$dummytimetopEle ");
    dummytimebotEle = getWuXing(dummytimebot);
    print(" dummytimebotEle:$dummytimebotEle");

    ConfirmTime();

    // check5Elements();

    // checkEnergydiziTheeMeet();
    // checkEnergydiziTheecome();

    // checkDiziThreeAttack();
    // check5Elements();
    // attackSelf();
    regularCalculating();
    xingXuo = lunarDate.getSolar().getXingZuo();
    print("xingXuo:$xingXuo");

    double lat1 = 37.4219983; // Example latitude 1
    double lon1 = -122.084; // Example longitude 1
    double lat2 = 34.0522; // Example latitude 2
    double lon2 = -118.2437; // Example longitude 2

    double distance = calculateDistance(lat1, lon1, lat2, lon2);
    print('Distance: $distance meters');
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          locationMessage =
              "Location services are disabled. Please enable them.";
        });
        return;
      }

      // Request permission if necessary
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            locationMessage = "Location permissions are denied.";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationMessage =
              "Location permissions are permanently denied. Please enable them in settings.";
        });
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      });

      print("Current Location: $locationMessage");
    } catch (e) {
      setState(() {
        locationMessage = "Failed to get location: $e";
      });
      print("Error: $e");
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // 確認時間
  void ConfirmTime() {
    if (widget.sure == false) {
      MissingChineseCharacters = [""];
// ===========================================================================
      happened = happedHistory2(15, tianShiShenMonth, tianShiShenYear, [], "",
          yearZhi, monthZhi, dayZhi, widget.sex);

      tiangan3top = gods.tianganThreeTops(
        tianShiShenMonth,
        tianShiShenYear,
        dayTop,
      );
      tianganAttk = gods.tianganAttk(lunarDate.getDayGan(),
          lunarDate.getMonthGan(), lunarDate.getYearGan());
      diziAttk = gods.diziAttk(lunarDate.getMonthZhi(), lunarDate.getYearZhi());
    } else {
      MissingChineseCharacters = calculateMissingChineseCharacters(
        tianShiShenTime,
        tianShiShenMonth,
        tianShiShenYear,
        timeZhi,
        yearZhi,
        monthZhi,
        dayZhi,
      );
// ===========================================================================
      happened = happedHistory2(15, tianShiShenMonth, tianShiShenYear, timeZhi,
          tianShiShenTime, yearZhi, monthZhi, dayZhi, widget.sex);

      tiangan3top = gods.tianganThreeTops(
        tianShiShenTime ?? "",
        tianShiShenMonth,
        tianShiShenYear,
        dayTop,
      );
      tianganAttk = gods.tianganAttk(
          lunarDate.getTimeGan(),
          lunarDate.getDayGan(),
          lunarDate.getMonthGan(),
          lunarDate.getYearGan());
      diziAttk = gods.diziAttk(lunarDate.getMonthZhi(), lunarDate.getYearZhi(),
          lunarDate.getDayZhi());
    }
  }

  void check5Elements() {
    String? firstElement;
    String? secondElement;
    int? secondElementCount;

    if (widget.sure == "sure") {
      // Step 1: Get the result map by counting element occurrences
      Map<String, int> result = countElementOccurrences(
        dummyyeartop,
        dummyyearbot,
        dummyMonthtop,
        dummyMonthbot,
        dummydaybot,
        optional2: dummytimetop,
        optional3: dummytimebot,
      );

      // Step 2: Map each input to its label and value
      Map<String, String?> labeledInputs = {
        "dummyyeartop": dummyyeartop,
        "dummyyearbot": dummyyearbot,
        "dummyMonthtop": dummyMonthtop,
        "dummyMonthbot": dummyMonthbot,
        "dummydaybot": dummydaybot,
        "dummytimetop (optional2)": dummytimetop,
        "dummytimebot (optional2)": dummytimebot,
      };
      print("Labeled inputs: $labeledInputs");

      // Step 3: Map inputs to elements
      Map<String, String> inputToElement = {};
      labeledInputs.forEach((label, word) {
        if (word != null && elementMapping.containsKey(word)) {
          String element = {
            ElementType.Wood: "木",
            ElementType.Fire: "火",
            ElementType.Earth: "土",
            ElementType.Metal: "金",
            ElementType.Water: "水",
          }[elementMapping[word]!]!;
          inputToElement[label] = element;
        }
      });
      print("Input to element map: $inputToElement");

      // Step 4: Process results and determine the first and second elements
      // We'll first loop through all elements to process them.
      result.forEach((element, count) {
        print("Element: $element, Count: $count");

        // Store contributing inputs for each element
        var contributingInputs = inputToElement.entries
            .where((entry) =>
                entry.value == element &&
                entry.key != "dummydaytop (optional1)") // Adjust if necessary
            .map((entry) => entry.key)
            .toList();

        print("Contributing inputs for $element: $contributingInputs");

        // Adjust results if `dummydaytop` affects the count
        if (count == contributingInputs.length + 1 &&
            inputToElement["dummydaytop (optional1)"] == element) {
          print(
              "Adjusted Element: $element, Count: ${contributingInputs.length} 1");
        }

        // Find exceptional inputs (those not contributing to the count)
        var exceptionalInputs = labeledInputs.keys.where((label) {
          return !contributingInputs.contains(label);
        }).toList();

        print("Exceptional inputs for $element: $exceptionalInputs");

        // Handle storing of first and second elements
        if (exceptionalInputs.isNotEmpty) {
          // Save first element when not already saved
          if (firstElement == null) {
            firstElement = element;
            print("First element saved: $firstElement");
          } else if (secondElement == null &&
              firstElement !=
                  element && // Ensure second element is not the same as first
              count <= 5) {
            // Save second element if it occurs <= 5 times
            secondElement = element;
            secondElementCount = count; // Store the count of second element
            print(
                "Second element saved: $secondElement with count: $secondElementCount");
          }
        }
      });

      // Step 5: After the loop completes, perform the switch case logic
      if (firstElement != null && secondElement != null) {
        print("First Element: $firstElement");
        print("Second Element: $secondElement");

        // Now process elements with count >= 5 after checking first and second elements
        result.forEach((element, count) {
          if (count >= 5) {
            print("Element $element has more than 5 occurrences: $count");

            // Custom processing for certain elements when their count >= 5
            switch (element) {
              case "金":
                if (inputToElement.containsKey("dummyMonthbot")) {
                  String? monthbotValue = inputToElement["dummyMonthbot"];
                  print("Value of dummyMonthbot in 金 case: $monthbotValue");

                  if (monthbotValue == "金" || monthbotValue == "土") {
                    print("monthbotValue:$monthbotValue");
                    if ((firstElement == "金" || secondElementCount == "土") ||
                        (firstElement == "土" || secondElementCount == "金")) {
                      print("從格");
                    } else {
                      print("從不了");
                    }
                  }
                }
                break;
              case "木":
                if (inputToElement.containsKey("dummyMonthbot")) {
                  String? monthbotValue = inputToElement["dummyMonthbot"];
                  print("Value of dummyMonthbot in 金 case: $monthbotValue");

                  if (monthbotValue == "水" || monthbotValue == "木") {
                    print("monthbotValue:$monthbotValue");
                    if ((firstElement == "木" || secondElementCount == "土") ||
                        (firstElement == "土" || secondElementCount == "木")) {
                      print("從格");
                    } else {
                      print("從不了");
                    }
                  }
                }
                break;
              case "水":
                if (inputToElement.containsKey("dummyMonthbot")) {
                  String? monthbotValue = inputToElement["dummyMonthbot"];
                  print("Value of dummyMonthbot in 金 case: $monthbotValue");

                  if (monthbotValue == "金" || monthbotValue == "水") {
                    print("monthbotValue:$monthbotValue");
                    if ((firstElement == "金" || secondElementCount == "金") ||
                        (firstElement == "水" || secondElementCount == "水")) {
                      print("從格");
                    } else {
                      print("從不了");
                    }
                  }
                }
                break;
              case "火":
                if (inputToElement.containsKey("dummyMonthbot")) {
                  String? monthbotValue = inputToElement["dummyMonthbot"];
                  print("Value of dummyMonthbot in 金 case: $monthbotValue");

                  if (monthbotValue == "火" || monthbotValue == "木") {
                    print("monthbotValue:$monthbotValue");
                    if ((firstElement == "木" || secondElementCount == "火") ||
                        (firstElement == "火" || secondElementCount == "木")) {
                      print("從格");
                    } else {
                      print("從不了");
                    }
                  }
                }
                break;
              case "土":
                if (inputToElement.containsKey("dummyMonthbot")) {
                  String? monthbotValue = inputToElement["dummyMonthbot"];
                  print("Value of dummyMonthbot in 金 case: $monthbotValue");

                  if (monthbotValue == "土" || monthbotValue == "火") {
                    print("monthbotValue:$monthbotValue");
                    if ((firstElement == "土" || secondElementCount == "火") ||
                        (firstElement == "火" || secondElementCount == "土")) {
                      print("從格");
                    } else {
                      print("從不了");
                    }
                  }
                }
                break;
            }
          }
        });
      }
    }
  }

  void checkEnergydiziTheecome() {
    // 不知道時間
    if (widget.sure == "false") {
      List<String> diziThreeCom = gods.diziThreeCom(
          // lunarDate.getMonthZhi(),
          //   lunarDate.getYearZhi(), lunarDate.getDayZhi()
          "亥",
          "卯",
          "未");
      print("diziThreeCom$diziThreeCom");
      if (diziThreeCom.isNotEmpty) {
        // 用三合的最後一個字找屬性
        String element = diziThreeCom[0].split('合').last;
        print("element:$element");
        List<String> tianEle = getKeysByValue(element);
        print("找三合透干:$tianEle");
        String? shiShenType = getShiShen(lunarDate.getDayGan(), tianEle[0]);

        print("shiShenType:$shiShenType");
        favorGods = favorElements(shiShenType ?? "");
        print("favorGods$favorGods");
        preferElements = identifyElement(lunarDate.getDayGan(), favorGods![0]);
        preferElements2 = identifyElement(lunarDate.getDayGan(), favorGods![2]);
        preferElements3 = (favorGods?.length ?? 0) > 4
            ? identifyElement(lunarDate.getDayGan(), favorGods![4])
            : null;
        print("preferElements2$preferElements2");
      }
    } else if (widget.sure == "true") {
      List<String> diziThreeCom = gods.diziThreeCom(
          lunarDate.getMonthZhi(),
          lunarDate.getYearZhi(),
          lunarDate.getDayZhi(),
          lunarDate.getTimeZhi());
      print("diziThreeCom$diziThreeCom");
      if (diziThreeCom.isNotEmpty) {
        // 用三合的最後一個字找屬性
        String element = diziThreeCom[0].split('合').last;
        print("element: $element");
        List<String> tianEle = getKeysByValue(element);
        print("找三合透干:$tianEle");
        String? shiShenType = getShiShen(lunarDate.getDayGan(), tianEle[0]);

        print("shiShenType:$shiShenType");
        favorGods = favorElements(shiShenType ?? "");
        print("favorGods$favorGods");
        preferElements = identifyElement(lunarDate.getDayGan(), favorGods![0]);
        preferElements2 = identifyElement(lunarDate.getDayGan(), favorGods![2]);
        preferElements3 = (favorGods?.length ?? 0) > 4
            ? identifyElement(lunarDate.getDayGan(), favorGods![4])
            : null;
      }
    }
  }

  void checkEnergydiziTheeMeet() {
    if (widget.sure == "false") {
      List<String> diziThreeMeet = gods.diziThreeMeets(
          // lunarDate.getMonthZhi(),
          //   lunarDate.getYearZhi(), lunarDate.getDayZhi()
          "巳",
          "午",
          "未");

      String element = diziThreeMeet[0].split('會').last;
      print("element:$element");
      List<String> tianEle = getKeysByValue(element);
      print("找三合透干:$tianEle");
      String? shiShenType = getShiShen(lunarDate.getDayGan(), tianEle[0]);

      print("shiShenType:$shiShenType");
      favorGods = favorElements(shiShenType ?? "");
      print("favorGods$favorGods");
      preferElements = identifyElement(lunarDate.getDayGan(), favorGods![0]);
      preferElements2 = identifyElement(lunarDate.getDayGan(), favorGods![3]);
      preferElements3 = (favorGods?.length ?? 0) > 4
          ? identifyElement(lunarDate.getDayGan(), favorGods![4])
          : null;
      print("preferElements2$preferElements2");
    } else if (widget.sure == "true") {
      List<String> diziThreeMeet = gods.diziThreeMeets(
          lunarDate.getMonthZhi(),
          lunarDate.getYearZhi(),
          lunarDate.getDayZhi(),
          lunarDate.getTimeZhi());
      print("diziThreeMeet$diziThreeMeet");
      if (diziThreeMeet.isNotEmpty) {
        // 用三合的最後一個字找屬性
        String element = diziThreeMeet[0].split('會').last;
        print("element: $element");
        List<String> tianEle = getKeysByValue(element);
        print("找三合透干:$tianEle");
        String? shiShenType = getShiShen(lunarDate.getDayGan(), tianEle[0]);

        print("shiShenType:$shiShenType");
        favorGods = favorElements(shiShenType ?? "");
        print("favorGods$favorGods");
        preferElements = identifyElement(lunarDate.getDayGan(), favorGods![0]);
        preferElements2 = identifyElement(lunarDate.getDayGan(), favorGods![2]);
        preferElements3 = (favorGods?.length ?? 0) > 4
            ? identifyElement(lunarDate.getDayGan(), favorGods![4])
            : null;
      }
    }
  }

// 3刑 透干10 沒有5
  void checkDiziThreeAttack() {
    if (widget.sure == "false") {
      List<String> diziThreeAttk = gods.diziThreeAttcks(
          // lunarDate.getMonthZhi(),
          //   lunarDate.getYearZhi(), lunarDate.getDayZhi()
          "丑",
          "未",
          "戌");

      if (diziThreeAttk.isNotEmpty) {
        // 用三合的最後一個字找屬性
        String element = diziThreeAttk[0];
        print("element:$element");
        List<String> tianEle = getKeysByValue(element);
        print("找三合透干:$tianEle");
        String? shiShenType = getShiShen(lunarDate.getDayGan(), tianEle[0]);

        print("shiShenType:$shiShenType");
        favorGods = favorElements(shiShenType ?? "");
        print("favorGods$favorGods");
        preferElements = identifyElement(lunarDate.getDayGan(), favorGods![0]);
        preferElements2 = identifyElement(lunarDate.getDayGan(), favorGods![2]);
        // preferElements3 = identifyElement("癸", favorGods![4]);
        preferElements3 = (favorGods?.length ?? 0) > 4
            ? identifyElement(lunarDate.getDayGan(), favorGods![4])
            : null;

        print("preferElements3$preferElements3");
      }
    } else if (widget.sure == "true") {
      List<String> diziThreeAttk = gods.diziThreeAttcks(
          lunarDate.getMonthZhi(),
          lunarDate.getYearZhi(),
          lunarDate.getDayZhi(),
          lunarDate.getTimeZhi());

      if (diziThreeAttk.isNotEmpty) {
        // 用三合的最後一個字找屬性
        String element = diziThreeAttk[0];
        print("element:$element");
        List<String> tianEle = getKeysByValue(element);
        print("找三合透干:$tianEle");
        String? shiShenType = getShiShen(lunarDate.getDayGan(), tianEle[0]);

        print("shiShenType:$shiShenType");
        favorGods = favorElements(shiShenType ?? "");
        print("favorGods$favorGods");
        preferElements = identifyElement(lunarDate.getDayGan(), favorGods![0]);
        preferElements2 = identifyElement(lunarDate.getDayGan(), favorGods![2]);
        preferElements3 = (favorGods?.length ?? 0) > 4
            ? identifyElement(lunarDate.getDayGan(), favorGods![4])
            : null;
      }
    }
  }

  void attackSelf() {
    if (widget.sure == "false") {
      attkOneSelf = gods.attkOneself(dummyyearbot, dummyMonthbot, dummydaybot);
      print("自邢$attkOneSelf");

      if (attkOneSelf!.isNotEmpty && attkOneSelf![0] == "亥亥自刑") {
        if (dummyyearbot == dummyMonthbot) {
          String element = "水";
          List<String> tianEle = getKeysByValue(element);
          print("找三合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");

          print("喜用神:${favorGods}");
          preferElements = identifyElement(dummydaytop, favorGods![0]);
          preferElements2 = identifyElement(dummydaytop, favorGods![2]);
          preferElements3 = (favorGods?.length ?? 0) > 4
              ? identifyElement(dummydaytop, favorGods![4])
              : null;
        } else if (dummydaybot == dummyMonthbot) {
          String element = "水";
          List<String> tianEle = getKeysByValue(element);
          print("找三合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");
          preferElements = identifyElement(dummydaytop, favorGods![0]);
          preferElements2 = identifyElement(dummydaytop, favorGods![2]);
          preferElements3 = (favorGods?.length ?? 0) > 4
              ? identifyElement(dummydaytop, favorGods![4])
              : null;
        }
      } else if (attkOneSelf!.isNotEmpty && attkOneSelf![0] == "辰辰自刑") {
        if (dummyyearbot == dummyMonthbot) {
          String element = "土";
          List<String> tianEle = getKeysByValue(element);
          print("找三合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");
          print("喜用神:${favorGods}");
          preferElements = identifyElement(dummydaytop, favorGods![0]);
          preferElements2 = identifyElement(dummydaytop, favorGods![2]);
          preferElements3 = (favorGods?.length ?? 0) > 4
              ? identifyElement(dummydaytop, favorGods![4])
              : null;
        } else if (dummydaybot == dummyMonthbot) {
          String element = "土";
          List<String> tianEle = getKeysByValue(element);
          print("找三合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");
          preferElements = identifyElement(dummydaytop, favorGods![0]);
          preferElements2 = identifyElement(dummydaytop, favorGods![2]);
          preferElements3 = (favorGods?.length ?? 0) > 4
              ? identifyElement(dummydaytop, favorGods![4])
              : null;
        }
      } else if (attkOneSelf!.isNotEmpty && attkOneSelf![0] == "酉酉自刑") {
        if (dummyyearbot == dummyMonthbot) {
          String element = "金";
          List<String> tianEle = getKeysByValue(element);
          print("找三合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");
          print("喜用神:${favorGods}");
          preferElements = identifyElement(dummydaytop, favorGods![0]);
          preferElements2 = identifyElement(dummydaytop, favorGods![2]);
          preferElements3 = (favorGods?.length ?? 0) > 4
              ? identifyElement(dummydaytop, favorGods![4])
              : null;
        } else if (dummydaybot == dummyMonthbot) {
          String element = "金";
          List<String> tianEle = getKeysByValue(element);
          print("找三合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");
          preferElements = identifyElement(dummydaytop, favorGods![0]);
          preferElements2 = identifyElement(dummydaytop, favorGods![2]);
          preferElements3 = (favorGods?.length ?? 0) > 4
              ? identifyElement(dummydaytop, favorGods![4])
              : null;
        }
      } else if (attkOneSelf!.isNotEmpty && attkOneSelf![0] == "午午自刑") {
        if (dummyyearbot == dummyMonthbot) {
          String element = "火";
          List<String> tianEle = getKeysByValue(element);
          print("找三合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");
          print("喜用神:${favorGods}");
          preferElements = identifyElement(dummydaytop, favorGods![0]);
          preferElements2 = identifyElement(dummydaytop, favorGods![2]);
          preferElements3 = (favorGods?.length ?? 0) > 4
              ? identifyElement(dummydaytop, favorGods![4])
              : null;
        } else if (dummydaybot == dummyMonthbot) {
          String element = "火";
          List<String> tianEle = getKeysByValue(element);
          print("找三合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");
          preferElements = identifyElement(dummydaytop, favorGods![0]);
          preferElements2 = identifyElement(dummydaytop, favorGods![2]);
          preferElements3 = (favorGods?.length ?? 0) > 4
              ? identifyElement(dummydaytop, favorGods![4])
              : null;
        }
      }
    }
  }

  //  地支沒合 算拱合 之後半合

  // 地支6合開始
  void regularCalculating() {
    if (widget.sure == "false") {
      List<String> diziCom = gods.diziCom(dummyyearbot, dummyMonthbot);
      List<String> diziComMonthDay = gods.diziCom(dummydaybot, dummyMonthbot);
      print("diziCom:$diziCom");
      if (diziCom.isNotEmpty) {
        // 如果地支年月合 還有通根
        String element = diziCom[0].split('合').last;
        if (element == dummyMonthtopEle || element == dummyyeartopEle) {
          // 看這個五行與這個日主是什麼關西
          print("element: $element");
          List<String> tianEle = getKeysByValue(element);
          print("找6合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");
          print("不知道時間所以先段喜用神 再問問題");
          print("喜用神:${favorGods}");
        }
      } else if (diziComMonthDay.isNotEmpty) {
        // 看月與日有沒有合
        String element = diziComMonthDay[0].split('合').last;
        if (element == dummyMonthtopEle || element == dummydaytopEle) {
          // 看這個五行與這個日主是什麼關西
          print("element: $element");
          List<String> tianEle = getKeysByValue(element);
          print("找6合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");
          print("不知道時間所以先段喜用神 再問問題");
          print("喜用神:${favorGods}");
        }
      }
      return;
    } else if (widget.sure == "sure") {
      List<String> diziCom = gods.diziCom(dummyyearbot, dummyMonthbot);
      List<String> diziComMonthDay = gods.diziCom(dummydaybot, dummyMonthbot);
      List<String> diziComhDayTime = gods.diziCom(dummydaybot, dummytimebot);
      print("diziCom:$diziCom");
      if (diziCom.isNotEmpty) {
        // 如果地支年月合 還有通根
        String element = diziCom[0].split('合').last;
        if (element == dummyMonthtopEle || element == dummyyeartopEle) {
          // 看這個五行與這個日主是什麼關西
          print("element: $element");
          List<String> tianEle = getKeysByValue(element);
          print("找6合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");
          print("不知道時間所以先段喜用神 再問問題");
          print("喜用神:${favorGods}");
        }
      } else if (diziComMonthDay.isNotEmpty) {
        // 看月與日有沒有合
        String element = diziComMonthDay[0].split('合').last;
        if (element == dummyMonthtopEle || element == dummydaytopEle) {
          // 看這個五行與這個日主是什麼關西
          print("element: $element");
          List<String> tianEle = getKeysByValue(element);
          print("找6合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");
          print("不知道時間所以先段喜用神 再問問題");
          print("喜用神:${favorGods}");
        }
      } else if (diziComhDayTime.isNotEmpty) {
        // 看月與日有沒有合
        String element = diziComhDayTime[0].split('合').last;
        if (element == dummyMonthtopEle || element == dummydaytopEle) {
          // 看這個五行與這個日主是什麼關西
          print("element: $element");
          List<String> tianEle = getKeysByValue(element);
          print("找6合透干:$tianEle");
          String? shiShenType = getShiShen(dummydaytop, tianEle[0]);
          print("shiShenType:$shiShenType");
          favorGods = favorElements(shiShenType ?? "");
          print("不知道時間所以先段喜用神 再問問題");
          print("喜用神:${favorGods}");
        }
      }
    }
  }

  int calculateAge(DateTime birthDate) {
    int years = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      years--;
    }
    return years;
  }

  static const Map<String, String> CUSTOM_ELEMENT_MAPPING = {
    '辛印': '土',
    '辛梟': '土',
    '辛財': '木',
    '辛才': '木',
    '辛比': '金',
    '辛劫': '金',
    '辛官': '火',
    '辛殺': '火',
    '辛食': '水',
    '辛傷': '水',
    '庚印': '土',
    '庚梟': '土',
    '庚財': '木',
    '庚才': '木',
    '庚比': '金',
    '庚劫': '金',
    '庚官': '火',
    '庚殺': '火',
    '庚食': '水',
    '庚傷': '水',
    '甲印': '水',
    '甲梟': '水',
    '甲財': '土',
    '甲才': '土',
    '甲比': '木',
    '甲劫': '木',
    '甲官': '金',
    '甲殺': '金',
    '甲食': '火',
    '甲傷': '火',
    '乙印': '水',
    '乙梟': '水',
    '乙財': '土',
    '乙才': '土',
    '乙比': '木',
    '乙劫': '木',
    '乙官': '金',
    '乙殺': '金',
    '乙食': '火',
    '乙傷': '火',
    '丙印': '木',
    '丙梟': '木',
    '丙財': '金',
    '丙才': '金',
    '丙比': '火',
    '丙劫': '火',
    '丙官': '水',
    '丙殺': '水',
    '丙食': '土',
    '丙傷': '土',
    '丁印': '木',
    '丁梟': '木',
    '丁財': '金',
    '丁才': '金',
    '丁比': '火',
    '丁劫': '火',
    '丁官': '水',
    '丁殺': '水',
    '丁食': '土',
    '丁傷': '土',
    '戊印': '火',
    '戊梟': '火',
    '戊財': '水',
    '戊才': '水',
    '戊比': '土',
    '戊劫': '土',
    '戊官': '木',
    '戊殺': '木',
    '戊食': '金',
    '戊傷': '金',
    '己印': '火',
    '己梟': '火',
    '己財': '水',
    '己才': '水',
    '己比': '土',
    '己劫': '土',
    '己官': '木',
    '己殺': '木',
    '己食': '金',
    '己傷': '金',
    '壬印': '金',
    '壬梟': '金',
    '壬財': '火',
    '壬才': '火',
    '壬比': '水',
    '壬劫': '水',
    '壬官': '土',
    '壬殺': '土',
    '壬食': '木',
    '壬傷': '木',
    '癸印': '金',
    '癸梟': '金',
    '癸財': '火',
    '癸才': '火',
    '癸比': '水',
    '癸劫': '水',
    '癸官': '土',
    '癸殺': '土',
    '癸食': '木',
    '癸傷': '木',
  };
  List<String> getKeysByValue(String value) {
    return LunarUtil.WU_XING_GAN.entries
        .where((entry) => entry.value == value)
        .map((entry) => entry.key)
        .toList();
  }

  // 用十神斷五行
  String identifyElement(String base, String word) {
    print('Base: $base, Word: $word'); // Debug input values

    // Validate and check for the custom mappings first
    String combinedKey = base + word;
    if (CUSTOM_ELEMENT_MAPPING.containsKey(combinedKey)) {
      String element = CUSTOM_ELEMENT_MAPPING[combinedKey]!;
      print('需要的十神: $combinedKey maps to $element');
      return element;
    }

    // Fallback to the original method if no custom mapping is found
    if (!LunarUtil.SHI_SHEN.containsKey(base + base) &&
        !LunarUtil.SHI_SHEN.containsKey(base + word)) {
      print('Invalid base or word: $base, $word');
      throw ArgumentError('Invalid base or word.');
    }

    // Find the matching key in SHI_SHEN
    String? matchKey;
    LunarUtil.SHI_SHEN.forEach((key, value) {
      if ((key.startsWith(base) && value == word) || (key == base + base)) {
        print(
            'Match found: Key = $key, Value = $value'); // Debug matching process
        matchKey = key;
      }
    });

    if (matchKey == null) {
      print('No match found for base: $base and word: $word');
      throw ArgumentError('No match found for the given base and word.');
    }

    // Extract elements from the key using WU_XING
    final elements = matchKey!.split('').map((char) {
      final element = LunarUtil.WU_XING_GAN[char];
      print('Character: $char, Element: $element'); // Debug element lookup
      return element;
    }).toSet();

    // Handle duplicate elements
    if (elements.length == 1) {
      print('Unique element identified: ${elements.first!}');
      return elements.first!; // Return the single unique element
    }

    // Explicit comparison for duplicates
    final uniqueElements = elements.where((element) => element != null).toSet();
    if (uniqueElements.length == 1) {
      print('All elements are the same: $uniqueElements');
      return uniqueElements.first!;
    }

    // If elements are genuinely different, handle the case
    print('Multiple unique elements found: $uniqueElements');
    throw StateError(
        'Multiple elements found, unable to identify a unique element.');
  }

  // 用五行斷十神
  String? getShiShen(String key1, String key2) {
    // Combine the keys into one string
    String combinedKey = key1 + key2;

    // Lookup in the SHI_SHEN dictionary
    return LunarUtil.SHI_SHEN[combinedKey];
  }

  // 段喜用
  List<String> favorElements(String input) {
    // Define the mappings
    const Map<String, List<String>> groupMap = {
      'Group1': ['才', '財', '官', '殺', '傷', '食'],
      'Group2': ['比', '劫', '印', '梟'],
    };

    // Check which group the input belongs to and return the opposite group
    if (groupMap['Group1']!.contains(input)) {
      return groupMap['Group2']!;
    } else if (groupMap['Group2']!.contains(input)) {
      return groupMap['Group1']!;
    } else {
      throw ArgumentError('');
    }
  }

// 天干地支換五行
  String? getWuXing(String key) {
    // Check in WU_XING_GAN
    if (LunarUtil.WU_XING_GAN.containsKey(key)) {
      return LunarUtil.WU_XING_GAN[key];
    }

    // Check in WU_XING_ZHI
    if (LunarUtil.WU_XING_ZHI.containsKey(key)) {
      return LunarUtil.WU_XING_ZHI[key];
    }

    // Return null if the key is not found
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
              "天干合: ${gods.tianganCombine(lunarDate.getTimeGan(), lunarDate.getDayGan(), lunarDate.getMonthGan(), lunarDate.getYearGan())}"),
          Text("人奇三合:$tiangan3top"),
          Text("天干互沖${tianganAttk}"),
          Text("地支互沖${diziAttk}"),
          Text("缺的十神: ${MissingChineseCharacters[0] ?? []}"),
          Text("喜用神: ${favorGods ?? []}"),
          Text(
              "喜用五行: ${preferElements} 和${preferElements2} ,${preferElements3 ?? ''}"),
          Text("發生什麼: ${happened![0]}"),
          Text(locationMessage, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _getCurrentLocation,
            child: const Text('Get Current Location'),
          ),
        ],
      ),
    );
  }

  final Map<String, ElementType> elementMapping = {
    "寅": ElementType.Wood,
    "卯": ElementType.Wood,
    "乙": ElementType.Wood,
    "甲": ElementType.Wood,
    "巳": ElementType.Fire,
    "午": ElementType.Fire,
    "丙": ElementType.Fire,
    "丁": ElementType.Fire,
    "未": ElementType.Earth,
    "申": ElementType.Metal,
    "戊": ElementType.Earth,
    "己": ElementType.Earth,
    "酉": ElementType.Metal,
    "戌": ElementType.Earth,
    "庚": ElementType.Metal,
    "辛": ElementType.Metal,
    "亥": ElementType.Water,
    "子": ElementType.Water,
    "壬": ElementType.Water,
    "癸": ElementType.Water,
    "丑": ElementType.Earth,
    "辰": ElementType.Earth
  };
  int bodyStrength({
    required String yeartop,
    required String yearbot,
    required String monthtop,
    required String monthbot,
    required String daytop, // Explicitly passing daytop
    required String daybot, // Explicitly passing daybot
    String timetop = "",
    String timebot = "",
  }) {
    int n1 = 0, n2 = 0, n3 = 0, n4 = 0, n5 = 0, n6 = 0, n7 = 0;
    int total = 0;

    switch (daytop) {
      // Using daytop as the "body"
      case "甲":
      case "乙":
        n1 = elementChangWood(daytop, yeartop,
            8); // Corrected: using daytop for the first calculation
        n2 = elementChangWood(daytop, yearbot, 4);
        n3 = elementChangWood(daytop, monthtop, 12);
        n4 = elementChangWood2(daytop, monthbot, 40);
        n5 = elementChangWood(
            daytop, daybot, 12); // Corrected: using daybot for n5
        n6 = timetop.isEmpty ? 0 : elementChangWood(daytop, timetop, 12);
        n7 = timebot.isEmpty ? 0 : elementChangWood(daytop, timebot, 12);
        break;

      case "丙":
      case "丁":
        n1 = elementChangFire(daytop, yeartop, 8);
        n2 = elementChangFire(daytop, yearbot, 4);
        n3 = elementChangFire(daytop, monthtop, 12);
        n4 = elementChangFire2(daytop, monthbot, 40);
        n5 = elementChangFire(daytop, daybot, 12);
        n6 = timetop.isEmpty ? 0 : elementChangFire(daytop, timetop, 12);
        n7 = timebot.isEmpty ? 0 : elementChangFire(daytop, timebot, 12);
        break;

      case "戊":
      case "己":
        n1 = elementChangEarth(daytop, yeartop, 8);
        n2 = elementChangEarth(daytop, yearbot, 4);
        n3 = elementChangEarth(daytop, monthtop, 12);
        n4 = elementChangEarth2(daytop, monthbot, 40);
        n5 = elementChangEarth(daytop, daybot, 12);
        n6 = timetop.isEmpty ? 0 : elementChangEarth(daytop, timetop, 12);
        n7 = timebot.isEmpty ? 0 : elementChangEarth(daytop, timebot, 12);
        break;

      case "庚":
      case "辛":
        n1 = elementChangMetal(daytop, yeartop, 8);
        n2 = elementChangMetal(daytop, yearbot, 4);
        n3 = elementChangMetal(daytop, monthtop, 12);
        n4 = elementChangMetal2(daytop, monthbot, 40);
        n5 = elementChangMetal(daytop, daybot, 12);
        n6 = timetop.isEmpty ? 0 : elementChangMetal(daytop, timetop, 12);
        n7 = timebot.isEmpty ? 0 : elementChangMetal(daytop, timebot, 12);
        break;

      case "壬":
      case "癸":
        n1 = elementChangWater(daytop, yeartop, 8);
        n2 = elementChangWater(daytop, yearbot, 4);
        n3 = elementChangWater(daytop, monthtop, 12);
        n4 = elementChangWater2(daytop, monthbot, 40);
        n5 = elementChangWater(daytop, daybot, 12);
        n6 = timetop.isEmpty ? 0 : elementChangWater(daytop, timetop, 12);
        n7 = timebot.isEmpty ? 0 : elementChangWater(daytop, timebot, 12);
        break;

      default:
        break;
    }

    // Total strength calculation
    total = n1 + n2 + n3 + n4 + n5 + n6 + n7;
    return total;
  }

  int elementChangWood(String word1, String word2, int tiangan) {
    int totalValue = 0;

    final types = (elementMapping[word1]!, elementMapping[word2]!);

    // Add points only if the element is Wood
    if (types.$1 == ElementType.Wood && types.$2 == ElementType.Wood) {
      totalValue += tiangan; // Add points if both are Wood
    }

    return totalValue;
  }

  int elementChangWood2(String word1, String word2, int tiangan) {
    int totalValue = 0;

    final types = (elementMapping[word1]!, elementMapping[word2]!);

    // Check if both elements are Wood (add points for Wood-Wood)
    if (types.$1 == types.$2) {
      if (types.$1 == ElementType.Wood) {
        totalValue += tiangan; // Only add points if both are Wood
      }
    } else {
      // For specific combinations of elements (e.g., Wood-Water)
      switch (types) {
        case (ElementType.Wood, ElementType.Water):
          totalValue += tiangan; // Add points for Wood-Water
          break;
        default:
          totalValue -= tiangan; // Otherwise, subtract points
      }
    }

    return totalValue;
  }

  int elementChangFire2(String word1, String word2, int tiangan) {
    int totalValue = 0;

    final types = (elementMapping[word1]!, elementMapping[word2]!);

    if (types.$1 == types.$2) {
      totalValue += tiangan;
    } else {
      switch (types) {
        case (ElementType.Fire, ElementType.Wood):
          totalValue += tiangan;
          break;
        default:
          totalValue -= tiangan;
      }
    }

    return totalValue;
  }

  int elementChangFire(String word1, String word2, int tiangan) {
    int totalValue = 0;

    final types = (elementMapping[word1]!, elementMapping[word2]!);

    // Add points only if the element is Fire
    if (types.$1 == ElementType.Fire && types.$2 == ElementType.Fire) {
      totalValue += tiangan; // Add points if both are Fire
    }

    return totalValue;
  }

  int elementChangMetal2(String word1, String word2, int tiangan) {
    int totalValue = 0;

    final types = (elementMapping[word1]!, elementMapping[word2]!);

    // Add points if either element is Metal or Earth
    if (types.$1 == ElementType.Metal ||
        types.$1 == ElementType.Earth ||
        types.$2 == ElementType.Metal ||
        types.$2 == ElementType.Earth) {
      totalValue += tiangan;
    }

    // If neither element is Metal or Earth, no points are added

    return totalValue;
  }

  int elementChangMetal(String word1, String word2, int tiangan) {
    int totalValue = 0;

    final types = (elementMapping[word1]!, elementMapping[word2]!);

    // Add points only if the element is Metal
    if (types.$1 == ElementType.Metal && types.$2 == ElementType.Metal) {
      totalValue += tiangan; // Add points if both are Metal
    }

    // If it’s not Metal, just keep the total value as it is (no subtraction or addition)

    return totalValue;
  }

  int elementChangWater2(String word1, String word2, int tiangan) {
    int totalValue = 0;

    final types = (elementMapping[word1]!, elementMapping[word2]!);

    if (types.$1 == types.$2) {
      totalValue += tiangan;
    } else {
      switch (types) {
        case (ElementType.Water, ElementType.Metal):
          totalValue += tiangan;
          break;
        default:
          totalValue -= tiangan;
      }
    }

    return totalValue;
  }

  int elementChangWater(String word1, String word2, int tiangan) {
    int totalValue = 0;

    final types = (elementMapping[word1]!, elementMapping[word2]!);

    // Add points only if the element is Water
    if (types.$1 == ElementType.Water && types.$2 == ElementType.Water) {
      totalValue += tiangan; // Add points if both are Water
    }

    return totalValue;
  }

  int elementChangEarth2(String word1, String word2, int tiangan) {
    int totalValue = 0;

    final types = (elementMapping[word1]!, elementMapping[word2]!);

    if (types.$1 == types.$2) {
      totalValue += tiangan;
    } else {
      switch (types) {
        case (ElementType.Earth, ElementType.Fire):
          totalValue += tiangan;
          break;
        default:
          totalValue -= tiangan;
      }
    }

    return totalValue;
  }

  int elementChangEarth(String word1, String word2, int tiangan) {
    int totalValue = 0;

    final types = (elementMapping[word1]!, elementMapping[word2]!);

    // Add points only if the element is Earth
    if (types.$1 == ElementType.Earth && types.$2 == ElementType.Earth) {
      totalValue += tiangan; // Add points if both are Earth
    }

    return totalValue;
  }
}
