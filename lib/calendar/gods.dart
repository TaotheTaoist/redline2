// ignore_for_file: non_constant_identifier_names

class gods {
  static List<String> runAllgodsTime(
      String yearBot,
      String daybot,
      String subject,
      String timebot,
      String timetop,
      String yeartop,
      String monthbot,
      bool sex) {
    String guasuc = "";
    String sixbads = "";
    String thiefc = "";
    String whitetiger = "";
    String attractivec = "";
    String deathgod = "";
    String fiveghost = "";
    String hongreng = "";
    String broken = "";
    String saddoor = "";
    String hangguest = "";
    String tianshic = "";
    String hongyangc = "";
    String generalc = "";
    String unstable = "";
    String heavenbless = "";
    String tianyiYear = "";
    String tianyi = "??";
    String tiander = "";
    String moonder = "";
    String happygod = "";
    String guoYinYearc = "";
    String guoyinday = "";
    String learnerc = "";
    String horseYearc = "";
    String horsec = "";
    String taiChiyear = "";
    String taiChi = "";
    String huagaic = "";
    String huagaiYearc = "";
    String thiefdayc = "";
    String bloodsword = "";
    String sheepsword = "";
    String guchenc = "";
    String heavencash = "";
    String flySword = "";
    String doc = "";
    String jinyuc = "";
    String againstoneself = "";
    String pearlc = "";
    String pearlyear = "";
    String happygodyear = "";
    String lusenc = "";

    // Calculations
    happygodyear = happyGod(yeartop, timebot);
    hangguest = hangGuest(yearBot, timebot);
    guchenc = guchen(yearBot, timebot);
    guasuc = guasu(yearBot, timebot);
    huagaiYearc = huagai(yearBot, timebot);
    taiChiyear = taichi(yeartop, timebot);
    horseYearc = horse(yearBot, timebot);
    guoYinYearc = guoYin(yeartop, timebot);
    tianyiYear = tianYi(yeartop, timebot);
    pearlyear = pearl(yeartop, timebot);
    sixbads = sixBads(daybot, timebot);
    thiefc = thief(yearBot, timebot);
    whitetiger = whiteTiger(yearBot, timebot);
    attractivec = attractive(yearBot, timebot);
    deathgod = deathGod(yearBot, timebot);
    hongreng = hongren(yearBot, timebot);
    saddoor = sadDoor(yearBot, timebot);
    tianshic = tianshi(yearBot, timebot);
    hongyangc = hongyang(subject, timebot);
    generalc = general(yearBot, timebot);
    unstable = unStable(yearBot, sex, timebot);
    heavenbless = heavenBless(yeartop, timebot);
    doc = doctor(subject, timebot);
    flySword = flyingSword(subject, timebot);
    heavencash = heavenCash(subject, timetop);
    sheepsword = sheepSword(subject, timebot);
    bloodsword = bloodSword(subject, timebot);
    thiefdayc = thief(daybot, timebot);
    huagaic = huagai(daybot, timebot);
    taiChi = taichi(subject, timebot);
    lusenc = lusen(subject, timebot);
    againstoneself = againstOneself(daybot, timebot);
    horsec = horse(daybot, timebot);
    jinyuc = jinyu(subject, timebot);
    happygod = happyGod(subject, timebot);
    guoyinday = guoYin(subject, timebot);
    learnerc = learner(subject, timebot);
    tianyi = tianYi(subject, timebot);
    pearlc = pearl(subject, timebot);
    broken = broKen2(monthbot, timebot, sex);
    moonder = moonDer(monthbot, timetop);
    tiander = tianDer(monthbot, timetop);
    fiveghost = fiveGhost(monthbot, timebot);
    heavenbless = heavenBless(yeartop, timebot);

    List<String> allgods = [
      tianyi,
      heavenbless,
      happygod,
      moonder,
      tiander,
      unstable,
      generalc,
      hongyangc,
      tianshic,
      saddoor,
      broken,
      hongreng,
      fiveghost,
      deathgod,
      attractivec,
      whitetiger,
      thiefc,
      sixbads,
      guoyinday,
      guoYinYearc,
      tianyiYear,
      learnerc,
      horsec,
      horseYearc,
      taiChi,
      taiChiyear,
      huagaiYearc,
      thiefdayc,
      bloodsword,
      sheepsword,
      guasuc,
      guchenc,
      heavencash,
      flySword,
      doc,
      hangguest,
      huagaic,
      jinyuc,
      againstoneself,
      pearlc,
      pearlyear,
      happygodyear,
      lusenc
    ];

    List<String> allgodset = [];
    Set<String> seenGods = {};

    for (var god in allgods) {
      if (god.isNotEmpty && !seenGods.contains(god)) {
        seenGods.add(god);
        allgodset.add(god);
      }
    }

    return allgodset;
  }

  static List<String> runAllgodsDay(
    String yearBot,
    String daybot,
    String subject,
    String yeartop,
    String monthbot,
    bool sex,
  ) {
    String thiefc = "";
    String whitetigerc = "";
    String attractivec = "";
    String deathgodc = "";
    String fiveghostc = "";
    String hongrengc = "";
    String brokenc = "";
    String saddoorc = "";
    String hangguestc = "";
    String tianShic = "";
    String hongYangc = "";
    String generalc = "";
    String unstablec = "";

    String tianyiYearc = "";
    String tianyic = "??";
    String heavenblessc = "";
    String tianderc = "";
    String moonderc = "";
    String happygodc = "";

    String suicidalc = "";
    String suicidalcc = "";
    String guoYinYearc = "";
    String guoyindayc = "";
    String learnerc = "";
    String horseYearc = "";
    String horsec = "";
    String taiChiyearc = "";
    String taiChic = "";

    String huagaiYearc = "";
    String allwrongc = "";
    String bloodswordc = "";
    String sheepswordc = "";
    String forgivenEssc = "";
    String guasuc = "";
    String guchenc = "";
    String flySwordc = "";
    String docc = "";
    String smartestc = "";
    String tenshitsc = "";
    String showerc = "";
    String lusenc = "";
    String jinyuc = "";
    String showOffc = "";
    String highmoralc = "";
    String classicc = "";
    String progc = "";
    String backWardc = "";
    String lonerc = "";
    String pearlc = "";
    String pearlyearc = "";
    String happygodyearc = "";
    String ironmanc = "";

    // Calculations (replace with your actual calculation functions)
    hangguestc = hangGuest(yearBot, daybot);
    guchenc = guchen(yearBot, daybot);
    guasuc = guasu(yearBot, daybot);
    huagaiYearc = huagai(yearBot, daybot);
    taiChiyearc = taichi(yeartop, daybot);
    happygodyearc = happyGod(yeartop, daybot);
    horseYearc = horse(yearBot, daybot);
    guoYinYearc = guoYin(yeartop, daybot);
    thiefc = thief(yearBot, daybot);
    whitetigerc = whiteTiger(yearBot, daybot);
    tianyiYearc = tianYi(yeartop, daybot);
    pearlyearc = pearl(yeartop, daybot);
    attractivec = attractive(yearBot, daybot);
    deathgodc = deathGod(daybot, daybot);
    hongrengc = hongren(yearBot, daybot);
    saddoorc = sadDoor(yearBot, daybot);
    tianShic = tianshi(yearBot, daybot);
    generalc = general(yearBot, daybot);
    unstablec = unStable(yearBot, sex, daybot);
    heavenblessc = heavenBless(yeartop, daybot);
    ironmanc = ironMan(subject, daybot);
    lonerc = loner(subject, daybot);
    backWardc = backward(subject, daybot);
    progc = progress(subject, daybot);
    classicc = classic(subject, daybot);
    highmoralc = highMoral(subject, daybot);
    showOffc = sixShow(subject, daybot);
    lusenc = lusen(subject, daybot);
    smartestc = smartest(subject, daybot);
    tenshitsc = tenShits(subject, daybot);
    docc = doctor(subject, daybot);
    flySwordc = flyingSword(subject, daybot);
    sheepswordc = sheepSword(subject, daybot);
    bloodswordc = bloodSword(subject, daybot);
    forgivenEssc = forgiveness(subject, daybot);
    allwrongc = allWrong(subject, daybot);

    guoyindayc = guoYin(subject, daybot);
    tianyic = tianYi(subject, daybot);
    pearlc = pearl(subject, daybot);
    hongYangc = hongyang(subject, daybot);
    showerc = shower(subject, daybot);
    horsec = horse(daybot, daybot);
    learnerc = learner(subject, daybot);
    happygodc = happyGod(subject, daybot);
    brokenc = broKen2(monthbot, daybot, sex);
    jinyuc = jinyu(subject, daybot);
    taiChic = taichi(subject, daybot);
    moonderc = moonDer(monthbot, subject);
    tianderc = tianDer(monthbot, subject);
    fiveghostc = fiveGhost(monthbot, daybot);
    suicidalc = suicidal(daybot, monthbot);
    suicidalcc = suicidal(daybot, yearBot);

    List<String> allgods = [
      tianyic,
      heavenblessc,
      tianderc,
      moonderc,
      happygodc,
      unstablec,
      generalc,
      hongYangc,
      tianShic,
      saddoorc,
      brokenc,
      hongrengc,
      fiveghostc,
      deathgodc,
      attractivec,
      whitetigerc,
      thiefc,
      tianyiYearc,
      guoyindayc,
      guoYinYearc,
      learnerc,
      horsec,
      horseYearc,
      taiChic,
      taiChiyearc,
      huagaiYearc,
      allwrongc,
      sheepswordc,
      bloodswordc,
      forgivenEssc,
      guasuc,
      guchenc,
      flySwordc,
      docc,
      hangguestc,
      guoyindayc,
      smartestc,
      tenshitsc,
      showerc,
      lusenc,
      jinyuc,
      showOffc,
      highmoralc,
      classicc,
      progc,
      backWardc,
      lonerc,
      pearlc,
      pearlyearc,
      happygodyearc,
      ironmanc,
      suicidalcc,
      suicidalc
    ];

    List<String> allgodset = [];
    Set<String> seenGods = {};

    for (var god in allgods) {
      if (god.isNotEmpty && !seenGods.contains(god)) {
        seenGods.add(god);
        allgodset.add(god);
      }
    }

    return allgodset;
  }

