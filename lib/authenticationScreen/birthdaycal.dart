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
// 五行過多
// ========================================================

Map<ElementType, List<String>> generateMessages(List<String> words) {
  Map<ElementType, int> elementCounts = {
    ElementType.Wood: 0,
    ElementType.Fire: 0,
    ElementType.Earth: 0,
    ElementType.Metal: 0,
    ElementType.Water: 0,
  };

  // Count occurrences of each element
  for (var word in words) {
    if (elementMapping.containsKey(word)) {
      // Safely access the element type, which will never be null due to the check
      ElementType element = elementMapping[word]!;
      elementCounts[element] = elementCounts[element]! + 1;
    }
  }

  // Prepare result with individual messages
  Map<ElementType, List<String>> result = {};

  elementCounts.forEach((element, count) {
    if (count > 3) {
      // Assign specific messages for each element as a list
      switch (element) {
        case ElementType.Wood:
          result[element] = [
            'Wood Message 1',
            'Wood Message 2',
            'Wood Message 3'
          ];
          break;
        case ElementType.Fire:
          result[element] = [
            'Fire Message 1',
            'Fire Message 2',
            'Fire Message 3'
          ];
          break;
        case ElementType.Earth:
          result[element] = ['胃經常不舒服', '', 'Earth Message 3'];
          break;
        case ElementType.Metal:
          result[element] = [
            'Metal Message 1',
            'Metal Message 2',
            'Metal Message 3'
          ];
          break;
        case ElementType.Water:
          result[element] = [
            'Water Message 1',
            'Water Message 2',
            'Water Message 3'
          ];
          break;
      }
    } else if (count > 4) {
      // Assign specific messages for each element as a list
      switch (element) {
        case ElementType.Wood:
          result[element] = [
            'Wood Message 1',
            'Wood Message 2',
            'Wood Message 3'
          ];
          break;
        case ElementType.Fire:
          result[element] = ['皮膚過乾', '經常喘不過氣', '容易生氣'];
          break;
        case ElementType.Earth:
          result[element] = ['經常胃痛', 'Earth Message 2', 'Earth Message 3'];
          break;
        case ElementType.Metal:
          result[element] = [
            'Metal Message 1',
            'Metal Message 2',
            'Metal Message 3'
          ];
          break;
        case ElementType.Water:
          result[element] = [
            'Water Message 1',
            'Water Message 2',
            'Water Message 3'
          ];
          break;
      }
    }
  });

  return result;
}

Map<String, List<String>> countAllWords({
  required String tianShiShenMonth,
  required String tianShiShenYear,
  List<String>? timeZhi, // Optional parameter
  String? tianShiShenTime, // Optional parameter
  required String yearZhi,
  required List<String> monthZhi,
  required List<String> dayZhi,
  required String sex,
}) {
  // Define a map for messages categorized by gender
  Map<String, Map<String, List<String>>> messageMapping = {
    "比": {
      "male": ["喜歡冒險", "可能與朋友有財務糾紛", "容易受到朋友影響"],
      "female": ["喜歡冒險", "過於依賴同伴", "受到朋友影響較大"],
    },
    "劫": {
      "male": ["可能與朋友競爭激烈", "容易衝動", "可能因朋友蒙受損失"],
      "female": ["競爭心強", "容易受到朋友影響", "可能冒險精神過強"],
    },
    "印": {
      "male": ["缺乏行動力", "學習能力強但執行力弱", "可能有胃部健康問題"],
      "female": ["注重學習", "過於依賴他人", "容易忽略實踐"],
    },
    "傷": {
      "male": ["善於表達", "可能因感情受傷", "有藝術天賦"],
      "female": ["情感細膩", "過於感性", "可能過於自我中心"],
    },
    "食": {
      "male": ["愛吃", "愛玩", "能說會道"],
      "female": ["貪玩", "有點胖", "能說會道"],
    },
    "官": {
      "male": ["具備領導力", "控制欲強", "講話前思考很久"],
      "female": ["追求者多", "吸引別人注意", "控制欲強"],
    },
  };

  // Combine all inputs into a list of strings to check
  List<String> allInputs = [
    if (tianShiShenTime != null) tianShiShenTime, // Only add if not null
    tianShiShenMonth,
    tianShiShenYear,
    yearZhi,
    ...?timeZhi, // Safely include timeZhi if it's not null
    ...monthZhi,
    ...dayZhi,
  ];

  // Create a map to store counts of each word and their messages
  Map<String, List<String>> wordMessages = {};

  // Iterate through each word in the mapping
  for (var entry in messageMapping.entries) {
    String word = entry.key;
    Map<String, List<String>> genderMessages = entry.value;

    // Count occurrences of the word in all inputs
    int count = countOccurrences(word, allInputs);

    // Collect messages for the current count if it is greater than 3
    if (count > 3) {
      String genderKey = sex.toLowerCase();
      if (genderMessages.containsKey(genderKey)) {
        wordMessages[word] = genderMessages[genderKey]!;
      }
    }
  }

  return wordMessages;
}

