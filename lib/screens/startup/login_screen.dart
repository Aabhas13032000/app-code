part of screens;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class CountryCode {
  late final String countryName;
  late final String countryCode;

  CountryCode({
    required this.countryCode,
    required this.countryName,
  });
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> slider = [];
  List<CountryCode> codes = [];
  List<CountryCode> searchCodes = [];
  String selectedCode = '+91';
  bool isLoading = false;
  bool isFocused = false;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final FocusNode _focus = FocusNode();
  String isUser = 'true';
  late String databaseName;
  late String type;
  late String name;
  String deviceToken = '';
  String completePhoneNumber = '';
  bool showLoading = false;
  bool isOtpScreen = false;
  late String verificationId;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> readJson() async {
    final String response = await rootBundle.loadString(Files.countryCodes);
    final data = await json.decode(response);
    data.forEach((code) => {
          codes.add(CountryCode(
            countryCode: code[ApiKeys.phoneCode],
            countryName: code[ApiKeys.country],
          )),
        });
    setState(() {
      searchCodes = codes;
    });
  }

  Future<void> setLoginPage() async {
    //Country code JSON
    await readJson();

    slider.add('https://cdn.mos.cms.futurecdn.net/KLZwUWe4JwyyXY7pV7CpaU.jpg');
    slider.add(
        'https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2022/02/fitness-tips-1645774618.jpg');
    slider.add(
        'https://static.wixstatic.com/media/6a670ac1508f442cac494d76770e1ded.jpg/v1/fill/w_640,h_452,al_t,q_80,usm_0.66_1.00_0.01,enc_auto/6a670ac1508f442cac494d76770e1ded.jpg');

    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      Utility.showProgress(false);
    });
  }

  Future<void> sendOTP(String verificationId) async {
    Get.to(
      () => OtpScreen(
        phoneNumber: phoneNumberController.text,
        verificationId: verificationId,
        selectedCode: Provider.of<LoginPageViewModel>(context, listen: false)
            .selectedCode,
      ),
    );
  }

  @override
  void initState() {
    Utility.showProgress(true);
    setLoginPage();
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    if (isFocused) {
      setState(() {
        isFocused = false;
      });
    } else {
      setState(() {
        isFocused = true;
      });
    }
  }

  Future<void> selectCountryCode() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.0),
      enableDrag: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) => Container(
            color: AppColors.transparent,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MediaQuery.of(context).viewInsets.bottom != 0
                      ? const SizedBox()
                      : GestureDetector(
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
                            borderRadius: 0.0,
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
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(0.0),
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxHeight: 480.0, minHeight: 200.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                height: 52.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.defaultInputBorders,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  style: const TextStyle(
                                    color: AppColors.richBlack,
                                    fontSize: 16.0,
                                    fontFamily: Fonts.montserratMedium,
                                  ),
                                  controller: searchController,
                                  cursorColor: AppColors.defaultInputBorders,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.search,
                                  maxLength: 10,
                                  cursorWidth: 1.5,
                                  onSubmitted: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        searchCodes = codes;
                                      });
                                    } else {
                                      var newArray = codes
                                          .where((element) => element
                                              .countryName
                                              .toUpperCase()
                                              .contains(value.toUpperCase()))
                                          .toList();
                                      setState(() {
                                        searchCodes = newArray;
                                      });
                                    }
                                  },
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        searchCodes = codes;
                                      });
                                    } else {
                                      var newArray = codes
                                          .where((element) => element
                                              .countryName
                                              .toUpperCase()
                                              .contains(value.toUpperCase()))
                                          .toList();
                                      setState(() {
                                        searchCodes = newArray;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintMaxLines: 1,
                                    hintText: 'Search by country name',
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
                                      fontFamily: Fonts.montserratMedium,
                                    ),
                                    focusColor: AppColors.placeholder,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.transparent,
                                        width: 0.0,
                                      ),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.transparent,
                                        width: 0.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              ListView.builder(
                                itemCount: searchCodes.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Provider.of<LoginPageViewModel>(context,
                                              listen: false)
                                          .setSelectedCode(
                                              searchCodes[index].countryCode);
                                      Get.back();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        top: 12.0,
                                        bottom: 12.0,
                                        left: 10.0,
                                        right: 10.0,
                                      ),
                                      margin:
                                          const EdgeInsets.only(bottom: 10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1.5,
                                            color:
                                                AppColors.defaultInputBorders,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(0.0)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              searchCodes[index].countryName,
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                fontFamily:
                                                    Fonts.montserratMedium,
                                                color: AppColors.richBlack,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            searchCodes[index].countryCode,
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily:
                                                  Fonts.montserratSemiBold,
                                              color: AppColors.richBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          // alignment: Alignment.topCenter,
          // clipBehavior: Clip.none,
          children: [
            !isLoading
                ? Container(
                    height: double.infinity,
                    color: AppColors.white,
                    width: double.infinity,
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 3 / 5,
                    child: Center(
                      child: Image.asset(
                        Images.splashCurect,
                        width: 200.0,
                        height: 100,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                    // child: AppSlider(
                    //   slider: Provider.of<MainContainerProvider>(context,
                    //           listen: false)
                    //       .slider,
                    //   height: MediaQuery.of(context).size.height * 3 / 5,
                    //   viewPortFraction: 1,
                    //   margin: const EdgeInsets.all(0.0),
                    //   borderRadius: 0.0,
                    //   aspectRatio: 9 / 16,
                    //   width: double.infinity,
                    //   duration: 1500,
                    //   bottomIndicatorVerticalPadding: 55.0,
                    // ),
                  ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              left: 0.0,
              child: phoneNumber(),
            ),
          ],
        ),
      ),
    );
  }

  Widget phoneNumber() {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.43,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            0.0,
          ),
          topRight: Radius.circular(
            0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30.0,
            ),
            const Text(
              'OTP Verification',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: Fonts.montserratSemiBold,
                color: AppColors.richBlack,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            const Text(
              'We will send you a One Time Password on this\nphone number',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: Fonts.montserratMedium,
                color: AppColors.subText,
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
                    height: 52.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isFocused
                            ? AppColors.highlight
                            : AppColors.defaultInputBorders,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: TextField(
                      focusNode: _focus,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                        color: AppColors.richBlack,
                        fontSize: 16.0,
                        fontFamily: Fonts.montserratMedium,
                      ),
                      controller: phoneNumberController,
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
                        prefixIcon: Center(
                          child: GestureDetector(
                            onTap: () {
                              selectCountryCode();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context
                                      .watch<LoginPageViewModel>()
                                      .selectedCode,
                                  style: const TextStyle(
                                    color: AppColors.richBlack,
                                    fontSize: 16.0,
                                    fontFamily: Fonts.montserratSemiBold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.richBlack,
                                )
                              ],
                            ),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minHeight: 55.0,
                          minWidth: 65.0,
                          maxHeight: 55.0,
                          maxWidth: 100.0,
                        ),
                        contentPadding:
                            const EdgeInsets.only(top: 20.0, left: 20.0),
                        hintStyle: const TextStyle(
                          color: AppColors.placeholder,
                          fontSize: 16.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                        focusColor: AppColors.placeholder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.transparent,
                            width: 0.0,
                          ),
                        ),
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.transparent,
                            width: 0.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20.0,
                    top: -8.0,
                    child: Container(
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Text(
                          'Phone number',
                          style: TextStyle(
                            color: isFocused
                                ? AppColors.highlight
                                : AppColors.placeholder,
                            fontSize: 14.0,
                            fontFamily: Fonts.montserratSemiBold,
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
            CustomButton(
              title: 'Get OTP',
              textColor: AppColors.white,
              paddingVertical: 18,
              onPressed: () async {
                Utility.showProgress(true);
                if (phoneNumberController.text.length >= 10) {
                  Utility.printLog(
                      '${Provider.of<LoginPageViewModel>(context, listen: false).selectedCode}${phoneNumberController.text}');
                  await auth.verifyPhoneNumber(
                    // timeout: const Duration(seconds: 60),
                    phoneNumber:
                        '${Provider.of<LoginPageViewModel>(context, listen: false).selectedCode}${phoneNumberController.text}',
                    verificationCompleted:
                        (PhoneAuthCredential phoneAuthCredential) async {
                      // User? user;
                      // bool error = false;
                      try {
                        Utility.showProgress(false);
                      } catch (e) {
                        Utility.printLog("Failed to sign in: $e");
                        // error = true;
                      }
                    },
                    verificationFailed:
                        (FirebaseAuthException verificationFailed) async {
                      if (verificationFailed.code == 'invalid-phone-number') {
                        Utility.showSnacbar(
                          context,
                          AlertMessages.getMessage(5),
                          AppColors.lightRed,
                          AppColors.warning,
                          duration: 2,
                          50.0,
                        );
                      }
                      Utility.printLog(
                          'verification error: ${verificationFailed.message}');
                      Utility.printLog(
                          'verification error: ${verificationFailed.code}');
                      Utility.showProgress(false);
                    },
                    codeSent: (verificationId, resendingCode) async {
                      Utility.showProgress(false);
                      setState(() {
                        this.verificationId = verificationId;
                      });
                      Utility.printLog('Verification id= $verificationId');
                      Utility.printLog(
                          'Phone Number = ${phoneNumberController.text}');
                      Utility.printLog('Code Sent = $resendingCode');
                      Utility.showSnacbar(
                        context,
                        AlertMessages.getMessage(7),
                        AppColors.lightGreen,
                        AppColors.congrats,
                        duration: 2,
                        50.0,
                      );
                      sendOTP(verificationId);
                    },
                    codeAutoRetrievalTimeout: (verificationId) async {},
                  );
                } else {
                  Utility.showSnacbar(
                    context,
                    AlertMessages.getMessage(6),
                    AppColors.lightRed,
                    AppColors.warning,
                    duration: 2,
                    50.0,
                  );
                }
              },
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Read ',
                        style: TextStyle(
                          fontFamily: Fonts.montserratMedium,
                          fontSize: 16.0,
                          color: AppColors.subText,
                        ),
                      ),
                      TextSpan(
                        text: 'Terms & Condition',
                        style: const TextStyle(
                          fontFamily: Fonts.montserratSemiBold,
                          fontSize: 16.0,
                          color: AppColors.highlight,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(
                              () => WebviewScreens(
                                url: Constants.imgFinalUrl +
                                    Application.termsAndConditionUrl,
                                title: 'Terms & Condition',
                              ),
                            );
                          },
                      ),
                      const TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          fontFamily: Fonts.montserratMedium,
                          fontSize: 16.0,
                          color: AppColors.subText,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          fontFamily: Fonts.montserratSemiBold,
                          fontSize: 16.0,
                          color: AppColors.highlight,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(
                              () => WebviewScreens(
                                url: Constants.imgFinalUrl +
                                    Application.privacyPolicyUrl,
                                title: 'Privacy Policy',
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