  static List<String> runAllgodsMonth(
    String monthbot,
    String daybot,
    String subject,
    String yearBot,
    String yeartop,
    String monthtop,
    bool sex,
  ) {
    String thiefc = "";
    String whitetigerc = "";
    String attractivec = "";
    String deathgodc = "";
    String hongrengc = "";
    String saddoorc = "";
    String hangguestc = "";
    String tianShic = "";
    String hongYangc = "";
    String generalc = "";
    String unstablec = "";
    String tianyic = "??";
    String tianyiYearc = "";
    String flySwordc = "";
    String happygodc = "";
    String heavenblessc = "";
    String sixbadsc = "";
    String guoYinYearc = "";
    String guoyindayc = "";
    String learnerc = "";
    String horseYearc = "";
    String horsec = "";
    String taiChiyearc = "";
    String taiChic = "";
    String huagaic = "";
    String huagaiYearc = "";
    String thiefdayc = "";
    String bloodswordc = "";
    String sheepswordc = "";
    String guasuc = "";
    String guchenc = "";
    String heavenCashc = "";
    String docc = "";
    String jinyuc = "";
    String againstOneselfc = "";
    String pearlc = "";
    String pearlyearc = "";
    String happygodyearc = "";
    String lusenc = "";

    // Calculations (replace with your actual calculation functions)
    sixbadsc = sixBads(yearBot, monthbot);
    hangguestc = hangGuest(yearBot, monthbot);
    guchenc = guchen(yearBot, monthbot);
    guasuc = guasu(yearBot, monthbot);
    huagaiYearc = huagai(yearBot, monthbot);
    taiChiyearc = taichi(yeartop, monthbot);
    happygodyearc = happyGod(yeartop, monthbot);
    horseYearc = horse(yearBot, monthbot);
    guoYinYearc = guoYin(yeartop, monthbot);
    tianyiYearc = tianYi(yeartop, monthbot);
    thiefc = thief(yearBot, monthbot);
    whitetigerc = whiteTiger(yearBot, monthbot);
    tianyiYearc = tianYi(yeartop, monthbot);
    pearlyearc = pearl(yeartop, monthbot);
    attractivec = attractive(yearBot, monthbot);
    deathgodc = deathGod(yearBot, monthbot);
    hongrengc = hongren(yearBot, monthbot);
    saddoorc = sadDoor(yearBot, monthbot);
    tianShic = tianshi(yearBot, monthbot);
    generalc = general(yearBot, monthbot);
    unstablec = unStable(yearBot, sex, monthbot);
    heavenblessc = heavenBless(yeartop, monthbot);
    happygodc = happyGod(monthtop, yearBot);
    jinyuc = jinyu(subject, monthbot);
    docc = doctor(subject, monthbot);
    flySwordc = flyingSword(subject, monthbot);
    heavenCashc = heavenCash(subject, monthtop);
    sheepswordc = sheepSword(subject, monthbot);
    bloodswordc = bloodSword(subject, monthbot);
    thiefdayc = thief(daybot, monthbot);
    huagaic = huagai(daybot, monthbot);
    taiChic = taichi(subject, monthbot);
    horsec = horse(daybot, monthbot);
    againstOneselfc = againstOneself(daybot, monthbot);
    lusenc = lusen(subject, monthbot);
    learnerc = learner(subject, monthbot);
    guoyindayc = guoYin(subject, monthbot);
    happygodc = happyGod(subject, monthbot);
    tianyic = tianYi(subject, monthbot);
    pearlc = pearl(subject, monthbot);
    hongYangc = hongyang(subject, monthbot);

    List<String> allgods = [
      tianyic,
      heavenblessc,
      happygodc,
      unstablec,
      generalc,
      hongYangc,
      tianShic,
      saddoorc,
      hongrengc,
      attractivec,
      deathgodc,
      whitetigerc,
      thiefc,
      sixbadsc,
      tianyiYearc,
      guoyindayc,
      guoYinYearc,
      learnerc,
      horsec,
      horseYearc,
      taiChic,
      taiChiyearc,
      huagaic,
      huagaiYearc,
      thiefdayc,
      bloodswordc,
      sheepswordc,
      guasuc,
      guchenc,
      heavenCashc,
      flySwordc,
      docc,
      hangguestc,
      jinyuc,
      againstOneselfc,
      pearlc,
      pearlyearc,
      happygodyearc,
      lusenc
    ];

    List<String> allgodset = [];
    Set<String> seenGods = {};

    for (var god in allgods) {
      if (god.isNotEmpty && !seenGods.contains(god)) {
        seenGods.add(god);
        allgodset.add(god);
      }
    }

    return allgodset;
  }

  static List<String> runAllgodsYear(
    String yearBot,
    String monthbot,
    String subject,
    bool sex,
    String yeartop,
    String daybot,
  ) {
    String fiveghostc = "";
    String brokenc = "";
    String hongYangc = "";
    String unstablec = "";
    String generalc = "";
    String tianyic = "??";
    String tianyiYearc = "";
    String tianderc = "";
    String moonderc = "";
    String happygodc = "";
    String heavenblessc = "";
    String guoYinYearc = "";
    String guoyindayc = "";
    String learnerc = "";
    String horseYearc = "";
    String horsec = "";
    String taiChiyearc = "";
    String taiChic = "";
    String huagaic = "";

    String thiefdayc = "";
    String bloodswordc = "";
    String sheepswordc = "";
    String heavenCashc = "";
    String flySwordc = "";
    String docc = "";
    String jinyuc = "";
    String againstOneselfc = "";
    String pearlc = "";
    String pearlyearc = "";
    String happygodyearc = "";
    String sixbadsc = "";
    String suicidalcc = "";
    String suicidalc = "";

    // Calculations (replace with your actual calculation functions)
    sixbadsc = sixBads(daybot, yearBot);

    taiChiyearc = taichi(yeartop, yearBot);
    happygodyearc = happyGod(yeartop, yearBot);
    horseYearc = horse(yearBot, daybot);
    guoYinYearc = guoYin(yeartop, yearBot);
    tianyiYearc = tianYi(yeartop, yearBot);
    pearlyearc = pearl(yeartop, yearBot);
    unstablec = unStable(yearBot, sex, yearBot);
    heavenblessc = heavenBless(yeartop, yearBot);
    jinyuc = jinyu(subject, yearBot);
    brokenc = broKen2(monthbot, yearBot, sex);
    moonderc = moonDer(monthbot, yeartop);
    tianderc = tianDer(monthbot, yeartop);
    fiveghostc = fiveGhost(monthbot, yearBot);
    docc = doctor(subject, yearBot);
    flySwordc = flyingSword(subject, yearBot);
    heavenCashc = heavenCash(subject, yeartop);
    sheepswordc = sheepSword(subject, yearBot);
    bloodswordc = bloodSword(subject, yearBot);
    thiefdayc = thief(daybot, yearBot);
    huagaic = huagai(daybot, yearBot);
    taiChic = taichi(subject, yearBot);
    againstOneselfc = againstOneself(daybot, yearBot);
    horsec = horse(daybot, yearBot);
    learnerc = learner(subject, yeartop);
    tianyic = tianYi(subject, yearBot);
    pearlc = pearl(subject, yearBot);
    guoyindayc = guoYin(subject, yearBot);
    generalc = general(yearBot, daybot);
    happygodc = happyGod(subject, yearBot);
    hongYangc = hongyang(subject, yearBot);
    suicidalc = suicidal(yearBot, monthbot);
    suicidalcc = suicidal(yearBot, daybot);

    List<String> allgods = [
      tianyic,
      tianderc,
      moonderc,
      happygodc,
      unstablec,
      heavenblessc,
      generalc,
      hongYangc,
      brokenc,
      fiveghostc,
      tianyiYearc,
      guoYinYearc,
      guoyindayc,
      learnerc,
      horsec,
      horseYearc,
      taiChic,
      taiChiyearc,
      huagaic,
      thiefdayc,
      bloodswordc,
      sheepswordc,
      heavenCashc,
      flySwordc,
      docc,
      jinyuc,
      againstOneselfc,
      pearlc,
      pearlyearc,
      happygodyearc,
      sixbadsc,
      suicidalc,
      suicidalcc
    ];

    List<String> allgodset = [];
    Set<String> seenGods = {};

    for (var god in allgods) {
      if (god.isNotEmpty && !seenGods.contains(god)) {
        seenGods.add(god);
        allgodset.add(god);
      }
    }

    return allgodset;
  }

  static List<String> runAllgodsDayun({
    required String yearBot,
    required String monthbot,
    required String Subject,
    required bool sex,
    required String yeartop,
    required String daybot,
    required String dayunTop,
    required String Dayunbot,
  }) {
    String Thiefc = '';
    String whitetigerc = '';
    String Attractivec = '';
    String Deathgodc = '';
    String fiveghostc = '';
    String brokenc = '';
    String hongYangc = '';
    String unstablec = '';
    String Generalc = '';
    String saddoorc = '';
    String hangguestc = '';
    String tianShic = '';
    String tianyic = '??';
    String tianyiYearc = '';
    String tianderc = '';
    String moonderc = '';
    String happygodc = '';
    String heavenblessc = '';
    String guoYinYearc = '';
    String guoyindayc = '';
    String Learnerc = '';
    String generalYearc = '';
    String hongrengc = '';
    String horseYearc = '';
    String Horsec = '';
    String taiChiyearc = '';
    String taiChic = '';
    String Huagaic = '';
    String huagaiYearc = '';
    String thiefdayc = '';
    String bloodswordc = '';
    String sheepswordc = '';
    String Guasuc = '';
    String Guchenc = '';
    String Heavencashc = '';
    String flySwordc = '';
    String docc = '';
    String Lusenc = '';
    String Jinyuc = '';
    String againstoneselfc = '';
    String Pearlc = '';
    String pearlyearc = '';
    String happygodyearc = '';
    String sixbadsc = '';

    sixbadsc = sixBads(daybot, Dayunbot);
    Guchenc = guchen(yearBot, Dayunbot);
    Guasuc = guasu(yearBot, Dayunbot);
    huagaiYearc = huagai(yearBot, Dayunbot);
    taiChiyearc = taichi(yeartop, Dayunbot);
    happygodyearc = happyGod(yeartop, Dayunbot);
    horseYearc = horse(yearBot, Dayunbot);
    generalYearc = general(yearBot, Dayunbot);
    guoYinYearc = guoYin(yeartop, Dayunbot);
    tianyiYearc = tianYi(yeartop, Dayunbot);
    pearlyearc = pearl(yeartop, Dayunbot);
    Deathgodc = deathGod(yearBot, Dayunbot);
    Thiefc = thief(yearBot, Dayunbot);
    whitetigerc = whiteTiger(yearBot, Dayunbot);
    Attractivec = attractive(yearBot, Dayunbot);
    unstablec = unStable(yearBot, sex, Dayunbot);
    heavenblessc = heavenBless(yeartop, Dayunbot);
    saddoorc = sadDoor(yearBot, Dayunbot);
    tianShic = tianshi(yearBot, Dayunbot);
    hongrengc = hongren(yearBot, Dayunbot);
    Lusenc = lusen(Subject, Dayunbot);
    brokenc = broKen2(monthbot, Dayunbot, sex);
    moonderc = moonDer(monthbot, dayunTop);
    tianderc = tianDer(monthbot, dayunTop);
    fiveghostc = fiveGhost(monthbot, Dayunbot);
    Pearlc = pearl(Subject, Dayunbot);
    againstoneselfc = againstOneself(daybot, Dayunbot);
    Jinyuc = jinyu(Subject, Dayunbot);
    hangguestc = hangGuest(yearBot, Dayunbot);
    docc = doctor(Subject, Dayunbot);
    flySwordc = flyingSword(Subject, Dayunbot);
    Heavencashc = heavenCash(Subject, dayunTop);
    sheepswordc = sheepSword(Subject, Dayunbot);
    bloodswordc = bloodSword(Subject, Dayunbot);
    thiefdayc = thief(daybot, Dayunbot);
    Huagaic = huagai(daybot, Dayunbot);
    taiChic = taichi(Subject, Dayunbot);
    Horsec = horse(daybot, Dayunbot);
    Learnerc = learner(Subject, Dayunbot);
    tianyic = tianYi(Subject, Dayunbot);
    guoyindayc = guoYin(Subject, Dayunbot);
    Generalc = general(daybot, Dayunbot);
    happygodc = happyGod(daybot, Dayunbot);
    hongYangc = hongyang(Subject, Dayunbot);

    List<String> allgods = [
      tianyic,
      tianderc,
      moonderc,
      happygodc,
      unstablec,
      heavenblessc,
      Generalc,
      hongYangc,
      brokenc,
      fiveghostc,
      tianyiYearc,
      guoYinYearc,
      guoyindayc,
      Learnerc,
      generalYearc,
      hongrengc,
      tianShic,
      saddoorc,
      Deathgodc,
      Thiefc,
      whitetigerc,
      Attractivec,
      Horsec,
      horseYearc,
      taiChic,
      taiChiyearc,
      Huagaic,
      huagaiYearc,
      thiefdayc,
      bloodswordc,
      sheepswordc,
      Guasuc,
      Guchenc,
      Heavencashc,
      flySwordc,
      docc,
      hangguestc,
      Lusenc,
      Jinyuc,
      againstoneselfc,
      Pearlc,
      pearlyearc,
      happygodyearc,
      sixbadsc
    ];

    Set<String> seenGods = {};
    List<String> allgodset = [];

    for (String god in allgods) {
      if (god.isNotEmpty && !seenGods.contains(god)) {
        seenGods.add(god);
        allgodset.add(god);
      }
    }

    return allgodset;
  }

