part of screens;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController slideAnimation;
  late Animation<Offset> offsetAnimation;
  late Animation<Offset> textAnimation;
  bool isLoading = false;
  List<String> onboardingSlider = [];

  Future<void> getAppData() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    String url = '${Constants.finalUrl}/createUser';
    Map<String, dynamic> getResult = await ApiFunctions.getApiResult(
        url, Application.deviceToken,
        version: info.version);

    bool status = getResult['status'];
    var data = getResult['data'];
    if (status) {
      if (data[ApiKeys.message] == 'User_Authenticated_successfully' ||
          data[ApiKeys.message] == 'User_created_successfully') {
        Application.isSplashDataLoaded = true;
        Application.user = Users.fromJson(data[ApiKeys.user][0]);
        Application.isShowForceUpdatePopup =
            data[ApiKeys.isShowForceUpdate] ?? false;
        Application.isPaymentAllowed = data[ApiKeys.isPaymentAllowed] ?? false;
        Application.isShowUpdatePopup = data[ApiKeys.isShowUpdate] ?? false;
      } else if (data[ApiKeys.message] == 'Auth_token_failure') {
        Application.isShowAuthPopup = true;
      } else {
        Application.isShowSomeErrorToast = true;
      }
      data[ApiKeys.slider].forEach((s) {
        onboardingSlider.add(s);
      });
      setSlider(onboardingSlider);
      Utility.showProgress(false);
      Future.delayed(const Duration(milliseconds: 1500), () {
        Application.loggedIn = Application.user?.loggedIn ?? false;
        Application.isOtpVerified = Application.user?.isOtpVerified ?? false;
        Application.userName = Application.user?.name ?? "";
        Application.phoneNumber = Application.user?.phoneNumber ?? "";
        Application.age = Application.user?.age ?? 0;
        if (Application.user?.status == 'BLOCKED') {
          showSnackBar(AlertMessages.getMessage(11), AppColors.lightRed,
              AppColors.warning, 90.0);
          Get.offAll(
            () => const LoginScreen(),
          );
        } else {
          if (Application.loggedIn) {
            Get.offAll(
              () => const MainContainer(),
            );
          } else {
            Utility.printLog(
                'Application phone number = ${Application.phoneNumber}');
            if (Application.phoneNumber.isEmpty) {
              Utility.printLog(
                  'Application phone number 1 = ${Application.phoneNumber}');
              Get.offAll(
                () => const LoginScreen(),
              );
            } else {
              Utility.printLog(
                  'Application phone number 1 = ${Application.phoneNumber}');
              if (Application.isOtpVerified) {
                if (Application.userName.isEmpty) {
                  Get.offAll(
                    () => const UserDetailScreen(),
                  );
                } else if (Application.age == 0) {
                  Get.offAll(
                    () => UserHeightWeight(
                      name: Application.userName,
                      email: Application.user?.email,
                      selectedImage: Application.user?.profileImage,
                      gender: Application.user?.gender ?? 'MALE',
                    ),
                  );
                } else {
                  Get.offAll(
                    () => const LoginScreen(),
                  );
                }
              } else {
                Utility.printLog(
                    'Application phone number 2 = ${Application.phoneNumber}');
                // Get.offAll(
                //   () => OtpScreen(
                //     phoneNumber: Application.phoneNumber,
                //     verificationId: '',
                //   ),
                // );
                Get.offAll(
                  () => const LoginScreen(),
                );
              }
            }
          }
        }
      });
    } else {
      Utility.printLog('Something went wrong.');
      Application.isShowSomeErrorToast = true;
      Utility.showProgress(false);
    }
  }

  void setSlider(List<String> slider) {
    Provider.of<MainContainerProvider>(context, listen: false)
        .setSlider(slider);
  }

  void showSnackBar(String message, Color bgColor, Color title, double height) {
    Utility.showSnacbar(
      context,
      message,
      bgColor,
      title,
      duration: 10 * 6 * 5,
      height,
    );
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 60,
      animationBehavior: AnimationBehavior.normal,
      duration: const Duration(milliseconds: 700),
    );

    animationController.forward();

    slideAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: slideAnimation,
        curve: Curves.easeInToLinear,
      ),
    );

    textAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: const Offset(0.2, 0.0),
    ).animate(
      CurvedAnimation(
        parent: slideAnimation,
        curve: Curves.fastOutSlowIn,
      ),
    );

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        slideAnimation.forward();
      }
    });

    getAppData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.lightYellow,
        width: double.infinity,
        height: double.infinity,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (_, child) {
            return SlideTransition(
              position: offsetAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.logo,
                    width: 120.0,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                  // const SizedBox(
                  //   height: 20.0,
                  // ),
                  // const Text(
                  //   'HEALFIT',
                  //   style: TextStyle(
                  //     fontFamily: Fonts.helixExtraBold,
                  //     fontSize: 48.0,
                  //   ),
                  // )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
