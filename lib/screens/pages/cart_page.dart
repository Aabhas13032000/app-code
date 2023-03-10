part of screens;

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController amountController = TextEditingController();
  Map<String, dynamic>? paymentParameter = {};
  List<Subscription> cartItems = [];
  List<Cart> productCartItems = [];
  bool isLoading = false;
  double total = 0;
  String selectedTab = 'product';
  List<Address> userAddress = [];
  Address? userDefaultAddress;
  double maximumCharge = 0;
  double shippingCharge = 0;
  bool defaultAddress = false;
  bool showAddressPopup = false;
  bool addAddressButton = false;
  bool selectAddressButton = false;
  bool noItemsPresent = false;
  int addressNullCounter = 0;
  String fullName = '';
  String phoneNumber = '';
  String selectedAddress = '';

  late Razorpay _razorpay;

  void changeTab(String value) {
    setState(() {
      selectedTab = value;
      total = 0;
      isLoading = false;
      cartItems = [];
      productCartItems = [];
    });
    getMyCart(value);
  }

  void getMyCart(String value) async {
    Utility.showProgress(true);
    String url = value == 'product'
        ? '${Constants.finalUrl}/cart/getUserProductCart?user_id=${Application.user?.id}'
        : '${Constants.finalUrl}/cart/getUserCart?user_id=${Application.user?.id}';
    Map<String, dynamic> cartData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = cartData['status'];
    var data = cartData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        cartItems.clear();
        productCartItems.clear();
        userAddress.clear();
        data[ApiKeys.data].forEach((program) {
          if (value == 'product') {
            total = total +
                (Cart.fromJson(program).discountPrice ?? 0) *
                    (Cart.fromJson(program).quantity ?? 0);
            productCartItems.add(Cart.fromJson(program));
          } else {
            total = total + (Subscription.fromJson(program).price ?? 0);
            cartItems.add(Subscription.fromJson(program));
          }
        });
        if (value == 'product') {
          if (data[ApiKeys.shippingDetails].length != 0) {
            maximumCharge = double.parse(data[ApiKeys.shippingDetails][0]
                    [ApiKeys.maximumValue]
                .toString());
            shippingCharge = double.parse(data[ApiKeys.shippingDetails][0]
                    [ApiKeys.shippingCharges]
                .toString());
          }
          double newTotal =
              maximumCharge <= total ? total : total + shippingCharge;
          total = newTotal;
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
          setUserDefaultAddress(userDefaultAddress);
        }
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

  void setUserDefaultAddress(Address? address) {
    Provider.of<MainContainerProvider>(context, listen: false)
        .setUserDefaultAddress(address);
  }

  void incrementDecrementValue(String id, String value) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "id": id,
      "value": value,
    };
    String url = '${Constants.finalUrl}/cart/increaseDecreaseQuantity';
    Map<String, dynamic> updateSessionCount =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = updateSessionCount['status'];
    var data = updateSessionCount['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(54), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        if (selectedTab == 'product') {
          changeTab('product');
        } else {
          changeTab('program');
        }
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

  void incrementDecrement(
      String id, String value, int maximumQuantity, int index) async {
    if (value == 'add') {
      int previousQuantity = productCartItems[index].quantity ?? 0;
      int newQuantity = previousQuantity + 1;
      if (newQuantity > maximumQuantity) {
        showSnackBar(AlertMessages.getMessage(52), AppColors.lightYellow,
            AppColors.highlight, 50.0);
      } else {
        incrementDecrementValue(id, value);
      }
    } else {
      int previousQuantity = productCartItems[index].quantity ?? 0;
      int newQuantity = previousQuantity - 1;
      if (newQuantity < 1) {
        showSnackBar(AlertMessages.getMessage(53), AppColors.lightYellow,
            AppColors.highlight, 50.0);
      } else {
        incrementDecrementValue(id, value);
      }
    }
  }

  void removeFromCart(String id, int index) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "cart_id": id,
    };
    String url = '${Constants.finalUrl}/cart/removeFromCart';
    Map<String, dynamic> updateSessionCount =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = updateSessionCount['status'];
    var data = updateSessionCount['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(16), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        if (selectedTab == 'product') {
          changeTab('product');
        } else {
          changeTab('program');
        }
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

  //Remove address
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
        if (selectedTab == 'product') {
          changeTab('product');
        } else {
          changeTab('program');
        }
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
    getMyCart(selectedTab);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
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
    return Scaffold(
      appBar: CustomAppBar(
        preferredSize: const Size.fromHeight(70.0),
        showLeadingIcon: true,
        centerTitle: true,
        title: const Text(
          'Cart',
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
          : FocusDetector(
              onFocusGained: () {
                if (Provider.of<MainContainerProvider>(context, listen: false)
                    .isAddressRefreshed) {
                  Provider.of<MainContainerProvider>(context, listen: false)
                      .setAddressRefreshValue(false);
                  getMyCart(selectedTab);
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 40.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 20.0,
                        ),
                        children: [
                          eachTab('product', 'Product'),
                          eachTab('program', 'Program'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    (cartItems.isEmpty && selectedTab != 'product') ||
                            (productCartItems.isEmpty &&
                                selectedTab == 'product')
                        ? const SizedBox(
                            height: 500.0,
                            child: Center(
                              child: NoDataAvailable(
                                message: 'No items present in cart, Add some!!',
                              ),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: selectedTab == 'product'
                                  ? productCartItems.length
                                  : cartItems.length,
                              itemBuilder: (context, index) {
                                return selectedTab == 'product'
                                    ? ProductCartCard(
                                        product: productCartItems[index],
                                        showDeleteButton: true,
                                        onDecreaseQuantity: () {
                                          incrementDecrement(
                                            productCartItems[index].cartId ??
                                                '0',
                                            'sub',
                                            productCartItems[index]
                                                    .maximumQuantity ??
                                                1,
                                            index,
                                          );
                                        },
                                        onIncreaseQuantity: () {
                                          incrementDecrement(
                                            productCartItems[index].cartId ??
                                                '0',
                                            'add',
                                            productCartItems[index]
                                                    .maximumQuantity ??
                                                1,
                                            index,
                                          );
                                        },
                                        onDeleteCartProduct: () {
                                          Utility.twoButtonPopup(
                                              context,
                                              Icons.warning_amber_rounded,
                                              40.0,
                                              AppColors.warning,
                                              AlertMessages.getMessage(17),
                                              'No',
                                              'Yes', onFirstButtonClicked: () {
                                            Get.back();
                                          }, onSecondButtonClicked: () {
                                            Get.back();
                                            Utility.printLog(
                                                'Cart Id = ${productCartItems[index].cartId}');
                                            removeFromCart(
                                                productCartItems[index]
                                                        .cartId ??
                                                    '',
                                                index);
                                          });
                                        },
                                        quantity:
                                            productCartItems[index].quantity,
                                        onProductPressed: () {
                                          Get.to(
                                            () => EachProductPage(
                                              id: productCartItems[index]
                                                      .itemId ??
                                                  '0',
                                            ),
                                          );
                                        },
                                      )
                                    : ProgramCardFour(
                                        subscription: cartItems[index],
                                        showDaysLeft: false,
                                        onProgramPressed: () {
                                          Get.to(
                                            () => EachProgram(
                                                id: cartItems[index].itemId ??
                                                    "0"),
                                          );
                                        },
                                        onDeleteButtonPressed: () {
                                          Utility.twoButtonPopup(
                                              context,
                                              Icons.warning_amber_rounded,
                                              40.0,
                                              AppColors.warning,
                                              AlertMessages.getMessage(17),
                                              'No',
                                              'Yes', onFirstButtonClicked: () {
                                            Get.back();
                                          }, onSecondButtonClicked: () {
                                            Get.back();
                                            Utility.printLog(
                                                'Cart Id = ${cartItems[index].cartId}');
                                            removeFromCart(
                                                cartItems[index].cartId ?? '',
                                                index);
                                          });
                                        },
                                      );
                              },
                            ),
                          ),
                    SizedBox(
                      height: selectedTab == 'product' ? 5.0 : 10.0,
                    ),
                    productCartItems.isNotEmpty && selectedTab == 'product'
                        ? AddressCard(
                            address: userAddress.isEmpty
                                ? Address()
                                : context
                                    .watch<MainContainerProvider>()
                                    .userDefaultAddress,
                            showChangeAddress:
                                userAddress.isEmpty ? false : true,
                            onButtonPressed: () {
                              if (userAddress.isEmpty) {
                                Get.to(
                                  () => AddEditAddressPage(),
                                );
                              } else {
                                selectAddressPopup(context);
                              }
                            },
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: selectedTab == 'product' ? 20.0 : 0.0,
                    ),
                    (cartItems.isEmpty && selectedTab != 'product') ||
                            (productCartItems.isEmpty &&
                                selectedTab == 'product')
                        ? const SizedBox()
                        : PayCard(
                            total: total,
                            initiatePayment: () {
                              if (Application.isPaymentAllowed) {
                                if (selectedTab == 'product') {
                                  if (userAddress.isEmpty) {
                                    showSnackBar(
                                        AlertMessages.getMessage(40),
                                        AppColors.lightRed,
                                        AppColors.warning,
                                        50.0);
                                  } else {
                                    if ((Provider.of<MainContainerProvider>(
                                                    context,
                                                    listen: false)
                                                .userDefaultAddress
                                                ?.fullName !=
                                            null) &&
                                        ((Provider.of<MainContainerProvider>(
                                                        context,
                                                        listen: false)
                                                    .userDefaultAddress
                                                    ?.fullName ??
                                                '')
                                            .isNotEmpty)) {
                                      _initiatePayment(total);
                                    } else {
                                      showSnackBar(
                                          AlertMessages.getMessage(41),
                                          AppColors.lightRed,
                                          AppColors.warning,
                                          50.0);
                                    }
                                  }
                                } else {
                                  _initiatePayment(total);
                                }
                              } else {
                                showSnackBar(
                                    AlertMessages.getMessage(55),
                                    AppColors.lightRed,
                                    AppColors.warning,
                                    75.0);
                              }
                            },
                            payOnDelivery: () {
                              if (selectedTab == 'product') {
                                if (userAddress.isEmpty) {
                                  showSnackBar(
                                      AlertMessages.getMessage(40),
                                      AppColors.lightRed,
                                      AppColors.warning,
                                      50.0);
                                } else {
                                  if ((Provider.of<MainContainerProvider>(
                                                  context,
                                                  listen: false)
                                              .userDefaultAddress
                                              ?.fullName !=
                                          null) &&
                                      ((Provider.of<MainContainerProvider>(
                                                      context,
                                                      listen: false)
                                                  .userDefaultAddress
                                                  ?.fullName ??
                                              '')
                                          .isNotEmpty)) {
                                    _payOnDelivery(
                                        Provider.of<MainContainerProvider>(
                                                context,
                                                listen: false)
                                            .userDefaultAddress);
                                  } else {
                                    showSnackBar(
                                        AlertMessages.getMessage(41),
                                        AppColors.lightRed,
                                        AppColors.warning,
                                        50.0);
                                  }
                                }
                              } else {
                                _initiatePayment(total);
                              }
                            },
                            showPayOnDelivery: false,
                            totalItems: selectedTab == 'product'
                                ? productCartItems.length
                                : cartItems.length,
                            shippingCharges:
                                maximumCharge <= total ? 0 : shippingCharge,
                            maximumCharges: maximumCharge,
                          ),
                    const SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget eachTab(String name, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            // changeTab('program');
            changeTab(name);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 15.0),
            decoration: BoxDecoration(
              color: selectedTab == (name)
                  ? AppColors.highlight
                  : AppColors.background,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                width: 1.0,
                color: selectedTab == (name)
                    ? AppColors.highlight
                    : AppColors.placeholder,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 8.0,
                bottom: 8.0,
              ),
              child: Text(
                value,
                style: TextStyle(
                  color:
                      selectedTab == (name) ? AppColors.white : AppColors.black,
                  fontSize: 16.0,
                  fontFamily: selectedTab == (name)
                      ? Fonts.gilroySemiBold
                      : Fonts.gilroyMedium,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _initiatePayment(double value) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "total": value.toString(),
      "name": Application.user?.name ?? '',
      "email": Application.user?.email ?? '',
      "phone": Application.user?.phoneNumber ?? '',
      "user_id": Application.user?.id ?? '',
      "companyName": selectedTab == 'product' ? 'Curect' : 'HealFit',
      "description": "Payment for the cart"
    };
    String url = selectedTab == 'product'
        ? '${Constants.finalProductUrl}/productPayment/paymentInitiate'
        : '${Constants.imgFinalUrl}/subscription/paymentInitiate';
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
    Utility.printLog(
        '${address?.flatNo} ${address?.area}, ${(address?.landmark ?? '').isEmpty ? '' : '${address?.landmark},'} ${address?.city}, ${address?.state}(${address?.pincode})');
    Utility.showProgress(true);
    Map<String, String> params = {
      "user_id": Application.user?.id ?? '',
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "finalAddress":
          '${address?.flatNo} ${address?.area}, ${(address?.landmark ?? '').isEmpty ? '' : '${address?.landmark},'} ${address?.city}, ${address?.state}(${address?.pincode})',
      "price": total.toString(),
    };
    String url =
        '${Constants.finalProductUrl}/productPayment/purchaseCartItemMobile';
    Map<String, dynamic> paymentSuccess =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = paymentSuccess['status'];
    var data = paymentSuccess['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'payment_success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(14), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        setAddressRefresh();
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
