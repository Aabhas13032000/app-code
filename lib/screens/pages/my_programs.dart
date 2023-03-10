part of screens;

class MyPrograms extends StatefulWidget {
  const MyPrograms({Key? key}) : super(key: key);

  @override
  State<MyPrograms> createState() => _MyProgramsState();
}

class _MyProgramsState extends State<MyPrograms> {
  List<Subscription> myPrograms = [];
  bool isLoading = false;

  Future<void> downloadFile(String mediaUrl, String title) async {
    Utility.showProgress(true);
    bool permissionsGranted = false;
    Future.delayed(const Duration(microseconds: 100), () async {
      Map<Permission, PermissionStatus> permissions = await [
        Permission.storage,
      ].request();
      permissionsGranted = permissions[Permission.storage]!.isGranted;
      if (permissionsGranted) {
        Directory documents = await getApplicationDocumentsDirectory();
        String outputFile =
            '${documents.path}/${title.trim().replaceAll(' ', '-')}_${DateTime.now().millisecondsSinceEpoch.toString()}.pdf';
        try {
          await Dio().download(mediaUrl, outputFile);
          Utility.printLog("Document saved");
          String message = "PDF is successfully downloaded";
          showSnackBar(message, AppColors.lightGreen, AppColors.congrats, 50.0);
        } catch (e) {
          Utility.showProgress(false);
          Utility.printLog("urlToFile ${e.toString()}");
        }
        Utility.showProgress(false);
        await OpenFilex.open(File(outputFile).path);
      } else if (permissions[Permission.storage]!.isPermanentlyDenied) {
        Utility.showProgress(false);
        openAppSettings();
      }
    });
  }

  void joinRoom(
      String meetingUrl, String subscriptionId, String day, String time) async {
    Utility.showProgress(true);
    if (meetingUrl.isNotEmpty) {
      var days = [];
      if (day == 'All 7 days') {
        days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      } else if (day == 'All 6 days') {
        days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      } else if (day == 'Monday-Wednesday-Friday') {
        days = ['Mon', 'Wed', 'Fri'];
      } else if (day == 'Tuesday-Thursday-Saturday') {
        days = ['Tue', 'Thu', 'Sat'];
      }
      var times = time.split('-');
      var today = DateTime.now();
      var counter = 0;
      var weekDay = DateFormat('EEEE').format(DateTime.now());
      for (var i = 0; i < days.length; i++) {
        if (weekDay.contains(days[i])) {
          if (today.toString().substring(11, 13) == times[0].substring(0, 2)) {
            counter++;
          }
        }
      }
      if (counter > 0) {
        Map<String, String> params = {};
        String url =
            '${Constants.finalUrl}/programs/increaseSessionCount?id=$subscriptionId';
        Map<String, dynamic> updateSessionCount =
            await ApiFunctions.postApiResult(
                url, Application.deviceToken, params);
        bool status = updateSessionCount['status'];
        var data = updateSessionCount['data'];
        if (status) {
          if (data[ApiKeys.message].toString() == 'success') {
            Utility.showProgress(false);
            launchUrl(
              Uri.parse(meetingUrl),
              mode: LaunchMode.externalApplication,
            );
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
      } else {
        showSnackBar(AlertMessages.getMessage(13), AppColors.lightRed,
            AppColors.warning, 50.0);
        Utility.showProgress(false);
      }
    } else {
      showSnackBar(AlertMessages.getMessage(13), AppColors.lightRed,
          AppColors.warning, 50.0);
      Utility.showProgress(false);
    }
  }

  void getMyPrograms() async {
    Utility.showProgress(true);
    String url =
        '${Constants.finalUrl}/programs/getUserPrograms?user_id=${Application.user?.id}';
    Map<String, dynamic> myProgramData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = myProgramData['status'];
    var data = myProgramData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        myPrograms.clear();
        data[ApiKeys.morePrograms].forEach((program) => {
              myPrograms.add(Subscription.fromJson(program)),
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
      setState(() {
        isLoading = true;
      });
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
    getMyPrograms();
    super.initState();
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
            'My programs',
            style: TextStyle(
              color: AppColors.richBlack,
              fontSize: 18.0,
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
        body: !isLoading
            ? Container()
            : myPrograms.isEmpty
                ? const Center(
                    child: NoDataAvailable(
                      message: 'Purchase some program first !!',
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: myPrograms.length,
                            itemBuilder: (context, index) {
                              return ProgramCardFour(
                                subscription: myPrograms[index],
                                showDaysLeft: true,
                                onProgramPressed: () {
                                  Get.to(
                                    () => EachProgram(
                                        id: myPrograms[index].itemId ?? "0"),
                                  );
                                },
                                onDownloadPdfClicked:
                                    (myPrograms[index].pdfPath ?? "")
                                                .isNotEmpty &&
                                            (myPrograms[index].pdfPath ?? "") !=
                                                'null'
                                        ? () {
                                            downloadFile(
                                                Constants.imgFinalUrl +
                                                    (myPrograms[index]
                                                            .pdfPath ??
                                                        ""),
                                                '${myPrograms[index].title ?? "program"}-diet-plan');
                                          }
                                        : null,
                                onJoinButtonPressed: () {
                                  joinRoom(
                                      myPrograms[index].meetingUrl ?? "",
                                      myPrograms[index].subscriptionId ?? "",
                                      myPrograms[index].dayId ?? "",
                                      myPrograms[index].timeId ?? "");
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
