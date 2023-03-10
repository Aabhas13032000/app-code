part of screens;

class CheckoutProductPage extends StatefulWidget {
  final String id;
  final String selectedSize;
  const CheckoutProductPage({
    super.key,
    required this.id,
    required this.selectedSize,
  });

  @override
  State<CheckoutProductPage> createState() => _CheckoutProductPageState();
}

class _CheckoutProductPageState extends State<CheckoutProductPage> {
  bool isLoading = false;
  Cart? product;
  Sizes? productSize;
  List<Address> userAddress = [];
  Address? userDefaultAddress;
  double total = 0;
  double maximumCharge = 0;
  double shippingCharge = 0;
  int totalItems = 0;
  int maximumQuantity = 0;
  String selectedAddressId = '';
  String fullName = '';
  String phoneNumber = '';
  String selectedAddress = '';
  int addressNullCounter = 0;
  int quantity = 0;
  bool defaultAddress = false;
  bool showAddressPopup = false;
  bool addAddressButton = false;
  bool selectAddressButton = false;
  bool noItemsPresent = false;

  late Razorpay _razorpay;

  void getUserCart() async {
    Utility.showProgress(true);
    String url =
        '${Constants.finalUrl}/cart/getCheckoutProduct?user_id=${Application.user?.id ?? "0"}&id=${widget.id}&size=${widget.selectedSize}';
    Map<String, dynamic> programData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = programData['status'];
    var data = programData['data'];
    if (status) {
      userAddress.clear();
      if (data[ApiKeys.message].toString() == 'success') {
        if (data[ApiKeys.data].length != 0) {
          if (data[ApiKeys.shippingDetails].length != 0) {
            maximumCharge = double.parse(data[ApiKeys.shippingDetails][0]
                    [ApiKeys.maximumValue]
                .toString());
            shippingCharge = double.parse(data[ApiKeys.shippingDetails][0]
                    [ApiKeys.shippingCharges]
                .toString());
          }
          product = Cart.fromJson(data[ApiKeys.data][0]);
          product?.description = widget.selectedSize;
          product?.quantity = 1;
          total = maximumCharge <=
                  (Cart.fromJson(data[ApiKeys.data][0]).discountPrice ?? 0)
              ? (Cart.fromJson(data[ApiKeys.data][0]).discountPrice ?? 0)
              : (Cart.fromJson(data[ApiKeys.data][0]).discountPrice ?? 0) +
                  shippingCharge;
          totalItems = 1;
          if (data[ApiKeys.eachQuantity].length != 0) {
            productSize = Sizes.fromJson(data[ApiKeys.eachQuantity][0]);
            maximumQuantity =
                Sizes.fromJson(data[ApiKeys.eachQuantity][0]).quantity ?? 0;
          }
          if (data[ApiKeys.address].length != 0) {
            data[ApiKeys.address].forEach((address) {
              userAddress.add(Address.fromJson(address));
              if (Address.fromJson(address).defaultAddress ?? false) {
                userDefaultAddress = Address.fromJson(address);
                fullName = Address.fromJson(address).fullName ?? '';
                phoneNumber = Address.fromJson(address).phoneNumber ?? '';
                selectedAddress =
                    '${Address.fromJson(address).flatNo ?? ''} ${Address.fromJson(address).area ?? ''}, ${(Address.fromJson(address).landmark ?? '').isNotEmpty ? '${Address.fromJson(address).landmark ?? ''},' : ''} ${(Address.fromJson(address).city ?? '')}, ${(Address.fromJson(address).state ?? '')}(${(Address.fromJson(address).pincode ?? '')})';
              } else {
                addressNullCounter++;
              }
            });
            if (addressNullCounter >= data[ApiKeys.address].length) {
              userDefaultAddress = userAddress[0];
              fullName = userAddress[0].fullName ?? '';
              phoneNumber = userAddress[0].phoneNumber ?? '';
              selectedAddress =
                  '${userAddress[0].flatNo ?? ''} ${userAddress[0].area ?? ''}, ${(userAddress[0].landmark ?? '').isNotEmpty ? '${userAddress[0].landmark ?? ''},' : ''} ${(userAddress[0].city ?? '')}, ${(userAddress[0].state ?? '')}(${(userAddress[0].pincode ?? '')})';
            } else {
              defaultAddress = true;
            }
            addAddressButton = false;
            selectAddressButton = true;
            showAddressPopup = false;
          } else {
            addAddressButton = true;
            selectAddressButton = false;
            showAddressPopup = true;
          }
          noItemsPresent = false;
        } else {
          noItemsPresent = true;
        }
        setUserDefaultAddress(userDefaultAddress);
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
        setState(() {
          isLoading = true;
        });
      }
      Utility.showProgress(false);
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
      setState(() {
        isLoading = true;
      });
    }
  }

  void setUserDefaultAddress(Address? address) {
    Provider.of<MainContainerProvider>(context, listen: false)
        .setUserDefaultAddress(address);
  }

