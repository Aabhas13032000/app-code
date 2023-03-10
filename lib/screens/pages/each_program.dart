part of screens;

class EachProgram extends StatefulWidget {
  final String id;
  const EachProgram({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<EachProgram> createState() => _EachProgramState();
}

class _EachProgramState extends State<EachProgram> {
  bool isLoading = false;
  Program? program;
  List<Trainer> trainers = [];
  List<Program> morePrograms = [];
  List<String> slider = [];
  List<Day> days = [];
  List<Timing> timings = [];
  List<Session> sessions = [];
  String daysDropdownValue = '';
  String sessionDropdownValue = '';
  String timeDropdownValue = '';
  String trainerDropdownValue = '';
  String trainerProgramId = '';
  bool present = false;
  bool alreadySubscribed = false;
  double priceToPay = 0;
  String programTitle = '';
  String address = '';

  late Razorpay _razorpay;

  Future<void> checkCombination() async {
    Utility.showProgress(true);
    String url =
        '${Constants.finalUrl}/programs/checkProgramCombination?id=${widget.id}&dayId=$daysDropdownValue&timeId=$timeDropdownValue&sessionId=$sessionDropdownValue&trainerId=$trainerDropdownValue&user_id=${Application.user?.id}';
    Map<String, dynamic> programData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = programData['status'];
    var data = programData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        alreadySubscribed = data[ApiKeys.alreadySubscribed] ?? false;
        present = data[ApiKeys.present] ?? false;
        if (data[ApiKeys.data].length != 0) {
          priceToPay =
              double.parse(data[ApiKeys.data][0][ApiKeys.price].toString());
          trainerProgramId = data[ApiKeys.data][0][ApiKeys.id].toString();
          if ((program?.addressIncluded ?? false) &&
              (data[ApiKeys.data][0][ApiKeys.address].toString() != 'null' ||
                  data[ApiKeys.data][0][ApiKeys.address]
                      .toString()
                      .isNotEmpty)) {
            address = data[ApiKeys.data][0][ApiKeys.address].toString();
          } else {
            address = "";
          }
        } else {
          priceToPay = 0;
          trainerProgramId = '';
        }
        setState(() {
          isLoading = true;
        });
        setProgramContent();
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
        setState(() {
          priceToPay = 0;
          isLoading = true;
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

  void setProgramContent() {
    Provider.of<MainContainerProvider>(context, listen: false)
        .setProgramData(priceToPay, address, present);
  }

  void addToCart() async {
    await checkCombination();
    Utility.printLog('Present = $present');
    Utility.printLog('Already Subscribed = $alreadySubscribed');
    Utility.printLog('Price To Pay = $priceToPay');
    Utility.printLog('Trainer Program Id = $trainerProgramId');
    // Get.back();
    if (present) {
      if (alreadySubscribed) {
        showPopup(22);
        // showSnackBar(AlertMessages.getMessage(22), AppColors.lightRed,
        //     AppColors.warning, 70.0);
      } else {
        Map<String, String> params = {
          "item_category": 'program',
          "item_id": widget.id,
          "user_id": Application.user?.id ?? "0",
          "trainer_program_id": trainerProgramId
        };
        String url = '${Constants.finalUrl}/cart/addToCart';
        Map<String, dynamic> updateSessionCount =
            await ApiFunctions.postApiResult(
                url, Application.deviceToken, params);
        bool status = updateSessionCount['status'];
        var data = updateSessionCount['data'];
        if (status) {
          if (data[ApiKeys.message].toString() == 'success') {
            Utility.showProgress(false);
            Get.back();
            showSnackBar(AlertMessages.getMessage(20), AppColors.lightGreen,
                AppColors.congrats, 50.0);
          } else if (data[ApiKeys.message].toString() == 'already_added') {
            Utility.showProgress(false);
            showPopup(23);
            // showSnackBar(AlertMessages.getMessage(23), AppColors.lightRed,
            //     AppColors.warning, 50.0);
          } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
              data[ApiKeys.message].toString() == 'Database_connection_error') {
            Utility.showProgress(false);
            Get.back();
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
    } else {
      // showSnackBar(AlertMessages.getMessage(21), AppColors.lightRed,
      //     AppColors.warning, 70.0);
      showPopup(21);
    }
  }

  void showPopup(int message) {
    Utility.singleButtonPopup(
        context,
        Icons.warning_amber_rounded,
        40.0,
        AppColors.warning,
        AlertMessages.getMessage(message),
        'Ok', onButtonClicked: () {
      Get.back();
    });
  }

  void payForSingleItem() async {
    await checkCombination();
    Utility.printLog('Present = $present');
    Utility.printLog('Already Subscribed = $alreadySubscribed');
    Utility.printLog('Price To Pay = $priceToPay');
    Utility.printLog('Trainer Program Id = $trainerProgramId');
    // Get.back();
    if (present) {
      if (alreadySubscribed) {
        showPopup(22);
        // showSnackBar(AlertMessages.getMessage(22), AppColors.lightRed,
        //     AppColors.warning, 70.0);
      } else {
        Get.back();
        _initiatePayment(priceToPay, programTitle);
      }
    } else {
      showPopup(21);
      // showSnackBar(AlertMessages.getMessage(21), AppColors.lightRed,
      //     AppColors.warning, 50.0);
    }
  }

  void getTDS(bool toggle) async {
    Utility.showProgress(true);
    if (toggle) {
      trainerDropdownValue = trainers[0].id ?? "";
    }
    String url =
        '${Constants.finalUrl}/programs/getTDS?id=${widget.id}&trainerId=$trainerDropdownValue';
    Map<String, dynamic> programData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = programData['status'];
    var data = programData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        days.clear();
        timings.clear();
        sessions.clear();
        data[ApiKeys.days].forEach((day) => {
              days.add(Day.fromJson(day)),
            });
        data[ApiKeys.sessions].forEach((session) => {
              sessions.add(Session.fromJson(session)),
            });
        data[ApiKeys.timings].forEach((timing) => {
              timings.add(Timing.fromJson(timing)),
            });
        daysDropdownValue = days[0].dayId ?? "";
        sessionDropdownValue = sessions[0].sessionId ?? "";
        timeDropdownValue = timings[0].timeId ?? "";
        Utility.showProgress(false);
        setState(() {
          isLoading = true;
        });
        bookProgram(toggle);
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

  void getEachProgram() async {
    Utility.showProgress(true);
    String url =
        '${Constants.finalUrl}/programs/getEachPrograms?id=${widget.id}';
    Map<String, dynamic> programData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = programData['status'];
    var data = programData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        morePrograms.clear();
        trainers.clear();
        slider.clear();
        if (data[ApiKeys.data].length != 0) {
          program = Program.fromJson(data[ApiKeys.data][0]);
          programTitle = Program.fromJson(data[ApiKeys.data][0]).title;
        }
        data[ApiKeys.images].forEach((image) => {
              slider.add(Constants.imgFinalUrl + image[ApiKeys.path]),
            });
        data[ApiKeys.trainers].forEach((trainer) => {
              trainers.add(Trainer.fromJson(trainer)),
            });
        data[ApiKeys.morePrograms].forEach((program) => {
              morePrograms.add(Program.fromJson(program)),
            });
        Utility.showProgress(false);
        setState(() {
          isLoading = true;
        });
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

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getEachProgram();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
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
        appBar: CustomAppBar(
          preferredSize: const Size.fromHeight(70.0),
          showLeadingIcon: true,
          centerTitle: true,
          title: const Text(
            '',
            style: TextStyle(
              color: AppColors.richBlack,
              fontSize: 20.0,
              fontFamily: Fonts.helixSemiBold,
            ),
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
              title: 'Book now',
              paddingVertical: 10.5,
              paddingHorizontal: 13.5,
              borderRadius: 8.0,
              onPressed: () {
                getTDS(true);
              },
            ),
          ),
        ),
        body: !isLoading
            ? Container()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: slider.isNotEmpty ? 250.0 : 20.0,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          slider.isNotEmpty
                              ? AppSlider(
                                  slider: slider,
                                  height: 250,
                                  viewPortFraction: 1,
                                  margin: const EdgeInsets.all(0.0),
                                  borderRadius: 0.0,
                                  aspectRatio: 16 / 10,
                                  width: double.infinity,
                                  duration: 1500,
                                  bottomIndicatorVerticalPadding: 34.0,
                                )
                              : const SizedBox(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 20.0,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        (program?.title ?? ''),
                        style: const TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 20.0,
                          fontFamily: Fonts.helixSemiBold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  color: AppColors.highlight,
                                  size: 20.0,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  '${program?.views}',
                                  style: const TextStyle(
                                    color: AppColors.highlight,
                                    fontSize: 18.0,
                                    fontFamily: Fonts.helixMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            program?.createdAt.substring(0, 10) ?? '',
                            style: const TextStyle(
                              color: AppColors.subText,
                              fontSize: 18.0,
                              fontFamily: Fonts.gilroyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: TextToHtmlTwo(
                        description: program?.description ?? '',
                        textColor: AppColors.richBlack,
                        fontSize: 16.0,
                        font: Fonts.gilroyRegular,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    trainers.isEmpty ? const SizedBox() : experts(),
                    SizedBox(
                      height: trainers.isEmpty ? 0.0 : 20.0,
                    ),
                    morePrograms.isEmpty ? const SizedBox() : moreProgram(),
                    SizedBox(
                      height: morePrograms.isEmpty ? 0.0 : 10.0,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget experts() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: HeadingViewAll(
            title: 'All trainers',
            isShowViewAll: false,
          ),
        ),
        SizedBox(
          height: 280.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trainers.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                  top: 20.0,
                  bottom: 20.0,
                  right: index == trainers.length - 1 ? 20.0 : 0.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => EachExpertPage(
                        id: trainers[index].id,
                      ),
                    );
                  },
                  child: ExpertCard(
                    width: 190,
                    name: trainers[index].name,
                    photoUrl:
                        Constants.imgFinalUrl + trainers[index].profileImage,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget moreProgram() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: HeadingViewAll(
            title: 'More programs',
            isShowViewAll: false,
          ),
        ),
        SizedBox(
          height: 270.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: morePrograms.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                  top: 20.0,
                  bottom: 20.0,
                  right: index == morePrograms.length - 1 ? 20.0 : 0.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Utility.printLog('Program is clicked');
                    Get.to(
                      () => EachProgram(id: morePrograms[index].id),
                      preventDuplicates: false,
                    );
                  },
                  child: ProgramCardThree(
                    photoUrl:
                        Constants.imgFinalUrl + morePrograms[index].coverPhoto,
                    title: morePrograms[index].title,
                    price: morePrograms[index].price.toString(),
                    isGridView: false,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void bookProgram(bool toggle) async {
    await checkCombination();
    if (toggle) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.black.withOpacity(0.0),
        enableDrag: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) => Container(
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
                      constraints: const BoxConstraints(maxHeight: 450.0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20.0, right: 20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                                    value: trainerDropdownValue,
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
                                    items: trainers.map((Trainer item) {
                                      return DropdownMenuItem(
                                        value: item.id,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              item.name,
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
                                        trainerDropdownValue = newValue!;
                                      });
                                      getTDS(false);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
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
                                    value: daysDropdownValue,
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
                                    items: days.map((Day item) {
                                      return DropdownMenuItem(
                                        value: item.dayId,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              item.dayId ?? "",
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
                                        daysDropdownValue = newValue!;
                                      });
                                      checkCombination();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
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
                                    value: sessionDropdownValue,
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
                                    items: sessions.map((Session item) {
                                      return DropdownMenuItem(
                                        value: item.sessionId,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              item.sessionId ?? "",
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
                                        sessionDropdownValue = newValue!;
                                      });
                                      checkCombination();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
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
                                    value: timeDropdownValue,
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
                                    items: timings.map((Timing item) {
                                      return DropdownMenuItem(
                                        value: item.timeId,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              item.timeId ?? "",
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
                                        timeDropdownValue = newValue!;
                                      });
                                      checkCombination();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: context
                                        .watch<MainContainerProvider>()
                                        .present
                                    ? 0.0
                                    : 10.0,
                              ),
                              context.watch<MainContainerProvider>().present
                                  ? const SizedBox()
                                  : const Text(
                                      "Selected combination not available ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.richBlack,
                                        fontSize: 16.0,
                                        fontFamily: Fonts.helixSemiBold,
                                      ),
                                    ),
                              SizedBox(
                                height: priceToPay == 0 ? 0 : 10.0,
                              ),
                              context
                                          .watch<MainContainerProvider>()
                                          .priceToPay ==
                                      0
                                  ? const SizedBox()
                                  : Text(
                                      "Total price = Rs ${context.watch<MainContainerProvider>().priceToPay}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.richBlack,
                                        fontSize: 16.0,
                                        fontFamily: Fonts.helixSemiBold,
                                      ),
                                    ),
                              (context
                                          .watch<MainContainerProvider>()
                                          .address
                                          .isNotEmpty &&
                                      context
                                              .watch<MainContainerProvider>()
                                              .address !=
                                          "null")
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 20.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.cardBg,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Address :- ${context.watch<MainContainerProvider>().address}",
                                          style: const TextStyle(
                                            color: AppColors.richBlack,
                                            fontSize: 16.0,
                                            fontFamily: Fonts.gilroyMedium,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      title: 'Purchase now',
                                      paddingVertical: 10.5,
                                      paddingHorizontal: 13.5,
                                      borderRadius: 8.0,
                                      isShowBorder: true,
                                      onPressed: () {
                                        payForSingleItem();
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                      title: 'Add to cart',
                                      isShowBorder: true,
                                      bgColor: AppColors.white,
                                      textColor: AppColors.highlight,
                                      paddingVertical: 10.5,
                                      paddingHorizontal: 13.5,
                                      borderRadius: 8.0,
                                      onPressed: () {
                                        addToCart();
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
          );
        },
      );
    }
  }

  Future _initiatePayment(double value, String title) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "total": value.toString(),
      "name": Application.user?.name ?? '',
      "email": Application.user?.email ?? '',
      "phone": Application.user?.phoneNumber ?? '',
      "user_id": Application.user?.id ?? '',
      "companyName": title,
      "description": "Payment for the program"
    };
    String url = '${Constants.imgFinalUrl}/subscription/paymentInitiate';
    Map<String, dynamic> initiatePayment =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = initiatePayment['status'];
    var data = initiatePayment['data'];
    if (status) {
      Utility.showProgress(false);
      try {
        _razorpay.open(data!);
      } catch (e) {
        Utility.printLog("Payment Payment error $e");
      }
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Utility.printLog("Payment Checkout Success ${response.paymentId}");
    // _razorpay?.clear();
    Utility.showProgress(true);
    Map<String, String> params = {
      "user_id": Application.user?.id ?? '',
    };
    String url =
        '${Constants.imgFinalUrl}/subscription/purchaseSingleItemMobile?item_id=${widget.id}&trainer_program_id=$trainerProgramId&user_id=${Application.user?.id}';
    Map<String, dynamic> paymentSuccess =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = paymentSuccess['status'];
    var data = paymentSuccess['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'payment_success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(14), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        setState(() {
          trainerProgramId = '';
          present = false;
          alreadySubscribed = false;
          priceToPay = 0;
        });
        Future.delayed(const Duration(seconds: 1), () {
          Get.to(() => const MyPrograms());
        });
      } else if (data[ApiKeys.message].toString() == 'payment_failed' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(15), AppColors.lightRed,
            AppColors.warning, 50.0);
      } else {
        Utility.showProgress(false);
        showSnackBar(data[ApiKeys.message].toString(), AppColors.lightRed,
            AppColors.warning, 50.0);
      }
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Utility.printLog(
        "Payment Checkout Failure ${response.code} ${response.message}");
    // _razorpay?.clear();

    showSnackBar(AlertMessages.getMessage(15), AppColors.lightRed,
        AppColors.warning, 50.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    Utility.printLog("Payment Checkout Wallet ${response.walletName}");
    // _razorpay?.clear();
    Utility.showProgress(true);
    Map<String, String> params = {
      "user_id": Application.user?.id ?? '',
    };
    String url =
        '${Constants.imgFinalUrl}/subscription/purchaseSingleItemMobile?item_id=${widget.id}&trainer_program_id=$trainerProgramId&user_id=${Application.user?.id}';
    Map<String, dynamic> paymentSuccess =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = paymentSuccess['status'];
    var data = paymentSuccess['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'payment_success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(14), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        setState(() {
          trainerProgramId = '';
          present = false;
          alreadySubscribed = false;
          priceToPay = 0;
        });
        Future.delayed(const Duration(seconds: 1), () {
          Get.to(() => const MyPrograms());
        });
      } else if (data[ApiKeys.message].toString() == 'payment_failed' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(15), AppColors.lightRed,
            AppColors.warning, 50.0);
      } else {
        Utility.showProgress(false);
        showSnackBar(data[ApiKeys.message].toString(), AppColors.lightRed,
            AppColors.warning, 50.0);
      }
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
    }
  }
}
