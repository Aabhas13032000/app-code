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
    const ProductPage(),
    // const BlogPage(),
    const WhislistPage(),
    const CartPage(),
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
                        .toString())
                : context.watch<DeepLink>().deepLinkUrl.contains('product')
                    ? EachProductPage(
                        id: context
                            .watch<DeepLink>()
                            .deepLinkUrl
                            .split('item_id=')[1]
                            .toString())
                    : WillPopScope(
                        onWillPop: () async {
                          if (index != 0) {
                            Provider.of<MainContainerProvider>(context,
                                    listen: false)
                                .setIndex(0);
                            return false;
                          } else {
                            return true;
                          }
                          //navigation history
                          // if (Provider.of<MainContainerProvider>(context,
                          //         listen: false)
                          //     .navigationQueue
                          //     .isEmpty) {
                          //   return false;
                          // }

                          // Provider.of<MainContainerProvider>(context, listen: false)
                          //     .setIndex(Provider.of<MainContainerProvider>(context,
                          //             listen: false)
                          //         .navigationQueue
                          //         .last);

                          // setState(() {
                          //   index = Provider.of<MainContainerProvider>(context,
                          //           listen: false)
                          //       .navigationQueue
                          //       .last;
                          // });
                          // Provider.of<MainContainerProvider>(context, listen: false)
                          //     .navigationQueue
                          //     .removeLast();
                          // return false;
                        },
                        child: Scaffold(
                          backgroundColor: AppColors.white,
                          body: screens[context
                              .watch<MainContainerProvider>()
                              .currentIndex],
                          bottomNavigationBar: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.04),
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
                              currentIndex: Provider.of<MainContainerProvider>(
                                      context,
                                      listen: false)
                                  .currentIndex,
                              onTap: (value) {
                                Provider.of<MainContainerProvider>(context,
                                        listen: false)
                                    .setIndex(value);
                                Provider.of<MainContainerProvider>(context,
                                        listen: false)
                                    .navigationQueue
                                    .addLast(index);
                                setState(() => index = value);
                              },
                              items: [
                                BottomNavigationBarItem(
                                  icon: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Provider.of<MainContainerProvider>(
                                                    context,
                                                    listen: false)
                                                .currentIndex ==
                                            0
                                        ? SvgIcons.homeFilled
                                        : SvgIcons.home,
                                  ),
                                  label: 'Home',
                                ),
                                // BottomNavigationBarItem(
                                //   icon: Padding(
                                //     padding: const EdgeInsets.all(3.0),
                                //     child: Provider.of<MainContainerProvider>(
                                //                     context,
                                //                     listen: false)
                                //                 .currentIndex ==
                                //             1
                                //         ? SvgIcons.feedFilled
                                //         : SvgIcons.feed,
                                //   ),
                                //   label: 'Feed',
                                // ),
                                BottomNavigationBarItem(
                                  icon: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Provider.of<MainContainerProvider>(
                                                    context,
                                                    listen: false)
                                                .currentIndex ==
                                            1
                                        ? SvgIcons.favouriteFilled
                                        : SvgIcons.favourite,
                                  ),
                                  label: 'Favourites',
                                ),
                                BottomNavigationBarItem(
                                  icon: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Provider.of<MainContainerProvider>(
                                                    context,
                                                    listen: false)
                                                .currentIndex ==
                                            2
                                        ? SvgIcons.cartFilled
                                        : SvgIcons.cart,
                                  ),
                                  label: 'Cart',
                                ),
                              ],
                              type: BottomNavigationBarType.fixed,
                              selectedItemColor: AppColors.highlight,
                              backgroundColor: AppColors.white,
                              unselectedItemColor:
                                  AppColors.unselectedIconColor,
                              iconSize: 30,
                              selectedFontSize: 11,
                              unselectedFontSize: 11,
                              showSelectedLabels: true,
                              showUnselectedLabels: true,
                              selectedLabelStyle: const TextStyle(
                                fontFamily: Fonts.montserratSemiBold,
                              ),
                              unselectedLabelStyle: const TextStyle(
                                fontFamily: Fonts.montserratSemiBold,
                              ),
                              elevation: 0.0,
                              enableFeedback: false,
                            ),
                          ),
                        ),
                      );
  }
}
