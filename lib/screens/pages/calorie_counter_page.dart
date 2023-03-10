part of screens;

class CurrentDate {
  final String month;
  final int number;

  CurrentDate({required this.month, required this.number});
}

class CalorieCounterPage extends StatefulWidget {
  final bool isAddFood;
  String? meal;
  final String date;
  CalorieCounterPage({
    Key? key,
    required this.isAddFood,
    this.meal = 'All',
    required this.date,
  }) : super(key: key);

  @override
  State<CalorieCounterPage> createState() => _CalorieCounterPageState();
}

class _CalorieCounterPageState extends State<CalorieCounterPage> {
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
  bool isFocused = true;
  bool isBreakfastExpanded = false;
  bool isSnacksExpanded = false;
  bool isLunchExpanded = false;
  bool isDinnerExpanded = false;
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
  int breakfast = 0;
  int snacks = 0;
  int lunch = 0;
  int dinner = 0;
  int total = 0;
  List<UsersCalories> breakfastCalories = [];
  List<UsersCalories> snacksCalories = [];
  List<UsersCalories> lunchCalories = [];
  List<UsersCalories> dinnerCalories = [];
  List<Food> searchedFood = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController servingsController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  Food selectedSearchedFoodItem = Food();
  String mealDropdownValue = 'BREAKFAST';
  List<String> meals = ['BREAKFAST', 'SNACKS', 'LUNCH', 'DINNER'];

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
        '${Constants.finalUrl}/getFoodCalorieData?user_id=${Application.user?.id}&date=$newDate';
    Map<String, dynamic> currentDateData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = currentDateData['status'];
    var data = currentDateData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        breakfastCalories.clear();
        snacksCalories.clear();
        lunchCalories.clear();
        dinnerCalories.clear();
        var actualToday = DateTime.now();
        var today = DateTime.parse(newDate);
        if (today.toString().substring(0, 10) ==
            actualToday.toString().substring(0, 10)) {
          mainDate = 'Today';
        } else {
          mainDate = newDate;
        }
        breakfast = 0;
        lunch = 0;
        dinner = 0;
        snacks = 0;
        data[ApiKeys.userCalories].forEach((userCalorie) {
          var calorie = UsersCalories.fromJson(userCalorie);
          if (calorie.meal == 'BREAKFAST') {
            breakfastCalories.add(calorie);
            breakfast = breakfast + (calorie.calories ?? 0).ceil();
          }
          if (calorie.meal == 'LUNCH') {
            lunchCalories.add(calorie);
            lunch = lunch + (calorie.calories ?? 0.0).ceil();
          }
          if (calorie.meal == 'DINNER') {
            dinnerCalories.add(calorie);
            dinner = dinner + (calorie.calories ?? 0.0).ceil();
          }
          if (calorie.meal == 'SNACKS') {
            snacksCalories.add(calorie);
            snacks = snacks + (calorie.calories ?? 0.0).ceil();
          }
        });
        total = breakfast + lunch + dinner + snacks;
        Utility.showProgress(false);
        if (widget.meal != 'All') {
          onExpansionChange(widget.meal ?? 'breakfast');
        }
        setState(() {
          isLoading = true;
        });
        if (isAddFood) {
          searchFood('All');
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
    _onFocusChange();
    DateTime now = DateTime.now();
    if (widget.date != 'Today') {
      var date = DateTime.parse(widget.date);
      setState(() {
        _selectedDay = date;
        _focusedDay = date;
        mainDate = widget.date;
        mealDropdownValue = widget.meal ?? "BREAKFAST";
      });
      getCurrentDateData(mainDate, widget.isAddFood);
    } else {
      setState(() {
        _selectedDay = now;
        _focusedDay = now;
        mainDate = widget.date;
        mealDropdownValue = widget.meal ?? "BREAKFAST";
      });
      getCurrentDateData(now.toString().substring(0, 10), widget.isAddFood);
    }
  }

