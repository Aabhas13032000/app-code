part of screens;

class MyAddresses extends StatefulWidget {
  const MyAddresses({super.key});

  @override
  State<MyAddresses> createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses> {
  List<Address> userAddress = [];
  bool isLoading = false;

  void getMyAddresses() async {
    Utility.showProgress(true);
    String url =
        '${Constants.finalUrl}/cart/getUserAddress?user_id=${Application.user?.id}';
    Map<String, dynamic> myProgramData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = myProgramData['status'];
    var data = myProgramData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        userAddress.clear();
        data[ApiKeys.address].forEach((address) => {
              userAddress.add(Address.fromJson(address)),
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

  void removeAddress(String id) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "id": id,
    };
    String url = '${Constants.finalUrl}/cart/deleteAddress';
    Map<String, dynamic> updateSessionCount =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = updateSessionCount['status'];
    var data = updateSessionCount['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(37), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        getMyAddresses();
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
      Get.back();
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
    getMyAddresses();
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
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          preferredSize: const Size.fromHeight(70.0),
          showLeadingIcon: true,
          centerTitle: true,
          title: const Text(
            'My Addresses',
            style: TextStyle(
              color: AppColors.richBlack,
              fontSize: 18.0,
              fontFamily: Fonts.montserratSemiBold,
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
                top: 0,
                right: 0,
                borderRadius: 0.0,
                isShowBorder: false,
                bgColor: AppColors.background,
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
            : userAddress.isEmpty
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const NoDataAvailable(
                          message: 'No address available. Please add one.',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: CustomButton(
                            title: 'Add address',
                            paddingVertical: 18,
                            paddingHorizontal: 20,
                            borderRadius: 0.0,
                            onPressed: () {
                              Get.to(
                                () => AddEditAddressPage(),
                                transition: Transition.rightToLeft,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : FocusDetector(
                    onFocusGained: () {
                      if (Provider.of<MainContainerProvider>(context,
                              listen: false)
                          .isAddressRefreshed) {
                        Provider.of<MainContainerProvider>(context,
                                listen: false)
                            .setAddressRefreshValue(false);
                        getMyAddresses();
                      }
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: userAddress.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 7.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0.0),
                                    color: AppColors.white,
                                    border: Border.all(
                                      width: 0.0,
                                      color: AppColors.transparent,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            '${userAddress[index].fullName}, ${userAddress[index].phoneNumber}',
                                            style: const TextStyle(
                                              color: AppColors.richBlack,
                                              fontSize: 16.0,
                                              fontFamily:
                                                  Fonts.montserratRegular,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            '${userAddress[index].flatNo} ${userAddress[index].area}, ${(userAddress[index].landmark ?? '').isEmpty ? '' : '${userAddress[index].landmark},'} ${userAddress[index].city}, ${userAddress[index].state}(${userAddress[index].pincode})',
                                            style: const TextStyle(
                                              color: AppColors.richBlack,
                                              fontSize: 16.0,
                                              fontFamily:
                                                  Fonts.montserratRegular,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                  () => AddEditAddressPage(
                                                    address: userAddress[index],
                                                    isEditAddress: true,
                                                  ),
                                                  transition:
                                                      Transition.rightToLeft,
                                                );
                                              },
                                              child: const CustomIcon(
                                                icon: Icons.edit_outlined,
                                                borderWidth: 0.0,
                                                borderColor: AppColors.white,
                                                isShowDot: false,
                                                radius: 30.0,
                                                iconSize: 24.0,
                                                iconColor:
                                                    AppColors.placeholder,
                                                top: 0,
                                                right: 0,
                                                borderRadius: 0.0,
                                                isShowBorder: false,
                                                bgColor: AppColors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Utility.twoButtonPopup(
                                                    context,
                                                    Icons.warning_amber_rounded,
                                                    40.0,
                                                    AppColors.highlight,
                                                    AlertMessages.getMessage(
                                                        36),
                                                    'No',
                                                    'Yes',
                                                    onFirstButtonClicked: () {
                                                  Get.back();
                                                }, onSecondButtonClicked: () {
                                                  Get.back();
                                                  Utility.printLog(
                                                      'Cart Id = ${userAddress[index].id}');
                                                  removeAddress(
                                                      userAddress[index].id ??
                                                          '');
                                                });
                                              },
                                              child: const CustomIcon(
                                                icon: Icons
                                                    .delete_outline_rounded,
                                                borderWidth: 0.0,
                                                borderColor: AppColors.white,
                                                isShowDot: false,
                                                radius: 30.0,
                                                iconSize: 24.0,
                                                iconColor: AppColors.warning,
                                                top: 0,
                                                right: 0,
                                                borderRadius: 0.0,
                                                isShowBorder: false,
                                                bgColor: AppColors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: CustomButton(
                              title: 'Add address',
                              paddingVertical: 18,
                              paddingHorizontal: 20,
                              borderRadius: 0.0,
                              onPressed: () {
                                Get.to(
                                  () => AddEditAddressPage(),
                                  transition: Transition.rightToLeft,
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
