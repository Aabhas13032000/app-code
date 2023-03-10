part of screens;

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Orders> myOrders = [];
  bool isLoading = false;
  bool isVerticalLoading = false;
  int offset = 0;
  int totalOrders = 0;

  void getMyOrders() async {
    if (offset == 0) {
      Utility.showProgress(true);
    }
    String url =
        '${Constants.finalUrl}/products/getUserProductOrders?user_id=${Application.user?.id}&offset=$offset';
    Map<String, dynamic> myProgramData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = myProgramData['status'];
    var data = myProgramData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        if (offset == 0) {
          myOrders.clear();
          totalOrders = data[ApiKeys.totalOrders];
        }
        data[ApiKeys.data].forEach((order) => {
              myOrders.add(Orders.fromJson(order)),
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
      setState(() {
        isLoading = true;
        isVerticalLoading = false;
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

  void cancelOrder(
      String id, String itemId, String details, int quantity, int index) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "id": id,
    };
    String url =
        '${Constants.finalUrl}/products/changeOrderStatus?status=CANCELLED&details=$details&quantity=$quantity&item_id=$itemId';
    Map<String, dynamic> updateSessionCount =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = updateSessionCount['status'];
    var data = updateSessionCount['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(39), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        myOrders[index].status = 'CANCELLED';
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
    getMyOrders();
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

  Future _loadMoreVertical() async {
    Utility.printLog('scrolling');
    getMyOrders();
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
            'My Orders',
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
            : myOrders.isEmpty
                ? const Center(
                    child: NoDataAvailable(
                      message: 'Purchase some product first !!',
                    ),
                  )
                : LazyLoadScrollView(
                    isLoading: isVerticalLoading,
                    onEndOfPage: () {
                      if (totalOrders > myOrders.length) {
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
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: myOrders.length,
                                itemBuilder: (context, index) {
                                  return OrderCard(
                                    order: myOrders[index],
                                    onCancelOrder: () {
                                      Utility.twoButtonPopup(
                                          context,
                                          Icons.warning_amber_rounded,
                                          40.0,
                                          AppColors.warning,
                                          AlertMessages.getMessage(38),
                                          'No',
                                          'Yes', onFirstButtonClicked: () {
                                        Get.back();
                                      }, onSecondButtonClicked: () {
                                        Get.back();
                                        Utility.printLog(
                                            'Id = ${myOrders[index].id}');
                                        cancelOrder(
                                            myOrders[index].id ?? '',
                                            myOrders[index].itemId ?? '',
                                            myOrders[index].details ?? '',
                                            myOrders[index].quantity ?? 0,
                                            index);
                                      });
                                    },
                                    onProductPressed: () {
                                      Get.to(
                                        () => EachProductPage(
                                          id: myOrders[index].itemId ?? '0',
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