  void incrementDecrement(String value) {
    if (value == 'add') {
      int previousQuantity = product?.quantity ?? 0;
      int newQuantity = previousQuantity + 1;
      if (newQuantity > maximumQuantity) {
        showSnackBar(AlertMessages.getMessage(52), AppColors.lightYellow,
            AppColors.highlight, 50.0);
      } else {
        double newProductPrice = (product?.discountPrice ?? 0) * newQuantity;
        Cart? newProduct = product;
        newProduct?.quantity = newQuantity;
        total = maximumCharge <= (newProductPrice)
            ? (newProductPrice)
            : (newProductPrice) + shippingCharge;
        totalItems = newQuantity;
        product = newProduct;
        setState(() {});
      }
    } else {
      int previousQuantity = product?.quantity ?? 0;
      int newQuantity = previousQuantity - 1;
      if (newQuantity < 1) {
        showSnackBar(AlertMessages.getMessage(53), AppColors.lightYellow,
            AppColors.highlight, 50.0);
      } else {
        double newProductPrice = (product?.discountPrice ?? 0) * newQuantity;
        Cart? newProduct = product;
        newProduct?.quantity = newQuantity;
        total = maximumCharge <= (newProductPrice)
            ? (newProductPrice)
            : (newProductPrice) + shippingCharge;
        totalItems = newQuantity;
        product = newProduct;
        setState(() {});
      }
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
        Get.back();
        getUserCart();
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
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getUserCart();
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

  //Show all address
  Future<void> selectAddressPopup(BuildContext context) {
    return showModalBottomSheet<void>(
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
                    constraints: const BoxConstraints(maxHeight: 500.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 0.0, right: 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 0.0,
                              left: 16.0,
                              right: 16.0,
                            ),
                            child: Text(
                              "Select Address",
                              style: TextStyle(
                                color: AppColors.richBlack,
                                fontSize: 20.0,
                                fontFamily: Fonts.helixSemiBold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Divider(
                            height: 20.0,
                            thickness: 1.0,
                            color:
                                AppColors.defaultInputBorders.withOpacity(0.7),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: ListView.builder(
                                // shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                itemCount: userAddress.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                      bottom: 7.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: userAddress[index].id ==
                                              context
                                                  .watch<
                                                      MainContainerProvider>()
                                                  .userDefaultAddress
                                                  ?.id
                                          ? AppColors.cardBg
                                          : AppColors.white,
                                      border: Border.all(
                                        width: userAddress[index].id ==
                                                context
                                                    .watch<
                                                        MainContainerProvider>()
                                                    .userDefaultAddress
                                                    ?.id
                                            ? 1.5
                                            : 0.0,
                                        color: userAddress[index].id ==
                                                context
                                                    .watch<
                                                        MainContainerProvider>()
                                                    .userDefaultAddress
                                                    ?.id
                                            ? AppColors.defaultInputBorders
                                            : AppColors.transparent,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              setUserDefaultAddress(
                                                  userAddress[index]);
                                            },
                                            child: Text(
                                              '${userAddress[index].fullName}, ${userAddress[index].phoneNumber}',
                                              style: const TextStyle(
                                                color: AppColors.richBlack,
                                                fontSize: 16.0,
                                                fontFamily: Fonts.gilroyRegular,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              setUserDefaultAddress(
                                                  userAddress[index]);
                                            },
                                            child: Text(
                                              '${userAddress[index].flatNo} ${userAddress[index].area}, ${(userAddress[index].landmark ?? '').isEmpty ? '' : '${userAddress[index].landmark},'} ${userAddress[index].city}, ${userAddress[index].state}(${userAddress[index].pincode})',
                                              style: const TextStyle(
                                                color: AppColors.richBlack,
                                                fontSize: 16.0,
                                                fontFamily: Fonts.gilroyRegular,
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
                                                  Get.back();
                                                  Get.to(
                                                    () => AddEditAddressPage(
                                                      address:
                                                          userAddress[index],
                                                      isEditAddress: true,
                                                    ),
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
                                                  borderRadius: 50.0,
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
                                                      Icons
                                                          .warning_amber_rounded,
                                                      40.0,
                                                      AppColors.warning,
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
                                                  borderRadius: 50.0,
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
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    title: 'Add address',
                                    paddingVertical: 10.5,
                                    paddingHorizontal: 20,
                                    borderRadius: 8.0,
                                    onPressed: () {
                                      Get.back();
                                      Get.to(
                                        () => AddEditAddressPage(),
                                      );
                                    },
                                  ),
                                ),
                              ],
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
              ],
            ),
          ),
        );
      },
    );
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
            'Checkout Page',
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
        body: !isLoading
            ? Container()
            : FocusDetector(
                onFocusGained: () {
                  if (Provider.of<MainContainerProvider>(context, listen: false)
                      .isAddressRefreshed) {
                    Provider.of<MainContainerProvider>(context, listen: false)
                        .setAddressRefreshValue(false);
                    getUserCart();
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: ProductCartCard(
                          product: product ?? Cart(),
                          showDeleteButton: false,
                          onDecreaseQuantity: () {
                            incrementDecrement('sub');
                          },
                          onIncreaseQuantity: () {
                            incrementDecrement('add');
                          },
                          onDeleteCartProduct: () {},
                          quantity: product?.quantity ?? 1,
                          onProductPressed: () {
                            Get.to(
                              () => EachProductPage(
                                id: product?.itemId ?? '0',
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      AddressCard(
                        address: userAddress.isEmpty
                            ? Address()
                            : context
                                .watch<MainContainerProvider>()
                                .userDefaultAddress,
                        showChangeAddress: userAddress.isEmpty ? false : true,
                        onButtonPressed: () {
                          if (userAddress.isEmpty) {
                            Get.to(
                              () => AddEditAddressPage(),
                            );
                          } else {
                            selectAddressPopup(context);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      PayCard(
                        total: total,
                        initiatePayment: () {
                          if (Application.isPaymentAllowed) {
                            if (userAddress.isEmpty) {
                              showSnackBar(AlertMessages.getMessage(40),
                                  AppColors.lightRed, AppColors.warning, 50.0);
                            } else {
                              if ((Provider.of<MainContainerProvider>(context,
                                              listen: false)
                                          .userDefaultAddress
                                          ?.fullName !=
                                      null) &&
                                  ((Provider.of<MainContainerProvider>(context,
                                                  listen: false)
                                              .userDefaultAddress
                                              ?.fullName ??
                                          '')
                                      .isNotEmpty)) {
                                _initiatePayment(
                                    total, product?.name ?? 'Curect');
                              } else {
                                showSnackBar(
                                    AlertMessages.getMessage(41),
                                    AppColors.lightRed,
                                    AppColors.warning,
                                    50.0);
                              }
                            }
                          } else {
                            showSnackBar(AlertMessages.getMessage(55),
                                AppColors.lightRed, AppColors.warning, 75.0);
                          }
                        },
                        payOnDelivery: () {
                          Utility.printLog('Payment on delivery clicked');
                          if (userAddress.isEmpty) {
                            showSnackBar(AlertMessages.getMessage(40),
                                AppColors.lightRed, AppColors.warning, 50.0);
                          } else {
                            if ((Provider.of<MainContainerProvider>(context,
                                            listen: false)
                                        .userDefaultAddress
                                        ?.fullName !=
                                    null) &&
                                ((Provider.of<MainContainerProvider>(context,
                                                listen: false)
                                            .userDefaultAddress
                                            ?.fullName ??
                                        '')
                                    .isNotEmpty)) {
                              _payOnDelivery(Provider.of<MainContainerProvider>(
                                      context,
                                      listen: false)
                                  .userDefaultAddress);
                            } else {
                              showSnackBar(AlertMessages.getMessage(41),
                                  AppColors.lightRed, AppColors.warning, 50.0);
                            }
                          }
                        },
                        showPayOnDelivery: false,
                        totalItems: totalItems,
                        shippingCharges:
                            maximumCharge <= total ? 0 : shippingCharge,
                        maximumCharges: maximumCharge,
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

  Future _initiatePayment(double value, String title) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "total": value.toString(),
      "name": Application.user?.name ?? '',
      "email": Application.user?.email ?? '',
      "phone": Application.user?.phoneNumber ?? '',
      "user_id": Application.user?.id ?? '',
      "companyName": title,
      "description": "Payment for the product"
    };
    String url = '${Constants.finalProductUrl}/productPayment/paymentInitiate';
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

  void setAddressRefresh() {
    Provider.of<MainContainerProvider>(context, listen: false)
        .setAddressRefreshValue(true);
  }

  void _payOnDelivery(Address? address) async {
    // _razorpay?.clear();
    Utility.showProgress(true);
    Map<String, String> params = {
      "user_id": Application.user?.id ?? '',
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "finalAddress":
          '${address?.flatNo} ${address?.area}, ${(address?.landmark ?? '').isEmpty ? '' : '${address?.landmark},'} ${address?.city}, ${address?.state}(${address?.pincode})',
      "description": widget.selectedSize,
      "quantity": (product?.quantity ?? 1).toString(),
      "item_id": widget.id,
      "price": total.toString(),
      "productName": product?.name ?? '',
      "paymentMethod": 'COD'
    };
    String url =
        '${Constants.finalProductUrl}/productPayment/purchaseSingleItemMobile';
    Map<String, dynamic> paymentSuccess =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = paymentSuccess['status'];
    var data = paymentSuccess['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'payment_success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(14), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        // setAddressRefresh();
        Get.back();
        Future.delayed(const Duration(seconds: 1), () {
          Get.to(() => const MyOrders());
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Utility.printLog("Payment Checkout Success ${response.paymentId}");
    // _razorpay?.clear();

    _payOnDelivery(Provider.of<MainContainerProvider>(context, listen: false)
        .userDefaultAddress);
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
    _payOnDelivery(Provider.of<MainContainerProvider>(context, listen: false)
        .userDefaultAddress);
  }
}
