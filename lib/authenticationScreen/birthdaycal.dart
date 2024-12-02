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

  static calculateAge(DateTime birthDate) {
    DateTime now = DateTime.now();
    int years = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      years--;
    }
    return years;
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

List<String> sixtybodyCondition({
  required String char1,
  required String char2,
  required String yearbot,
  required String monthbot,
}) {
  // Initialize a list to store messages
  List<String> messages = [];

  // Conditional logic for combining characters and adding messages
  if (char1 == "丙" && char2 == "申") {
    messages.add("和母親的關係親密");
    messages.add("野心有點大而帶給自己壓力");
    messages.add("容易精神不佳");
    messages.add("心臟、脾土和腎功能先天欠");
    if (monthbot == "子" || monthbot == "丑" || monthbot == "辰") {
      messages.add("有血疾");
    }
  }
  if (char1 == "丙" && char2 == "子") {
    messages.add("自尊心極強");
    messages.add("膽大");

    if (yearbot == "午" || monthbot == "巳") {
      messages.add("血症，腹鳴、脹滿、痙攣、疝氣、癌症、血壓異常，以及由於抵抗力不足，心腎不交，睡眠不好。");
    }
  }
  if (char1 == "甲" && char2 == "辰") {
    messages.add("吃軟不吃硬");
  }
  if (char1 == "辛" && char2 == "亥") {
    messages.add("通常不惹閒事");
    messages.add("非常容易罵另一半導致感情不順利");
    messages.add("嬌氣");
    if (monthbot == "巳") {
      messages.add("經常走動或搬家");
    }
  }

  return messages;
}

List<String> specialCasesMonthTop({
  required String monthTop,
  required String monthBot,
  required String sex,
}) {
  // Initialize an empty list to store messages
  List<String> messages = [];

  // Add messages based on conditions
  if (monthTop == "梟" && monthBot == "食") {
    messages.add("父母關西差");
    messages.add("或者已經離婚");
  }
  if (monthTop == "食" && monthBot == "梟") {
    messages.add("父母關西差");
    messages.add("或者已經離婚");
  }
  if (monthTop == "劫" && monthBot == "才") {
    messages.add("投資失敗");
    messages.add("父母關西差");
    messages.add("或者已經離婚");
  }
  if (monthTop == "才" && monthBot == "劫") {
    messages.add("投資失敗");
    messages.add("父母關西差");
    messages.add("或者已經離婚");
  }
  if (monthTop == "劫" && monthBot == "財") {
    messages.add("投資失敗");
    messages.add("父母關西差");
    messages.add("或者已經離婚");
  }
  if (monthTop == "財" && monthBot == "劫") {
    messages.add("投資失敗");
    messages.add("父母關西差");
    messages.add("或者已經離婚");
  }

  // Default message if no conditions are matched
  if (messages.isEmpty) {
    messages.add("正常");
  }

  return messages;
}

// 甲盰乙膽丙小腸 丁心戊胃已脾鄉　庚金大腸辛金肺　壬是膀胱癸腎藏

String body5ElementCheck({
  required String
      yearTop, // Made it required as it doesn't make sense to leave it optional
  required String yearbotr,
  required String monthTop,
  required String monthBot,
  required String dayTop,
  required String dayBot,
  required String sex,
  String? timeTop,
  String? tianBot,
}) {
  if (yearTop == "庚" || yearTop == "辛" || yearTop == "戊" || yearTop == "己") {
    return "頭髮稀少";
  }

  // Default return if no conditions match
  return "正常";
}

String bodyGodsCheck({
  required String
      yearTop, // Made it required as it doesn't make sense to leave it optional
  required String yearbotr,
  required String monthTop,
  required String monthBot,
  required String dayTop,
  required String dayBot,
  required String sex,
  String? timeTop,
  String? timeBot,
}) {
  if (yearTop == "庚" || yearTop == "辛" || yearTop == "戊" || yearTop == "己") {
    return "頭髮稀少";
  }
  if (timeBot != null && timeBot == "食") {
    return "小腿粗";
  }

  // Default return if no conditions match
  return "正常";
}

// 算體態