  static List<String> runAllgodsLiuyear(
    String yearBot,
    String monthbot,
    String subject,
    bool sex,
    String yeartop,
    String daybot,
    String liuyearsTop,
    String liuYears,
  ) {
    String thiefc = "";
    String whitetigerc = "";
    String attractivec = "";
    String deathgodc = "";
    String fiveghostc = "";
    String brokenc = "";
    String hongYangc = "";
    String unstablec = "";
    String generalc = "";
    String saddoorc = "";
    String hangguestc = "";
    String tianshic = "";
    String tianyic = "??";
    String tianyiYearc = "";
    String tianderc = "";
    String moonderc = "";
    String happygodc = "";
    String heavenblessc = "";
    String guoYinYearc = "";
    String guoyindayc = "";
    String learnerc = "";
    String generalYearc = "";
    String hongrengc = "";
    String horseYearc = "";
    String horsec = "";
    String taiChiyearc = "";
    String taiChic = "";
    String huagaic = "";
    String huagaiYearc = "";
    String thiefdayc = "";
    String bloodswordc = "";
    String sheepswordc = "";
    String guasuc = "";
    String guchenc = "";
    String heavencashc = "";
    String flySwordc = "";
    String docc = "";
    String lusenc = "";
    String jinyuc = "";
    String againstoneselfc = "";
    String pearlc = "";
    String pearlyearc = "";
    String happygodyearc = "";
    String sixbadsc = "";

    sixbadsc = sixBads(daybot, liuYears);
    guchenc = guchen(yearBot, liuYears);
    guasuc = guasu(yearBot, liuYears);
    huagaiYearc = huagai(yearBot, liuYears);
    taiChiyearc = taichi(yeartop, liuYears);
    happygodyearc = happyGod(yeartop, liuYears);
    horseYearc = horse(yearBot, liuYears);
    generalYearc = general(yearBot, liuYears);
    guoYinYearc = guoYin(yeartop, liuYears);
    tianyiYearc = tianYi(yeartop, liuYears);
    pearlyearc = pearl(yeartop, liuYears);
    deathgodc = deathGod(yearBot, liuYears);
    thiefc = thief(yearBot, liuYears);
    whitetigerc = whiteTiger(yearBot, liuYears);
    attractivec = attractive(yearBot, liuYears);
    unstablec = unStable(yearBot, sex, liuYears);
    heavenblessc = heavenBless(yeartop, liuYears);
    saddoorc = sadDoor(yearBot, liuYears);
    tianshic = tianshi(yearBot, liuYears);
    hongrengc = hongren(yearBot, liuYears);
    lusenc = lusen(subject, liuYears);
    brokenc = broKen2(monthbot, liuYears, sex);
    moonderc = moonDer(monthbot, liuyearsTop);
    tianderc = tianDer(monthbot, liuyearsTop);
    fiveghostc = fiveGhost(monthbot, liuYears);
    pearlc = pearl(subject, liuYears);
    againstoneselfc = againstOneself(daybot, liuYears);
    jinyuc = jinyu(subject, liuYears);
    hangguestc = hangGuest(yearBot, liuYears);
    docc = doctor(subject, liuYears);
    flySwordc = flyingSword(subject, liuYears);
    heavencashc = heavenCash(subject, liuyearsTop);
    sheepswordc = sheepSword(subject, liuYears);
    bloodswordc = bloodSword(subject, liuYears);
    thiefdayc = thief(daybot, liuYears);
    huagaic = huagai(daybot, liuYears);
    taiChic = taichi(subject, liuYears);
    horsec = horse(daybot, liuYears);
    learnerc = learner(subject, liuYears);
    tianyic = tianYi(subject, liuYears);
    guoyindayc = guoYin(subject, liuYears);
    generalc = general(daybot, liuYears);
    happygodc = happyGod(daybot, liuYears);
    hongYangc = hongyang(subject, liuYears);

    List<String> allgodsc = [
      tianyic,
      tianderc,
      moonderc,
      happygodc,
      unstablec,
      heavenblessc,
      generalc,
      hongYangc,
      brokenc,
      fiveghostc,
      tianyiYearc,
      guoYinYearc,
      guoyindayc,
      learnerc,
      generalYearc,
      hongrengc,
      tianshic,
      saddoorc,
      deathgodc,
      thiefc,
      whitetigerc,
      attractivec,
      horsec,
      horseYearc,
      taiChic,
      taiChiyearc,
      huagaic,
      huagaiYearc,
      thiefdayc,
      bloodswordc,
      sheepswordc,
      guasuc,
      guchenc,
      heavencashc,
      flySwordc,
      docc,
      hangguestc,
      lusenc,
      jinyuc,
      againstoneselfc,
      pearlc,
      pearlyearc,
      happygodyearc,
      sixbadsc
    ];

    Set<String> seenGodsc = {};
    List<String> uniqueGodsc = [];

    for (var godc in allgodsc) {
      if (godc.isNotEmpty && seenGodsc.add(godc)) {
        uniqueGodsc.add(godc);
      }
    }

    return uniqueGodsc;
  }

  static List<String> runAllgodsLiuMonth({
    required String yearBot,
    required String monthbot,
    required String Subject,
    required bool sex,
    required String yeartop,
    required String daybot,
    required String LiumonthsTop,
    required String liumonths,
  }) {
    String Thiefc = '';
    String whitetigerc = '';
    String Attractivec = '';
    String Deathgodc = '';
    String fiveghostc = '';
    String brokenc = '';
    String hongYangc = '';
    String unstablec = '';
    String Generalc = '';
    String saddoorc = '';
    String hangguestc = '';
    String tianShic = '';
    String tianyic = '??';
    String tianyiYearc = '';
    String tianderc = '';
    String moonderc = '';
    String happygodc = '';
    String heavenblessc = '';
    String guoYinYearc = '';
    String guoyindayc = '';
    String Learnerc = '';
    String generalYearc = '';
    String hongrengc = '';
    String horseYearc = '';
    String Horsec = '';
    String taiChiyearc = '';
    String taiChic = '';
    String Huagaic = '';
    String huagaiYearc = '';
    String thiefdayc = '';
    String bloodswordc = '';
    String sheepswordc = '';
    String Guasuc = '';
    String Guchenc = '';
    String Heavencashc = '';
    String flySwordc = '';
    String docc = '';
    String Lusenc = '';
    String Jinyuc = '';
    String againstoneselfc = '';
    String Pearlc = '';
    String pearlyearc = '';
    String happygodyearc = '';
    String sixbadsc = '';

    sixbadsc = sixBads(daybot, liumonths);
    Guchenc = guchen(yearBot, liumonths);
    Guasuc = guasu(yearBot, liumonths);
    huagaiYearc = huagai(yearBot, liumonths);
    taiChiyearc = taichi(yeartop, liumonths);
    happygodyearc = happyGod(yeartop, liumonths);
    horseYearc = horse(yearBot, liumonths);
    generalYearc = general(yearBot, liumonths);
    guoYinYearc = guoYin(yeartop, liumonths);
    tianyiYearc = tianYi(yeartop, liumonths);
    pearlyearc = pearl(yeartop, liumonths);
    Deathgodc = deathGod(yearBot, liumonths);
    Thiefc = thief(yearBot, liumonths);
    whitetigerc = whiteTiger(yearBot, liumonths);
    tianyiYearc = tianYi(yeartop, liumonths);
    Attractivec = attractive(yearBot, liumonths);
    unstablec = unStable(yearBot, sex, liumonths);
    heavenblessc = heavenBless(yeartop, liumonths);
    saddoorc = sadDoor(yearBot, liumonths);
    tianShic = tianshi(yearBot, liumonths);
    hongrengc = hongren(yearBot, liumonths);
    Lusenc = lusen(Subject, liumonths);
    brokenc = broKen2(monthbot, liumonths, sex);
    moonderc = moonDer(monthbot, LiumonthsTop);
    tianderc = tianDer(monthbot, LiumonthsTop);
    fiveghostc = fiveGhost(monthbot, liumonths);
    Pearlc = pearl(Subject, liumonths);
    againstoneselfc = againstOneself(daybot, liumonths);
    Jinyuc = jinyu(Subject, liumonths);
    hangguestc = hangGuest(yearBot, liumonths);
    docc = doctor(Subject, liumonths);
    flySwordc = flyingSword(Subject, liumonths);
    Heavencashc = heavenCash(Subject, LiumonthsTop);
    sheepswordc = sheepSword(Subject, liumonths);
    bloodswordc = bloodSword(Subject, liumonths);
    thiefdayc = thief(daybot, liumonths);
    Huagaic = huagai(daybot, liumonths);
    taiChic = taichi(Subject, liumonths);
    Horsec = horse(daybot, liumonths);
    Learnerc = learner(Subject, liumonths);
    tianyic = tianYi(Subject, liumonths);
    guoyindayc = guoYin(Subject, liumonths);
    Generalc = general(daybot, liumonths);
    happygodc = happyGod(daybot, liumonths);
    hongYangc = hongyang(Subject, liumonths);

    List<String> allgods = [
      tianyic,
      tianderc,
      moonderc,
      happygodc,
      unstablec,
      heavenblessc,
      Generalc,
      hongYangc,
      brokenc,
      fiveghostc,
      tianyiYearc,
      guoYinYearc,
      guoyindayc,
      Learnerc,
      generalYearc,
      hongrengc,
      tianShic,
      saddoorc,
      Deathgodc,
      Thiefc,
      whitetigerc,
      Attractivec,
      Horsec,
      horseYearc,
      taiChic,
      taiChiyearc,
      Huagaic,
      huagaiYearc,
      thiefdayc,
      bloodswordc,
      sheepswordc,
      Guasuc,
      Guchenc,
      Heavencashc,
      flySwordc,
      docc,
      hangguestc,
      Lusenc,
      Jinyuc,
      againstoneselfc,
      Pearlc,
      pearlyearc,
      happygodyearc,
      sixbadsc,
    ];

    List<String> allgodset = [];
    Set<String> seenGods = {};

    for (String god in allgods) {
      if (god.isNotEmpty && !seenGods.contains(god)) {
        seenGods.add(god);
        allgodset.add(god);
      }
    }

    return allgodset;
  }

  static List<String> runAllgodspickDate({
    required String yearBot,
    required String monthbot,
    required String Subject,
    required bool sex,
    required String yeartop,
    required String daybot,
    required String pickerDatetop,
    required String pickerDatebot,
  }) {
    String Thiefc = '';
    String whitetigerc = '';
    String Attractivec = '';
    String Deathgodc = '';
    String fiveghostc = '';
    String brokenc = '';
    String hongYangc = '';
    String unstablec = '';
    String Generalc = '';
    String saddoorc = '';
    String hangguestc = '';
    String tianShic = '';
    String tianyic = '??';
    String tianyiYearc = '';
    String tianderc = '';
    String moonderc = '';
    String happygodc = '';
    String heavenblessc = '';
    String guoYinYearc = '';
    String guoyindayc = '';
    String Learnerc = '';
    String generalYearc = '';
    String hongrengc = '';
    String horseYearc = '';
    String Horsec = '';
    String taiChiyearc = '';
    String taiChic = '';
    String Huagaic = '';
    String huagaiYearc = '';
    String thiefdayc = '';
    String bloodswordc = '';
    String sheepswordc = '';
    String Guasuc = '';
    String Guchenc = '';
    String Heavencashc = '';
    String flySwordc = '';
    String docc = '';
    String Lusenc = '';
    String Jinyuc = '';
    String againstoneselfc = '';
    String Pearlc = '';
    String pearlyearc = '';
    String happygodyearc = '';
    String sixbadsc = '';

    sixbadsc = sixBads(pickerDatebot, pickerDatebot);
    Guchenc = guchen(yearBot, pickerDatebot);
    Guasuc = guasu(yearBot, pickerDatebot);
    huagaiYearc = huagai(yearBot, pickerDatebot);
    taiChiyearc = taichi(yeartop, pickerDatebot);
    happygodyearc = happyGod(yeartop, pickerDatebot);
    horseYearc = horse(yearBot, pickerDatebot);
    generalYearc = general(yearBot, pickerDatebot);
    guoYinYearc = guoYin(yeartop, pickerDatebot);
    tianyiYearc = tianYi(yeartop, pickerDatebot);
    pearlyearc = pearl(yeartop, pickerDatebot);
    Deathgodc = deathGod(yearBot, pickerDatebot);
    Thiefc = thief(yearBot, pickerDatebot);
    whitetigerc = whiteTiger(yearBot, pickerDatebot);
    tianyiYearc = tianYi(yeartop, pickerDatebot);
    Attractivec = attractive(yearBot, pickerDatebot);
    unstablec = unStable(yearBot, sex, pickerDatebot);
    heavenblessc = heavenBless(yeartop, pickerDatebot);
    saddoorc = sadDoor(yearBot, pickerDatebot);
    tianShic = tianshi(yearBot, pickerDatebot);
    hongrengc = hongren(yearBot, pickerDatebot);
    Lusenc = lusen(Subject, pickerDatebot);
    brokenc = broKen2(monthbot, pickerDatebot, sex);
    moonderc = moonDer(monthbot, pickerDatetop);
    tianderc = tianDer(monthbot, pickerDatetop);
    fiveghostc = fiveGhost(monthbot, pickerDatebot);
    Pearlc = pearl(Subject, pickerDatebot);
    againstoneselfc = againstOneself(daybot, pickerDatebot);
    Jinyuc = jinyu(Subject, pickerDatebot);
    hangguestc = hangGuest(yearBot, pickerDatebot);
    docc = doctor(Subject, pickerDatebot);
    flySwordc = flyingSword(Subject, pickerDatebot);
    Heavencashc = heavenCash(Subject, pickerDatetop);
    sheepswordc = sheepSword(Subject, pickerDatebot);
    bloodswordc = bloodSword(Subject, pickerDatebot);
    thiefdayc = thief(daybot, pickerDatebot);
    Huagaic = huagai(daybot, pickerDatebot);
    taiChic = taichi(Subject, pickerDatebot);
    Horsec = horse(daybot, pickerDatebot);
    Learnerc = learner(Subject, pickerDatebot);
    tianyic = tianYi(Subject, pickerDatebot);
    guoyindayc = guoYin(Subject, pickerDatebot);
    Generalc = general(daybot, pickerDatebot);
    happygodc = happyGod(daybot, pickerDatebot);
    hongYangc = hongyang(Subject, pickerDatebot);

    List<String> allgods = [
      tianyic,
      tianderc,
      moonderc,
      happygodc,
      unstablec,
      heavenblessc,
      Generalc,
      hongYangc,
      brokenc,
      fiveghostc,
      tianyiYearc,
      guoYinYearc,
      guoyindayc,
      Learnerc,
      generalYearc,
      hongrengc,
      tianShic,
      saddoorc,
      Deathgodc,
      Thiefc,
      whitetigerc,
      Attractivec,
      Horsec,
      horseYearc,
      taiChic,
      taiChiyearc,
      Huagaic,
      huagaiYearc,
      thiefdayc,
      bloodswordc,
      sheepswordc,
      Guasuc,
      Guchenc,
      Heavencashc,
      flySwordc,
      docc,
      hangguestc,
      Lusenc,
      Jinyuc,
      againstoneselfc,
      Pearlc,
      pearlyearc,
      happygodyearc,
      sixbadsc,
    ];

    List<String> allgodset = [];
    Set<String> seenGods = {};

    for (String god in allgods) {
      if (god.isNotEmpty && !seenGods.contains(god)) {
        seenGods.add(god);
        allgodset.add(god);
      }
    }

    return allgodset;
  }

