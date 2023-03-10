part of screens;

class MainContainer extends StatefulWidget {
  const MainContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  List<Widget> screens = [
    const HomePage(),
    const BlogPage(),
    const HomePage(),
    const ProductPage(),
    const ProgramPage(),
  ];
  int index = 0;
  bool isLoading = false;
  bool isInternetAvailable = false;

  Future<void> setAppData() async {
    try {
      final result = await InternetAddress.lookup(Constants.internetCheckUrl);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
          isInternetAvailable = true;
        });
        Utility.showProgress(false);
        showUpdatePopups();
      }
    } on SocketException catch (_) {
      Utility.printLog('not connected');
      Utility.showProgress(false);
      setState(() {
        isLoading = true;
        isInternetAvailable = false;
      });
    }
  }

  void showUpdatePopups() {
    if (Application.isShowUpdatePopup) {
      Utility.twoButtonPopup(
          context,
          Icons.update,
          40.0,
          AppColors.highlight,
          AlertMessages.getMessage(30),
          'Cancel',
          'Update', onFirstButtonClicked: () {
        Get.back();
      }, onSecondButtonClicked: () {
        Get.back();
        LaunchReview.launch(
          androidAppId: Constants.androidPlayStoreId,
          iOSAppId: Constants.iosAppStoreId,
        );
      });
      Application.isShowUpdatePopup = false;
    }
    if (Application.isShowForceUpdatePopup) {
      Utility.singleButtonPopup(
        context,
        Icons.update,
        40.0,
        AppColors.highlight,
        AlertMessages.getMessage(30),
        'Update',
        onButtonClicked: () {
          Get.back();
          LaunchReview.launch(
            androidAppId: Constants.androidPlayStoreId,
            iOSAppId: Constants.iosAppStoreId,
          );
        },
        isForceUpdate: true,
      );
      Application.isShowForceUpdatePopup = false;
    }
  }

  @override
  void initState() {
    Utility.showProgress(true);
    super.initState();
    setAppData();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Container()
        : !isInternetAvailable
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Center(
                      child: NoDataAvailable(
                        message:
                            'No internet, Please reopen the\napplication or click retry',
                        image: Images.internetError,
                        width: 200.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomButton(
                      title: 'Retry',
                      onPressed: () {
                        Get.offAll(() => const SplashScreen());
                      },
                    ),
                  ),
                ],
              )
            : context.watch<DeepLink>().deepLinkUrl.contains('blog')
                ? EachBlog(
                    id: context
                        .watch<DeepLink>()
                        .deepLinkUrl
                        .split('item_id=')[1]
                        .toString(),
                  )
                : context.watch<DeepLink>().deepLinkUrl.contains('program')
                    ? EachProgram(
                        id: context
                            .watch<DeepLink>()
                            .deepLinkUrl
                            .split('item_id=')[1]
                            .toString())
                    : context.watch<DeepLink>().deepLinkUrl.contains('book')
                        ? const BooksPage()
                        : context
                                .watch<DeepLink>()
                                .deepLinkUrl
                                .contains('myPrograms')
                            ? const MyPrograms()
                            : context
                                    .watch<DeepLink>()
                                    .deepLinkUrl
                                    .contains('foodCalories')
                                ? CalorieCounterPage(
                                    isAddFood: true,
                                    date: context
                                        .watch<DeepLink>()
                                        .deepLinkUrl
                                        .split('date=')[1]
                                        .toString(),
                                  )
                                : context
                                        .watch<DeepLink>()
                                        .deepLinkUrl
                                        .contains('exerciseCalories')
                                    ? CalorieWorkoutPage(
                                        isAddFood: true,
                                        date: context
                                            .watch<DeepLink>()
                                            .deepLinkUrl
                                            .split('date=')[1]
                                            .toString(),
                                      )
                                    : WillPopScope(
                                        onWillPop: () async {
                                          if (Provider.of<
                                                      MainContainerProvider>(
                                                  context,
                                                  listen: false)
                                              .navigationQueue
                                              .isEmpty) {
                                            return false;
                                          }

                                          Provider.of<MainContainerProvider>(
                                                  context,
                                                  listen: false)
                                              .setIndex(Provider.of<
                                                          MainContainerProvider>(
                                                      context,
                                                      listen: false)
                                                  .navigationQueue
                                                  .last);

                                          setState(() {
                                            index = Provider.of<
                                                        MainContainerProvider>(
                                                    context,
                                                    listen: false)
                                                .navigationQueue
                                                .last;
                                          });
                                          Provider.of<MainContainerProvider>(
                                                  context,
                                                  listen: false)
                                              .navigationQueue
                                              .removeLast();
                                          return false;
                                        },
                                        child: Scaffold(
                                          backgroundColor: AppColors.background,
                                          body: screens[context
                                              .watch<MainContainerProvider>()
                                              .currentIndex],
                                          floatingActionButton: Container(
                                            margin: const EdgeInsets.only(
                                                top: 12.0),
                                            height: 64.0,
                                            width: 64.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 10.0,
                                                  spreadRadius: 0.0,
                                                  color: AppColors.black
                                                      .withOpacity(0.1),
                                                  offset: Offset.fromDirection(
                                                    0.0,
                                                    4.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                            child: FittedBox(
                                              child: FloatingActionButton(
                                                backgroundColor:
                                                    AppColors.highlight,
                                                elevation: 0.0,
                                                onPressed: () {
                                                  openBottomOptions();
                                                },
                                                child: const Icon(
                                                  MdiIcons.menu,
                                                  size: 24.0,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          floatingActionButtonLocation:
                                              FloatingActionButtonLocation
                                                  .centerDocked,
                                          bottomNavigationBar: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.black
                                                      .withOpacity(0.04),
                                                  blurRadius: 30.0,
                                                  spreadRadius: 0.0,
                                                  offset: const Offset(
                                                    0.0,
                                                    -10.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            child: BottomNavigationBar(
                                              currentIndex: Provider.of<
                                                          MainContainerProvider>(
                                                      context,
                                                      listen: false)
                                                  .currentIndex,
                                              onTap: (value) {
                                                if (value != 2) {
                                                  Provider.of<MainContainerProvider>(
                                                          context,
                                                          listen: false)
                                                      .setIndex(value);
                                                  Provider.of<MainContainerProvider>(
                                                          context,
                                                          listen: false)
                                                      .navigationQueue
                                                      .addLast(index);
                                                  setState(() => index = value);
                                                } else {
                                                  openBottomOptions();
                                                  return;
                                                }
                                              },
                                              items: [
                                                BottomNavigationBarItem(
                                                  icon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Provider.of<MainContainerProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .currentIndex ==
                                                            0
                                                        ? const Icon(
                                                            MdiIcons.home,
                                                          )
                                                        : const Icon(
                                                            MdiIcons
                                                                .homeOutline,
                                                          ),
                                                  ),
                                                  label: 'Home',
                                                ),
                                                BottomNavigationBarItem(
                                                  icon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Provider.of<MainContainerProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .currentIndex ==
                                                            1
                                                        ? const Icon(
                                                            MdiIcons
                                                                .newspaperVariant,
                                                          )
                                                        : const Icon(
                                                            MdiIcons
                                                                .newspaperVariantOutline,
                                                          ),
                                                  ),
                                                  label: 'Feed',
                                                ),
                                                const BottomNavigationBarItem(
                                                  icon: Padding(
                                                    padding:
                                                        EdgeInsets.all(3.0),
                                                    child: Icon(
                                                      MdiIcons
                                                          .playCircleOutline,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                  label: '',
                                                ),
                                                BottomNavigationBarItem(
                                                  icon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Provider.of<MainContainerProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .currentIndex ==
                                                            3
                                                        ? const Icon(
                                                            MdiIcons.tshirtCrew,
                                                          )
                                                        : const Icon(
                                                            MdiIcons
                                                                .tshirtCrewOutline,
                                                          ),
                                                  ),
                                                  label: 'Store',
                                                ),
                                                BottomNavigationBarItem(
                                                  icon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Provider.of<MainContainerProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .currentIndex ==
                                                            4
                                                        ? const Icon(
                                                            MdiIcons.playCircle,
                                                          )
                                                        : const Icon(
                                                            MdiIcons
                                                                .playCircleOutline,
                                                          ),
                                                  ),
                                                  label: 'Programs',
                                                ),
                                              ],
                                              type:
                                                  BottomNavigationBarType.fixed,
                                              selectedItemColor:
                                                  AppColors.highlight,
                                              backgroundColor: AppColors.white,
                                              unselectedItemColor:
                                                  AppColors.unselectedIconColor,
                                              iconSize: 30,
                                              selectedFontSize: 11,
                                              unselectedFontSize: 11,
                                              showSelectedLabels: true,
                                              showUnselectedLabels: true,
                                              selectedLabelStyle:
                                                  const TextStyle(
                                                fontFamily:
                                                    Fonts.gilroySemiBold,
                                              ),
                                              unselectedLabelStyle:
                                                  const TextStyle(
                                                fontFamily:
                                                    Fonts.gilroySemiBold,
                                              ),
                                              elevation: 0.0,
                                              enableFeedback: false,
                                            ),
                                          ),
                                        ),
                                      );
  }

  void openBottomOptions() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.0),
      enableDrag: true,
      builder: (BuildContext context) {
        return Container(
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
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          eachBottomOption(
                            'Add today\'s eaten calories',
                            CalorieCounterPage(
                              isAddFood: true,
                              date: 'Today',
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          eachBottomOption(
                            'Add today\'s workout log',
                            const CalorieWorkoutPage(
                              isAddFood: true,
                              date: 'Today',
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          eachBottomOption(
                            'My Programs',
                            const MyPrograms(),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          eachBottomOption(
                            'My Books',
                            const PurchasedBooks(),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          eachBottomOption(
                            'My Orders',
                            const MyOrders(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget eachBottomOption(String name, Widget widget) {
    return GestureDetector(
      onTap: () {
        Get.back();
        Get.to(
          () => widget,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.cardBg,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            top: 15.0,
            bottom: 15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                maxLines: 2,
                style: const TextStyle(
                  color: AppColors.richBlack,
                  fontSize: 16.0,
                  fontFamily: Fonts.helixSemiBold,
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              const CustomIcon(
                icon: Icons.arrow_forward_ios_rounded,
                borderWidth: 0.0,
                borderColor: AppColors.highlight,
                isShowDot: false,
                radius: 30.0,
                iconSize: 22.0,
                iconColor: AppColors.richBlack,
                top: 0,
                right: 0,
                borderRadius: 50.0,
                isShowBorder: false,
                bgColor: AppColors.transparent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
