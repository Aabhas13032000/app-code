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
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        preferredSize: const Size.fromHeight(70.0),
        showLeadingIcon: true,
        centerTitle: true,
        title: const Text(
          'Profile',
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
                CircularAvatar(
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
                    'Hello\n${Application.user?.name}',
                    style: const TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 20.0,
                      fontFamily: Fonts.helixSemiBold,
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
              icon: Icons.person_outline_rounded,
              bgColor: AppColors.lightYellow,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Edit profile Clicked');
                Get.to(
                  () => const EditProfile(),
                );
              },
            ),
            profileCard(
              title: 'My Orders',
              icon: MdiIcons.cartOutline,
              bgColor: AppColors.lightYellow,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('My orders Clicked');
                Get.to(
                  () => const MyOrders(),
                );
              },
            ),
            profileCard(
              title: 'My programs',
              icon: Icons.play_circle_outline_rounded,
              bgColor: AppColors.lightYellow,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('My programs Clicked');
                Get.to(
                  () => const MyPrograms(),
                );
              },
            ),
            profileCard(
              title: 'Purchased books',
              icon: Icons.book_outlined,
              bgColor: AppColors.lightYellow,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Purchased books Clicked');
                Get.to(
                  () => const PurchasedBooks(),
                );
              },
            ),
            profileCard(
              title: 'About',
              icon: Icons.info_outline,
              bgColor: AppColors.lightYellow,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('About Clicked');
                Get.to(
                  () => WebviewScreens(
                    url: Constants.imgFinalUrl + Application.aboutUs,
                    title: 'About us',
                  ),
                );
              },
            ),
            profileCard(
              title: 'Contact us',
              icon: Icons.local_phone_outlined,
              bgColor: AppColors.lightYellow,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Contact us Clicked');
                Get.to(
                  () => WebviewScreens(
                    url: Constants.imgFinalUrl + Application.contactUs,
                    title: 'Contact us',
                  ),
                );
              },
            ),
            profileCard(
              title: 'FAQ',
              icon: Icons.message_outlined,
              bgColor: AppColors.lightYellow,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Frequently Asked Questions Clicked');
                Get.to(
                  () => WebviewScreens(
                    url: Constants.prodProductBackendUrl + Application.faqUrl,
                    title: 'Frequently Asked Questions',
                  ),
                );
              },
            ),
            profileCard(
              title: 'Privacy Policies',
              icon: Icons.lock_outline_rounded,
              bgColor: AppColors.lightYellow,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Privacy policy Clicked');
                openBottomOptions(
                    Constants.prodProductBackendUrl +
                        Application.privacyPolicyUrl,
                    Constants.imgFinalUrl + Application.privacyPolicyUrl);
              },
            ),
            profileCard(
              title: 'Terms and conditions',
              icon: Icons.privacy_tip_outlined,
              bgColor: AppColors.lightYellow,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Terms and condition Clicked');
                openBottomOptions(
                    Constants.prodProductBackendUrl +
                        Application.termsAndConditionUrl,
                    Constants.imgFinalUrl + Application.termsAndConditionUrl);
              },
            ),
            profileCard(
              title: 'Refund & Shipping policies',
              icon: Icons.bookmark_border_rounded,
              bgColor: AppColors.lightYellow,
              iconColor: AppColors.highlight,
              onClicked: () {
                Utility.printLog('Refund policy Clicked');
                openBottomOptions(
                    Constants.prodProductBackendUrl +
                        Application.refundPolicyUrl,
                    Constants.imgFinalUrl + Application.refundPolicyUrl);
              },
            ),
            profileCard(
              title: 'Logout',
              icon: Icons.logout,
              bgColor: AppColors.lightRed,
              iconColor: AppColors.warning,
              onClicked: () {
                Utility.printLog('Logout Clicked');
                Utility.twoButtonPopup(
                    context,
                    Icons.warning_amber_rounded,
                    40.0,
                    AppColors.warning,
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

  void openBottomOptions(String productUrl, String programUrl) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.0),
      enableDrag: true,
      builder: (BuildContext context) {
        return Container(
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
                  constraints: const BoxConstraints(maxHeight: 450.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          eachBottomOption(
                            'Product',
                            WebviewScreens(
                              url: productUrl,
                              title: 'Product - Privacy Policy',
                              isShowTab: false,
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          eachBottomOption(
                            'Program',
                            WebviewScreens(
                              url: programUrl,
                              title: 'Program - Privacy Policy',
                              isShowTab: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget eachBottomOption(String name, Widget widget) {
    return GestureDetector(
      onTap: () {
        Get.back();
        Get.to(
          () => widget,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.cardBg,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            top: 15.0,
            bottom: 15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                maxLines: 2,
                style: const TextStyle(
                  color: AppColors.richBlack,
                  fontSize: 16.0,
                  fontFamily: Fonts.helixSemiBold,
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              const CustomIcon(
                icon: Icons.arrow_forward_ios_rounded,
                borderWidth: 0.0,
                borderColor: AppColors.highlight,
                isShowDot: false,
                radius: 30.0,
                iconSize: 22.0,
                iconColor: AppColors.richBlack,
                top: 0,
                right: 0,
                borderRadius: 50.0,
                isShowBorder: false,
                bgColor: AppColors.transparent,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget profileCard({
    required String title,
    required IconData icon,
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
          margin: const EdgeInsets.only(bottom: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.richBlack.withOpacity(0.06),
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
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomIcon(
                  icon: icon,
                  borderWidth: 0.0,
                  borderColor: bgColor,
                  isShowDot: false,
                  radius: 45.0,
                  iconSize: 22.0,
                  iconColor: iconColor,
                  top: 0,
                  right: 0,
                  borderRadius: 50.0,
                  isShowBorder: false,
                  bgColor: bgColor,
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
                      fontFamily: Fonts.gilroyMedium,
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