  static List<String> tianganThreeTops(String input1, String input2,
      [String? input3,
      String? input4,
      String? input5,
      String? input6,
      String? input7,
      String? input8]) {
    final List<List<String>> combinedTiangan = [
      ['甲', '戊', '庚'],
      ['壬', '癸', '辛'],
      ['乙', '丙', '丁']
    ];

    List<String> inputs = [input1, input2];
    if (input3 != null) inputs.add(input3);
    if (input4 != null) inputs.add(input4);
    if (input5 != null) inputs.add(input5);
    if (input6 != null) inputs.add(input6);
    if (input7 != null) inputs.add(input7);
    if (input8 != null) inputs.add(input8);

    List<String> matchingPairs = [];

    for (var tiangan in combinedTiangan) {
      if (inputs.contains(tiangan[0]) &&
          inputs.contains(tiangan[1]) &&
          inputs.contains(tiangan[2])) {
        matchingPairs.add('${tiangan[0]}${tiangan[1]}${tiangan[2]}三奇');
      }
    }

    return matchingPairs;
  }

  static List<String> tianganCombine(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    // Collect all inputs into a list
    final inputs = <String>[
      input1,
      input2,
      input3 ?? '',
      input4 ?? '',
      input5 ?? '',
      input6 ?? '',
      input7 ?? '',
      input8 ?? '',
    ];

    final combinedTiangan = [
      ['丙', '辛'],
      ['丁', '壬'],
      ['戊', '癸'],
      ['乙', '庚'],
      ['甲', '己'],
    ];

    final appendDict = {
      '丙辛': '水',
      '丁壬': '木',
      '戊癸': '火',
      '乙庚': '金',
      '甲己': '土',
    };

    List<String> matchingPairs = [];

    for (var pair in combinedTiangan) {
      final first = pair[0];
      final second = pair[1];

      if (inputs.contains(first) && inputs.contains(second)) {
        final pairString = '$first$second';
        final appendString = appendDict[pairString] ??
            ''; // Default to empty string if not found
        matchingPairs.add('$pairString化$appendString;');
      }
    }

    return matchingPairs;
  }

  static List<String> tianganAttk(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    // Collect all inputs into a list
    final inputs = <String>[
      input1,
      input2,
      input3 ?? '',
      input4 ?? '',
      input5 ?? '',
      input6 ?? '',
      input7 ?? '',
      input8 ?? '',
    ];

    // Define the combined Tiangan pairs
    final combinedTiangan = [
      ['乙', '辛'],
      ['丙', '壬'],
      ['丁', '癸'],
      ['甲', '庚'],
    ];

    List<String> matchingPairs = [];

    // Check for matching pairs
    for (var pair in combinedTiangan) {
      final first = pair[0];
      final second = pair[1];

      if (inputs.contains(first) && inputs.contains(second)) {
        matchingPairs.add('$first$second沖;');
      }
    }

    return matchingPairs;
  }

  // 宮位受損 算本命 不須寅巳申
  static List<String> diziThreeAttcks(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    final inputs = <String>[
      input1,
      input2,
      input3 ?? '',
      input4 ?? '',
      input5 ?? '',
      input6 ?? '',
      input7 ?? '',
      input8 ?? '',
    ];

    final combinedTiangan = [
      ['丑', '未', '戌'],
    ];

    List<String> matchingPairs = [];

    for (var trio in combinedTiangan) {
      final first = trio[0];
      final second = trio[1];
      final third = trio[2];

      if (inputs.contains(first) &&
          inputs.contains(second) &&
          inputs.contains(third)) {
        matchingPairs.add('土');
      }
    }

    return matchingPairs;
  }

  // 宮位受損  算運勢用
  static List<String> diziThreeAttcks2(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    final inputs = <String>[
      input1,
      input2,
      input3 ?? '',
      input4 ?? '',
      input5 ?? '',
      input6 ?? '',
      input7 ?? '',
      input8 ?? '',
    ];

    final combinedTiangan = [
      ['寅', '巳', '申'],
      ['丑', '未', '戌'],
    ];

    List<String> matchingPairs = [];

    for (var trio in combinedTiangan) {
      final first = trio[0];
      final second = trio[1];
      final third = trio[2];

      if (inputs.contains(first) &&
          inputs.contains(second) &&
          inputs.contains(third)) {
        matchingPairs.add('$first$second$third邢');
      }
    }

    return matchingPairs;
  }

  static List<String> diziTwoAttk(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    final inputs = <String>[
      input1,
      input2,
      input3 ?? '',
      input4 ?? '',
      input5 ?? '',
      input6 ?? '',
      input7 ?? '',
      input8 ?? '',
    ];

    final combinedTiangan = [
      ['子', '卯'],
    ];

    List<String> matchingPairs = [];

    for (var pair in combinedTiangan) {
      final first = pair[0];
      final second = pair[1];

      if (inputs.contains(first) && inputs.contains(second)) {
        matchingPairs.add('$first$second邢;');
      }
    }

    return matchingPairs;
  }

  static List<String> diziHalfCom(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    final inputs = <String>[
      input1,
      input2,
      input3 ?? '',
      input4 ?? '',
      input5 ?? '',
      input6 ?? '',
      input7 ?? '',
      input8 ?? '',
    ];

    final combinedTiangan = [
      ['申', '子'],
      ['寅', '午'],
      ['亥', '卯'],
      ['巳', '酉'],
    ];

    final appendDict = {
      '申子': '水',
      '寅午': '火',
      '亥卯': '木',
      '巳酉': '金',
    };

    List<String> matchingPairs = [];

    for (var pair in combinedTiangan) {
      final first = pair[0];
      final second = pair[1];

      if (inputs.contains(first) && inputs.contains(second)) {
        final combined = '$first$second';
        final appendString = appendDict[combined] ?? '';
        matchingPairs.add('$combined半合$appendString;');
      }
    }

    return matchingPairs;
  }

  static List<String> diziSuppCom(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    final inputs = <String>[
      input1,
      input2,
      input3 ?? '',
      input4 ?? '',
      input5 ?? '',
      input6 ?? '',
      input7 ?? '',
      input8 ?? '',
    ];

    final combinedTiangan = [
      ['申', '辰'],
      ['寅', '戌'],
      ['亥', '未'],
      ['巳', '丑'],
    ];

    final appendDict = {
      '申辰': '水',
      '寅戌': '火',
      '亥未': '木',
      '巳丑': '金',
    };

    List<String> matchingPairs = [];

    for (var pair in combinedTiangan) {
      final first = pair[0];
      final second = pair[1];

      if (inputs.contains(first) && inputs.contains(second)) {
        final combined = '$first$second';
        final appendString = appendDict[combined] ?? '';
        matchingPairs.add('$combined拱合$appendString;');
      }
    }

    return matchingPairs;
  }

  static List<String> diziCom(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    final inputs = <String>[
      input1,
      input2,
      input3 ?? '',
      input4 ?? '',
      input5 ?? '',
      input6 ?? '',
      input7 ?? '',
      input8 ?? '',
    ];

    final combinedTiangan = [
      ['巳', '申'],
      ['辰', '酉'],
      ['卯', '戌'],
      ['寅', '亥'],
      ['子', '丑'],
      ['午', '未'],
    ];

    final appendDict = {
      '巳申': '水',
      '辰酉': '金',
      '卯戌': '火',
      '寅亥': '木',
      '子丑': '土',
      '午未': '火土',
    };

    List<String> matchingPairs = [];

    for (var pair in combinedTiangan) {
      final first = pair[0];
      final second = pair[1];

      if (inputs.contains(first) && inputs.contains(second)) {
        final combined = '$first$second';
        final appendString = appendDict[combined] ?? '';
        matchingPairs.add('$combined可合$appendString;');
      }
    }

    return matchingPairs;
  }

  static List<String> diziHidCom(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    final combinedTiangan = [
      ('巳', '酉'),
      ('亥', '午'),
    ];

    final appendDict = {
      '亥午': '木',
      '巳酉': '水',
    };
    final inputs = [
      input1,
      input2,
      input3,
      input4,
      input5,
      input6,
      input7,
      input8
    ].whereType<String>().toList();
    final matchingPairs = <String>[];

    for (var (first, second) in combinedTiangan) {
      if (inputs.contains(first) && inputs.contains(second)) {
        final pair = '$first$second';
        final appendString = appendDict[pair] ?? '';
        matchingPairs.add('$pair暗合$appendString;');
      }
    }

    return matchingPairs;
  }

  static List<String> diziThreeCom(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    // Combine inputs into a list and filter out null values
    final inputs = [
      input1,
      input2,
      if (input3 != null) input3,
      if (input4 != null) input4,
      if (input5 != null) input5,
      if (input6 != null) input6,
      if (input7 != null) input7,
      if (input8 != null) input8,
    ];

    // Define the combinations and their corresponding values
    final combinedTiangan = [
      ["申", "子", "辰"],
      ["寅", "午", "戌"],
      ["亥", "卯", "未"],
      ["巳", "酉", "丑"]
    ];

    final appendDict = {"申子辰": "水", "寅午戌": "火", "亥卯未": "木", "巳酉丑": "金"};

    List<String> matchingPairs = [];

    // Loop through each combination
    for (var combination in combinedTiangan) {
      final first = combination[0];
      final second = combination[1];
      final third = combination[2];

      if (inputs.contains(first) &&
          inputs.contains(second) &&
          inputs.contains(third)) {
        final pair = "$first$second$third";
        final appendString =
            appendDict[pair] ?? ""; // Default to empty string if not found
        matchingPairs.add("$pair合$appendString");
      }
    }

    return matchingPairs;
  }

  static List<String> diziAttk(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    final combinedTiangan = [
      ('子', '午'),
      ('卯', '酉'),
      ('寅', '申'),
      ('巳', '亥'),
      ('辰', '戌'),
      ('丑', '未'),
    ];
    final inputs = [
      input1,
      input2,
      input3,
      input4,
      input5,
      input6,
      input7,
      input8
    ].whereType<String>().toList();
    final matchingPairs = <String>[];

    for (var (first, second) in combinedTiangan) {
      if (inputs.contains(first) && inputs.contains(second)) {
        matchingPairs.add('$first$second沖;');
      }
    }

    return matchingPairs;
  }