// Function to count occurrences of a word in a list of strings

// 計算神煞多餘3
// Map<String, List<String>> countAllWords({
//   required String tianShiShenMonth,
//   required String tianShiShenYear,
//   List<String>? timeZhi, // Optional parameter
//   String? tianShiShenTime, // Optional parameter
//   required String yearZhi,
//   required List<String> monthZhi,
//   required List<String> dayZhi,
//   required String sex,
// }) {
//   // Define a map for messages based on word and count
//   Map<String, Map<int, List<String>>> messageMapping = {
//     "比": {
//       2: ["有好賭行為", "喜歡冒險"],
//       3: ["可能冒險精神過強", "可能與朋友有財務糾紛"],
//       4: ["容易受到朋友影響", "可能過於依賴同伴"],
//     },
//     "劫": {
//       2: ["有好賭行為", "可能與朋友競爭激烈"],
//       3: ["可能冒險精神過強", "容易衝動"],
//       4: ["容易受到朋友影響", "可能因朋友蒙受損失"],
//     },
//     "印": {
//       3: ["自己很懶", "缺乏行動力"],
//       4: ["依賴他人過多", "過於注重學習而忽略實踐"],
//       5: ["學習能力強，但執行力弱", "可能有胃部健康問題"],
//     },
//     "傷": {
//       2: ["情感細膩", "善於表達"],
//       3: ["可能過於感性", "容易因感情受傷"],
//       4: ["有藝術天賦", "可能過於自我中心"],
//     },
//     "食": {
//       2: ["貪玩"],
//       3: ["愛吃", "愛玩"],
//       4: ["有點胖", "能說會道"],
//     },
//     "官": {
//       2: ["講話前思考很久"],
//       3: ["強迫症?"],
//       4: ["控制欲強"],
//     },
//   };

//   // Handle specific sex-based cases
//   if (sex == "female") {
//     messageMapping["官"]![2] = ["追求者多"];
//   } else if (sex == "male") {
//     messageMapping["官"]![2] = ["講話前思考很久"]; // No message for males
//   }

//   // Combine all inputs into a list of strings to check
//   List<String> allInputs = [
//     if (tianShiShenTime != null) tianShiShenTime, // Only add if not null
//     tianShiShenMonth,
//     tianShiShenYear,
//     yearZhi,
//     ...?timeZhi, // Safely include timeZhi if it's not null
//     ...monthZhi,
//     ...dayZhi
//   ];

//   // Create a map to store counts of each word and their messages
//   Map<String, List<String>> wordMessages = {};

//   // Iterate through each word in the mapping
//   for (var entry in messageMapping.entries) {
//     String word = entry.key;
//     Map<int, List<String>> countMessages = entry.value;

//     // Count occurrences of the word in all inputs
//     int count = countOccurrences(word, allInputs);

//     // Collect messages for the current count
//     List<String> messages = [];
//     countMessages.forEach((key, value) {
//       if (count >= key) {
//         messages.addAll(value); // Add all messages for the matching count
//       }
//     });

