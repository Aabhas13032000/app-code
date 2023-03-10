part of screens;

class CalorieWorkoutPage extends StatefulWidget {
  final bool isAddFood;
  final String date;
  const CalorieWorkoutPage({
    Key? key,
    required this.isAddFood,
    required this.date,
  }) : super(key: key);

  @override
  State<CalorieWorkoutPage> createState() => _CalorieWorkoutPageState();
}

class _CalorieWorkoutPageState extends State<CalorieWorkoutPage> {
  String dropdownValue = '';
  var months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  var number = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  bool isLoading = false;
  double height = 100.0;
  FocusNode focus = FocusNode();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String mainDate = '';
  DateTime selectedDate = DateTime.now();
  DateTime todaysDate = DateTime.now();
  List<UsersExercise> exerciseCalories = [];
  List<Exercise> searchedExercise = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController setController = TextEditingController();
  TextEditingController perSetController = TextEditingController();
  TextEditingController minController = TextEditingController();
  TextEditingController weightSetController = TextEditingController();
  Exercise selectedSearchedExerciseItem = Exercise();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: mainDate == 'Today'
          ? DateTime.parse(todaysDate.toString().substring(0, 10))
          : DateTime.parse(mainDate),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.parse(todaysDate.toString().substring(0, 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.highlight,
              onPrimary: AppColors.richBlack,
              onSurface: AppColors.richBlack,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.richBlack, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      setState(() {
        _selectedDay = selectedDate;
        _focusedDay = selectedDate;
      });
      getCurrentDateData(selectedDate.toString().substring(0, 10), false);
    }
  }