  static List<String> attkOneself(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    final combinedTiangan = [
      ('酉', '酉'),
      ('辰', '辰'),
      ('亥', '亥'),
      ('午', '午'),
    ];
    final appendDict = {
      '辰辰': '自刑',
      '酉酉': '自刑',
      '亥亥': '自刑',
      '午午': '自刑',
    };
    final inputs = [
      input1,
      input2,
      input3,
      input4,
      input5,
      input6,
      input7,
      input8
    ].whereType<String>().toList();
    final matchingPairs = <String>[];

    for (var (first, _) in combinedTiangan) {
      final count = inputs.where((input) => input == first).length;
      if (count >= 2) {
        final pair = '$first$first';
        final appendString = appendDict[pair] ?? '';
        matchingPairs.add('$pair$appendString;');
      }
    }

    return matchingPairs;
  }

  static List<String> dizihai(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    final combinedTiangan = [
      ('寅', '巳'),
      ('卯', '辰'),
      ('酉', '戌'),
      ('申', '亥'),
      ('丑', '午'),
      ('子', '未'),
    ];
    final inputs = [
      input1,
      input2,
      input3,
      input4,
      input5,
      input6,
      input7,
      input8
    ].whereType<String>().toList();
    final matchingPairs = <String>[];

    for (var (first, second) in combinedTiangan) {
      if (inputs.contains(first) && inputs.contains(second)) {
        matchingPairs.add('$first$second害;');
      }
    }

    return matchingPairs;
  }

  static List<String> diziThreeMeets(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    // List of combined Tiangan groups
    final combinedTiangan = [
      ['寅', '卯', '辰'],
      ['亥', '子', '丑'],
      ['巳', '午', '未'],
      ['申', '酉', '戌'],
    ];

    // Dictionary to map pairs to specific strings
    final appendDict = {
      '寅卯辰': '木',
      '亥子丑': '水',
      '巳午未': '火',
      '申酉戌': '金',
    };

    // Collect all inputs into a list, ignoring null values
    final inputs = [
      input1,
      input2,
      input3,
      input4,
      input5,
      input6,
      input7,
      input8,
    ].whereType<String>().toList();

    // To store the matching pairs
    final matchingPairs = <String>[];

    // Loop through the Tiangan combinations
    for (var group in combinedTiangan) {
      if (inputs.contains(group[0]) &&
          inputs.contains(group[1]) &&
          inputs.contains(group[2])) {
        final pair = '${group[0]}${group[1]}${group[2]}';
        final appendString =
            appendDict[pair] ?? ''; // Use empty string if not found
        matchingPairs.add('$pair會$appendString');
      }
    }

    return matchingPairs;
  }

  static List<String> dizibroke(
    String input1,
    String input2, [
    String? input3,
    String? input4,
    String? input5,
    String? input6,
    String? input7,
    String? input8,
  ]) {
    final combinedTiangan = [
      ('子', '酉'),
      ('寅', '亥'),
      ('卯', '午'),
      ('辰', '丑'),
      ('巳', '申'),
      ('未', '戌'),
    ];
    final inputs = [
      input1,
      input2,
      input3,
      input4,
      input5,
      input6,
      input7,
      input8
    ].whereType<String>().toList();
    final matchingPairs = <String>[];

    for (var (first, second) in combinedTiangan) {
      if (inputs.contains(first) && inputs.contains(second)) {
        matchingPairs.add('$first$second破');
      }
    }

    return matchingPairs;
  }

  // 玉堂 日柱算出
  static String pearl(String subject, String anybot) {
    String result = "";

    // Valid pairs of conditions
    List<List<String>> validPairs = [
      ["辛", "午"],
      ["己", "子"],
      ["庚", "未"],
      ["戊", "未"],
      ["癸", "卯"],
      ["丁", "酉"],
      ["壬", "巳"],
      ["己", "申"],
      ["甲", "丑"],
      ["乙", "子"],
      ["丙", "亥"],
    ];

    for (var pair in validPairs) {
      if (pair[0] == subject && pair[1] == anybot) {
        result = "玉堂";
        break;
      }
    }

    return result;
  }

// 天乙 日柱算出
  static String tianYi(String subject, String anybot) {
    String result = "";

    // Valid pairs of conditions
    List<List<String>> validPairs = [
      ["辛", "寅"],
      ["己", "子"],
      ["庚", "丑"],
      ["戊", "丑"],
      ["癸", "巳"],
      ["丁", "亥"],
      ["壬", "卯"],
      ["甲", "未"],
      ["乙", "申"],
      ["丙", "酉"],
    ];

    for (var pair in validPairs) {
      if (pair[0] == subject && pair[1] == anybot) {
        result = "天乙";
        break;
      }
    }

    return result;
  }

// 月德 月柱算出
  static String moonDer(String monthBot, String anybot) {
    String result = "";

    // Valid pairs of conditions
    List<List<String>> validPairs = [
      ["寅", "丙"],
      ["午", "丙"],
      ["戌", "丙"],
      ["子", "壬"],
      ["申", "壬"],
      ["辰", "壬"],
      ["未", "甲"],
      ["卯", "甲"],
      ["未", "甲"],
      ["巳", "庚"],
      ["酉", "庚"],
      ["丑", "庚"],
    ];

    for (var pair in validPairs) {
      if (pair[0] == monthBot && pair[1] == anybot) {
        result = "月德";
        break;
      }
    }

    return result;
  }

// 天德 月柱算出
  static String tianDer(String monthBot, String anybot) {
    String result = "";

    // Valid pairs of conditions
    List<List<String>> validPairs = [
      ["寅", "丁"],
      ["卯", "申"],
      ["辰", "壬"],
      ["巳", "辛"],
      ["午", "亥"],
      ["未", "甲"],
      ["申", "癸"],
      ["酉", "寅"],
      ["戌", "丙"],
      ["亥", "乙"],
      ["子", "巳"],
      ["丑", "庚"],
    ];

    for (var pair in validPairs) {
      if (pair[0] == monthBot && pair[1] == anybot) {
        result = "天德";
        break;
      }
    }

    return result;
  }

// 天財 月柱算出
  static String heavenCash(String monthBot, String anybot) {
    String result = "";

    // Valid pairs of conditions
    List<List<String>> validPairs = [
      ["甲", "戊"],
      ["乙", "己"],
      ["丙", "庚"],
      ["丁", "辛"],
      ["戊", "壬"],
      ["己", "癸"],
      ["庚", "甲"],
      ["辛", "乙"],
      ["壬", "丙"],
      ["癸", "丁"],
    ];

    for (var pair in validPairs) {
      if (pair[0] == monthBot && pair[1] == anybot) {
        result = "天財";
        break;
      }
    }

    return result;
  }

  static String heavenBless(String yearTop, String anybot) {
    Map<String, String> conditions = {
      '甲': '寅',
      '乙': '亥',
      '癸': '卯',
      '丙': '戌',
      '丁': '酉',
      '戊': '申',
      '己': '未',
      '庚': '午',
      '辛': '巳',
      '壬': '辰',
    };

    return conditions[yearTop] == anybot ? '天印' : '';
  }

  static String happyGod(String yearOrdayBot, String anybot) {
    Map<String, String> conditions = {
      '辛': '巳',
      '甲': '寅',
      '丙': '子',
      '丁': '酉',
      '戊': '申',
      '己': '未',
      '庚': '午',
      '酉': '寅',
      '壬': '辰',
      '癸': '卯',
    };

    return conditions[yearOrdayBot] == anybot ? '福德' : '';
  }

  static String againstOneself(String monthBot, String daybot) {
    Map<String, String> conditions = {
      '巳': '亥',
      '申': '寅',
      '戌': '辰',
      '亥': '巳',
      '子': '午',
      '丑': '未',
      '寅': '申',
      '卯': '酉',
      '辰': '戌',
      '午': '子',
    };

    return conditions[monthBot] == daybot ? '日破' : '';
  }

  static String fiveGhost(String monthBot, String anybot) {
    Map<String, String> conditions = {
      '寅': '午',
      '卯': '未',
      '辰': '申',
      '巳': '酉',
      '午': '戌',
      '未': '亥',
      '申': '子',
      '酉': '丑',
      '戌': '寅',
      '亥': '卯',
      '子': '辰',
      '丑': '巳',
    };

    return conditions[monthBot] == anybot ? '五鬼' : '';
  }

  static String lawSue(String yearOrdayBot, String anybot) {
    String result = "";

    List<List<String>> validPairs = [
      ["子", "巳"],
      ["丑", "午"],
      ["寅", "未"],
      ["卯", "申"],
      ["辰", "酉"],
      ["巳", "戌"],
      ["午", "亥"],
      ["未", "子"],
      ["申", "丑"],
      ["酉", "寅"],
      ["戊", "卯"],
      ["亥", "辰"],
    ];

    for (var pair in validPairs) {
      if (pair[0] == yearOrdayBot && pair[1] == anybot) {
        result = "官符";
        break;
      }
    }

    return result;
  }

  static String sadDoor(String yearOrdayBot, String timebot) {
    String result = "";

    List<List<String>> validPairs = [
      ["子", "寅"],
      ["丑", "卯"],
      ["寅", "辰"],
      ["卯", "巳"],
      ["辰", "午"],
      ["巳", "未"],
      ["午", "申"],
      ["未", "酉"],
      ["申", "戌"],
      ["酉", "亥"],
      ["戌", "子"],
      ["亥", "丑"],
    ];

    for (var pair in validPairs) {
      if (pair[0] == yearOrdayBot && pair[1] == timebot) {
        result = "喪門";
        break;
      }
    }

    return result;
  }

  static String hangGuest(String yearOrdayBot, String timebot) {
    String result = "";

    List<List<String>> validPairs = [
      ["子", "戌"],
      ["丑", "亥"],
      ["寅", "子"],
      ["卯", "丑"],
      ["辰", "寅"],
      ["巳", "卯"],
      ["午", "辰"],
      ["未", "巳"],
      ["申", "午"],
      ["酉", "未"],
      ["戌", "申"],
      ["亥", "酉"],
    ];

    for (var pair in validPairs) {
      if (pair[0] == yearOrdayBot && pair[1] == timebot) {
        result = "吊客";
        break;
      }
    }

    return result;
  }

  static String whiteCoat(String yearOrdayBot, String timebot) {
    String result = "";

    List<List<String>> validPairs = [
      ["子", "酉"],
      ["丑", "戌"],
      ["寅", "亥"],
      ["卯", "子"],
      ["辰", "丑"],
      ["巳", "寅"],
      ["午", "卯"],
      ["未", "辰"],
      ["申", "巳"],
      ["酉", "午"],
      ["戌", "未"],
      ["亥", "申"],
    ];

    for (var pair in validPairs) {
      if (pair[0] == yearOrdayBot && pair[1] == timebot) {
        result = "披麻";
        break;
      }
    }

    return result;
  }

  static String taichi(String yearOrdayBot, String timebot) {
    String result = "";

    List<List<String>> validPairs = [
      ["甲", "午"],
      ["甲", "子"],
      ["乙", "午"],
      ["乙", "子"],
      ["丙", "卯"],
      ["丙", "酉"],
      ["丁", "卯"],
      ["丁", "酉"],
      ["戊", "辰"],
      ["戊", "戌"],
      ["戊", "丑"],
      ["戊", "未"],
      ["己", "辰"],
      ["己", "戌"],
      ["己", "丑"],
      ["己", "未"],
      ["庚", "寅"],
      ["庚", "亥"],
      ["辛", "寅"],
      ["辛", "亥"],
      ["壬", "申"],
      ["壬", "巳"],
      ["癸", "申"],
      ["癸", "巳"]
    ];

    for (var pair in validPairs) {
      if (pair[0] == yearOrdayBot && pair[1] == timebot) {
        result = "太極";
        break;
      }
    }

    return result;
  }

  static String allWrong(String topString, String botString) {
    String tiandi = topString + botString;
    String result = "";

    List<String> validPairs = [
      "丙子",
      "丁丑",
      "戊寅",
      "辛卯",
      "壬辰",
      "癸巳",
      "丙午",
      "丁未",
      "戊申",
      "辛酉",
      "壬戌",
      "癸亥"
    ];

    if (validPairs.contains(tiandi)) {
      result = "陰差";
    }

    return result;
  }

