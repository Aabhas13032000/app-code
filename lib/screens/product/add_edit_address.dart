part of screens;

class AddEditAddressPage extends StatefulWidget {
  Address? address;
  bool? isEditAddress;
  AddEditAddressPage({
    super.key,
    this.address,
    this.isEditAddress = false,
  });

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  bool isLoading = false;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController flatNoController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String officeTypeDropdownValue = 'HOME';
  String stateDropdownValue = '';
  String cityDropdownValue = '';
  List<String> officeType = ['HOME', 'OFFICE', 'OTHER'];
  bool isChecked = false;
  List<StateCity> states = [];
  List<StateCity> cities = [];
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _pincodeFocus = FocusNode();
  final FocusNode _flatNoFocus = FocusNode();
  final FocusNode _areaFocus = FocusNode();
  final FocusNode _landmarkFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _stateFocus = FocusNode();
  final FocusNode _addressTypeFocus = FocusNode();
  bool isFullNameFocused = false;
  bool isMobileFocused = false;
  bool isPincodeFocused = false;
  bool isFlatNoFocused = false;
  bool isAreaFocused = false;
  bool isLandmarkFocused = false;
  bool isCityFocused = false;
  bool isStateFocused = false;
  bool isAddressTypeFocused = false;

  void setUserAddress() async {
    Utility.showProgress(true);
    if (widget.isEditAddress ?? false) {
      setState(() {
        fullNameController.text = widget.address?.fullName ?? '';
        mobileController.text =
            (widget.address?.phoneNumber ?? '').contains('+91')
                ? (widget.address?.phoneNumber ?? '').split('+91')[1]
                : (widget.address?.phoneNumber ?? '').length > 10 &&
                        (widget.address?.phoneNumber ?? '')[0] == '0'
                    ? (widget.address?.phoneNumber ?? '').substring(1)
                    : widget.address?.phoneNumber ?? '';
        pincodeController.text = widget.address?.pincode ?? '';
        flatNoController.text = widget.address?.flatNo ?? '';
        areaController.text = widget.address?.area ?? '';
        landmarkController.text = widget.address?.landmark ?? '';
        officeTypeDropdownValue = widget.address?.category ?? '';
        isChecked = widget.address?.defaultAddress ?? false;
      });
      setStateDropdown(widget.address?.state ?? '');
      setCityDropdown(widget.address?.city ?? '');
    }
    String url = '${Constants.finalUrl}/cart/getCitiesStates';
    Map<String, dynamic> programData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = programData['status'];
    var data = programData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        data[ApiKeys.cities].forEach((city) {
          cities.add(StateCity.fromJson(city));
        });
        data[ApiKeys.states].forEach((state) {
          states.add(StateCity.fromJson(state));
        });
        if (!(widget.isEditAddress ?? false)) {
          cityDropdownValue = '';
          stateDropdownValue = '';
          setStateDropdown(stateDropdownValue);
          setCityDropdown(cityDropdownValue);
        }
        setStates(states);
        setCities(cities);
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

  void setStateDropdown(String? state) {
    Provider.of<MainContainerProvider>(context, listen: false)
        .setStateValue(state ?? '');
  }

  void setCityDropdown(String? city) {
    Provider.of<MainContainerProvider>(context, listen: false)
        .setCityValue(city ?? '');
  }

  void setStates(List<StateCity> state) {
    Provider.of<MainContainerProvider>(context, listen: false).setStates(state);
  }

  void setCities(List<StateCity> city) {
    Provider.of<MainContainerProvider>(context, listen: false).setCities(city);
  }

  void saveAddressData() async {
    Utility.showProgress(true);
    Map<String, String> params = {
      'full_name': fullNameController.text.trim(),
      'phoneNumber': '+91${mobileController.text.trim()}',
      'flat_no': flatNoController.text.trim(),
      'area': areaController.text.trim(),
      'landmark': landmarkController.text.trim(),
      'pincode': pincodeController.text.trim(),
      'city': Provider.of<MainContainerProvider>(context, listen: false)
          .cityDropdownValue
          .trim(),
      'state': Provider.of<MainContainerProvider>(context, listen: false)
          .stateDropdownValue
          .trim(),
      'category': officeTypeDropdownValue.trim(),
      'default_address': isChecked ? '1' : '0',
      'user_id': Application.user?.id ?? "0",
      'id': widget.isEditAddress ?? false ? (widget.address?.id ?? '0') : '0'
    };
    String url = widget.isEditAddress ?? false
        ? '${Constants.finalUrl}/cart/saveAddress'
        : '${Constants.finalUrl}/cart/addAddress';
    Map<String, dynamic> loginData =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = loginData['status'];
    var data = loginData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        showSnackBar(
            AlertMessages.getMessage(widget.isEditAddress ?? false ? 51 : 50),
            AppColors.lightGreen,
            AppColors.congrats,
            50.0);
        setAddressRefresh();
        Get.back();
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
      } else {
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

  void setAddressRefresh() {
    Provider.of<MainContainerProvider>(context, listen: false)
        .setAddressRefreshValue(true);
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
    _fullNameFocus.addListener(_onFullNameFocusChange);
    _mobileFocus.addListener(_onFocusMobileChange);
    _pincodeFocus.addListener(_onPincodeChange);
    _flatNoFocus.addListener(_onFlatNoChange);
    _areaFocus.addListener(_onAreaChange);
    _landmarkFocus.addListener(_onLandmarkChange);
    _cityFocus.addListener(_onCityChange);
    _stateFocus.addListener(_onStateChange);
    _addressTypeFocus.addListener(_onAddressTypeChange);
    Future.delayed(Duration.zero, () {
      //your code goes here
      setUserAddress();
    });
  }

  void _onFullNameFocusChange() {
    if (isFullNameFocused) {
      setState(() {
        isFullNameFocused = false;
      });
    } else {
      setState(() {
        isFullNameFocused = true;
      });
    }
  }

  void _onFocusMobileChange() {
    if (isMobileFocused) {
      setState(() {
        isMobileFocused = false;
      });
    } else {
      setState(() {
        isMobileFocused = true;
      });
    }
  }

  void _onPincodeChange() {
    if (isPincodeFocused) {
      setState(() {
        isPincodeFocused = false;
      });
    } else {
      setState(() {
        isPincodeFocused = true;
      });
    }
  }

  void _onFlatNoChange() {
    if (isFlatNoFocused) {
      setState(() {
        isFlatNoFocused = false;
      });
    } else {
      setState(() {
        isFlatNoFocused = true;
      });
    }
  }

  void _onAreaChange() {
    if (isAreaFocused) {
      setState(() {
        isAreaFocused = false;
      });
    } else {
      setState(() {
        isAreaFocused = true;
      });
    }
  }

  void _onLandmarkChange() {
    if (isLandmarkFocused) {
      setState(() {
        isLandmarkFocused = false;
      });
    } else {
      setState(() {
        isLandmarkFocused = true;
      });
    }
  }

  void _onCityChange() {
    if (isCityFocused) {
      setState(() {
        isCityFocused = false;
      });
    } else {
      setState(() {
        isCityFocused = true;
      });
    }
  }

  void _onStateChange() {
    if (isStateFocused) {
      setState(() {
        isStateFocused = false;
      });
    } else {
      setState(() {
        isStateFocused = true;
      });
    }
  }

  void _onAddressTypeChange() {
    if (isAddressTypeFocused) {
      setState(() {
        isAddressTypeFocused = false;
      });
    } else {
      setState(() {
        isAddressTypeFocused = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
            'Add/Edit address',
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
            : states.isEmpty || cities.isEmpty
                ? const Center(
                    child: NoDataAvailable(
                      message: 'Some error occurred !!',
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            height: 55.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  height: 55.0,
                                  child: TextField(
                                    focusNode: _fullNameFocus,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      color: AppColors.richBlack,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroyMedium,
                                    ),
                                    controller: fullNameController,
                                    cursorColor: AppColors.defaultInputBorders,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.done,
                                    cursorWidth: 1.5,
                                    decoration: InputDecoration(
                                      hintMaxLines: 1,
                                      hintText: 'Enter your full name..',
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
                                      focusColor: AppColors.placeholder,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.highlight,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.defaultInputBorders,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20.0,
                                  top: -8.0,
                                  child: Container(
                                    color: AppColors.background,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Text(
                                        'Full name',
                                        style: TextStyle(
                                          color: isFullNameFocused
                                              ? AppColors.highlight
                                              : AppColors.placeholder,
                                          fontSize: 14.0,
                                          fontFamily: Fonts.gilroySemiBold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            height: 55.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  height: 55.0,
                                  child: TextField(
                                    focusNode: _mobileFocus,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      color: AppColors.richBlack,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroyMedium,
                                    ),
                                    controller: mobileController,
                                    cursorColor: AppColors.defaultInputBorders,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    maxLength: 10,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ], // Only numbers
                                    cursorWidth: 1.5,
                                    decoration: InputDecoration(
                                      hintMaxLines: 1,
                                      hintText: '123-456-7890',
                                      counterText: '',
                                      prefixIcon: const Center(
                                        child: Text(
                                          '+91',
                                          style: TextStyle(
                                            color: AppColors.richBlack,
                                            fontSize: 16.0,
                                            fontFamily: Fonts.gilroySemiBold,
                                          ),
                                        ),
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minHeight: 55.0,
                                        minWidth: 55.0,
                                        maxHeight: 55.0,
                                        maxWidth: 55.0,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 20.0, left: 20.0),
                                      hintStyle: const TextStyle(
                                        color: AppColors.placeholder,
                                        fontSize: 16.0,
                                        fontFamily: Fonts.gilroyMedium,
                                      ),
                                      focusColor: AppColors.placeholder,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.highlight,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.defaultInputBorders,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20.0,
                                  top: -8.0,
                                  child: Container(
                                    color: AppColors.background,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Text(
                                        'Phone number',
                                        style: TextStyle(
                                          color: isMobileFocused
                                              ? AppColors.highlight
                                              : AppColors.placeholder,
                                          fontSize: 14.0,
                                          fontFamily: Fonts.gilroySemiBold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            height: 55.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  height: 55.0,
                                  child: TextField(
                                    focusNode: _pincodeFocus,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      color: AppColors.richBlack,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroyMedium,
                                    ),
                                    controller: pincodeController,
                                    cursorColor: AppColors.defaultInputBorders,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.done,
                                    cursorWidth: 1.5,
                                    maxLength: 7,
                                    decoration: InputDecoration(
                                      hintMaxLines: 1,
                                      hintText: 'Enter your pincode..',
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
                                      focusColor: AppColors.placeholder,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.highlight,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.defaultInputBorders,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20.0,
                                  top: -8.0,
                                  child: Container(
                                    color: AppColors.background,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Text(
                                        'Pincode',
                                        style: TextStyle(
                                          color: isPincodeFocused
                                              ? AppColors.highlight
                                              : AppColors.placeholder,
                                          fontSize: 14.0,
                                          fontFamily: Fonts.gilroySemiBold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            height: 55.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  height: 55.0,
                                  child: TextField(
                                    focusNode: _flatNoFocus,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      color: AppColors.richBlack,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroyMedium,
                                    ),
                                    controller: flatNoController,
                                    cursorColor: AppColors.defaultInputBorders,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.done,
                                    cursorWidth: 1.5,
                                    decoration: InputDecoration(
                                      hintMaxLines: 1,
                                      hintText: 'Enter your flat no..',
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
                                      focusColor: AppColors.placeholder,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.highlight,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.defaultInputBorders,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20.0,
                                  top: -8.0,
                                  child: Container(
                                    color: AppColors.background,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Text(
                                        'Flat/House No, Building, Apartment',
                                        style: TextStyle(
                                          color: isFlatNoFocused
                                              ? AppColors.highlight
                                              : AppColors.placeholder,
                                          fontSize: 14.0,
                                          fontFamily: Fonts.gilroySemiBold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            height: 55.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  height: 55.0,
                                  child: TextField(
                                    focusNode: _areaFocus,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      color: AppColors.richBlack,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroyMedium,
                                    ),
                                    controller: areaController,
                                    cursorColor: AppColors.defaultInputBorders,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.done,
                                    cursorWidth: 1.5,
                                    decoration: InputDecoration(
                                      hintMaxLines: 1,
                                      hintText: 'Enter your area..',
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
                                      focusColor: AppColors.placeholder,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.highlight,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.defaultInputBorders,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20.0,
                                  top: -8.0,
                                  child: Container(
                                    color: AppColors.background,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Text(
                                        'Area, Street, Sector, Village',
                                        style: TextStyle(
                                          color: isAreaFocused
                                              ? AppColors.highlight
                                              : AppColors.placeholder,
                                          fontSize: 14.0,
                                          fontFamily: Fonts.gilroySemiBold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            height: 55.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  height: 55.0,
                                  child: TextField(
                                    focusNode: _landmarkFocus,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      color: AppColors.richBlack,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroyMedium,
                                    ),
                                    controller: landmarkController,
                                    cursorColor: AppColors.defaultInputBorders,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.done,
                                    cursorWidth: 1.5,
                                    decoration: InputDecoration(
                                      hintMaxLines: 1,
                                      hintText: 'Enter your landmark..',
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
                                      focusColor: AppColors.placeholder,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.highlight,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.defaultInputBorders,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20.0,
                                  top: -8.0,
                                  child: Container(
                                    color: AppColors.background,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Text(
                                        'Landmark',
                                        style: TextStyle(
                                          color: isLandmarkFocused
                                              ? AppColors.highlight
                                              : AppColors.placeholder,
                                          fontSize: 14.0,
                                          fontFamily: Fonts.gilroySemiBold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            height: 55.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    selectStateCityPopup(context, 'city');
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        width: 1.5,
                                        color: isCityFocused
                                            ? AppColors.highlight
                                            : AppColors.defaultInputBorders,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 10.0),
                                      child: Text(
                                        context
                                                .watch<MainContainerProvider>()
                                                .cityDropdownValue
                                                .isNotEmpty
                                            ? context
                                                .watch<MainContainerProvider>()
                                                .cityDropdownValue
                                            : 'Select a town/city',
                                        style: TextStyle(
                                          color: context
                                                  .watch<
                                                      MainContainerProvider>()
                                                  .cityDropdownValue
                                                  .isNotEmpty
                                              ? AppColors.richBlack
                                              : AppColors.placeholder,
                                          fontSize: 16.0,
                                          fontFamily: Fonts.gilroyMedium,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20.0,
                                  top: -8.0,
                                  child: Container(
                                    color: AppColors.background,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Text(
                                        'Town/City',
                                        style: TextStyle(
                                          color: isCityFocused
                                              ? AppColors.highlight
                                              : AppColors.placeholder,
                                          fontSize: 14.0,
                                          fontFamily: Fonts.gilroySemiBold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            height: 55.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    selectStateCityPopup(context, 'state');
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        width: 1.5,
                                        color: isStateFocused
                                            ? AppColors.highlight
                                            : AppColors.defaultInputBorders,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 10.0),
                                      child: Text(
                                        context
                                                .watch<MainContainerProvider>()
                                                .stateDropdownValue
                                                .isNotEmpty
                                            ? context
                                                .watch<MainContainerProvider>()
                                                .stateDropdownValue
                                            : 'Select a state',
                                        style: TextStyle(
                                          color: context
                                                  .watch<
                                                      MainContainerProvider>()
                                                  .stateDropdownValue
                                                  .isNotEmpty
                                              ? AppColors.richBlack
                                              : AppColors.placeholder,
                                          fontSize: 16.0,
                                          fontFamily: Fonts.gilroyMedium,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20.0,
                                  top: -8.0,
                                  child: Container(
                                    color: AppColors.background,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Text(
                                        'States',
                                        style: TextStyle(
                                          color: isStateFocused
                                              ? AppColors.highlight
                                              : AppColors.placeholder,
                                          fontSize: 14.0,
                                          fontFamily: Fonts.gilroySemiBold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            height: 55.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      width: 1.5,
                                      color: isAddressTypeFocused
                                          ? AppColors.highlight
                                          : AppColors.defaultInputBorders,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 10.0),
                                    child: DropdownButton(
                                      value: officeTypeDropdownValue,
                                      elevation: 0,
                                      isExpanded: true,
                                      underline: Container(
                                        height: 0.0,
                                        width: 0.0,
                                        color: AppColors.transparent,
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppColors.richBlack,
                                      ),
                                      items: officeType.map((String item) {
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
                                                  fontFamily:
                                                      Fonts.helixSemiBold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          officeTypeDropdownValue = newValue!;
                                        });
                                        _addressTypeFocus.removeListener(() {});
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20.0,
                                  top: -8.0,
                                  child: Container(
                                    color: AppColors.background,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Text(
                                        'Address type',
                                        style: TextStyle(
                                          color: isAddressTypeFocused
                                              ? AppColors.highlight
                                              : AppColors.placeholder,
                                          fontSize: 14.0,
                                          fontFamily: Fonts.gilroySemiBold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: AppColors.white,
                                value: isChecked,
                                focusColor: AppColors.highlight,
                                splashRadius: 8.0,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Expanded(
                                child: Text(
                                  'Do you want to make this your default address',
                                  style: TextStyle(
                                    color: AppColors.richBlack,
                                    fontSize: 16.0,
                                    fontFamily: Fonts.gilroyRegular,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          CustomButton(
                            title:
                                widget.isEditAddress ?? false ? 'Edit' : 'Add',
                            textColor: AppColors.white,
                            onPressed: () {
                              if (fullNameController.text.trim().isEmpty) {
                                showSnackBar(
                                    AlertMessages.getMessage(42),
                                    AppColors.lightRed,
                                    AppColors.warning,
                                    50.0);
                              } else if (mobileController.text.trim().length <
                                  10) {
                                showSnackBar(
                                    AlertMessages.getMessage(43),
                                    AppColors.lightRed,
                                    AppColors.warning,
                                    50.0);
                              } else if (pincodeController.text.trim().length <
                                  6) {
                                showSnackBar(
                                    AlertMessages.getMessage(44),
                                    AppColors.lightRed,
                                    AppColors.warning,
                                    50.0);
                              } else if (flatNoController.text.trim().isEmpty) {
                                showSnackBar(
                                    AlertMessages.getMessage(45),
                                    AppColors.lightRed,
                                    AppColors.warning,
                                    50.0);
                              } else if (areaController.text.trim().isEmpty) {
                                showSnackBar(
                                    AlertMessages.getMessage(46),
                                    AppColors.lightRed,
                                    AppColors.warning,
                                    50.0);
                              } else if (landmarkController.text
                                  .trim()
                                  .isEmpty) {
                                showSnackBar(
                                    AlertMessages.getMessage(47),
                                    AppColors.lightRed,
                                    AppColors.warning,
                                    50.0);
                              } else if (Provider.of<MainContainerProvider>(
                                      context,
                                      listen: false)
                                  .cityDropdownValue
                                  .trim()
                                  .isEmpty) {
                                showSnackBar(
                                    AlertMessages.getMessage(48),
                                    AppColors.lightRed,
                                    AppColors.warning,
                                    50.0);
                              } else if (Provider.of<MainContainerProvider>(
                                      context,
                                      listen: false)
                                  .stateDropdownValue
                                  .trim()
                                  .isEmpty) {
                                showSnackBar(
                                    AlertMessages.getMessage(49),
                                    AppColors.lightRed,
                                    AppColors.warning,
                                    50.0);
                              } else {
                                saveAddressData();
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  //Show all address
  Future<void> selectStateCityPopup(BuildContext context, String value) {
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
                    constraints: const BoxConstraints(
                      maxHeight: 500.0,
                      minHeight: 500.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 0.0, right: 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 0.0,
                              left: 16.0,
                              right: 16.0,
                            ),
                            child: Text(
                              value == 'state' ? "Select State" : "Select city",
                              style: const TextStyle(
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
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: SizedBox(
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
                                onSubmitted: (textValue) {
                                  if (textValue.isEmpty) {
                                    if (value == 'state') {
                                      setStates(states);
                                    } else {
                                      setCities(cities);
                                    }
                                  } else {
                                    if (value == 'state') {
                                      List<StateCity> filteredStates = states
                                          .where((e) => (e.name ?? '')
                                              .toUpperCase()
                                              .contains(textValue
                                                  .trim()
                                                  .toUpperCase()))
                                          .toList();
                                      setStates(filteredStates);
                                    } else {
                                      List<StateCity> filteredCities = cities
                                          .where((e) => (e.name ?? '')
                                              .toUpperCase()
                                              .contains(textValue
                                                  .trim()
                                                  .toUpperCase()))
                                          .toList();
                                      setCities(filteredCities);
                                    }
                                  }
                                },
                                onChanged: (textValue) {
                                  if (textValue.isEmpty) {
                                    if (value == 'state') {
                                      setStates(states);
                                    } else {
                                      setCities(cities);
                                    }
                                  } else {
                                    if (value == 'state') {
                                      List<StateCity> filteredStates = states
                                          .where((e) => (e.name ?? '')
                                              .toUpperCase()
                                              .contains(textValue
                                                  .trim()
                                                  .toUpperCase()))
                                          .toList();
                                      setStates(filteredStates);
                                    } else {
                                      List<StateCity> filteredCities = cities
                                          .where((e) => (e.name ?? '')
                                              .toUpperCase()
                                              .contains(textValue
                                                  .trim()
                                                  .toUpperCase()))
                                          .toList();
                                      setCities(filteredCities);
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  hintMaxLines: 1,
                                  hintText: value == 'state'
                                      ? 'Search by state name'
                                      : 'Search by city name',
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
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: ListView.builder(
                                itemCount: value == 'state'
                                    ? context
                                        .watch<MainContainerProvider>()
                                        .states
                                        .length
                                    : context
                                        .watch<MainContainerProvider>()
                                        .cities
                                        .length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.back();
                                      searchController.text = '';
                                      setState(() {});
                                      if (value == 'state') {
                                        setStateDropdown(
                                            Provider.of<MainContainerProvider>(
                                                    context,
                                                    listen: false)
                                                .states[index]
                                                .name);
                                        setStates(states);
                                      } else {
                                        setCityDropdown(
                                            Provider.of<MainContainerProvider>(
                                                    context,
                                                    listen: false)
                                                .cities[index]
                                                .name);
                                        setCities(cities);
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        bottom: 7.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: value == 'state'
                                            ? context
                                                        .watch<
                                                            MainContainerProvider>()
                                                        .states[index]
                                                        .name ==
                                                    context
                                                        .watch<
                                                            MainContainerProvider>()
                                                        .stateDropdownValue
                                                ? AppColors.cardBg
                                                : AppColors.white
                                            : context
                                                        .watch<
                                                            MainContainerProvider>()
                                                        .cities[index]
                                                        .name ==
                                                    context
                                                        .watch<
                                                            MainContainerProvider>()
                                                        .cityDropdownValue
                                                ? AppColors.cardBg
                                                : AppColors.white,
                                        border: Border.all(
                                          width: value == 'state'
                                              ? context
                                                          .watch<
                                                              MainContainerProvider>()
                                                          .states[index]
                                                          .name ==
                                                      context
                                                          .watch<
                                                              MainContainerProvider>()
                                                          .stateDropdownValue
                                                  ? 1.5
                                                  : 0.0
                                              : context
                                                          .watch<
                                                              MainContainerProvider>()
                                                          .cities[index]
                                                          .name ==
                                                      context
                                                          .watch<
                                                              MainContainerProvider>()
                                                          .cityDropdownValue
                                                  ? 1.5
                                                  : 0.0,
                                          color: value == 'state'
                                              ? context
                                                          .watch<
                                                              MainContainerProvider>()
                                                          .states[index]
                                                          .name ==
                                                      context
                                                          .watch<
                                                              MainContainerProvider>()
                                                          .stateDropdownValue
                                                  ? AppColors
                                                      .defaultInputBorders
                                                  : AppColors.transparent
                                              : context
                                                          .watch<
                                                              MainContainerProvider>()
                                                          .cities[index]
                                                          .name ==
                                                      context
                                                          .watch<
                                                              MainContainerProvider>()
                                                          .cityDropdownValue
                                                  ? AppColors
                                                      .defaultInputBorders
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
                                            Text(
                                              value == 'state'
                                                  ? '${context.watch<MainContainerProvider>().states[index].name}'
                                                  : '${context.watch<MainContainerProvider>().cities[index].name}',
                                              style: const TextStyle(
                                                color: AppColors.richBlack,
                                                fontSize: 16.0,
                                                fontFamily: Fonts.gilroyRegular,
                                              ),
                                            ),
                                          ],
                                        ),
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
}