// 陰陽
String checkYinYang({
  required String tianShiShenMonth,
  required String tianShiShenYear,
  String? timeZhi, // Optional parameter
  String? tianShiShenTime, // Optional parameter
  required String yearZhi,
  required String monthZhi,
  required String dayZhi,
  required String sex, // Currently not used in calculation but included
}) {
  // Define mappings for 天干 and 地支
  Map<String, String> yinYangMapping = {
    // 天干 mappings
    "甲": "陽",
    "乙": "陰",
    "丙": "陽",
    "丁": "陰",
    "戊": "陽",
    "己": "陰",
    "庚": "陽",
    "辛": "陰",
    "壬": "陽",
    "癸": "陰",

    // 地支 mappings
    "子": "陽",
    "丑": "陰",
    "寅": "陽",
    "卯": "陰",
    "辰": "陽",
    "巳": "陰",
    "午": "陽",
    "未": "陰",
    "申": "陽",
    "酉": "陰",
    "戌": "陽",
    "亥": "陰"
  };

  // Combine inputs into a single list for analysis
  List<String> combinedWords = [
    tianShiShenMonth,
    tianShiShenYear,
    if (timeZhi != null) timeZhi, // Include if not null
    if (tianShiShenTime != null) tianShiShenTime, // Include if not null
    yearZhi,
    monthZhi,
    dayZhi
  ];

  // Check for presence of 陰 and 陽 elements in the input
  bool containsYin = combinedWords.any((word) => yinYangMapping[word] == "陰");
  bool containsYang = combinedWords.any((word) => yinYangMapping[word] == "陽");

  // Return appropriate result
  if (!containsYin) {
    return "個性過於陽剛";
  } else if (!containsYang) {
    return "過於陰柔";
  } else {
    return "陰陽平衡";
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
      "male": ["喜歡冒險", "可能與朋友有財務糾紛", "容易受到朋友影響", "固執"],
      "female": ["喜歡冒險", "過於依賴同伴", "受到朋友影響較大", "固執"],
    },
    "劫": {
      "male": [
        "可能與朋友競爭激烈",
        "容易衝動",
        "把好的讓給朋友或者送給朋友",
        "性個過於強硬",
        "感覺有時候精神分裂, 或者雙從性格"
      ],
      "female": [
        "競爭心強",
        "把好的讓給朋友或者送給朋友",
        "可能冒險精神過強",
        "性個過於強硬",
        "感覺有時候精神分裂, 或者雙從性格"
      ],
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
      "female": ["追求者多", "吸引別人注意", "控制欲強", "性格古板"],
    },
    "殺": {
      "male": ["魯莽衝動", "聽不進去建言", "非常有魄力與行動力", "意志力堅強"],
      "female": ["魯莽衝動", "聽不進去建言", "非常有魄力與行動力", "意志力堅強"],
    },
    "財": {
      "male": ["誠實", "摳,小氣", "注重穩定性"],
      "female": ["誠實", "摳,小氣", "摳,小氣"],
    },
    "才": {
      "male": ["多情,花心", "豪爽,不在乎細節,只在乎最重要的環節"],
      "female": ["多情,花心", "豪爽,不在乎細節,只在乎最重要的環節"],
    },
    "梟": {
      "male": ["經常憂鬱", "杞人憂天", "敏感,容易不開心", "經常疑神疑鬼"],
      "female": ["經常憂鬱", "杞人憂天", "敏感,容易不開心", "經常疑神疑鬼"],
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

// 算有多少五行

Map<String, int> countElementOccurrences(
  String word1,
  String word2,
  String word3,
  String word4,
  String word5, {
  String? optional1,
  String? optional2,
  String? optional3,
  String? optional4,
  String? optional5,
}) {
  // Initialize the counts for each element type
  Map<ElementType, int> elementCounts = {
    ElementType.Wood: 0,
    ElementType.Fire: 0,
    ElementType.Earth: 0,
    ElementType.Metal: 0,
    ElementType.Water: 0,
  };

  // Combine required and optional inputs into a single list
  List<String?> allWords = [
    word1,
    word2,
    word3,
    word4,
    word5,
    optional1,
    optional2,
    optional3,
    optional4,
    optional5,
  ];

  // Count occurrences of each element
  for (var word in allWords) {
    if (word != null && elementMapping.containsKey(word)) {
      ElementType element = elementMapping[word]!;
      elementCounts[element] = elementCounts[element]! + 1;
    }
  }

  // Map enum values to their Chinese names
  final Map<ElementType, String> chineseNames = {
    ElementType.Wood: "木",
    ElementType.Fire: "火",
    ElementType.Earth: "土",
    ElementType.Metal: "金",
    ElementType.Water: "水",
  };

  // Convert element counts to a map with Chinese names as keys
  Map<String, int> result = {};
  elementCounts.forEach((element, count) {
    if (count > 0) {
      result[chineseNames[element]!] = count;
    }
  });

  return result;
}

// 查月干與月支是否同一氣
List<String> personalityWrapper({
  required List<String> zhiList2,
  required String sex,
  required bool
      sameInput, // Indicates if monthTop and monthBot have the same input
}) {
  if (sameInput) {
    // Use only `personalityMonthBot` if inputs are the same
    return personalityMonthBot(zhiList2: zhiList2, sex: sex);
  } else {
    // Combine results from `personalityMonthTop` and `personalityMonthBot`
    List<String> topTraits = personalityMonthTop(zhiList2: zhiList2, sex: sex);
    List<String> botTraits = personalityMonthBot(zhiList2: zhiList2, sex: sex);
    return [...topTraits, ...botTraits];
  }
}

//性格外表 單論月住 與日住
List<String> personalityMonthTop({
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
      "male": ["喜歡冒險", "意志力堅強", "容易受到朋友影響", "會自我反省"],
      "female": ["喜歡冒險", "意志力堅強", "受到朋友影響較大", "會自我反省"],
    },
    "劫": {
      "male": [
        "朋友多",
        "個性強",
        "很會編故事",
        "反應很快",
        "很容易混進去新的圈子,擅長處理人際關西",
        "情商高",
        "外表客氣與圓可是內心想其他的",
        "喜歡挑戰自己",
        "雙重個性"
      ],
      "female": [
        "朋友多",
        "個性強",
        "很會編故事",
        "反應很快",
        "很容易混進去新的圈子,擅長處理人際關西",
        "情商高",
        "外表客氣與圓可是內心想其他的",
        "喜歡挑戰自己",
        "雙重個性"
      ],
    },
    "印": {
      "male": ["缺乏行動力", "學習能力強但執行力弱", "可能有胃部健康問題"],
      "female": ["注重學習", "過於依賴他人", "容易忽略實踐"],
    },
    "傷": {
      "male": ["經常吵架", "經常不滿現況", "性子急", "不容易服人,除非對方能力比妳強", "上進心強", "講話一針見血"],
      "female": ["經常不服氣", "經常不滿現況", "性子急", "不容易服人,除非對方能力比妳強", "上進心強", "講話一針見血"],
    },
    "食": {
      "male": ["愛吃", "愛玩", "能說會道"],
      "female": ["貪玩", "有點胖", "能說會道"],
    },
    "官": {
      "male": ["具備領導力", "控制欲強", "講話前思考很久"],
      "female": ["追求者多", "吸引別人注意", "控制欲強"],
    },
    "梟": {
      "male": ["心思細膩城府夠深", "善於分析", "記憶好理解力強", "喜歡創意與研究"],
      "female": ["心思細膩城府夠深", "善於分析", "記憶好理解力強", "喜歡創意與研究"],
    },
    "才": {
      "male": ["豪爽", "大俠的性格", "多情"],
      "female": ["豪爽", "大俠的性格", "多情"],
    },
  };

  // Initialize a list to store the results
  List<String> traits = [];

  // Determine the gender key for the mapping
  String genderKey = sex.toLowerCase();

  // Iterate through each word in zhiList2
  for (String word in zhiList2) {
    // Check if the word exists in the mapping
    if (messageMapping.containsKey(word) &&
        messageMapping[word]!.containsKey(genderKey)) {
      // Add the traits for this word to the result list
      traits.addAll(messageMapping[word]![genderKey]!);
    }
  }

  return traits;
}

//性格 單論月住 與日住
List<String> personalityMonthBot({
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
      "male": ["喜歡冒險", "意志力堅強", "受到朋友影響較大", "會自我反省"],
      "female": ["喜歡冒險", "意志力堅強", "受到朋友影響較大", "會自我反省"],
    },
    "劫": {
      "male": [
        "朋友多",
        "個性強",
        "很會編故事",
        "反應很快",
        "很容易混進去新的圈子,擅長處理人際關西",
        "情商高",
        "喜歡挑戰自己",
        "雙重個性"
      ],
      "female": [
        "朋友多",
        "個性強",
        "很會編故事",
        "反應很快",
        "很容易混進去新的圈子,擅長處理人際關西",
        "情商高",
        "喜歡挑戰自己",
        "雙重個性"
      ],
    },
    "印": {
      "male": ["缺乏行動力", "學習能力強但執行力弱", "可能有胃部健康問題"],
      "female": ["注重學習", "過於依賴他人", "容易忽略實踐"],
    },
    "傷": {
      "male": ["經常吵架", "經常不滿現況", "性子急", "不容易服人,除非對方能力比妳強", "上進心強"],
      "female": ["經常不服氣", "經常不滿現況", "性子急", "不容易服人,除非對方能力比妳強", "上進心強"],
    },
    "食": {
      "male": ["愛吃", "愛玩", "能說會道"],
      "female": ["貪玩", "有點胖", "能說會道"],
    },
    "官": {
      "male": ["具備領導力", "控制欲強", "講話前思考很久"],
      "female": ["追求者多", "吸引別人注意", "控制欲強"],
    },
    "梟": {
      "male": ["心思細膩城府夠深", "善於分析", "記憶好理解力強", "喜歡創意與研究"],
      "female": ["心思細膩城府夠深", "善於分析", "記憶好理解力強", "喜歡創意與研究"],
    },
    "才": {
      "male": ["豪爽", "大俠的性格", "大方", "多情", "比較不在乎當下利益,眼光比較遠"],
      "female": ["豪爽", "女俠性格", "大方", "多情", "比較不在乎當下利益,眼光比較遠"],
    },
  };

  // Initialize a list to store the results
  List<String> traits = [];

  // Determine the gender key for the mapping
  String genderKey = sex.toLowerCase();

  // Iterate through each word in zhiList2
  for (String word in zhiList2) {
    // Check if the word exists in the mapping
    if (messageMapping.containsKey(word) &&
        messageMapping[word]!.containsKey(genderKey)) {
      // Add the traits for this word to the result list
      traits.addAll(messageMapping[word]![genderKey]!);
    }
  }

  return traits;
}