  static String classic(String topString, String botString) {
    String tiandi = topString + botString;
    String result = "";

    List<String> validPairs = ["丁酉", "丁亥", "癸卯", "癸巳"];

    if (validPairs.contains(tiandi)) {
      result = "日貴";
    }

    return result;
  }

  static String shower(String topString, String botString) {
    String tiandi = topString + botString;
    String result = "";

    List<String> validPairs = ["辛亥", "庚午", "甲子", "乙巳"];

    if (validPairs.contains(tiandi)) {
      result = "沐浴";
    }

    return result;
  }

  static String forgiveness(String topString, String botString) {
    String tiandi = topString + botString;
    String result = "";

    List<String> validPairs = ["甲午", "戊寅", "戊申", "甲子"];

    if (validPairs.contains(tiandi)) {
      result = "天赦貴";
    }

    return result;
  }

  static String smartest(String topString, String botString) {
    String tiandi = topString + botString;
    String result = "";

    List<String> validPairs = [
      "甲辰",
      "乙亥",
      "丁酉",
      "戊午",
      "庚戌",
      "庚寅",
      "辛亥",
      "壬寅",
      "癸未",
      "丙辰"
    ];

    if (validPairs.contains(tiandi)) {
      result = "十靈";
    }

    return result;
  }

  static String highMoral(String topString, String botString) {
    String tiandi = topString + botString;
    String result = "";

    List<String> validPairs = ["甲寅", "丙辰", "戊辰", "庚辰", "壬戌"];

    if (validPairs.contains(tiandi)) {
      result = "日德";
    }

    return result;
  }

  static String sixShow(String topString, String botString) {
    String tiandi = topString + botString;
    String result = "";

    List<String> validPairs = ["丙午", "丁末", "戊子", "戊午", "己丑", "己未"];

    if (validPairs.contains(tiandi)) {
      result = "六秀";
    }

    return result;
  }

  static String tenShits(String topString, String botString) {
    String tiandi = topString + botString;
    String result = "";

    List<String> validPairs = [
      "甲辰",
      "乙巳",
      "丙申",
      "丁亥",
      "戊戌",
      "己丑",
      "庚辰",
      "辛巳",
      "壬申",
      "癸亥"
    ];

    if (validPairs.contains(tiandi)) {
      result = "十惡";
    }

    return result;
  }

  static String progress(String topString, String botString) {
    String tiandi = topString + botString;
    String result = "";

    switch (tiandi) {
      case "甲子":
      case "甲午":
      case "己卯":
      case "己酉":
        result = "進神";
        break;
      default:
        result = "";
    }
    return result;
  }

  static String backward(String topString, String botString) {
    String tiandi = topString + botString;
    String result = "";

    switch (tiandi) {
      case "丁丑":
      case "丁末":
      case "壬辰":
      case "壬戌":
        result = "退神";
        break;
      default:
        result = "";
    }
    return result;
  }

  static String loner(String topString, String botString) {
    String tiandi = topString + botString;
    String result = "";

    switch (tiandi) {
      case "甲寅":
      case "乙巳":
      case "丙午":
      case "丁巳":
      case "戊午":
      case "戊申":
      case "辛亥":
      case "壬子":
      case "癸巳":
        result = "孤鸞";
        break;
      default:
        result = "";
    }
    return result;
  }

  static String ironMan(String topString, String botString) {
    String tiandi = topString + botString;
    String result = "";

    switch (tiandi) {
      case "壬辰":
      case "庚辰":
      case "戊戌":
      case "庚戌":
        result = "魁罡";
        break;
      default:
        result = "";
    }
    return result;
  }

  static String guoYin(String yearOrdayBot, String timebot) {
    String result = "";

    // Define valid pairs
    final validSubjects1 = ["庚"];
    final validTimebots1 = ["辰"];
    final validSubjects2 = ["甲"];
    final validTimebots2 = ["戌"];
    final validSubjects3 = ["乙"];
    final validTimebots3 = ["亥"];
    final validSubjects4 = ["丙"];
    final validTimebots4 = ["丑"];
    final validSubjects5 = ["丁"];
    final validTimebots5 = ["寅"];
    final validSubjects6 = ["戊"];
    final validTimebots6 = ["丑"];
    final validSubjects7 = ["辛"];
    final validTimebots7 = ["巳"];
    final validSubjects8 = ["壬"];
    final validTimebots8 = ["未"];
    final validSubjects9 = ["癸"];
    final validTimebots9 = ["申"];
    final validSubjects10 = ["丁"];
    final validTimebots10 = ["寅"];

    // Check pairs
    if ((validSubjects1.contains(yearOrdayBot) &&
            validTimebots1.contains(timebot)) ||
        (validSubjects2.contains(yearOrdayBot) &&
            validTimebots2.contains(timebot)) ||
        (validSubjects3.contains(yearOrdayBot) &&
            validTimebots3.contains(timebot)) ||
        (validSubjects4.contains(yearOrdayBot) &&
            validTimebots4.contains(timebot)) ||
        (validSubjects5.contains(yearOrdayBot) &&
            validTimebots5.contains(timebot)) ||
        (validSubjects6.contains(yearOrdayBot) &&
            validTimebots6.contains(timebot)) ||
        (validSubjects7.contains(yearOrdayBot) &&
            validTimebots7.contains(timebot)) ||
        (validSubjects8.contains(yearOrdayBot) &&
            validTimebots8.contains(timebot)) ||
        (validSubjects9.contains(yearOrdayBot) &&
            validTimebots9.contains(timebot)) ||
        (validSubjects10.contains(yearOrdayBot) &&
            validTimebots10.contains(timebot))) {
      result = "國印";
    }

    return result;
  }

  static String jinyu(String yearOrdayBot, String timebot) {
    String result = "";

    // Define valid pairs
    final validSubjects1 = ["甲"];
    final validTimebots1 = ["辰"];
    final validSubjects2 = ["乙"];
    final validTimebots2 = ["巳"];
    final validSubjects3 = ["丙"];
    final validTimebots3 = ["未"];
    final validSubjects4 = ["丁"];
    final validTimebots4 = ["申"];
    final validSubjects5 = ["戊"];
    final validTimebots5 = ["未"];
    final validSubjects6 = ["己"];
    final validTimebots6 = ["申"];
    final validSubjects7 = ["庚"];
    final validTimebots7 = ["戌"];
    final validSubjects8 = ["辛"];
    final validTimebots8 = ["亥"];
    final validSubjects9 = ["壬"];
    final validTimebots9 = ["丑"];
    final validSubjects10 = ["癸"];
    final validTimebots10 = ["寅"];

    // Check pairs
    if ((validSubjects1.contains(yearOrdayBot) &&
            validTimebots1.contains(timebot)) ||
        (validSubjects2.contains(yearOrdayBot) &&
            validTimebots2.contains(timebot)) ||
        (validSubjects3.contains(yearOrdayBot) &&
            validTimebots3.contains(timebot)) ||
        (validSubjects4.contains(yearOrdayBot) &&
            validTimebots4.contains(timebot)) ||
        (validSubjects5.contains(yearOrdayBot) &&
            validTimebots5.contains(timebot)) ||
        (validSubjects6.contains(yearOrdayBot) &&
            validTimebots6.contains(timebot)) ||
        (validSubjects7.contains(yearOrdayBot) &&
            validTimebots7.contains(timebot)) ||
        (validSubjects8.contains(yearOrdayBot) &&
            validTimebots8.contains(timebot)) ||
        (validSubjects9.contains(yearOrdayBot) &&
            validTimebots9.contains(timebot)) ||
        (validSubjects10.contains(yearOrdayBot) &&
            validTimebots10.contains(timebot))) {
      result = "金輿";
    }

    return result;
  }

  static String huagai(String yearOrdayBot, String timebot) {
    List<String> validSubjects1 = ["亥", "卯", "未"];
    List<String> validTimebots1 = ["未"];

    List<String> validSubjects2 = ["申", "子", "辰"];
    List<String> validTimebots2 = ["辰"];

    List<String> validSubjects3 = ["巳", "酉", "丑"];
    List<String> validTimebots3 = ["丑"];

    List<String> validSubjects4 = ["寅", "午", "戌"];
    List<String> validTimebots4 = ["戌"];

    if (validSubjects1.contains(yearOrdayBot) &&
        validTimebots1.contains(timebot)) {
      return "華蓋";
    } else if (validSubjects2.contains(yearOrdayBot) &&
        validTimebots2.contains(timebot)) {
      return "華蓋";
    } else if (validSubjects3.contains(yearOrdayBot) &&
        validTimebots3.contains(timebot)) {
      return "華蓋";
    } else if (validSubjects4.contains(yearOrdayBot) &&
        validTimebots4.contains(timebot)) {
      return "華蓋";
    }

    return "";
  }

  static String attractive(String yearOrdayBot, String timebot) {
    List<String> validSubjects1 = ["亥", "卯", "未"];
    List<String> validTimebots1 = ["子"];

    List<String> validSubjects2 = ["申", "子", "辰"];
    List<String> validTimebots2 = ["酉"];

    List<String> validSubjects3 = ["巳", "酉", "丑"];
    List<String> validTimebots3 = ["午"];

    List<String> validSubjects4 = ["寅", "午", "戌"];
    List<String> validTimebots4 = ["卯"];

    if (validSubjects1.contains(yearOrdayBot) &&
        validTimebots1.contains(timebot)) {
      return "桃花";
    } else if (validSubjects2.contains(yearOrdayBot) &&
        validTimebots2.contains(timebot)) {
      return "桃花";
    } else if (validSubjects3.contains(yearOrdayBot) &&
        validTimebots3.contains(timebot)) {
      return "桃花";
    } else if (validSubjects4.contains(yearOrdayBot) &&
        validTimebots4.contains(timebot)) {
      return "桃花";
    }

    return "";
  }

  static String tragedey(String yearOrdayBot, String timebot) {
    List<String> validSubjects1 = ["亥", "卯", "未"];
    List<String> validTimebots1 = ["酉"];

    List<String> validSubjects2 = ["申", "子", "辰"];
    List<String> validTimebots2 = ["午"];

    List<String> validSubjects3 = ["巳", "酉", "丑"];
    List<String> validTimebots3 = ["卯"];

    List<String> validSubjects4 = ["寅", "午", "戌"];
    List<String> validTimebots4 = ["子"];

    if (validSubjects1.contains(yearOrdayBot) &&
        validTimebots1.contains(timebot)) {
      return "災煞";
    } else if (validSubjects2.contains(yearOrdayBot) &&
        validTimebots2.contains(timebot)) {
      return "災煞";
    } else if (validSubjects3.contains(yearOrdayBot) &&
        validTimebots3.contains(timebot)) {
      return "災煞";
    } else if (validSubjects4.contains(yearOrdayBot) &&
        validTimebots4.contains(timebot)) {
      return "災煞";
    }

    return "";
  }

  static String saltWater(String yearOrdayBot, String timebot) {
    List<String> validSubjects1 = ["子"];
    List<String> validTimebots1 = ["酉"];

    List<String> validSubjects2 = ["丑"];
    List<String> validTimebots2 = ["未"];

    List<String> validSubjects3 = ["寅"];
    List<String> validTimebots3 = ["卯"];

    List<String> validSubjects4 = ["卯"];
    List<String> validTimebots4 = ["子"];

    List<String> validSubjects5 = ["辰"];
    List<String> validTimebots5 = ["酉"];

    List<String> validSubjects6 = ["巳"];
    List<String> validTimebots6 = ["未"];

    List<String> validSubjects7 = ["午"];
    List<String> validTimebots7 = ["卯"];

    List<String> validSubjects8 = ["未"];
    List<String> validTimebots8 = ["子"];

    List<String> validSubjects9 = ["申"];
    List<String> validTimebots9 = ["酉"];

    List<String> validSubjects10 = ["酉"];
    List<String> validTimebots10 = ["未"];

    List<String> validSubjects11 = ["戌"];
    List<String> validTimebots11 = ["卯"];

    List<String> validSubjects12 = ["亥"];
    List<String> validTimebots12 = ["子"];

    if (validSubjects1.contains(yearOrdayBot) &&
        validTimebots1.contains(timebot)) {
      return "咸池";
    } else if (validSubjects2.contains(yearOrdayBot) &&
        validTimebots2.contains(timebot)) {
      return "咸池";
    } else if (validSubjects3.contains(yearOrdayBot) &&
        validTimebots3.contains(timebot)) {
      return "咸池";
    } else if (validSubjects4.contains(yearOrdayBot) &&
        validTimebots4.contains(timebot)) {
      return "咸池";
    } else if (validSubjects5.contains(yearOrdayBot) &&
        validTimebots5.contains(timebot)) {
      return "咸池";
    } else if (validSubjects6.contains(yearOrdayBot) &&
        validTimebots6.contains(timebot)) {
      return "咸池";
    } else if (validSubjects7.contains(yearOrdayBot) &&
        validTimebots7.contains(timebot)) {
      return "咸池";
    } else if (validSubjects8.contains(yearOrdayBot) &&
        validTimebots8.contains(timebot)) {
      return "咸池";
    } else if (validSubjects9.contains(yearOrdayBot) &&
        validTimebots9.contains(timebot)) {
      return "咸池";
    } else if (validSubjects10.contains(yearOrdayBot) &&
        validTimebots10.contains(timebot)) {
      return "咸池";
    } else if (validSubjects11.contains(yearOrdayBot) &&
        validTimebots11.contains(timebot)) {
      return "咸池";
    } else if (validSubjects12.contains(yearOrdayBot) &&
        validTimebots12.contains(timebot)) {
      return "咸池";
    }

    return "";
  }