  void getCurrentDateData(String newDate, bool isAddFood) async {
    Utility.showProgress(true);
    String url =
        '${Constants.finalUrl}/getWorkoutCalorieData?user_id=${Application.user?.id}&date=$newDate';
    Map<String, dynamic> currentDateData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = currentDateData['status'];
    var data = currentDateData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        exerciseCalories.clear();
        var actualToday = DateTime.now();
        var today = DateTime.parse(newDate);
        if (today.toString().substring(0, 10) ==
            actualToday.toString().substring(0, 10)) {
          mainDate = 'Today';
        } else {
          mainDate = newDate;
        }
        data[ApiKeys.userExercise].forEach((userExercise) {
          var calorie = UsersExercise.fromJson(userExercise);
          exerciseCalories.add(calorie);
        });
        Utility.showProgress(false);
        setState(() {
          isLoading = true;
        });
        if (isAddFood) {
          searchExercise();
        }
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
        setState(() {
          isLoading = true;
        });
      } else {
        Utility.showProgress(false);
        showSnackBar(data[ApiKeys.message].toString(), AppColors.lightRed,
            AppColors.warning, 50.0);
      }
      Utility.showProgress(false);
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
    }
  }

  void showSnackBar(String message, Color bgColor, Color title, double height) {
    Utility.showSnacbar(
      context,
      message,
      bgColor,
      title,
      duration: 2,
      height,
    );
  }

  void getData() async {
    perSetController = TextEditingController();
    perSetController.text = '0';
    minController = TextEditingController();
    minController.text = '0';
    weightSetController = TextEditingController();
    weightSetController.text = '0';
    DateTime now = DateTime.now();
    if (widget.date != 'Today') {
      var date = DateTime.parse(widget.date);
      setState(() {
        _selectedDay = date;
        _focusedDay = date;
        mainDate = widget.date;
      });
      getCurrentDateData(mainDate, widget.isAddFood);
    } else {
      setState(() {
        _selectedDay = now;
        _focusedDay = now;
        mainDate = widget.date;
      });
      getCurrentDateData(now.toString().substring(0, 10), widget.isAddFood);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void goBack() {
    Utility.printLog('back button clicked');
    if (Provider.of<DeepLink>(context, listen: false).deepLinkUrl.isNotEmpty) {
      context.read<DeepLink>().setDeepLinkUrl('');
      Get.offAll(
        () => const MainContainer(),
      );
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goBack();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.cardBg,
        appBar: CustomAppBar(
          preferredSize: const Size.fromHeight(70.0),
          showLeadingIcon: true,
          centerTitle: true,
          opacity: 0.0,
          bgColor: AppColors.cardBg,
          title: Column(
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Text(
                  mainDate,
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 16.0,
                    fontFamily: Fonts.helixSemiBold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.5,
                horizontal: 20.0,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    () => const CartPage(),
                  );
                },
                child: const CustomIcon(
                  icon: MdiIcons.cartOutline,
                  borderWidth: 2.0,
                  borderColor: AppColors.defaultInputBorders,
                  isShowDot: true,
                  radius: 45.0,
                  iconSize: 24.0,
                  iconColor: AppColors.richBlack,
                  top: 8.0,
                  right: 8.0,
                  borderRadius: 8.0,
                ),
              ),
            ),
          ],
          leadingWidget: Padding(
            padding: const EdgeInsets.only(
              top: 12.5,
              left: 20.0,
              bottom: 12.5,
              right: 0.0,
            ),
            child: GestureDetector(
              onTap: () {
                goBack();
              },
              child: const CustomIcon(
                icon: Icons.arrow_back_ios_rounded,
                borderWidth: 2.0,
                borderColor: AppColors.defaultInputBorders,
                isShowDot: false,
                radius: 45.0,
                iconSize: 20.0,
                iconColor: AppColors.richBlack,
                top: 8.0,
                right: 8.0,
                borderRadius: 8.0,
              ),
            ),
          ),
          leadingWidth: 65.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Container(
              height: 0.0,
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.richBlack.withOpacity(0.06),
                blurRadius: 30.0, // soften the shadow
                spreadRadius: 0.0, //extend the shadow
                offset: const Offset(
                  0.0, // Move to right 10  horizontally
                  -4.5, // Move to bottom 10 Vertically
                ),
              ),
            ],
          ),
          height: 70.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.5,
              horizontal: 20.0,
            ),
            child: CustomButton(
              title: 'Add a new entry',
              paddingVertical: 10.5,
              paddingHorizontal: 13.5,
              borderRadius: 8.0,
              onPressed: () {
                searchExercise();
              },
            ),
          ),
        ),
        body: !isLoading
            ? Container()
            : Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 90.0,
                    color: AppColors.transparent,
                    child: TableCalendar(
                      rowHeight: 60.0,
                      daysOfWeekHeight: 30.0,
                      formatAnimationCurve: Curves.easeIn,
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      calendarStyle: const CalendarStyle(
                        cellMargin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 6.0),
                        cellPadding: EdgeInsets.all(0.0),
                        rowDecoration: BoxDecoration(
                          color: AppColors.transparent,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: TextStyle(
                          color: AppColors.subText,
                          fontSize: 18.0,
                          fontFamily: Fonts.helixMedium,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        holidayTextStyle: TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 18.0,
                          fontFamily: Fonts.helixMedium,
                        ),
                        weekendTextStyle: TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 18.0,
                          fontFamily: Fonts.helixMedium,
                        ),
                        rangeEndTextStyle: TextStyle(
                          color: AppColors.placeholder,
                          fontSize: 18.0,
                          fontFamily: Fonts.helixMedium,
                        ),
                        todayTextStyle: TextStyle(
                          color: AppColors.subText,
                          fontSize: 18.0,
                          fontFamily: Fonts.helixMedium,
                        ),
                        defaultTextStyle: TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 18.0,
                          fontFamily: Fonts.helixMedium,
                        ),
                        disabledTextStyle: TextStyle(
                          color: AppColors.placeholder,
                          fontSize: 18.0,
                          fontFamily: Fonts.helixMedium,
                        ),
                      ),
                      headerVisible: false,
                      calendarFormat: CalendarFormat.week,
                      calendarBuilders: CalendarBuilders(
                        dowBuilder: (context, day) {
                          final text = DateFormat.E().format(day);
                          return Center(
                            child: Text(
                              text,
                              style: const TextStyle(
                                color: AppColors.subText,
                                fontSize: 16.0,
                                fontFamily: Fonts.helixMedium,
                              ),
                            ),
                          );
                        },
                      ),
                      // rangeSelectionMode: _rangeSelectionMode,
                      onDaySelected: (selectedDay, focusedDay) {
                        var selected = number.indexWhere(
                            (element) => element == focusedDay.month);
                        if (todaysDate.toString().substring(0, 10) ==
                            selectedDay.toString().substring(0, 10)) {
                          setState(() {
                            mainDate = 'Today';
                          });
                        } else {
                          setState(() {
                            mainDate = selectedDay.toString().substring(0, 10);
                          });
                        }
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            _rangeStart = null; // Important to clean those
                            _rangeEnd = null;
                            _rangeSelectionMode = RangeSelectionMode.toggledOff;
                          });
                        }
                        getCurrentDateData(
                            selectedDay.toString().substring(0, 10), false);
                      },
                      onRangeSelected: (start, end, focusedDay) {
                        setState(() {
                          _selectedDay = null;
                          _focusedDay = focusedDay;
                          _rangeStart = start;
                          _rangeEnd = end;
                          _rangeSelectionMode = RangeSelectionMode.toggledOn;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        var selected = number.indexWhere(
                            (element) => element == focusedDay.month);
                        setState(() {
                          dropdownValue = months[selected];
                        });
                        _focusedDay = focusedDay;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        color: AppColors.background,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.richBlack.withOpacity(0.06),
                            blurRadius: 20.0, // soften the shadow
                            spreadRadius: 0.0, //extend the shadow
                            offset: const Offset(
                              0.0, // Move to right 10  horizontally
                              -4.0, // Move to bottom 10 Vertically
                            ),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        child: exerciseCalories.isEmpty
                            ? Column(
                                children: const [
                                  Expanded(
                                    child: Center(
                                      child: NoDataAvailable(
                                        message: 'No entries available!!',
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    const Text(
                                      'See your workout log here',
                                      style: TextStyle(
                                        color: AppColors.richBlack,
                                        fontSize: 16.0,
                                        fontFamily: Fonts.gilroySemiBold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: exerciseCalories.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                            bottom: 15.0,
                                          ),
                                          child: calorieCard(
                                              exerciseCalories[index], index),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  void removeItem(String id, int index) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "id": id,
    };
    String url = '${Constants.finalUrl}/removeFromUserExerciseCalories';
    Map<String, dynamic> updateSessionCount =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = updateSessionCount['status'];
    var data = updateSessionCount['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(24), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        exerciseCalories.removeAt(index);
        Provider.of<MainContainerProvider>(context, listen: false)
            .setRefreshValue(true);
        setState(() {});
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
      } else {
        Utility.showProgress(false);
        showSnackBar(data[ApiKeys.message].toString(), AppColors.lightRed,
            AppColors.warning, 50.0);
      }
      Utility.showProgress(false);
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
    }
  }

  Widget calorieCard(UsersExercise calorie, int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 1.5, color: AppColors.defaultInputBorders),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircularAvatar(
              url: Constants.imgFinalUrl +
                  (calorie.coverPhoto ?? "/images/local/logo.png"),
              radius: 45.0,
              borderColor: AppColors.highlight,
              borderWidth: 0.0,
              isShowBorder: false,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${calorie.name}',
                    // '${calorie.name} (${calorie.set} sets and ${calorie.perset} repetitions with ${calorie.weight} Kgs weight)',
                    style: const TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 14.0,
                      fontFamily: Fonts.gilroyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  // Text(
                  //   '${calorie.calories} kcal',
                  //   style: const TextStyle(
                  //     color: AppColors.subText,
                  //     fontSize: 16.0,
                  //     fontFamily: Fonts.gilroySemiBold,
                  //   ),
                  // )
                  Text(
                    '${(calorie.sets ?? 0) > 0 ? calorie.sets == 1 ? ('${calorie.sets} set') : ('${calorie.sets} sets') : ''} ${(calorie.perset ?? 0) > 0 ? (', ${calorie.perset} repetitions') : ''} ${(calorie.min ?? 0) > 0 ? (', ${calorie.min} mins') : ''} ${(calorie.weight ?? 0) > 0 ? (', ${calorie.weight} Kgs weight') : ''}',
                    style: const TextStyle(
                      color: AppColors.subText,
                      fontSize: 16.0,
                      fontFamily: Fonts.gilroySemiBold,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedSearchedExerciseItem.id = calorie.exerciseId;
                  selectedSearchedExerciseItem.name = calorie.name;
                  selectedSearchedExerciseItem.calories =
                      calorie.exerciseCalories;
                  selectedSearchedExerciseItem.perset = calorie.exercisePerset;
                  selectedSearchedExerciseItem.sets = calorie.exerciseSet;
                  selectedSearchedExerciseItem.coverPhoto = calorie.coverPhoto;
                  selectedSearchedExerciseItem.description =
                      calorie.description;
                  selectedSearchedExerciseItem.cat = calorie.cat;
                  selectedSearchedExerciseItem.status = 1;
                  selectedSearchedExerciseItem.weight = calorie.weight;
                  setController.text = (calorie.sets ?? 0).toString();
                  perSetController.text = (calorie.perset ?? 0).toString();
                  weightSetController.text = (calorie.weight ?? 0).toString();
                  minController.text = (calorie.min ?? 0).toString();
                });
                addExercise(true, calorie.id);
              },
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: AppColors.highlight,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: const Center(
                  child: Icon(
                    Icons.edit_outlined,
                    size: 20.0,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            GestureDetector(
              onTap: () {
                Utility.twoButtonPopup(
                    context,
                    Icons.warning_amber_rounded,
                    40.0,
                    AppColors.warning,
                    AlertMessages.getMessage(25),
                    'No',
                    'Yes', onFirstButtonClicked: () {
                  Get.back();
                }, onSecondButtonClicked: () {
                  Get.back();
                  removeItem(calorie.id, index);
                });
              },
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: const Center(
                  child: Icon(
                    Icons.delete_outline,
                    size: 20.0,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchExerciseItem(String value) async {
    Utility.showProgress(true);
    String url = '${Constants.finalUrl}/getSearchExercise?searchedTitle=$value';
    Map<String, dynamic> bookData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = bookData['status'];
    var data = bookData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        searchedExercise.clear();
        data[ApiKeys.data].forEach((item) => {
              searchedExercise.add(Exercise.fromJson(item)),
            });
        setState(() {});
        setSearchedExerciseContent();
        Utility.showProgress(false);
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
        setState(() {
          isLoading = true;
        });
      } else {
        Utility.showProgress(false);
        showSnackBar(data[ApiKeys.message].toString(), AppColors.lightRed,
            AppColors.warning, 50.0);
      }
      Utility.showProgress(false);
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
    }
  }

  void setSearchedExerciseContent() {
    Provider.of<MainContainerProvider>(context, listen: false)
        .setSearchedExercise(searchedExercise);
  }

  void searchExercise() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.0),
      enableDrag: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) => Container(
            height: 570.0,
            color: AppColors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const CustomIcon(
                    icon: Icons.close,
                    borderWidth: 0.0,
                    borderColor: AppColors.highlight,
                    isShowDot: false,
                    radius: 60.0,
                    iconSize: 30.0,
                    iconColor: AppColors.white,
                    top: 0,
                    right: 0,
                    borderRadius: 50.0,
                    isShowBorder: false,
                    bgColor: AppColors.highlight,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxHeight: 500.0, minHeight: 500.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.0,
                            child: TextField(
                              autofocus: false,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                color: AppColors.richBlack,
                                fontSize: 16.0,
                                fontFamily: Fonts.gilroyMedium,
                              ),
                              controller: searchController,
                              cursorColor: AppColors.defaultInputBorders,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.search,
                              cursorWidth: 1.5,
                              onSubmitted: (value) {
                                if (value.isEmpty) {
                                  searchedExercise.clear();
                                  setState(() {});
                                } else {
                                  searchExerciseItem(value);
                                }
                              },
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  searchedExercise.clear();
                                  setState(() {});
                                }
                              },
                              decoration: InputDecoration(
                                hintMaxLines: 1,
                                hintText: 'Search by exercise name',
                                counterText: '',
                                contentPadding:
                                    const EdgeInsets.only(top: 20.0),
                                prefixIcon: const Center(
                                  child: Icon(
                                    Icons.search_sharp,
                                    size: 24.0,
                                    color: AppColors.subText,
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minHeight: 55.0,
                                  minWidth: 50.0,
                                  maxHeight: 55.0,
                                  maxWidth: 50.0,
                                ),
                                hintStyle: const TextStyle(
                                  color: AppColors.placeholder,
                                  fontSize: 16.0,
                                  fontFamily: Fonts.gilroyMedium,
                                ),
                                focusColor: AppColors.placeholder,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: AppColors.highlight,
                                    width: 2.0,
                                  ),
                                ),
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: AppColors.defaultInputBorders,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          context
                                  .watch<MainContainerProvider>()
                                  .searchedExercise
                                  .isEmpty
                              ? searchController.text.isNotEmpty
                                  ? const Expanded(
                                      child: Center(
                                        child: NoDataAvailable(
                                          message: 'No item available!!',
                                        ),
                                      ),
                                    )
                                  : const SizedBox()
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: context
                                        .watch<MainContainerProvider>()
                                        .searchedExercise
                                        .length,
                                    itemBuilder: (context, index) {
                                      return searchCard(
                                          context
                                              .watch<MainContainerProvider>()
                                              .searchedExercise[index],
                                          true,
                                          false,
                                          index);
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addExerciseItem() async {
    if (setController.text.isNotEmpty) {
      Get.back();
      var caloriesTotal;
      if (selectedSearchedExerciseItem.weight != 0 &&
          double.parse(weightSetController.text) != 0) {
        caloriesTotal = (double.parse(setController.text) /
                    (selectedSearchedExerciseItem.sets ?? 1))
                .ceil() *
            (double.parse(perSetController.text) /
                    (selectedSearchedExerciseItem.perset ?? 1))
                .ceil() *
            (selectedSearchedExerciseItem.calories ?? 0) *
            (double.parse(weightSetController.text) /
                (selectedSearchedExerciseItem.weight ?? 1));
      } else {
        caloriesTotal = (double.parse(setController.text) /
                    (selectedSearchedExerciseItem.sets ?? 1))
                .ceil() *
            (double.parse(perSetController.text) /
                    (selectedSearchedExerciseItem.perset ?? 1))
                .ceil() *
            (selectedSearchedExerciseItem.calories ?? 0);
      }
      Map<String, String> params = {
        "user_id": Application.user?.id ?? '0',
        "exercise_id": selectedSearchedExerciseItem.id ?? '',
        "set": setController.text,
        "perset": perSetController.text.isEmpty ? '0' : perSetController.text,
        "calories": caloriesTotal.toString(),
        "date": mainDate == 'Today'
            ? ('${todaysDate.toString().substring(0, 10)} 00:00:00')
            : ('$mainDate 00:00:00'),
        "weight":
            weightSetController.text.isEmpty ? '0' : weightSetController.text,
        "min": minController.text.isEmpty ? '0' : minController.text,
      };
      String url = '${Constants.finalUrl}/addExercise';
      Map<String, dynamic> updateSessionCount =
          await ApiFunctions.postApiResult(
              url, Application.deviceToken, params);
      bool status = updateSessionCount['status'];
      var data = updateSessionCount['data'];
      if (status) {
        if (data[ApiKeys.message].toString() == 'success') {
          Utility.showProgress(false);
          showSnackBar(AlertMessages.getMessage(31), AppColors.lightGreen,
              AppColors.congrats, 50.0);
          setState(() {
            selectedSearchedExerciseItem = Exercise();
            setController.text = '';
            perSetController.text = '0';
            weightSetController.text = '0';
            minController.text = '0';
          });
          Provider.of<MainContainerProvider>(context, listen: false)
              .setRefreshValue(true);
          getCurrentDateData(
              mainDate == 'Today'
                  ? todaysDate.toString().substring(0, 10)
                  : mainDate,
              false);
        } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
            data[ApiKeys.message].toString() == 'Database_connection_error') {
          Utility.showProgress(false);
          showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
              AppColors.warning, 50.0);
        }
        Utility.showProgress(false);
      } else {
        Utility.printLog('Something went wrong while saving token.');
        Utility.printLog('Some error occurred');
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
      }
    } else {
      Utility.singleButtonPopup(
          context,
          Icons.warning_amber_rounded,
          40.0,
          AppColors.warning,
          AlertMessages.getMessage(29),
          'Ok', onButtonClicked: () {
        Get.back();
      });
    }
  }

  void editExerciseItem(String id) async {
    if (setController.text.isNotEmpty) {
      Get.back();
      var caloriesTotal;
      if (selectedSearchedExerciseItem.weight != 0 &&
          double.parse(weightSetController.text) != 0) {
        caloriesTotal = (double.parse(setController.text) /
                    (selectedSearchedExerciseItem.sets ?? 1))
                .ceil() *
            (double.parse(perSetController.text) /
                    (selectedSearchedExerciseItem.perset ?? 1))
                .ceil() *
            (selectedSearchedExerciseItem.calories ?? 0) *
            (double.parse(weightSetController.text) /
                (selectedSearchedExerciseItem.weight ?? 1));
      } else {
        caloriesTotal = (double.parse(setController.text) /
                    (selectedSearchedExerciseItem.sets ?? 1))
                .ceil() *
            (double.parse(perSetController.text) /
                    (selectedSearchedExerciseItem.perset ?? 1))
                .ceil() *
            (selectedSearchedExerciseItem.calories ?? 0);
      }
      Map<String, String> params = {
        "set": setController.text,
        "perset": perSetController.text.isEmpty ? '0' : perSetController.text,
        "calories": caloriesTotal.toString(),
        "weight":
            weightSetController.text.isEmpty ? '0' : weightSetController.text,
        "min": minController.text.isEmpty ? '0' : minController.text,
        "id": id,
      };
      String url = '${Constants.finalUrl}/editExercise';
      Map<String, dynamic> updateSessionCount =
          await ApiFunctions.postApiResult(
              url, Application.deviceToken, params);
      bool status = updateSessionCount['status'];
      var data = updateSessionCount['data'];
      if (status) {
        if (data[ApiKeys.message].toString() == 'success') {
          Utility.showProgress(false);
          showSnackBar(AlertMessages.getMessage(31), AppColors.lightGreen,
              AppColors.congrats, 50.0);
          setState(() {
            selectedSearchedExerciseItem = Exercise();
            setController.text = '';
            perSetController.text = '0';
            weightSetController.text = '0';
            minController.text = '0';
          });
          Provider.of<MainContainerProvider>(context, listen: false)
              .setRefreshValue(true);
          getCurrentDateData(
              mainDate == 'Today'
                  ? todaysDate.toString().substring(0, 10)
                  : mainDate,
              false);
        } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
            data[ApiKeys.message].toString() == 'Database_connection_error') {
          Utility.showProgress(false);
          showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
              AppColors.warning, 50.0);
        }
        Utility.showProgress(false);
      } else {
        Utility.printLog('Something went wrong while saving token.');
        Utility.printLog('Some error occurred');
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
      }
    } else {
      Utility.singleButtonPopup(
          context,
          Icons.warning_amber_rounded,
          40.0,
          AppColors.warning,
          AlertMessages.getMessage(29),
          'Ok', onButtonClicked: () {
        Get.back();
      });
    }
  }

  void addExercise(bool isEdit, String id) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.0),
      enableDrag: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) => Container(
            color: AppColors.transparent,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MediaQuery.of(context).viewInsets.bottom != 0
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const CustomIcon(
                            icon: Icons.close,
                            borderWidth: 0.0,
                            borderColor: AppColors.highlight,
                            isShowDot: false,
                            radius: 60.0,
                            iconSize: 30.0,
                            iconColor: AppColors.white,
                            top: 0,
                            right: 0,
                            borderRadius: 50.0,
                            isShowBorder: false,
                            bgColor: AppColors.highlight,
                          ),
                        ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxHeight: 480.0, minHeight: 200.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              const Text(
                                'Selected exercise item',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: Fonts.gilroyMedium,
                                  color: AppColors.richBlack,
                                ),
                              ),
                              searchCard(selectedSearchedExerciseItem, false,
                                  isEdit, 0),
                              const SizedBox(
                                height: 0.0,
                              ),
                              const Text(
                                'Sets',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: Fonts.gilroyMedium,
                                  color: AppColors.richBlack,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 55.0,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  style: const TextStyle(
                                    color: AppColors.richBlack,
                                    fontSize: 16.0,
                                    fontFamily: Fonts.gilroyMedium,
                                  ),
                                  controller: setController,
                                  cursorColor: AppColors.defaultInputBorders,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"[0-9]")),
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      try {
                                        final text = newValue.text;
                                        if (text.isNotEmpty) double.parse(text);
                                        return newValue;
                                      } catch (e) {}
                                      return oldValue;
                                    }),
                                  ],
                                  textInputAction: TextInputAction.done,
                                  maxLength: 7,
                                  cursorWidth: 1.5,
                                  decoration: InputDecoration(
                                    hintMaxLines: 1,
                                    hintText: 'Enter no. of sets',
                                    counterText: '',
                                    contentPadding: const EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 20.0,
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    hintStyle: const TextStyle(
                                      color: AppColors.placeholder,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroyMedium,
                                    ),
                                    focusColor: AppColors.placeholder,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.highlight,
                                        width: 1.5,
                                      ),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.defaultInputBorders,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              const Text(
                                'Number of repetations',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: Fonts.gilroyMedium,
                                  color: AppColors.richBlack,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 55.0,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  style: const TextStyle(
                                    color: AppColors.richBlack,
                                    fontSize: 16.0,
                                    fontFamily: Fonts.gilroyMedium,
                                  ),
                                  controller: perSetController,
                                  cursorColor: AppColors.defaultInputBorders,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"[0-9]")),
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      try {
                                        final text = newValue.text;
                                        if (text.isNotEmpty) double.parse(text);
                                        return newValue;
                                      } catch (e) {}
                                      return oldValue;
                                    }),
                                  ],
                                  textInputAction: TextInputAction.done,
                                  maxLength: 7,
                                  cursorWidth: 1.5,
                                  decoration: InputDecoration(
                                    hintMaxLines: 1,
                                    hintText: 'Enter no. of repetations',
                                    counterText: '',
                                    contentPadding: const EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 20.0,
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    hintStyle: const TextStyle(
                                      color: AppColors.placeholder,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroyMedium,
                                    ),
                                    focusColor: AppColors.placeholder,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.highlight,
                                        width: 1.5,
                                      ),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.defaultInputBorders,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              const Text(
                                'Total duration',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: Fonts.gilroyMedium,
                                  color: AppColors.richBlack,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 55.0,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  style: const TextStyle(
                                    color: AppColors.richBlack,
                                    fontSize: 16.0,
                                    fontFamily: Fonts.gilroyMedium,
                                  ),
                                  controller: minController,
                                  cursorColor: AppColors.defaultInputBorders,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"[0-9.]")),
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      try {
                                        final text = newValue.text;
                                        if (text.isNotEmpty) double.parse(text);
                                        return newValue;
                                      } catch (e) {}
                                      return oldValue;
                                    }),
                                  ],
                                  textInputAction: TextInputAction.done,
                                  maxLength: 7,
                                  cursorWidth: 1.5,
                                  decoration: InputDecoration(
                                    hintMaxLines: 1,
                                    hintText: 'Enter total duration (in mins)',
                                    counterText: '',
                                    contentPadding: const EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 20.0,
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    hintStyle: const TextStyle(
                                      color: AppColors.placeholder,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroyMedium,
                                    ),
                                    suffixIcon: const Center(
                                      child: Text(
                                        'min',
                                        style: TextStyle(
                                          color: AppColors.subText,
                                          fontSize: 16.0,
                                          fontFamily: Fonts.gilroySemiBold,
                                        ),
                                      ),
                                    ),
                                    suffixIconConstraints: const BoxConstraints(
                                      minHeight: 55.0,
                                      minWidth: 50.0,
                                      maxHeight: 55.0,
                                      maxWidth: 50.0,
                                    ),
                                    focusColor: AppColors.placeholder,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.highlight,
                                        width: 1.5,
                                      ),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.defaultInputBorders,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              const Text(
                                'Weight',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: Fonts.gilroyMedium,
                                  color: AppColors.richBlack,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 55.0,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  style: const TextStyle(
                                    color: AppColors.richBlack,
                                    fontSize: 16.0,
                                    fontFamily: Fonts.gilroyMedium,
                                  ),
                                  controller: weightSetController,
                                  cursorColor: AppColors.defaultInputBorders,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"[0-9.]")),
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      try {
                                        final text = newValue.text;
                                        if (text.isNotEmpty) double.parse(text);
                                        return newValue;
                                      } catch (e) {}
                                      return oldValue;
                                    }),
                                  ],
                                  textInputAction: TextInputAction.done,
                                  maxLength: 7,
                                  cursorWidth: 1.5,
                                  decoration: InputDecoration(
                                    hintMaxLines: 1,
                                    hintText: 'Enter total weight used',
                                    counterText: '',
                                    contentPadding: const EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 20.0,
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    hintStyle: const TextStyle(
                                      color: AppColors.placeholder,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroyMedium,
                                    ),
                                    suffixIcon: const Center(
                                      child: Text(
                                        'kg',
                                        style: TextStyle(
                                          color: AppColors.subText,
                                          fontSize: 16.0,
                                          fontFamily: Fonts.gilroySemiBold,
                                        ),
                                      ),
                                    ),
                                    suffixIconConstraints: const BoxConstraints(
                                      minHeight: 55.0,
                                      minWidth: 50.0,
                                      maxHeight: 55.0,
                                      maxWidth: 50.0,
                                    ),
                                    focusColor: AppColors.placeholder,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.highlight,
                                        width: 1.5,
                                      ),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.defaultInputBorders,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              CustomButton(
                                title: isEdit ? 'Save' : 'Add',
                                paddingVertical: 10.5,
                                paddingHorizontal: 13.5,
                                borderRadius: 8.0,
                                isShowBorder: true,
                                onPressed: () {
                                  if (isEdit) {
                                    editExerciseItem(id);
                                  } else {
                                    addExerciseItem();
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void removeSelectedExerciseItem() {
    setState(() {
      selectedSearchedExerciseItem = Exercise();
    });
    searchExercise();
  }

  Widget searchCard(Exercise searchedExerciseItem, bool isSearchCard,
      bool isEditCard, int index) {
    return GestureDetector(
      onTap: () {
        if (isSearchCard && !isEditCard) {
          setState(() {
            searchedExercise.clear();
            selectedSearchedExerciseItem = searchedExerciseItem;
            searchController.text = '';
          });
          Get.back();
          addExercise(false, '');
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          top: index == 0 ? 20.0 : 0.0,
          bottom: 15.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(width: 1.5, color: AppColors.defaultInputBorders),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircularAvatar(
                    url: Constants.imgFinalUrl +
                        (searchedExerciseItem.coverPhoto ??
                            "/images/local/logo.png"),
                    radius: 45.0,
                    borderColor: AppColors.highlight,
                    borderWidth: 0.0,
                    isShowBorder: false,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          searchedExerciseItem.name ?? '',
                          // '${searchedExerciseItem.name} (${searchedExerciseItem.set} set and ${searchedExerciseItem.perset} repetitions and ${searchedExerciseItem.weight} Kgs weight)',
                          style: const TextStyle(
                            color: AppColors.richBlack,
                            fontSize: 14.0,
                            fontFamily: Fonts.gilroyMedium,
                          ),
                        ),
                        // const SizedBox(
                        //   height: 5.0,
                        // ),
                        // Text(
                        //   '${searchedExerciseItem.calories} kcal',
                        //   style: const TextStyle(
                        //     color: AppColors.subText,
                        //     fontSize: 16.0,
                        //     fontFamily: Fonts.gilroySemiBold,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: isSearchCard ? 0.0 : 10.0,
                  ),
                  isSearchCard
                      ? const SizedBox()
                      : isEditCard
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: () {
                                Utility.twoButtonPopup(
                                    context,
                                    Icons.warning_amber_rounded,
                                    40.0,
                                    AppColors.warning,
                                    AlertMessages.getMessage(26),
                                    'No',
                                    'Yes', onFirstButtonClicked: () {
                                  Get.back();
                                }, onSecondButtonClicked: () {
                                  Get.back();
                                  Get.back();
                                  removeSelectedExerciseItem();
                                });
                              },
                              child: Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.delete_outline,
                                    size: 20.0,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
