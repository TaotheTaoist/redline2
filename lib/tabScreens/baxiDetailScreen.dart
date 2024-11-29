import 'package:flutter/material.dart';
import 'package:redline/authenticationScreen/birthdaycal.dart';

import 'package:redline/calendar/Lunar.dart' as lunar;

// import 'package:redline/calendar/Lunar.dart' as Lunar;

import 'package:redline/calendar/gods.dart';
import 'package:redline/calendar/util/LunarUtil.dart';
import '../calendar/Lunar.dart' as Lunar;

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
    // firstCharacter = lunarDate.getBaZiShiShenTimeZhi()[0];

    print(tianShiShenTime);
    print(tianShiShenMonth);

    print(tianShiShenYear);
    print(timeZhi);
    print(yearZhi);
    print(monthZhi);

    print(dayZhi);
    print(timeZhi);

    // MissingChineseCharacters = calculateMissingChineseCharacters(
    //   tianShiShenTime,
    //   tianShiShenMonth,
    //   tianShiShenYear,
    //   timeZhi,
    //   yearZhi,
    //   monthZhi,
    //   dayZhi,
    // );
// // ===========================================================================
//     happened = happedHistory2(15, tianShiShenMonth, tianShiShenYear, timeZhi,
//         tianShiShenTime, yearZhi, monthZhi, dayZhi, widget.sex);

//     tiangan3top = gods.tianganThreeTops(
//       tianShiShenTime,
//       tianShiShenMonth,
//       tianShiShenYear,
//       dayTop,
//     );
//     tianganAttk = gods.tianganAttk(lunarDate.getTimeGan(),
//         lunarDate.getDayGan(), lunarDate.getMonthGan(), lunarDate.getYearGan());
    ConfirmTime();
    // checkEnergydiziTheeMeet();
    // checkEnergydiziTheecome();

    checkDiziThreeAttack();
    attackSelf();
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
    if (widget.sure == "false ") {
      attkOneSelf = gods.attkOneself("亥", "亥", "午", "午");
      if (lunarDate.getYearZhi() == lunarDate.getYearZhi()) {}
    }

    print(attkOneSelf);
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
      print('Custom mapping found: $combinedKey maps to $element');
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
              "天干合: ${gods.tianganCombine(lunarDate.getTimeGan(), lunarDate.getDayGan(), lunarDate.getMonthGan(), lunarDate.getYearGan())}"),
          Text("人奇三合:$tiangan3top"),
          Text("天干互沖${tianganAttk}"),
          Text("地支互沖${diziAttk}"),
          Text("缺的十神: ${MissingChineseCharacters[0] ?? []}"),
          Text("喜用神: ${favorGods ?? []}"),
          Text(
              "喜用五行: ${preferElements} 和${preferElements2} ,${preferElements3 ?? ''}"),
          Text("發生什麼: ${happened![0]}"),
        ],
      ),
    );
  }
}