//性格外表 單論月住 與日住
List<String> temper({
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
      "male": ["喜歡冒險", "意志力堅強", "容易受到朋友影響", "自我中心"],
      "female": ["喜歡冒險", "意志力堅強", "受到朋友影響較大", "自我中心"],
    },
    "劫": {
      "male": ["朋友多", "個性強", "很會編故事", "反應很快", "很容易混進去新的圈子,擅長處理人際關西", "情商高"],
      "female": ["朋友多", "個性強", "很會編故事", "反應很快", "很容易混進去新的圈子,擅長處理人際關西", "情商高"],
    },
    "印": {
      "male": ["缺乏行動力", "學習能力強但執行力弱", "可能有胃部健康問題"],
      "female": ["注重學習", "過於依賴他人", "容易忽略實踐"],
    },
    "傷": {
      "male": ["急" "上進心強"],
      "female": ["急" "上進心強"],
    },
    "食": {
      "male": ["愛吃", "愛玩", "能說會道"],
      "female": ["貪玩", "有點胖", "能說會道"],
    },
    "官": {
      "male": ["具備領導力", "控制欲強", "講話前思考很久"],
      "female": ["追求者多", "吸引別人注意", "控制欲強"],
    },
    "梟": {
      "male": ["心思細膩城府夠深", "善於分析", "記憶好理解力強", "喜歡創意與研究"],
      "female": ["心思細膩城府夠深", "善於分析", "記憶好理解力強", "喜歡創意與研究"],
    },
    "才": {
      "male": ["豪爽", "不拘小節"],
      "female": ["豪爽", "不拘小節"],
    },
  };

  // Initialize a list to store the results
  List<String> traits = [];

  // Determine the gender key for the mapping
  String genderKey = sex.toLowerCase();

  // Iterate through each word in zhiList2
  for (String word in zhiList2) {
    // Check if the word exists in the mapping
    if (messageMapping.containsKey(word) &&
        messageMapping[word]!.containsKey(genderKey)) {
      // Add the traits for this word to the result list
      traits.addAll(messageMapping[word]![genderKey]!);
    }
  }

  return traits;
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
      "Male": ["當時家裡屏寒", "叛逆", "比較不服氣"],
      "Female": [
        "失敗的感情",
        "叛逆",
      ]
    },
    "財": {
      "Male": [""],
      "Female": [""]
    },
    "梟": {
      "Male": [""],
      "Female": [""]
    },
    "劫": {
      "Male": ["早年家庭平困", "賭性特高,也不好賺錢", "錢被借了 拿不回來", "喜歡的人被搶走", "花錢在面子上"],
      "Female": ["早年家庭平困", "賭性特高,也不好賺錢", "錢被借了 拿不回來", "花錢在面子上"]
    },
    "才": {
      "Male": ["交的朋友什麼類型都有"],
      "Female": ["交的朋友什麼類型都有"]
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

// 缺乏五行 沒有確認時間不用
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
    return "做事時不喜歡被別人看到,習慣默默做事.";
  }
  if (missingElements.contains(ElementType.Earth)) {
    return "Earth element is missing - Customize this message!";
  }
  if (missingElements.contains(ElementType.Metal)) {
    return "感覺很容易累,有時感覺呼吸困難";
  }
  if (missingElements.contains(ElementType.Water)) {
    return "Water element is missing - Customize this message!";
  }

  return "No elements are missing - Customize this message!";
}

