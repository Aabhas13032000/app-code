part of screens;

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int offset = 0;
  int totalNotification = 0;
  List<Notifications> notificationList = [];
  bool isVerticalLoading = false;
  bool isLoading = false;
  DateTime today = DateTime.now();

  void removeFrom(String id, int index) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "id": id,
    };
    String url =
        '${Constants.imgFinalUrl}/notifications/removeEachNotification';
    Map<String, dynamic> removeNotification =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = removeNotification['status'];
    var data = removeNotification['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        notificationList.removeAt(index);
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

  void getNotifications() async {
    if (offset == 0) {
      Utility.showProgress(true);
    }
    String url =
        '${Constants.imgFinalUrl}/notifications?offset=$offset&user_id=${Application.user?.id}';
    Map<String, dynamic> bookData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = bookData['status'];
    var data = bookData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        if (offset == 0) {
          notificationList.clear();
          totalNotification = data[ApiKeys.total];
        }
        data[ApiKeys.data].forEach((notification) => {
              notificationList.add(Notifications.fromJson(notification)),
            });
        Utility.showProgress(false);
        setState(() {
          isLoading = true;
          isVerticalLoading = false;
        });
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
        setState(() {
          isLoading = true;
          isVerticalLoading = false;
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
    getNotifications();
  }

  Future _loadMoreVertical() async {
    Utility.printLog('scrolling');
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        preferredSize: const Size.fromHeight(70.0),
        showLeadingIcon: true,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.richBlack,
            fontSize: 18.0,
            fontFamily: Fonts.helixSemiBold,
          ),
        ),
        actions: const [],
        leadingWidget: Padding(
          padding: const EdgeInsets.only(
            top: 12.5,
            left: 20.0,
            bottom: 12.5,
            right: 0.0,
          ),
          child: GestureDetector(
            onTap: () {
              Get.back();
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
          : notificationList.isEmpty
              ? const Center(
                  child: NoDataAvailable(
                    message: 'No Notifications available!!',
                  ),
                )
              : LazyLoadScrollView(
                  isLoading: isVerticalLoading,
                  onEndOfPage: () {
                    if (totalNotification > notificationList.length) {
                      setState(() {
                        offset = offset + 20;
                        isVerticalLoading = true;
                      });
                      _loadMoreVertical();
                    }
                  },
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ListView.builder(
                              itemCount: notificationList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    var date = '';
                                    if (today.toString().substring(0, 10) ==
                                        DateTime.parse(notificationList[index]
                                                    .createdAt ??
                                                "")
                                            .toString()
                                            .substring(0, 10)) {
                                      date = 'Today';
                                    } else {
                                      date = DateTime.parse(
                                              notificationList[index]
                                                      .createdAt ??
                                                  "")
                                          .toString()
                                          .substring(0, 10);
                                    }
                                    if (notificationList[index].itemCategory ==
                                        'exercise') {
                                      Get.to(
                                        () => CalorieCounterPage(
                                          isAddFood: true,
                                          date: date,
                                        ),
                                      );
                                    } else if (notificationList[index]
                                            .itemCategory ==
                                        'calorie') {
                                      Get.to(
                                        () => CalorieWorkoutPage(
                                          isAddFood: true,
                                          date: date,
                                        ),
                                      );
                                    } else if (notificationList[index]
                                            .itemCategory ==
                                        'myPrograms') {
                                      Get.to(
                                        () => const MyPrograms(),
                                      );
                                    } else if (notificationList[index]
                                            .itemCategory ==
                                        'purchasedBooks') {
                                      Get.to(
                                        () => const PurchasedBooks(),
                                      );
                                    }
                                  },
                                  child: NotificationCard(
                                    icon: (notificationList[index].type ??
                                                "REMINDER") ==
                                            'REMINDER'
                                        ? MdiIcons.bellRingOutline
                                        : (notificationList[index].type ??
                                                    "REMINDER") ==
                                                'WARNING'
                                            ? Icons.warning_amber_rounded
                                            : (notificationList[index].type ??
                                                        "REMINDER") ==
                                                    'CONGRATS'
                                                ? MdiIcons.giftOutline
                                                : MdiIcons.bellRingOutline,
                                    title: notificationList[index].type ??
                                        "REMINDER",
                                    message:
                                        notificationList[index].message ?? "",
                                    time: DateTime.parse(
                                            notificationList[index].createdAt ??
                                                "")
                                        .toString()
                                        .substring(0, 10),
                                    iconColor: (notificationList[index].type ??
                                                "REMINDER") ==
                                            'REMINDER'
                                        ? AppColors.highlight
                                        : (notificationList[index].type ??
                                                    "REMINDER") ==
                                                'WARNING'
                                            ? AppColors.warning
                                            : (notificationList[index].type ??
                                                        "REMINDER") ==
                                                    'CONGRATS'
                                                ? AppColors.congrats
                                                : AppColors.highlight,
                                    bgColor: (notificationList[index].type ??
                                                "REMINDER") ==
                                            'REMINDER'
                                        ? AppColors.lightYellow
                                        : (notificationList[index].type ??
                                                    "REMINDER") ==
                                                'WARNING'
                                            ? AppColors.lightRed
                                            : (notificationList[index].type ??
                                                        "REMINDER") ==
                                                    'CONGRATS'
                                                ? AppColors.lightGreen
                                                : AppColors.lightYellow,
                                    onClosed: () {
                                      removeFrom(
                                          notificationList[index].id ?? "0",
                                          index);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          !isVerticalLoading
                              ? const Center()
                              : const Padding(
                                  padding:
                                      EdgeInsets.only(top: 0.0, bottom: 20.0),
                                  child: Center(
                                    child: Text(
                                      'Loading...',
                                      style: TextStyle(
                                        color: AppColors.richBlack,
                                        fontSize: 16.0,
                                        fontFamily: Fonts.gilroyMedium,
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
