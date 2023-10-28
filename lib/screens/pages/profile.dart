part of screens;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void logout() async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "user_id": Application.user?.id ?? "0",
    };
    String url = '${Constants.finalUrl}/logout';
    Map<String, dynamic> updateSessionCount =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = updateSessionCount['status'];
    var data = updateSessionCount['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success_logout') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(19), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAll(
            () => const SplashScreen(),
          );
        });
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        preferredSize: const Size.fromHeight(70.0),
        showLeadingIcon: true,
        centerTitle: true,
        title: const Text(
          'Profile',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 24.0,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20.0,
                ),
                ((Application.user?.profileImage ?? "").isEmpty)
                    ? CustomIcon(
                        icon: Icons.close,
                        borderWidth: 0.0,
                        borderColor: AppColors.transparent,
                        isShowDot: false,
                        radius: 90.0,
                        iconSize: 30.0,
                        iconColor: AppColors.white,
                        top: 0,
                        right: 0,
                        borderRadius: 0.0,
                        isShowBorder: false,
                        bgColor: AppColors.background,
                        isNameInitial: true,
                        fontSize: 40.0,
                        name: (Application.user?.name ?? '')[0],
                      )
                    : CircularAvatar(
                        url: Constants.imgFinalUrl +
                            ((Application.user?.profileImage ?? "").isEmpty
                                ? Application.profileImage
                                : (Application.user?.profileImage ?? "")),
                        radius: 90.0,
                        borderColor: AppColors.highlight,
                        borderWidth: 3.0,
                      ),
                const SizedBox(
                  width: 24.0,
                ),
                Expanded(
                  child: Text(
                    'Hello,\n${Application.user?.name}',
                    style: const TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 20.0,
                      fontFamily: Fonts.montserratSemiBold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            profileCard(
              title: 'Edit profile',
              icon: SvgIcons.profile,
              bgColor: AppColors.background,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Edit profile Clicked');
                Get.to(
                  () => const EditProfile(),
                  transition: Transition.rightToLeft,
                );
              },
            ),
            profileCard(
              title: 'My Orders',
              icon: SvgIcons.profileCart,
              bgColor: AppColors.background,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('My orders Clicked');
                Get.to(
                  () => const MyOrders(),
                  transition: Transition.rightToLeft,
                );
              },
            ),
            profileCard(
              title: 'My Addresses',
              icon: SvgIcons.address,
              bgColor: AppColors.background,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('My Addresses Clicked');
                Get.to(
                  () => const MyAddresses(),
                  transition: Transition.rightToLeft,
                );
              },
            ),
            profileCard(
              title: 'Contact us',
              icon: SvgIcons.contact,
              bgColor: AppColors.background,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Contact us Clicked');
                Get.to(
                  () => WebviewScreens(
                    url: Constants.imgFinalUrl + Application.contactUs,
                    title: 'Contact us',
                  ),
                  transition: Transition.rightToLeft,
                );
              },
            ),
            profileCard(
              title: 'FAQ',
              icon: SvgIcons.faq,
              bgColor: AppColors.background,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Frequently Asked Questions Clicked');
                Get.to(
                  () => WebviewScreens(
                    url: Constants.imgFinalUrl + Application.faqUrl,
                    title: 'Frequently Asked Questions',
                  ),
                  transition: Transition.rightToLeft,
                );
              },
            ),
            profileCard(
              title: 'Privacy Policies',
              icon: SvgIcons.privacy,
              bgColor: AppColors.background,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Privacy policy Clicked');
                Get.to(
                  () => WebviewScreens(
                    url: Constants.imgFinalUrl + Application.privacyPolicyUrl,
                    title: 'Privacy Policy',
                    isShowTab: false,
                  ),
                  transition: Transition.rightToLeft,
                );
              },
            ),
            profileCard(
              title: 'Terms and conditions',
              icon: SvgIcons.tandc,
              bgColor: AppColors.background,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Terms and condition Clicked');
                Get.to(
                  () => WebviewScreens(
                    url: Constants.imgFinalUrl +
                        Application.termsAndConditionUrl,
                    title: 'Terms and conditions',
                    isShowTab: false,
                  ),
                  transition: Transition.rightToLeft,
                );
              },
            ),
            profileCard(
              title: 'Refund & Shipping policies',
              icon: SvgIcons.shipping,
              bgColor: AppColors.background,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Refund policy Clicked');
                Get.to(
                  () => WebviewScreens(
                    url: Constants.imgFinalUrl + Application.refundPolicyUrl,
                    title: 'Refund & Shipping policies',
                    isShowTab: false,
                  ),
                  transition: Transition.rightToLeft,
                );
              },
            ),
            profileCard(
              title: 'Logout',
              icon: SvgIcons.logOut,
              bgColor: AppColors.background,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Logout Clicked');
                Utility.twoButtonPopup(
                    context,
                    Icons.warning_amber_rounded,
                    40.0,
                    AppColors.highlight,
                    AlertMessages.getMessage(18),
                    'No',
                    'Yes', onFirstButtonClicked: () {
                  Get.back();
                }, onSecondButtonClicked: () {
                  Get.back();
                  logout();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget profileCard({
    required String title,
    required Widget icon,
    required Color bgColor,
    required Color iconColor,
    required Function() onClicked,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: GestureDetector(
        onTap: onClicked,
        child: Container(
          margin: const EdgeInsets.only(bottom: 25.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.richBlack.withOpacity(0.0),
                blurRadius: 30.0, // soften the shadow
                spreadRadius: 0.0, //extend the shadow
                offset: const Offset(
                  0.0, // Move to right 10  horizontally
                  0.0, // Move to bottom 10 Vertically
                ),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: AppColors.background,
                  height: 44.0,
                  width: 44.0,
                  child: Center(
                    child: icon,
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 16.0,
                      fontFamily: Fonts.montserratMedium,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20.0,
                  color: AppColors.richBlack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