//     // Only add the word to the map if there are messages
//     if (messages.isNotEmpty) {
//       wordMessages[word] = messages;
//     }
//   }

//   return wordMessages;
// }

// 看哪年發生甚麼事
List<String> happedHistory(
    int age, // The input age
    String tianShiShenMonth, // Current month (e.g., "殺")
    String tianShiShenYear,
    List<String>? timeZhi,
    List<String> yearZhi,
    List<String> monthZhi,
    List<String> dayZhi,
    [int messageIndex = 1] // Optional index to select the specific message
    ) {
  // Dummy strings for each Chinese word and their corresponding messages
  Map<String, List<String>> dummyMessages = {
    "印": [
      "年輕且有活力",
      "努力工作，但不太注重細節",
      "逐漸學會依賴他人",
      "自己有些懶惰",
      "依賴他人過多",
      "有很強的學習能力，但執行力較弱",
      "胃部可能有問題",
    ],
    "梟": [
      "可以理解他人的需求",
      "在表達上有獨到見解",
      "有時候有些過於冷靜",
      "情緒容易波動",
      "脾氣古怪",
    ],
    "比": [
      "有好賭行為",
      "喜歡冒險",
      "可能冒險精神過強",
      "可能與朋友有財務糾紛",
      "容易受到朋友影響",
    ],
    "劫": [
      "有好賭行為",
      "可能與朋友競爭激烈",
      "可能冒險精神過強",
      "容易衝動",
      "容易受到朋友影響",
    ],
    "才": [
      "有才能但尚未被發掘",
      "有潛力但需努力",
      "智慧逐漸發展",
      "有創新思維",
      "發揮才能的時候已經到來",
    ],
    "財": [
      "有金錢的潛力",
      "學會如何理財",
      "可能有一些財務問題",
      "財運來臨",
      "財富累積中",
    ],
    "食": [
      "精力充沛，食量大",
      "食慾旺盛",
      "對飲食有很高要求",
      "健康飲食",
      "有時候會過度放縱自己",
    ],
    "傷": [
      "有一段失敗的感情",
    ],
    "殺": [
      "極具行動力",
      "敢於冒險，渴望挑戰",
      "有強烈的勝利慾望",
      "喜歡競爭，強勢",
      "有時過於激進",
    ],
    "官": [
      "具備領導力",
      "喜歡幫助他人",
      "可能有官場運勢",
      "領導潛力逐漸顯現",
      "有很強的管理能力",
    ],
  };

  // Determine the number of words in the monthZhi, yearZhi, and dayZhi lists
  int getAgeRange(List<String> zhiList) {
    if (zhiList.length == 1) {
      return 9; // Represents a 9-year period per word
    } else if (zhiList.length == 2) {
      return 4; // Represents 4.5 years per word
    } else if (zhiList.length == 3) {
      return 3; // Represents 3 years per word
    }
    return 0; // Default, should not happen
  }

  // Calculate the specific word based on the age
  List<String> getMessagesForAge(List<String> zhiList, int age) {
    int range = getAgeRange(zhiList);
    int wordIndex = (age / range)
        .floor(); // Determine which word corresponds to the given age

    // Ensure we don't go out of bounds
    if (wordIndex >= zhiList.length) {
      wordIndex = zhiList.length - 1; // Use the last word if out of bounds
    }

    // The word at the calculated index (based on age)
    String targetWord = zhiList[wordIndex];
    return dummyMessages[targetWord] ?? [];
  }

  // Find the messages based on the age and monthZhi (for example)
  List<String> selectedMessages = getMessagesForAge(monthZhi, age);

  return selectedMessages;
}