// 缺少十神 2段式 沒有確認時間不用
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

  // Check for combinations of two missing characters first
  if (missingCharacters.contains("殺") && missingCharacters.contains("印")) {
    messages.add("缺少 '殺' 和 '印'，意味著既不夠狠，也不記得重要事情");
  } else if (missingCharacters.contains("食") &&
      missingCharacters.contains("印")) {
    messages.add("缺少 '食' 和 '印'，暗示你不善表達，也記性不佳");
  } else if (missingCharacters.contains("比") &&
      missingCharacters.contains("官")) {
    messages.add("沒比沒官");
  } else if (missingCharacters.contains("劫") &&
      missingCharacters.contains("比")) {
    messages.add("做事靠自己 不喜歡靠別人");
  }

  // If no combination was added, check for individual missing characters
  if (messages.isEmpty) {
    // No parentheses needed here
    for (String missing in missingCharacters) {
      switch (missing) {
        case "殺":
          if (messageIndex == 1) {
            messages.add("人不夠狠");
          } else if (messageIndex == 2) {
            messages.add("比較容易原諒別人");
          } else if (messageIndex == 3) {
            messages.add("不記仇");
          }
          break;
        case "印":
          if (messageIndex == 1) {
            messages.add("不喜歡.");
          } else if (messageIndex == 2) {
            messages.add("記性不好");
          }
          break;
        case "梟":
          if (messageIndex == 1) {
            messages.add("不注重細節,出心大意");
          } else if (messageIndex == 2) {
            messages.add("開心派");
          } else if (messageIndex == 2) {
            messages.add("比較容易相信別人");
          }
          break;
        case "食":
          if (messageIndex == 1) {
            messages.add("吃不胖");
          } else if (messageIndex == 2) {
            messages.add("很難放鬆");
          }
          break;
        case "傷":
          if (messageIndex == 1) {
            messages.add("有時感覺自己不上進");
          } else if (messageIndex == 2) {
            messages.add("經常無所謂的感覺");
          }
          break;

        case "官":
          if (messageIndex == 1) {
            messages.add("管不好自己");
          } else if (messageIndex == 2) {
            messages.add("不喜歡被控制");
          }
          break;
        case "比":
          if (messageIndex == 1) {
            messages.add("毅力不高");
          } else if (messageIndex == 2) {
            messages.add("不喜社交");
          }
          break;

        case "劫":
          if (messageIndex == 1) {
            messages.add("不會利用別人,不適合管理別人");
          } else if (messageIndex == 2) {
            messages.add("");
          }
          break;
        case "財":
          if (messageIndex == 1) {
            messages.add("跟爸爸關西不好");
          } else if (messageIndex == 2) {
            messages.add("不太在意穩定收入");
          }
          break;
        default:
          messages.add("性格全面");
      }
    }
  }

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
