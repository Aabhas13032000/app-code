part of config;

class Application {
  //Define Application variables
  static bool isDeepLink = false;
  static bool callAPI = false;
  static bool isShowUpdatePopup = false;
  static bool isShowForceUpdatePopup = false;
  static bool isShowAuthPopup = false;
  static bool isShowBlockedPopup = false;
  static bool isShowLogoutPopup = false;
  static bool isShowDatabasePopup = false;
  static String deepLinkUrl = '';
  static String appVersion = '';
  static String iosAppVersion = '';
  static String fcmToken = '';
  static String deviceToken = '';
  static String deviceId = '';
  static String userId = '';
  static String userName = '';
  static String address = '';
  static String pinCode = '';
  static String languageId = '';
  static String phoneNumber = '';
  static String adminPhoneNumber = '';
  static String shareText = '';
  static String profileImage = '';
  static bool loggedIn = false;
  static bool isOtpVerified = false;
  static bool isSplashDataLoaded = false;
  static bool isShowSomeErrorToast = false;
  static bool isPaymentAllowed = false;
  static int age = 0;
  static String termsAndConditionUrl = '/terms-conditions';
  static String aboutUs = '/about-mobile';
  static String contactUs = '/contact-mobile';
  static String privacyPolicyUrl = '/privacy-policy';
  static String refundPolicyUrl = '/refund-policy';
  static String faqUrl = '/faq-mobile';

  //userData
  static Users? user;

  //index
  static int previousIndex = 0;
  static int currentIndex = 0;

  //App initialisation
  static init() {
    Application.deviceToken = '';
  }

  //Create file of pdf url
  static Future<File> createFileOfPdfUrl(String path) async {
    Completer<File> completer = Completer();
    Utility.printLog("Start download file from internet!");
    try {
      final url = path;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      Utility.printLog("Download files");
      Utility.printLog("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  //Generate share link
  static Future<String> generateShareLink(
      String itemId, String type, String link) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "link": Constants.imgBackendUrl + link,
      "item_id": itemId,
      "type": type,
    };
    String url = '${Constants.finalUrl}/generateShareLink';
    Map<String, dynamic> generateLink =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = generateLink['status'];
    var data = generateLink['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        return data[ApiKeys.shareLink];
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        return 'error';
      } else {
        Utility.showProgress(false);
        return 'error';
      }
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      return 'error';
    }
  }

  //Open share plus
  static void onShare(
      BuildContext context, String remotePDFpath, String shareText) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.shareFiles(
      [remotePDFpath],
      text: shareText,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  //open pdf on browser
  static openPdf(String path, BuildContext context) async {
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(path.replaceAll(' ', '%20')))) {
        await launchUrl(Uri.parse(path.replaceAll(' ', '%20')));
      } else {
        Utility.showSnacbar(context, AlertMessages.getMessage(2),
            AppColors.lightYellow, AppColors.highlight, 50.0);
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(path.replaceAll(' ', '%20')))) {
        await launchUrl(Uri.parse(path.replaceAll(' ', '%20')));
      } else {
        Utility.showSnacbar(context, AlertMessages.getMessage(2),
            AppColors.lightYellow, AppColors.highlight, 50.0);
      }
    }
    // }
  }

  static void goBack(BuildContext context) {
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
}