List<String> happedHistory2(
    int age, // The input age
    String tianShiShenMonth, // Current month (e.g., "殺")
    String tianShiShenYear, // Current year (e.g., "印")
    List<String>? timeZhi, // Optional time-based Zhi list
    String? tianShiShenTime, // Time-related TianShiShen (e.g., "印" for 46~54)
    String yearZhi, // Year-related Zhi
    List<String> monthZhi, // Month-related Zhi
    List<String> dayZhi, // Day-related Zhi
    String sex, // Gender ("male" or "female")
    [int messageIndex = 1] // Optional index for a specific message
    ) {
  // Define dummy messages with gender differentiation
  Map<String, Map<String, List<String>>> dummyMessages = {
    "印": {
      "male": ["年輕且有活力", "努力工作，但不太注重細節", "逐漸學會依賴他人"],
      "female": ["學習能力強", "注重細節，但行動力稍弱", "依賴他人過多"],
    },
    "官": {
      "male": ["具備領導力", "喜歡幫助他人", "可能有官場運勢", "有很強的管理能力"],
      "female": ["早戀", "容易吸引別人的注意", "可能有婚姻運勢", "擁有天然魅力"],
    },
    "殺": {
      "male": ["極具行動力", "敢於冒險，渴望挑戰", "有強烈的勝利慾望"],
      "female": ["早戀", "喜歡挑戰自己的極限", "具有領袖風範"],
    },
    "食": {
      "male": ["當時比較胖", "比較貪玩", "有強烈的勝利慾望"],
      "female": ["當時比較胖", "比較貪玩", "具有領袖風範"],
    },
    "傷": {
      "male": ["", "個性刁鑽", "比較不服氣"],
      "female": ["失敗的感情", "比較貪玩", "具有領袖風範"],
    },
  };

  // Function to determine age range per word
  int getAgeRange(List<String> zhiList) {
    if (zhiList.length == 1) {
      return 9; // 9-year period per word
    } else if (zhiList.length == 2) {
      return 4; // 4.5-year period per word
    } else if (zhiList.length == 3) {
      return 3; // 3-year period per word
    }
    return 0; // Default, should not happen
  }

  // Function to get messages based on age, Zhi list, and sex
  List<String> getMessagesForAgeAndSex(
      List<String> zhiList, int age, String sex) {
    int range = getAgeRange(zhiList);
    int wordIndex = (age / range).floor();

    // Ensure we don't go out of bounds
    if (wordIndex >= zhiList.length) {
      wordIndex = zhiList.length - 1; // Use the last word if out of bounds
    }

    String targetWord = zhiList[wordIndex];
    // Get messages for the target word based on sex
    return dummyMessages[targetWord]?[sex] ?? [];
  }

  // Combine different Zhi lists based on the input parameters
  List<String> combineZhiLists() {
    // Example: Use `tianShiShenTime` for ages 46~54 specifically
    if (age >= 46 && age <= 54 && tianShiShenTime != null) {
      return [tianShiShenTime];
    }

    // Otherwise, prioritize the monthZhi list
    return monthZhi;
  }

  // Use the combined Zhi list to determine the messages
  List<String> combinedZhi = combineZhiLists();
  List<String> selectedMessages =
      getMessagesForAgeAndSex(combinedZhi, age, sex);

  return selectedMessages;
}

// 缺乏五行
// ========================================================
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
          messages.add("沒有責任心");
        } else if (messageIndex == 5) {
          messages.add("得不到母親幫助");
        }
        break;
      case "食":
        if (messageIndex == 1) {
          messages.add("吃不胖");
        } else if (messageIndex == 2) {
          messages.add("很難放鬆");
        } else if (messageIndex == 3) {
          messages.add("不喜歡廢話,不善言詞");
        } else if (messageIndex == 4) {
          messages.add("不會玩");
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
          messages.add("管不好自己");
        } else if (messageIndex == 2) {
          messages.add("不喜歡被控制");
        }
        break;
      default:
        messages.add("Missing $missing: General message.");
    }
  }

  // Return the list of messages
  return messages;
}

int countOccurrences(String word, List<String> list) {
  return list.where((e) => e == word).length;
}

TimeOfDay? stringToTimeOfDay(String? time) {
  if (time == null || time.isEmpty) return null;
  final parts = time.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}
