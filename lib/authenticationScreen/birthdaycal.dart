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

// 多餘3個
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
      "male": ["經常吵架", "經常不滿現況", "性子急", "有特殊才能"],
      "female": ["經常不服氣", "經常不滿現況", "性子急", "有特殊才能"],
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

//性格
Map<String, List<String>> personality({
  required List<String> zhiList1,
  required List<String> zhiList2,
  required String sex,
}) {
  // Define a map for messages categorized by gender
  Map<String, Map<String, List<String>>> messageMapping = {
    "殺": {
      "male": ["喜歡冒險", "可能與朋友有財務糾紛", "容易受到朋友影響"],
      "female": ["喜歡冒險", "過於依賴同伴", "受到朋友影響較大"],
    },
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
      "male": ["經常吵架", "經常不滿現況", "性子急"],
      "female": ["經常不服氣", "經常不滿現況", "性子急"],
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

  // Combine the inputs into a single list to process
  List<String> allInputs = [...zhiList1, ...zhiList2];

  // Create a map to store words and their corresponding messages
  Map<String, List<String>> wordMessages = {};

  // Iterate through each word in the mapping
  for (var entry in messageMapping.entries) {
    String word = entry.key;
    Map<String, List<String>> genderMessages = entry.value;

    // Check if the word exists in the combined inputs
    if (allInputs.contains(word)) {
      String genderKey = sex.toLowerCase();
      if (genderMessages.containsKey(genderKey)) {
        wordMessages[word] = genderMessages[genderKey]!;
      }
    }
  }

  return wordMessages;
}

List<String> happedHistory2(
  int age, // The person's age
  String tianShiShenMonth, // For ages 19~26
  String tianShiShenYear, // For ages 10~18
  List<String>? timeZhi, // For ages 56~65, 56~60 and 61~65
  String? tianShiShenTime, // For ages 47~55
  List<String> yearZhi, // For ages 10~18
  List<String> monthZhi, // For ages 27~36
  List<String> dayZhi, // For ages 37~46
  String sex, // Male or Female
) {
  // TianShiShen and corresponding messages based on gender
  // Messages map for different TianShiShen types and sex
  Map<String, Map<String, List<String>>> messages = {
    "印": {
      "Male": ["年輕且有活力", "努力工作，但不太注重細節", "逐漸學會依賴他人"],
      "Female": ["學習能力強", "注重細節，但行動力稍弱", "依賴他人過多"]
    },
    "比": {
      "Male": [""],
      "Female": [""]
    },
    "官": {
      "Male": ["具備領導力", "喜歡幫助他人", "可能有官場運勢", "有很強的管理能力"],
      "Female": ["早戀", "容易吸引別人的注意", "可能有婚姻運勢", "擁有天然魅力"]
    },
    "殺": {
      "Male": ["極具行動力", "敢於冒險，渴望挑戰", "有強烈的勝利慾望"],
      "Female": ["早戀", "喜歡挑戰自己的極限", "具有領袖風範"]
    },
    "食": {
      "Male": ["當時比較胖", "比較貪玩", "有強烈的勝利慾望", "有癮"],
      "Female": ["當時比較胖", "比較貪玩", "具有領袖風範", "有癮"]
    },
    "傷": {
      "Male": ["當時家裡屏寒", "個性刁鑽", "比較不服氣"],
      "Female": ["失敗的感情", "當時家裡屏寒", "具有領袖風範"]
    },
    "財": {
      "Male": ["年輕且有活力", "努力工作，但不太注重細節", "逐漸學會依賴他人"],
      "Female": ["學習能力強", "注重細節，但行動力稍弱", "依賴他人過多"]
    },
    "梟": {
      "Male": ["年輕且有活力", "努力工作，但不太注重細節", "逐漸學會依賴他人"],
      "Female": ["學習能力強", "注重細節，但行動力稍弱", "依賴他人過多"]
    },
    "劫": {
      "Male": ["偷拐搶騙"],
      "Female": ["偷拐搶騙"]
    },
    "才": {
      "Male": ["moe"],
      "Female": ["money"]
    }
  };

  String result = '';

  // Determine TianShiShen based on age ranges and input data
  if (age >= 10 && age <= 18) {
    if (yearZhi.isNotEmpty) {
      if (yearZhi.length == 1) {
        result = yearZhi[0];
      } else if (yearZhi.length == 2) {
        result = (age <= 14) ? yearZhi[0] : yearZhi[1];
      } else if (yearZhi.length == 3) {
        result = (age <= 12)
            ? yearZhi[0]
            : (age <= 15)
                ? yearZhi[1]
                : yearZhi[2];
      }
    }
  } else if (age >= 19 && age <= 26) {
    result = tianShiShenMonth;
  } else if (age >= 27 && age <= 36) {
    if (monthZhi.isNotEmpty) {
      if (monthZhi.length == 1) {
        result = monthZhi[0];
      } else if (monthZhi.length == 2) {
        result = (age <= 31) ? monthZhi[0] : monthZhi[1];
      } else if (monthZhi.length == 3) {
        result = (age <= 29)
            ? monthZhi[0]
            : (age <= 33)
                ? monthZhi[1]
                : monthZhi[2];
      }
    }
  } else if (age >= 37 && age <= 46) {
    if (dayZhi.isNotEmpty) {
      result = (dayZhi.length == 1)
          ? dayZhi[0]
          : (age <= 41)
              ? dayZhi[0]
              : dayZhi[1];
    }
  } else if (age >= 47 && age <= 55 && tianShiShenTime != null) {
    result = tianShiShenTime;
  } else if (age >= 56 && age <= 65 && timeZhi != null) {
    if (timeZhi.isNotEmpty) {
      if (timeZhi.length == 1) {
        result = timeZhi[0];
      } else if (timeZhi.length == 2) {
        result = (age <= 60) ? timeZhi[0] : timeZhi[1];
      } else if (timeZhi.length == 3) {
        result = (age <= 58)
            ? timeZhi[0]
            : (age <= 61)
                ? timeZhi[1]
                : timeZhi[2];
      }
    }
  }

  print('Final TianShiShen determined: $result');

  // Fetch messages based on the determined result and sex
  List<String> resultMessages = [];
  if (messages.containsKey(result)) {
    if (messages[result]!.containsKey(sex)) {
      resultMessages = messages[result]![sex]!;
      print('Messages for $result and $sex: ${resultMessages.join(", ")}');
    } else {
      resultMessages = ['No specific messages found for this gender'];
    }
  } else {
    resultMessages = ['No messages found for the determined TianShiShen'];
  }

  return resultMessages;
}

// // 看哪年發生甚麼事
// v1
// List<String> happedHistory2(
//   int age, // The person's age
//   String tianShiShenMonth, // For ages 19~26
//   String tianShiShenYear, // For ages 10~18
//   List<String>? timeZhi, // For ages 56~65, 56~60 and 61~65
//   String? tianShiShenTime, // For ages 47~55
//   List<String> yearZhi, // For ages 10~18
//   List<String> monthZhi, // For ages 27~36
//   List<String> dayZhi, // For ages 37~46
//   String sex, // Male or female
// ) {
//   // Messages map for different TianShiShen types and sex
//   Map<String, Map<String, List<String>>> messages = {
//     "印": {
//       "Male": ["年輕且有活力", "努力工作，但不太注重細節", "逐漸學會依賴他人"],
//       "Female": ["學習能力強", "注重細節，但行動力稍弱", "依賴他人過多"]
//     },
//     "比": {
//       "Male": [""],
//       "Female": [""]
//     },
//     "官": {
//       "Male": ["具備領導力", "喜歡幫助他人", "可能有官場運勢", "有很強的管理能力"],
//       "Female": ["早戀", "容易吸引別人的注意", "可能有婚姻運勢", "擁有天然魅力"]
//     },
//     "殺": {
//       "Male": ["極具行動力", "敢於冒險，渴望挑戰", "有強烈的勝利慾望"],
//       "Female": ["早戀", "喜歡挑戰自己的極限", "具有領袖風範"]
//     },
//     "食": {
//       "Male": ["當時比較胖", "比較貪玩", "有強烈的勝利慾望", "有癮"],
//       "Female": ["當時比較胖", "比較貪玩", "具有領袖風範", "有癮"]
//     },
//     "傷": {
//       "Male": ["當時家裡屏寒", "個性刁鑽", "比較不服氣"],
//       "Female": ["失敗的感情", "當時家裡屏寒", "具有領袖風範"]
//     },
//     "財": {
//       "Male": ["年輕且有活力", "努力工作，但不太注重細節", "逐漸學會依賴他人"],
//       "Female": ["學習能力強", "注重細節，但行動力稍弱", "依賴他人過多"]
//     },
//     "梟": {
//       "Male": ["年輕且有活力", "努力工作，但不太注重細節", "逐漸學會依賴他人"],
//       "Female": ["學習能力強", "注重細節，但行動力稍弱", "依賴他人過多"]
//     },
//     "劫": {
//       "Male": ["偷拐搶騙"],
//       "Female": ["偷拐搶騙"]
//     },
//     "才": {
//       "Male": ["moe"],
//       "Female": ["money"]
//     }
//   };

//   String result = '';

//   // Determine the TianShiShen word based on the age ranges and other conditions
//   if (yearZhi.isNotEmpty) {
//     if (yearZhi.length == 1 && age >= 10 && age <= 18) {
//       result = yearZhi[0];
//     } else if (yearZhi.length == 2) {
//       if (age >= 10 && age <= 14) {
//         result = yearZhi[0];
//       } else if (age >= 15 && age <= 18) {
//         result = yearZhi[1];
//       }
//     } else if (yearZhi.length == 3) {
//       if (age >= 10 && age <= 12) {
//         result = yearZhi[0];
//       } else if (age >= 13 && age <= 15) {
//         result = yearZhi[1];
//       } else if (age >= 16 && age <= 18) {
//         result = yearZhi[2];
//       }
//     }
//   }

//   if (age >= 19 && age <= 26) {
//     result = tianShiShenMonth;
//     print('Age is between 19 and 26. Result set to tianShiShenMonth: $result');
//   }

//   if (age >= 27 && age <= 36) {
//     if (monthZhi.isNotEmpty) {
//       if (monthZhi.length == 1) {
//         result = monthZhi[0];
//       } else if (monthZhi.length == 2) {
//         result = (age >= 27 && age <= 31) ? monthZhi[0] : monthZhi[1];
//       } else if (monthZhi.length == 3) {
//         if (age >= 27 && age <= 29) {
//           result = monthZhi[0];
//         } else if (age >= 30 && age <= 33) {
//           result = monthZhi[1];
//         } else if (age >= 34 && age <= 36) {
//           result = monthZhi[2];
//         }
//       }
//     }
//   }

//   if (age >= 37 && age <= 46) {
//     if (dayZhi.isNotEmpty) {
//       result = (dayZhi.length == 1)
//           ? dayZhi[0]
//           : (age >= 37 && age <= 41)
//               ? dayZhi[0]
//               : dayZhi[1];
//     }
//   }

//   if (age >= 47 && age <= 55 && tianShiShenTime != null) {
//     result = tianShiShenTime;
//   }

//   if (timeZhi != null && timeZhi.isNotEmpty) {
//     result = (timeZhi.length == 1 && age >= 56 && age <= 65)
//         ? timeZhi[0]
//         : (timeZhi.length == 2 && age >= 56 && age <= 60)
//             ? timeZhi[0]
//             : (timeZhi.length == 2 && age >= 61 && age <= 65)
//                 ? timeZhi[1]
//                 : (timeZhi.length == 3 && age >= 56 && age <= 58)
//                     ? timeZhi[0]
//                     : (timeZhi.length == 3 && age >= 59 && age <= 61)
//                         ? timeZhi[1]
//                         : timeZhi[2];
//   }
// // Debugging the final result
//   print('Final result: $result');

// // Initialize an empty list to hold the final messages
//   List<String> resultMessages = [];

// // Check for result in the messages map and the sex key
//   if (messages.containsKey(result)) {
//     if (messages[result]!.containsKey(sex)) {
//       List<String> sexMessages = messages[result]![sex]!;
//       print(
//           'Messages for $result and $sex: ${sexMessages.join(", ")}'); // Debugging the messages found
//       resultMessages = sexMessages; // Store the messages in the list
//     } else {
//       print('No messages found for sex $sex under result $result');
//       resultMessages = [
//         'No messages found for this sex'
//       ]; // Store the fallback message
//     }
//   } else {
//     print('No TianShiShen found for result $result');
//     resultMessages = [
//       'No TianShiShen found for this age'
//     ]; // Store the fallback message
//   }

// // Return the list of messages instead of a single string
//   return resultMessages;
// }

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
      case "殺":
        if (messageIndex == 1) {
          messages.add("人不夠狠");
        } else if (messageIndex == 2) {
          messages.add("比較容易原諒別人");
        } else if (messageIndex == 3) {
          messages.add("");
        } else if (messageIndex == 4) {
          messages.add("");
        } else if (messageIndex == 5) {
          messages.add("");
        }
        break;
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
      case "傷":
        if (messageIndex == 1) {
          messages.add("有時感覺自己不上進");
        } else if (messageIndex == 2) {
          messages.add("經常無所謂的感覺");
        } else if (messageIndex == 3) {
          messages.add("");
        } else if (messageIndex == 4) {
          messages.add("");
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