  static String sixBads(String yearOrdayBot, String timebot) {
    List<String> validSubjects1 = ["亥", "卯", "未"];
    List<String> validTimebots1 = ["午"];

    List<String> validSubjects2 = ["申", "子", "辰"];
    List<String> validTimebots2 = ["卯"];

    List<String> validSubjects3 = ["巳", "酉", "丑"];
    List<String> validTimebots3 = ["子"];

    List<String> validSubjects4 = ["寅", "午", "戌"];
    List<String> validTimebots4 = ["酉"];

    if (validSubjects1.contains(yearOrdayBot) &&
        validTimebots1.contains(timebot)) {
      return "六厄";
    } else if (validSubjects2.contains(yearOrdayBot) &&
        validTimebots2.contains(timebot)) {
      return "六厄";
    } else if (validSubjects3.contains(yearOrdayBot) &&
        validTimebots3.contains(timebot)) {
      return "六厄";
    } else if (validSubjects4.contains(yearOrdayBot) &&
        validTimebots4.contains(timebot)) {
      return "六厄";
    }

    return "";
  }

  static String whiteTiger(String yearOrdayBot, String timebot) {
    List<String> validSubjects1 = ["亥", "卯", "未"];
    List<String> validTimebots1 = ["酉"];

    List<String> validSubjects2 = ["申", "子", "辰"];
    List<String> validTimebots2 = ["午"];

    List<String> validSubjects3 = ["巳", "酉", "丑"];
    List<String> validTimebots3 = ["卯"];

    List<String> validSubjects4 = ["寅", "午", "戌"];
    List<String> validTimebots4 = ["子"];

    if (validSubjects1.contains(yearOrdayBot) &&
        validTimebots1.contains(timebot)) {
      return "白虎";
    } else if (validSubjects2.contains(yearOrdayBot) &&
        validTimebots2.contains(timebot)) {
      return "白虎";
    } else if (validSubjects3.contains(yearOrdayBot) &&
        validTimebots3.contains(timebot)) {
      return "白虎";
    } else if (validSubjects4.contains(yearOrdayBot) &&
        validTimebots4.contains(timebot)) {
      return "白虎";
    }

    return "";
  }

  static String horse(String yearOrdaybot, String anybot) {
    List<String> validSubjects = ["亥", "卯", "未"];
    List<String> validTimebots = ["巳"];

    List<String> validSubjects2 = ["巳", "酉", "丑"];
    List<String> validTimebots2 = ["亥"];

    List<String> validSubjects3 = ["寅", "午", "戌"];
    List<String> validTimebots3 = ["申"];

    List<String> validSubjects4 = ["申", "子", "辰"];
    List<String> validTimebots4 = ["寅"];

    if (validSubjects.contains(yearOrdaybot) &&
        validTimebots.contains(anybot)) {
      return "驛馬";
    } else if (validSubjects2.contains(yearOrdaybot) &&
        validTimebots2.contains(anybot)) {
      return "驛馬";
    } else if (validSubjects3.contains(yearOrdaybot) &&
        validTimebots3.contains(anybot)) {
      return "驛馬";
    } else if (validSubjects4.contains(yearOrdaybot) &&
        validTimebots4.contains(anybot)) {
      return "驛馬";
    }

    return "";
  }

  static String broKen(String monthBot, String anybot, bool sex) {
    List<String> validSubjects2 = ["戌", "巳", "酉"];
    List<String> validTimebots2 = ["辰"];

    List<String> validSubjects3 = ["亥", "卯", "未"];
    List<String> validTimebots3 = ["丑"];

    List<String> validSubjects4 = ["子", "辰", "申"];
    List<String> validTimebots4 = ["午"];

    if (validSubjects2.contains(monthBot) && validTimebots2.contains(anybot)) {
      return "月破";
    } else if (validSubjects3.contains(monthBot) &&
        validTimebots3.contains(anybot)) {
      return "月破";
    } else if (validSubjects4.contains(monthBot) &&
        validTimebots4.contains(anybot)) {
      return "月破";
    }

    return "";
  }

  static String broKen2(String monthBot, String anybot, bool sex) {
    if (!sex) {
      List<String> validSubjects1 = ["卯", "亥", "未"];
      List<String> validTimebots1 = ["寅"];

      List<String> validSubjects2 = ["酉", "巳"];
      List<String> validTimebots2 = ["巳"];

      List<String> validSubjects3 = ["寅", "戌", "午", "丑"];
      List<String> validTimebots3 = ["辰"];

      List<String> validSubjects4 = ["辰", "申", "子"];
      List<String> validTimebots4 = ["未"];

      if (validSubjects1.contains(monthBot) &&
          validTimebots1.contains(anybot)) {
        return "月破";
      } else if (validSubjects2.contains(monthBot) &&
          validTimebots2.contains(anybot)) {
        return "月破";
      } else if (validSubjects3.contains(monthBot) &&
          validTimebots3.contains(anybot)) {
        return "月破";
      } else if (validSubjects4.contains(monthBot) &&
          validTimebots4.contains(anybot)) {
        return "月破";
      }
    } else {
      List<String> validSubjects1 = ["子"];
      List<String> validTimebots1 = ["卯"];

      List<String> validSubjects2 = ["丑"];
      List<String> validTimebots2 = ["辰"];

      List<String> validSubjects3 = ["寅"];
      List<String> validTimebots3 = ["亥"];

      List<String> validSubjects4 = ["卯"];
      List<String> validTimebots4 = ["午"];

      List<String> validSubjects5 = ["龍"];
      List<String> validTimebots5 = ["丑"];

      List<String> validSubjects6 = ["巳"];
      List<String> validTimebots6 = ["寅"];

      List<String> validSubjects7 = ["未"];
      List<String> validTimebots7 = ["戌"];

      List<String> validSubjects8 = ["申"];
      List<String> validTimebots8 = ["巳"];

      List<String> validSubjects9 = ["酉"];
      List<String> validTimebots9 = ["子"];

      List<String> validSubjects10 = ["戌"];
      List<String> validTimebots10 = ["未"];

      List<String> validSubjects11 = ["亥"];
      List<String> validTimebots11 = ["申"];

      List<String> validSubjects12 = ["午"];
      List<String> validTimebots12 = ["酉"];

      if (validSubjects1.contains(monthBot) &&
          validTimebots1.contains(anybot)) {
        return "月破";
      } else if (validSubjects2.contains(monthBot) &&
          validTimebots2.contains(anybot)) {
        return "月破";
      } else if (validSubjects3.contains(monthBot) &&
          validTimebots3.contains(anybot)) {
        return "月破";
      } else if (validSubjects4.contains(monthBot) &&
          validTimebots4.contains(anybot)) {
        return "月破";
      } else if (validSubjects5.contains(monthBot) &&
          validTimebots5.contains(anybot)) {
        return "月破";
      } else if (validSubjects6.contains(monthBot) &&
          validTimebots6.contains(anybot)) {
        return "月破";
      } else if (validSubjects7.contains(monthBot) &&
          validTimebots7.contains(anybot)) {
        return "月破";
      } else if (validSubjects8.contains(monthBot) &&
          validTimebots8.contains(anybot)) {
        return "月破";
      } else if (validSubjects9.contains(monthBot) &&
          validTimebots9.contains(anybot)) {
        return "月破";
      } else if (validSubjects10.contains(monthBot) &&
          validTimebots10.contains(anybot)) {
        return "月破";
      } else if (validSubjects11.contains(monthBot) &&
          validTimebots11.contains(anybot)) {
        return "月破";
      } else if (validSubjects12.contains(monthBot) &&
          validTimebots12.contains(anybot)) {
        return "月破";
      }
    }

    return "";
  }

  static String unStable(String yearOrdayBot, bool sex, String anybot) {
    String result = '';

    if (!sex) {
      switch (yearOrdayBot) {
        case '子':
          if (anybot == '未') result = '元辰';
          break;
        case '丑':
          if (anybot == '申') result = '元辰';
          break;
        case '寅':
          if (anybot == '酉') result = '元辰';
          break;
        case '卯':
          if (anybot == '戊') result = '元辰';
          break;
        case '辰':
          if (anybot == '亥') result = '元辰';
          break;
        case '巳':
          if (anybot == '子') result = '元辰';
          break;
        case '午':
          if (anybot == '丑') result = '元辰';
          break;
        case '未':
          if (anybot == '寅') result = '元辰';
          break;
        case '申':
          if (anybot == '卯') result = '元辰';
          break;
        case '酉':
          if (anybot == '辰') result = '元辰';
          break;
        case '戌':
          if (anybot == '巳') result = '元辰';
          break;
        case '亥':
          if (anybot == '亥') result = '元辰';
          break;
        default:
          result = '';
          break;
      }
    } else {
      switch (yearOrdayBot) {
        case '子':
          if (anybot == '巳') result = '元辰';
          break;
        case '丑':
          if (anybot == '午') result = '元辰';
          break;
        case '寅':
          if (anybot == '未') result = '元辰';
          break;
        case '卯':
          if (anybot == '申') result = '元辰';
          break;
        case '辰':
          if (anybot == '酉') result = '元辰';
          break;
        case '巳':
          if (anybot == '戌') result = '元辰';
          break;
        case '午':
          if (anybot == '亥') result = '元辰';
          break;
        case '未':
          if (anybot == '子') result = '元辰';
          break;
        case '申':
          if (anybot == '丑') result = '元辰';
          break;
        case '酉':
          if (anybot == '寅') result = '元辰';
          break;
        case '戌':
          if (anybot == '卯') result = '元辰';
          break;
        case '亥':
          if (anybot == '辰') result = '元辰';
          break;
        default:
          result = '';
          break;
      }
    }

    return result;
  }

  static String thief(String yearOrdayBot, String timebot) {
    final conditions = {
      '子': ['巳'],
      '丑': ['寅'],
      '寅': ['亥', '申'],
      '辰': ['巳'],
      '巳': ['寅'],
      '午': ['亥'],
      '未': ['申'],
      '申': ['巳'],
      '酉': ['寅'],
      '戌': ['亥'],
      '亥': ['寅'],
    };

    if (conditions[yearOrdayBot]?.contains(timebot) ?? false) {
      return '劫煞';
    }
    return '';
  }

  static String deathGod(String yearOrdayBot, String timebot) {
    final conditions = {
      '子': ['亥'],
      '丑': ['申'],
      '寅': ['巳'],
      '卯': ['寅'],
      '辰': ['亥'],
      '巳': ['申'],
      '午': ['巳'],
      '未': ['寅'],
      '申': ['亥'],
      '酉': ['申'],
      '戌': ['巳'],
      '亥': ['寅'],
    };

    if (conditions[yearOrdayBot]?.contains(timebot) ?? false) {
      return '亡神';
    }
    return '';
  }

  static String easyHorse(String yearOrdayBot, String timebot) {
    final conditions = {
      '子': ['寅'],
      '丑': ['亥'],
      '寅': ['申'],
      '卯': ['巳'],
      '辰': ['寅'],
      '巳': ['亥'],
      '午': ['申'],
      '未': ['巳'],
      '申': ['寅'],
      '酉': ['亥'],
      '戌': ['申'],
      '亥': ['巳'],
    };

    if (conditions[yearOrdayBot]?.contains(timebot) ?? false) {
      return '驛馬';
    }
    return '';
  }