  @override
  void initState() {
    super.initState();
    focus.addListener(_onFocusChange);
    getData();
  }

  void _onFocusChange() {
    if (isFocused) {
      setState(() {
        isFocused = false;
      });
    } else {
      setState(() {
        isFocused = true;
      });
    }
  }

  void onExpansionChange(String value) {
    if (value == 'breakfast') {
      if (isBreakfastExpanded) {
        setState(() {
          isBreakfastExpanded = false;
        });
      } else {
        setState(() {
          isBreakfastExpanded = true;
        });
      }
    } else if (value == 'snacks') {
      if (isSnacksExpanded) {
        setState(() {
          isSnacksExpanded = false;
        });
      } else {
        setState(() {
          isSnacksExpanded = true;
        });
      }
    } else if (value == 'lunch') {
      if (isLunchExpanded) {
        setState(() {
          isLunchExpanded = false;
        });
      } else {
        setState(() {
          isLunchExpanded = true;
        });
      }
    } else if (value == 'dinner') {
      if (isDinnerExpanded) {
        setState(() {
          isDinnerExpanded = false;
        });
      } else {
        setState(() {
          isDinnerExpanded = true;
        });
      }
    }
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
                searchFood('All');
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
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              expansionTile(-45, -55, Images.breakfast,
                                  'Breakfast', breakfast, breakfastCalories),
                              expansionTile(-50, -70, Images.snacks, 'Snacks',
                                  snacks, snacksCalories),
                              expansionTile(-45, -55, Images.lunch, 'Lunch',
                                  lunch, lunchCalories),
                              expansionTile(-45, -55, Images.dinner, 'Dinner',
                                  dinner, dinnerCalories),
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

  void searchFoodItem(String value) async {
    Utility.showProgress(true);
    String url = '${Constants.finalUrl}/getSearchFood?searchedTitle=$value';
    Map<String, dynamic> bookData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = bookData['status'];
    var data = bookData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        searchedFood.clear();
        data[ApiKeys.data].forEach((item) => {
              searchedFood.add(Food.fromJson(item)),
            });
        setState(() {});
        setSearchedFoodContent();
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

  void setSearchedFoodContent() {
    Provider.of<MainContainerProvider>(context, listen: false)
        .setSearchedFood(searchedFood);
  }

  void addFoodItem() async {
    if (servingsController.text.isNotEmpty) {
      Get.back();
      var caloriesTotal = (selectedSearchedFoodItem.calories ?? 0.0) *
          double.parse(servingsController.text);
      Map<String, String> params = {
        "user_id": Application.user?.id ?? '0',
        "food_id": selectedSearchedFoodItem.id ?? '',
        "meal": mealDropdownValue,
        "unit": selectedSearchedFoodItem.unit ?? "",
        "servings": servingsController.text,
        "calories": caloriesTotal.toString(),
        "date": mainDate == 'Today'
            ? ('${todaysDate.toString().substring(0, 10)} 00:00:00')
            : ('$mainDate 00:00:00')
      };
      String url = '${Constants.finalUrl}/addFood';
      Map<String, dynamic> updateSessionCount =
          await ApiFunctions.postApiResult(
              url, Application.deviceToken, params);
      bool status = updateSessionCount['status'];
      var data = updateSessionCount['data'];
      if (status) {
        if (data[ApiKeys.message].toString() == 'success') {
          Utility.showProgress(false);
          showSnackBar(AlertMessages.getMessage(27), AppColors.lightGreen,
              AppColors.congrats, 50.0);
          setState(() {
            selectedSearchedFoodItem = Food();
            servingsController.text = '';
            mealDropdownValue = 'BREAKFAST';
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

  void editFoodItem(String id) async {
    if (servingsController.text.isNotEmpty) {
      Get.back();
      var caloriesTotal = (selectedSearchedFoodItem.calories ?? 0.0) *
          double.parse(servingsController.text);
      Map<String, String> params = {
        "meal": mealDropdownValue,
        "unit": selectedSearchedFoodItem.unit ?? "",
        "servings": servingsController.text,
        "calories": caloriesTotal.toString(),
        "id": id,
      };
      String url = '${Constants.finalUrl}/editFood';
      Map<String, dynamic> updateSessionCount =
          await ApiFunctions.postApiResult(
              url, Application.deviceToken, params);
      bool status = updateSessionCount['status'];
      var data = updateSessionCount['data'];
      if (status) {
        if (data[ApiKeys.message].toString() == 'success') {
          Utility.showProgress(false);
          showSnackBar(AlertMessages.getMessage(56), AppColors.lightGreen,
              AppColors.congrats, 50.0);
          setState(() {
            selectedSearchedFoodItem = Food();
            servingsController.text = '';
            mealDropdownValue = 'BREAKFAST';
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

  void addFood(bool isEdit, String id) {
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
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                'Selected food item',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: Fonts.gilroyMedium,
                                  color: AppColors.richBlack,
                                ),
                              ),
                              searchCard(
                                  selectedSearchedFoodItem, false, isEdit, 0),
                              const SizedBox(
                                height: 5.0,
                              ),
                              const Text(
                                'Select Meal',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: Fonts.gilroyMedium,
                                  color: AppColors.richBlack,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    width: 1.5,
                                    color: AppColors.defaultInputBorders,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  child: DropdownButton(
                                    value: mealDropdownValue,
                                    elevation: 0,
                                    isExpanded: true,
                                    // alignment: Alignment.center,
                                    underline: Container(
                                      height: 0.0,
                                      width: 0.0,
                                      color: AppColors.transparent,
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.richBlack,
                                    ),
                                    items: meals.map((String item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              item,
                                              style: const TextStyle(
                                                color: AppColors.richBlack,
                                                fontSize: 16.0,
                                                fontFamily: Fonts.helixSemiBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        mealDropdownValue = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              const Text(
                                'Servings',
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
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    SizedBox(
                                      height: 55.0,
                                      child: TextField(
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: const TextStyle(
                                          color: AppColors.richBlack,
                                          fontSize: 16.0,
                                          fontFamily: Fonts.gilroyMedium,
                                        ),
                                        controller: servingsController,
                                        cursorColor:
                                            AppColors.defaultInputBorders,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r"[0-9.]")),
                                          TextInputFormatter.withFunction(
                                              (oldValue, newValue) {
                                            try {
                                              final text = newValue.text;
                                              if (text.isNotEmpty)
                                                double.parse(text);
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
                                          hintText: 'Enter no. of servings',
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
                                          suffixIcon: Center(
                                            child: Text(
                                              '* ${selectedSearchedFoodItem.quantity} ${selectedSearchedFoodItem.unit}',
                                              style: const TextStyle(
                                                color: AppColors.subText,
                                                fontSize: 16.0,
                                                fontFamily:
                                                    Fonts.gilroySemiBold,
                                              ),
                                            ),
                                          ),
                                          suffixIconConstraints:
                                              const BoxConstraints(
                                            minHeight: 55.0,
                                            minWidth: 120.0,
                                            maxHeight: 55.0,
                                            maxWidth: 150.0,
                                          ),
                                          focusColor: AppColors.placeholder,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: AppColors.highlight,
                                              width: 1.5,
                                            ),
                                          ),
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color:
                                                  AppColors.defaultInputBorders,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      title: isEdit ? 'Save' : 'Add',
                                      paddingVertical: 10.5,
                                      paddingHorizontal: 13.5,
                                      borderRadius: 8.0,
                                      isShowBorder: true,
                                      onPressed: () {
                                        if (isEdit) {
                                          editFoodItem(id);
                                        } else {
                                          addFoodItem();
                                        }
                                      },
                                    ),
                                  ),
                                ],
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

  void searchFood(String value) {
    if (value != 'All') {
      setState(() {
        mealDropdownValue = value;
      });
    } else {
      setState(() {
        mealDropdownValue = 'BREAKFAST';
      });
    }
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
                                  searchedFood.clear();
                                  setState(() {});
                                } else {
                                  searchFoodItem(value);
                                }
                              },
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  searchedFood.clear();
                                  setState(() {});
                                }
                              },
                              decoration: InputDecoration(
                                hintMaxLines: 1,
                                hintText: 'Search by food name',
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
                                  .searchedFood
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
                                        .searchedFood
                                        .length,
                                    itemBuilder: (context, index) {
                                      return searchCard(
                                          context
                                              .watch<MainContainerProvider>()
                                              .searchedFood[index],
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

  Widget expansionTile(double top, double left, String image, String title,
      int calorie, List<UsersCalories> calories) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.richBlack.withOpacity(0.06),
              blurRadius: 30.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: const Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: AppColors.transparent,
            ),
            child: ExpansionTile(
              onExpansionChanged: (value) {
                setState(() {
                  isBreakfastExpanded = value;
                });
              },
              initiallyExpanded: isBreakfastExpanded,
              backgroundColor: AppColors.white,
              collapsedBackgroundColor: AppColors.white,
              childrenPadding: EdgeInsets.zero,
              tilePadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.trailing,
              trailing: Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  top: 18,
                ),
                child: CustomIcon(
                  icon: isBreakfastExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  borderWidth: 1.5,
                  borderColor: AppColors.highlight,
                  isShowDot: false,
                  radius: 35.0,
                  iconSize: 24.0,
                  iconColor: AppColors.white,
                  top: 0,
                  right: 0,
                  bgColor: AppColors.highlight,
                  isShowBorder: true,
                  borderRadius: 50.0,
                ),
              ),
              title: Stack(
                alignment: Alignment.centerLeft,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: top,
                    left: left,
                    child: Image.asset(
                      image,
                      width: 150.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 0.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 100.0,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: Fonts.helixMedium,
                                      color: AppColors.richBlack,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '$calorie ',
                                          style: const TextStyle(
                                            fontSize: 24.0,
                                            fontFamily: Fonts.gilroySemiBold,
                                            color: AppColors.richBlack,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: 'kacl',
                                          style: TextStyle(
                                            fontFamily: Fonts.gilroySemiBold,
                                            fontSize: 16.0,
                                            color: AppColors.richBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (title == 'Breakfast') {
                                  searchFood('BREAKFAST');
                                }
                                if (title == 'Snacks') {
                                  searchFood('SNACKS');
                                }
                                if (title == 'Lunch') {
                                  searchFood('LUNCH');
                                }
                                if (title == 'Dinner') {
                                  searchFood('DINNER');
                                }
                              },
                              child: const CustomIcon(
                                icon: Icons.add,
                                borderWidth: 1.5,
                                borderColor: AppColors.highlight,
                                isShowDot: false,
                                radius: 35.0,
                                iconSize: 24.0,
                                iconColor: AppColors.highlight,
                                top: 0,
                                right: 0,
                                bgColor: AppColors.white,
                                isShowBorder: true,
                                borderRadius: 50.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: calories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 15.0,
                      ),
                      child: calorieCard(calories[index], index),
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
    );
  }

  void removeItem(String id, int index, double total, String value) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "id": id,
    };
    String url = '${Constants.finalUrl}/removeFromUserFoodCalories';
    Map<String, dynamic> updateSessionCount =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = updateSessionCount['status'];
    var data = updateSessionCount['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(24), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        if (value == 'BREAKFAST') {
          breakfast = breakfast - total.toInt();
          breakfastCalories.removeAt(index);
        } else if (value == 'SNACKS') {
          snacks = snacks - total.toInt();
          snacksCalories.removeAt(index);
        } else if (value == 'DINNER') {
          dinner = dinner - total.toInt();
          dinnerCalories.removeAt(index);
        } else if (value == 'LUNCH') {
          lunch = lunch - total.toInt();
          lunchCalories.removeAt(index);
        }
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

  Widget calorieCard(UsersCalories calorie, int index) {
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
                    '${calorie.name} (${calorie.servings} servings)',
                    style: const TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 14.0,
                      fontFamily: Fonts.gilroyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${calorie.calories} kcal',
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
                  selectedSearchedFoodItem.id = calorie.foodId;
                  selectedSearchedFoodItem.name = calorie.name;
                  selectedSearchedFoodItem.calories = calorie.foodCalories;
                  selectedSearchedFoodItem.carbs = calorie.carbs;
                  selectedSearchedFoodItem.fats = calorie.fats;
                  selectedSearchedFoodItem.fiber = calorie.fiber;
                  selectedSearchedFoodItem.protein = calorie.protein;
                  selectedSearchedFoodItem.quantity = calorie.foodQuantity;
                  selectedSearchedFoodItem.coverPhoto = calorie.coverPhoto;
                  selectedSearchedFoodItem.description = calorie.description;
                  selectedSearchedFoodItem.unit = calorie.foodUnit;
                  selectedSearchedFoodItem.status = 1;
                  unitController.text = calorie.foodUnit ?? "";
                  mealDropdownValue = calorie.meal ?? 'BREAKFAST';
                  servingsController.text = (calorie.servings ?? 0).toString();
                });
                addFood(true, calorie.id);
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
                  removeItem(calorie.id, index, calorie.calories ?? 0.0,
                      calorie.meal ?? "");
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

  void removeSelectedFoodItem() {
    setState(() {
      selectedSearchedFoodItem = Food();
    });
    searchFood(mealDropdownValue);
  }

  Widget searchCard(
      Food searchedFoodItem, bool isSearchCard, bool isEditCard, int index) {
    return GestureDetector(
      onTap: () {
        if (isSearchCard && !isEditCard) {
          setState(() {
            searchedFood.clear();
            selectedSearchedFoodItem = searchedFoodItem;
            searchController.text = '';
            unitController.text = searchedFoodItem.unit ?? "";
          });
          Get.back();
          addFood(false, '');
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
                        (searchedFoodItem.coverPhoto ??
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
                          '${searchedFoodItem.name} (1 servings = ${searchedFoodItem.quantity} ${searchedFoodItem.unit})',
                          style: const TextStyle(
                            color: AppColors.richBlack,
                            fontSize: 14.0,
                            fontFamily: Fonts.gilroyMedium,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          '${searchedFoodItem.calories} kcal',
                          style: const TextStyle(
                            color: AppColors.subText,
                            fontSize: 16.0,
                            fontFamily: Fonts.gilroySemiBold,
                          ),
                        )
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
                                  removeSelectedFoodItem();
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
              const SizedBox(
                height: 10.0,
              ),
              Divider(
                height: 20.0,
                thickness: 1.0,
                color: AppColors.defaultInputBorders.withOpacity(0.7),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Protein',
                        style: TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 14.0,
                          fontFamily: Fonts.gilroyMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${searchedFoodItem.protein}g',
                        style: const TextStyle(
                          color: AppColors.subText,
                          fontSize: 16.0,
                          fontFamily: Fonts.gilroySemiBold,
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Carbs',
                        style: TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 14.0,
                          fontFamily: Fonts.gilroyMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${searchedFoodItem.carbs}g',
                        style: const TextStyle(
                          color: AppColors.subText,
                          fontSize: 16.0,
                          fontFamily: Fonts.gilroySemiBold,
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Fiber',
                        style: TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 14.0,
                          fontFamily: Fonts.gilroyMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${searchedFoodItem.fiber}g',
                        style: const TextStyle(
                          color: AppColors.subText,
                          fontSize: 16.0,
                          fontFamily: Fonts.gilroySemiBold,
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Fats',
                        style: TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 14.0,
                          fontFamily: Fonts.gilroyMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${searchedFoodItem.fats}g',
                        style: const TextStyle(
                          color: AppColors.subText,
                          fontSize: 16.0,
                          fontFamily: Fonts.gilroySemiBold,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
