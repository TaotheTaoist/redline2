import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthdayCal {
  // Method to select a date using date picker
  static Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  // Method to select time using time picker
  static Future<void> selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      controller.text = selectedTime.format(context);
    }
  }
}

enum ElementType { Wood, Fire, Earth, Metal, Water }

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
  "辰": ElementType.Earth,
};

TimeOfDay? stringToTimeOfDay(String? time) {
  if (time == null || time.isEmpty) return null;
  final parts = time.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}

// 缺乏五行
String determineLackingElements(List<String> words) {
  // Initialize a set of all elements
  Set<ElementType> allElements = {
    ElementType.Wood,
    ElementType.Fire,
    ElementType.Earth,
    ElementType.Metal,
    ElementType.Water,
  };

  // Find elements present in the input
  Set<ElementType> presentElements = {};
  for (String word in words) {
    ElementType? element = elementMapping[word];
    if (element != null) {
      presentElements.add(element);
    }
  }

  // Find missing elements
  Set<ElementType> missingElements = allElements.difference(presentElements);

  // Handle missing elements specifically
  if (missingElements.contains(ElementType.Wood)) {
    return "喝酒容易醉!";
  }
  if (missingElements.contains(ElementType.Fire)) {
    return "Fire element is missing - Customize this message!";
  }
  if (missingElements.contains(ElementType.Earth)) {
    return "Earth element is missing - Customize this message!";
  }
  if (missingElements.contains(ElementType.Metal)) {
    return "Metal element is missing - Customize this message!";
  }
  if (missingElements.contains(ElementType.Water)) {
    return "Water element is missing - Customize this message!";
  }

  return "No elements are missing - Customize this message!";
}

// 缺少十神
List<String> calculateMissingChineseCharacters(
    String? tianShiShenTime, // Make tianShiShenTime optional
    String tianShiShenMonth,
    String tianShiShenYear,
    List<String>? timeZhi, // Make timeZhi optional
    List<String> yearZhi,
    List<String> monthZhi,
    List<String> dayZhi,
    [int messageIndex = 1] // Optional index to select the specific message
    ) {
  // Full list of Chinese words
  List<String> allChineseWords = [
    "印",
    "梟",
    "比",
    "劫",
    "才",
    "財",
    "食",
    "傷",
    "殺",
    "官"
  ];

  // Combine all input into one list
  List<String> providedWords = [
    if (tianShiShenTime != null) tianShiShenTime, // Only add if not null
    tianShiShenMonth,
    tianShiShenYear,
    if (timeZhi != null) ...timeZhi, // Safely include timeZhi if it's not null
    ...yearZhi,
    ...monthZhi,
    ...dayZhi,
  ];

  // Find missing characters
  List<String> missingCharacters =
      allChineseWords.where((word) => !providedWords.contains(word)).toList();

  // Prepare a list to store messages
  List<String> messages = [];

  // Handle each missing character
  for (String missing in missingCharacters) {
    switch (missing) {
      case "印":
        if (messageIndex == 1) {
          messages.add("不喜歡.");
        } else if (messageIndex == 2) {
          messages.add("記性不好");
        } else if (messageIndex == 3) {
          messages.add("容易生病");
        } else if (messageIndex == 4) {
          messages.add("容易生病");
        }
        break;
      case "梟":
        if (messageIndex == 1) {
          messages.add("Missing 梟: Primary message for 梟.");
        } else if (messageIndex == 2) {
          messages.add("Missing 梟: Secondary message for 梟.");
        }
        break;
      case "殺":
        if (messageIndex == 1) {
          messages.add("Missing 殺: Primary message for 殺.");
        } else if (messageIndex == 2) {
          messages.add("Missing 殺: Secondary message for 殺.");
        }
        break;
      case "官":
        if (messageIndex == 1) {
          messages.add("Missing 官: Primary message for 官.");
        } else if (messageIndex == 2) {
          messages.add("Missing 官: Secondary message for 官.");
        }
        break;
      default:
        messages.add("Missing $missing: General message.");
    }
  }

  // Return the list of messages
  return messages;
}

// 算十神
int countOccurrences(String word, List<String> list) {
  return list.where((e) => e == word).length;
}

Map<String, int> countAllWords({
  required String tianShiShenMonth,
  required String tianShiShenYear,
  List<String>? timeZhi, // Optional parameter
  String? tianShiShenTime, // Optional parameter
  required List<String> yearZhi,
  required List<String> monthZhi,
  required List<String> dayZhi,
}) {
  List<String> allChineseWords = [
    "印",
    "梟",
    "比",
    "劫",
    "才",
    "財",
    "食",
    "傷",
    "殺",
    "官"
  ];

  // Create a map to store counts of each word
  Map<String, int> wordCounts = {};

  // Combine all inputs into a list of strings to check
  List<String> allInputs = [
    if (tianShiShenTime != null) tianShiShenTime, // Only add if not null
    tianShiShenMonth,
    tianShiShenYear,
    ...?timeZhi, // Safely include timeZhi if it's not null
    ...yearZhi,
    ...monthZhi,
    ...dayZhi
  ];

  // Iterate through all Chinese words and count occurrences
  for (String word in allChineseWords) {
    int count = 0;

    // Count occurrences in the provided inputs
    count += countOccurrences(word, allInputs);

    // Store the count in the map
    wordCounts[word] = count;
  }

  return wordCounts;
}
