part of screens;

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final String selectedCode;
  const OtpScreen({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
    required this.selectedCode,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<String> slider = [];
  bool isLoading = false;
  bool isFocused = false;
  String verificationId = '';
  late Timer timer;
  bool isDisabled = true;
  int counter = 0;
  int start = 60;
  TextEditingController otpControllerOne = TextEditingController();
  TextEditingController otpControllerTwo = TextEditingController();
  TextEditingController otpControllerThree = TextEditingController();
  TextEditingController otpControllerFour = TextEditingController();
  TextEditingController otpControllerFive = TextEditingController();
  TextEditingController otpControllerSix = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void _saveLogin() async {
    Map<String, String> params = {
      'phoneNumber': widget.phoneNumber,
      'country_code': widget.selectedCode,
      'userId': Application.user?.id ?? '0',
    };
    String url = '${Constants.finalUrl}/updatePhoneNumber';
    Map<String, dynamic> loginData =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = loginData['status'];
    var data = loginData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'Updated_successfully') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('loggedIn', true);
        prefs.setString('phoneNumber', widget.phoneNumber);
        Application.phoneNumber = widget.phoneNumber;
        Application.user = Users.fromJson(data[ApiKeys.user][0]);
        Application.isPaymentAllowed = data[ApiKeys.isPaymentAllowed] ?? false;
        Application.isOtpVerified = true;
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(8), AppColors.lightGreen,
            AppColors.congrats, 75.0);
        Future.delayed(const Duration(seconds: 2), () {
          if ((Application.user?.name ?? "").isEmpty ||
              (Application.user?.gender ?? "").isEmpty) {
            Get.offAll(
              () => const UserDetailScreen(),
            );
          } else {
            Get.offAll(
              () => const MainContainer(),
            );
          }
        });
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
      } else {
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

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        _saveLogin();
      }
    } on FirebaseAuthException catch (e) {
      Utility.printLog('error: ${e.message}');
    }
  }

  Future<void> setLoginPage() async {
    Utility.showProgress(false);
    slider.add('https://cdn.mos.cms.futurecdn.net/KLZwUWe4JwyyXY7pV7CpaU.jpg');
    slider.add(
        'https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2022/02/fitness-tips-1645774618.jpg');
    slider.add(
        'https://static.wixstatic.com/media/6a670ac1508f442cac494d76770e1ded.jpg/v1/fill/w_640,h_452,al_t,q_80,usm_0.66_1.00_0.01,enc_auto/6a670ac1508f442cac494d76770e1ded.jpg');

    setState(() {
      verificationId = widget.verificationId;
    });

    if (widget.verificationId.isEmpty) {
      Utility.printLog('inside verify phone number');
      await verifyPhoneNumber();
    }

    startTimer();

    setState(() {
      isLoading = true;
    });
  }

  Future<void> verifyPhoneNumber() async {
    Utility.showProgress(true);
    Utility.printLog('here 1');
    await auth.verifyPhoneNumber(
      // timeout: const Duration(seconds: 60),
      phoneNumber: '+91${widget.phoneNumber}',
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        // User? user;
        // bool error = false;
        try {
          // user = (await auth.signInWithCredential(phoneAuthCredential)).user!;
          Utility.showProgress(false);
        } catch (e) {
          Utility.printLog("Failed to sign in: $e");
          // error = true;
        }
      },
      verificationFailed: (FirebaseAuthException verificationFailed) async {
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
        Utility.printLog('verification error: ${verificationFailed.message}');
        Utility.printLog('verification error: ${verificationFailed.code}');
        Utility.showProgress(false);
      },
      codeSent: (verificationId, resendingCode) async {
        Utility.showProgress(false);
        setState(() {
          this.verificationId = verificationId;
          counter = counter + 1;
          isDisabled = true;
        });
        Utility.printLog('Verification id= $verificationId');
        Utility.printLog('Phone Number = ${widget.phoneNumber}');
        Utility.printLog('Code Sent = $resendingCode');
        if (counter == 4) {
          Utility.showSnacbar(
            context,
            AlertMessages.getMessage(9),
            AppColors.lightRed,
            AppColors.warning,
            duration: 2,
            75.0,
          );
        } else {
          Utility.showSnacbar(
            context,
            AlertMessages.getMessage(7),
            AppColors.lightGreen,
            AppColors.congrats,
            duration: 2,
            50.0,
          );
        }
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  Future<void> verifyOtp(String otp) async {
    if (verificationId.isEmpty) {
      await verifyPhoneNumber();
    } else {
      Utility.showProgress(true);
      Utility.printLog('here');
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      // await _auth.signInWithCredential(phoneAuthCredential);
      signInWithPhoneAuthCredential(phoneAuthCredential);
    }
  }

  @override
  void initState() {
    setLoginPage();
    Utility.showProgress(false);
    super.initState();
  }

  void startTimer() async {
    // if (verificationId.isEmpty) {
    await verifyPhoneNumber();
    // }
    const oneSec = Duration(seconds: 1);
    start = 60;
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
            isDisabled = false;
          });
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Container(
            height: double.infinity,
            color: AppColors.white,
            width: double.infinity,
          )
        : Scaffold(
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                // alignment: Alignment.topCenter,
                // clipBehavior: Clip.none,
                children: [
                  SizedBox(
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
                    //   bottomIndicatorVerticalPadding: 45.0,
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
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Enter the OTP sent to ',
                          style: TextStyle(
                            fontFamily: Fonts.montserratMedium,
                            fontSize: 16.0,
                            color: AppColors.subText,
                          ),
                        ),
                        TextSpan(
                          text: '${widget.selectedCode}-${widget.phoneNumber}',
                          style: const TextStyle(
                            fontFamily: Fonts.montserratSemiBold,
                            fontSize: 16.0,
                            color: AppColors.richBlack,
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
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  iconSize: 24.0,
                  color: AppColors.subText,
                  onPressed: () {
                    Get.back();
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55.0,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.richBlack,
                        fontSize: 16.0,
                        fontFamily: Fonts.montserratMedium,
                      ),
                      controller: otpControllerOne,
                      cursorColor: AppColors.defaultInputBorders,

                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 1,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers
                      cursorWidth: 1.5,
                      decoration: InputDecoration(
                        hintMaxLines: 1,
                        hintText: '0',
                        counterText: '',
                        contentPadding: const EdgeInsets.only(top: 20.0),
                        hintStyle: const TextStyle(
                          color: AppColors.placeholder,
                          fontSize: 16.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                        focusColor: AppColors.placeholder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.highlight,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.defaultInputBorders,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: SizedBox(
                    height: 55.0,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.richBlack,
                        fontSize: 16.0,
                        fontFamily: Fonts.montserratMedium,
                      ),
                      controller: otpControllerTwo,
                      cursorColor: AppColors.defaultInputBorders,

                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 1,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers
                      cursorWidth: 1.5,
                      decoration: InputDecoration(
                        hintMaxLines: 1,
                        hintText: '0',
                        counterText: '',
                        contentPadding: const EdgeInsets.only(top: 20.0),
                        hintStyle: const TextStyle(
                          color: AppColors.placeholder,
                          fontSize: 16.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                        focusColor: AppColors.placeholder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.highlight,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.defaultInputBorders,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: SizedBox(
                    height: 55.0,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.richBlack,
                        fontSize: 16.0,
                        fontFamily: Fonts.montserratMedium,
                      ),
                      controller: otpControllerThree,
                      cursorColor: AppColors.defaultInputBorders,

                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 1,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers
                      cursorWidth: 1.5,
                      decoration: InputDecoration(
                        hintMaxLines: 1,
                        hintText: '0',
                        counterText: '',
                        contentPadding: const EdgeInsets.only(top: 20.0),
                        hintStyle: const TextStyle(
                          color: AppColors.placeholder,
                          fontSize: 16.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                        focusColor: AppColors.placeholder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.highlight,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.defaultInputBorders,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: SizedBox(
                    height: 55.0,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.richBlack,
                        fontSize: 16.0,
                        fontFamily: Fonts.montserratMedium,
                      ),
                      controller: otpControllerFour,
                      cursorColor: AppColors.defaultInputBorders,

                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 1,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers
                      cursorWidth: 1.5,
                      decoration: InputDecoration(
                        hintMaxLines: 1,
                        hintText: '0',
                        counterText: '',
                        contentPadding: const EdgeInsets.only(top: 20.0),
                        hintStyle: const TextStyle(
                          color: AppColors.placeholder,
                          fontSize: 16.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                        focusColor: AppColors.placeholder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.highlight,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.defaultInputBorders,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: SizedBox(
                    height: 55.0,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.richBlack,
                        fontSize: 16.0,
                        fontFamily: Fonts.montserratMedium,
                      ),
                      controller: otpControllerFive,
                      cursorColor: AppColors.defaultInputBorders,

                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 1,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers
                      cursorWidth: 1.5,
                      decoration: InputDecoration(
                        hintMaxLines: 1,
                        hintText: '0',
                        counterText: '',
                        contentPadding: const EdgeInsets.only(top: 20.0),
                        hintStyle: const TextStyle(
                          color: AppColors.placeholder,
                          fontSize: 16.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                        focusColor: AppColors.placeholder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.highlight,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.defaultInputBorders,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: SizedBox(
                    height: 55.0,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.richBlack,
                        fontSize: 16.0,
                        fontFamily: Fonts.montserratMedium,
                      ),
                      controller: otpControllerSix,
                      cursorColor: AppColors.defaultInputBorders,

                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      maxLength: 1,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers
                      cursorWidth: 1.5,
                      decoration: InputDecoration(
                        hintMaxLines: 1,
                        hintText: '0',
                        counterText: '',
                        contentPadding: const EdgeInsets.only(top: 20.0),
                        hintStyle: const TextStyle(
                          color: AppColors.placeholder,
                          fontSize: 16.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                        focusColor: AppColors.placeholder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.highlight,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: AppColors.defaultInputBorders,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && value.length == 1) {
                          FocusScope.of(context).unfocus();
                        } else {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            CustomButton(
              title: 'Verify',
              textColor: AppColors.white,
              paddingVertical: 18,
              onPressed: () {
                String otp = otpControllerOne.text +
                    otpControllerTwo.text +
                    otpControllerThree.text +
                    otpControllerFour.text +
                    otpControllerFive.text +
                    otpControllerSix.text;
                if (otp.length == 6) {
                  Utility.printLog('Otp verification number');
                  verifyOtp(otp);
                } else {
                  Utility.showSnacbar(
                    context,
                    'Please fill all the boxes.',
                    AppColors.lightRed,
                    AppColors.warning,
                    duration: 2,
                    50.0,
                  );
                }
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            (isDisabled && counter < 4)
                ? SizedBox(
                    child: Center(
                      child: Text(
                        '00:${start < 10 ? '0$start' : start}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: Fonts.montserratMedium,
                          fontSize: 14.0,
                          color: AppColors.subText,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 10.0,
                  ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Didn’t recieved the OTP ? ',
                        style: TextStyle(
                          fontFamily: Fonts.montserratMedium,
                          fontSize: 16.0,
                          color: AppColors.subText,
                        ),
                      ),
                      TextSpan(
                        text: 'Resend',
                        style: TextStyle(
                          fontFamily: Fonts.montserratSemiBold,
                          fontSize: 16.0,
                          color: counter == 4
                              ? AppColors.subText
                              : isDisabled
                                  ? AppColors.subText
                                  : AppColors.highlight,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (!isDisabled && counter < 4) {
                              Utility.printLog('Starting timer again !');
                              startTimer();
                            }
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