  static String guasu(String yearOrdayBot, String timebot) {
    final conditions = {
      '子': ['戌'],
      '丑': ['戌'],
      '亥': ['戌'],
      '寅': ['丑'],
      '卯': ['丑'],
      '辰': ['丑'],
      '巳': ['辰'],
      '午': ['辰'],
      '未': ['辰'],
      '申': ['未'],
      '酉': ['未'],
      '戌': ['未'],
    };

    if (conditions[yearOrdayBot]?.contains(timebot) ?? false) {
      return '寡宿';
    }
    return '';
  }

  static String guchen(String yearOrdayBot, String timebot) {
    final conditions = {
      '子': ['寅'],
      '丑': ['寅'],
      '亥': ['寅'],
      '寅': ['巳'],
      '卯': ['巳'],
      '辰': ['巳'],
      '巳': ['申'],
      '午': ['申'],
      '未': ['申'],
      '申': ['亥'],
      '酉': ['亥'],
      '戌': ['亥'],
    };

    if (conditions[yearOrdayBot]?.contains(timebot) ?? false) {
      return '孤辰';
    }
    return '';
  }

  static String lusen(String yearOrdayBot, String timebot) {
    final Map<String, Set<String>> validCombinations = {
      "甲": {"寅"},
      "乙": {"卯"},
      "丙": {"巳"},
      "丁": {"午"},
      "戊": {"巳"},
      "庚": {"申"},
      "辛": {"酉"},
      "壬": {"亥"},
      "癸": {"子"},
      "己": {"午"},
    };

    if (validCombinations.containsKey(yearOrdayBot) &&
        validCombinations[yearOrdayBot]!.contains(timebot)) {
      return "祿神";
    }

    return "";
  }

  static String bloodSword(String yearOrdayBot, String timebot) {
    final Map<String, Set<String>> validCombinations = {
      "甲": {"卯"},
      "乙": {"辰"},
      "丙": {"午"},
      "丁": {"未"},
      "戊": {"午"},
      "庚": {"酉"},
      "辛": {"戌"},
      "壬": {"子"},
      "癸": {"丑"},
      "己": {"未"},
    };

    if (validCombinations.containsKey(yearOrdayBot) &&
        validCombinations[yearOrdayBot]!.contains(timebot)) {
      return "血刃";
    }

    return "";
  }

  static String sheepSword(String yearOrdayBot, String timebot) {
    final Map<String, Set<String>> validCombinations = {
      "甲": {"卯"},
      "乙": {"寅"},
      "丙": {"午"},
      "丁": {"巳"},
      "戊": {"午"},
      "庚": {"酉"},
      "辛": {"申"},
      "壬": {"子"},
      "癸": {"亥"},
      "己": {"巳"},
    };

    if (validCombinations.containsKey(yearOrdayBot) &&
        validCombinations[yearOrdayBot]!.contains(timebot)) {
      return "羊刃";
    }

    return "";
  }

  static String suicidal(String yearOrdayBot, String timebot) {
    final Map<String, Set<String>> validCombinations = {
      "辰": {"亥"},
      "亥": {"辰"},
      "戌": {"巳"},
      "巳": {"戌"},
      "寅": {"未"},
      "未": {"寅"},
      "卯": {"申"},
      "申": {"卯"},
      "午": {"丑"},
      "丑": {"午"},
      "子": {"酉"},
      "酉": {"子"},
    };

    if (validCombinations.containsKey(yearOrdayBot) &&
        validCombinations[yearOrdayBot]!.contains(timebot)) {
      return "自縊";
    }

    return "";
  }

  static String smallWaste(String yearBot, String anybot) {
    final Map<String, Set<String>> validCombinations = {
      "子": {"午"},
      "丑": {"未"},
      "寅": {"申"},
      "卯": {"酉"},
      "辰": {"戌"},
      "巳": {"亥"},
      "午": {"子"},
      "未": {"丑"},
      "申": {"寅"},
      "酉": {"卯"},
      "戌": {"辰"},
      "亥": {"巳"},
    };

    if (validCombinations.containsKey(yearBot) &&
        validCombinations[yearBot]!.contains(anybot)) {
      return "日破";
    }

    return "";
  }

  static String flyingSword(String yearOrdayBot, String timebot) {
    final Map<String, Set<String>> validCombinations = {
      "甲": {"酉"},
      "乙": {"戌"},
      "丙": {"子"},
      "丁": {"丑"},
      "戊": {"子"},
      "庚": {"卯"},
      "辛": {"辰"},
      "壬": {"午"},
      "癸": {"未"},
      "己": {"丑"},
    };

    if (validCombinations.containsKey(yearOrdayBot) &&
        validCombinations[yearOrdayBot]!.contains(timebot)) {
      return "飛刃";
    }

    return "";
  }

  static String learner(String yearOrdayBot, String timebot) {
    final Map<String, Set<String>> validCombinations = {
      "甲": {"巳"},
      "乙": {"午"},
      "丙": {"申"},
      "丁": {"酉"},
      "己": {"酉"},
      "庚": {"亥"},
      "辛": {"子"},
      "壬": {"寅"},
      "癸": {"卯"},
      "戊": {"申"},
    };

    if (validCombinations.containsKey(yearOrdayBot) &&
        validCombinations[yearOrdayBot]!.contains(timebot)) {
      return "文昌";
    }

    return "";
  }

  static String doctor(String yearOrdayBot, String timebot) {
    final Map<String, Set<String>> validCombinations = {
      "甲": {"酉"},
      "乙": {"戌"},
      "丙": {"未"},
      "丁": {"申"},
      "戊": {"巳"},
      "己": {"午"},
      "庚": {"辰"},
      "辛": {"卯"},
      "壬": {"亥"},
      "癸": {"寅"},
    };

    if (validCombinations.containsKey(yearOrdayBot) &&
        validCombinations[yearOrdayBot]!.contains(timebot)) {
      return "流霞";
    }

    return "";
  }

  static String tianshi(String yearOrdayBot, String timebot) {
    final Map<String, Set<String>> validCombinations = {
      "子": {"酉"},
      "丑": {"申"},
      "寅": {"未"},
      "卯": {"午"},
      "辰": {"巳"},
      "巳": {"辰"},
      "午": {"卯"},
      "未": {"寅"},
      "申": {"丑"},
      "酉": {"子"},
      "戌": {"亥"},
      "亥": {"戌"},
    };

    if (validCombinations.containsKey(yearOrdayBot) &&
        validCombinations[yearOrdayBot]!.contains(timebot)) {
      return "天喜";
    }

    return "";
  }

  static String hongren(String yearOrdayBot, String anybot) {
    final Map<String, Set<String>> validCombinations = {
      "子": {"卯"},
      "丑": {"寅"},
      "寅": {"丑"},
      "卯": {"子"},
      "辰": {"亥"},
      "巳": {"戌"},
      "午": {"酉"},
      "未": {"申"},
      "申": {"未"},
      "酉": {"馬"},
      "戌": {"巳"},
      "亥": {"辰"},
    };

    if (validCombinations.containsKey(yearOrdayBot) &&
        validCombinations[yearOrdayBot]!.contains(anybot)) {
      return "紅鸞";
    }

    return "";
  }

  static String hongyang(String yearOrdayBot, String timebot) {
    String result = "";

    // List of conditions
    List<String> validSubjects1 = ["甲"];
    List<String> validTimebots1 = ["午"];

    List<String> validSubjects2 = ["丙"];
    List<String> validTimebots2 = ["寅"];

    List<String> validSubjects3 = ["丁"];
    List<String> validTimebots3 = ["未"];

    List<String> validSubjects4 = ["戊"];
    List<String> validTimebots4 = ["辰"];

    List<String> validSubjects5 = ["己"];
    List<String> validTimebots5 = ["辰"];

    List<String> validSubjects6 = ["庚"];
    List<String> validTimebots6 = ["戌"];

    List<String> validSubjects7 = ["辛"];
    List<String> validTimebots7 = ["酉"];

    List<String> validSubjects8 = ["壬"];
    List<String> validTimebots8 = ["子"];

    List<String> validSubjects9 = ["癸"];
    List<String> validTimebots9 = ["申"];

    List<String> validSubjects10 = ["乙"];
    List<String> validTimebots10 = ["申"];

    // Check the conditions
    if (validSubjects1.contains(yearOrdayBot) &&
        validTimebots1.contains(timebot)) {
      result = "紅艷";
    } else if (validSubjects2.contains(yearOrdayBot) &&
        validTimebots2.contains(timebot)) {
      result = "紅艷";
    } else if (validSubjects3.contains(yearOrdayBot) &&
        validTimebots3.contains(timebot)) {
      result = "紅艷";
    } else if (validSubjects4.contains(yearOrdayBot) &&
        validTimebots4.contains(timebot)) {
      result = "紅艷";
    } else if (validSubjects5.contains(yearOrdayBot) &&
        validTimebots5.contains(timebot)) {
      result = "紅艷";
    } else if (validSubjects6.contains(yearOrdayBot) &&
        validTimebots6.contains(timebot)) {
      result = "紅艷";
    } else if (validSubjects7.contains(yearOrdayBot) &&
        validTimebots7.contains(timebot)) {
      result = "紅艷";
    } else if (validSubjects8.contains(yearOrdayBot) &&
        validTimebots8.contains(timebot)) {
      result = "紅艷";
    } else if (validSubjects9.contains(yearOrdayBot) &&
        validTimebots9.contains(timebot)) {
      result = "紅艷";
    } else if (validSubjects10.contains(yearOrdayBot) &&
        validTimebots10.contains(timebot)) {
      result = "紅艷";
    }

    return result;
  }

  static String general(String yearOrdayBot, String timebot) {
    String result = "";

    // First pair of conditions
    final validSubjects1 = ["子"];
    final validTimebots1 = ["子"];

    final validSubjects2 = ["丑"];
    final validTimebots2 = ["酉"];

    final validSubjects3 = ["寅"];
    final validTimebots3 = ["午"];

    final validSubjects4 = ["卯"];
    final validTimebots4 = ["卯"];

    final validSubjects5 = ["辰"];
    final validTimebots5 = ["子"];

    final validSubjects6 = ["巳"];
    final validTimebots6 = ["酉"];

    final validSubjects7 = ["午"];
    final validTimebots7 = ["午"];

    final validSubjects8 = ["未"];
    final validTimebots8 = ["卯"];

    final validSubjects9 = ["申"];
    final validTimebots9 = ["子"];

    final validSubjects10 = ["酉"];
    final validTimebots10 = ["酉"];

    final validSubjects11 = ["戌"];
    final validTimebots11 = ["午"];

    final validSubjects12 = ["亥"];
    final validTimebots12 = ["卯"];

    // Check the first pair
    if (validSubjects1.contains(yearOrdayBot) &&
        validTimebots1.contains(timebot)) {
      result = "將星";
    } else if (validSubjects2.contains(yearOrdayBot) &&
        validTimebots2.contains(timebot)) {
      result = "將星";
    } else if (validSubjects3.contains(yearOrdayBot) &&
        validTimebots3.contains(timebot)) {
      result = "將星";
    } else if (validSubjects4.contains(yearOrdayBot) &&
        validTimebots4.contains(timebot)) {
      result = "將星";
    } else if (validSubjects5.contains(yearOrdayBot) &&
        validTimebots5.contains(timebot)) {
      result = "將星";
    } else if (validSubjects6.contains(yearOrdayBot) &&
        validTimebots6.contains(timebot)) {
      result = "將星";
    } else if (validSubjects7.contains(yearOrdayBot) &&
        validTimebots7.contains(timebot)) {
      result = "將星";
    } else if (validSubjects8.contains(yearOrdayBot) &&
        validTimebots8.contains(timebot)) {
      result = "將星";
    } else if (validSubjects9.contains(yearOrdayBot) &&
        validTimebots9.contains(timebot)) {
      result = "將星";
    } else if (validSubjects10.contains(yearOrdayBot) &&
        validTimebots10.contains(timebot)) {
      result = "將星";
    } else if (validSubjects11.contains(yearOrdayBot) &&
        validTimebots11.contains(timebot)) {
      result = "將星";
    } else if (validSubjects12.contains(yearOrdayBot) &&
        validTimebots12.contains(timebot)) {
      result = "將星";
    }

    return result;
  }
}
