part of config;

class Constants {
  // Make true for Development otherwise false
  static bool isDevelopment = false;

  //BackendUrls
  static String devBackendUrl = 'http://172.20.10.3:3000/api';
  static String devProductBackendUrl = 'http://172.20.10.3:3006';
  static String devImgBackendUrl = 'http://172.20.10.3:3000';
  static String prodBackendUrl = 'https://healfit.in/api';
  static String prodProductBackendUrl = 'https://curect.healfit.in';
  static String imgBackendUrl = 'https://healfit.in';
  static String internetCheckUrl = 'healfit.in';
  static String finalUrl = isDevelopment ? devBackendUrl : prodBackendUrl;
  static String finalProductUrl =
      isDevelopment ? devProductBackendUrl : prodProductBackendUrl;
  static String imgFinalUrl = isDevelopment ? devImgBackendUrl : imgBackendUrl;

  //Folders
  static String folderName = "HealFit";
  static String folderPath = '/storage/emulated/0/Download/$folderName';

  //App defaults
  static String iosAppStoreId = '1645721639';
  static String androidPlayStoreId = 'com.healfit.heal_fit';
  static String iosBundleId = 'com.healfit.healFit';

  //Firebase Dynamic Links
  static const firebaseLinkDomain = 'https://healfit.page.link';
  static const firebaseReferLink = 'https://';
}

//Application colors
class AppColors {
  static const Color richBlack = Color(0xff080909);
  static const Color black = Color(0xff000000);
  static const Color subText = Color(0xff879DA1);
  static const Color defaultInputBorders = Color(0xffD9E7EA);
  static const Color highlight = Color(0xffFFCE30);
  static const Color lightYellow = Color(0xffFFFAEA);
  static const Color placeholder = Color(0xffBDCBCE);
  static const Color white = Color(0xffffffff);
  static const Color background = Color(0xffFAFAFB);
  static const Color warning = Color(0xffFF3333);
  static const Color congrats = Color(0xff3EDE61);
  static const Color lightGreen = Color(0xffE5FFE1);
  static const Color lightRed = Color(0xffFFEAEA);
  static const Color cardBg = Color(0xffE1F0F4);
  static const Color lightCardBg = Color(0xffF4FDFF);
  static const Color unselectedIconColor = Color(0xffDBDBDB);
  static const Color transparent = Colors.transparent;
}

//Application fonts
class Fonts {
  static const String helixRegular = 'Hellix-Regular';
  static const String helixBold = 'Hellix-Bold';
  static const String helixBlack = 'Hellix-Black';
  static const String helixLight = 'Hellix-Light';
  static const String helixExtraBold = 'Hellix-ExtraBold';
  static const String helixMedium = 'Hellix-Medium';
  static const String helixSemiBold = 'Hellix-SemiBold';
  static const String gilroyRegular = 'Gilroy-Regular';
  static const String gilroyBold = 'Gilroy-Bold';
  static const String gilroyBlack = 'Gilroy-Black';
  static const String gilroyLight = 'Gilroy-Light';
  static const String gilroyExtraBold = 'Gilroy-ExtraBold';
  static const String gilroyMedium = 'Gilroy-Medium';
  static const String gilroySemiBold = 'Gilroy-SemiBold';
}

//Application images
class Images {
  static const logo = 'assets/images/logo.png';
  static const curectLogo = 'assets/images/curectLogo.png';
  static const curectLogo1 = 'assets/images/curectLogo1.png';
  static const curectLogoName = 'assets/images/curectLogoName.png';
  static const male = 'assets/images/male.png';
  static const female = 'assets/images/female.png';
  static const trans = 'assets/images/trans.png';
  static const userDetail = 'assets/images/userDetail.png';
  static const fork = 'assets/images/fork.png';
  static const insights = 'assets/images/insights.png';
  static const add = 'assets/images/add.png';
  static const breakfast = 'assets/images/breakfast.png';
  static const dinner = 'assets/images/dinner.png';
  static const snacks = 'assets/images/snacks.png';
  static const lunch = 'assets/images/lunch.png';
  static const workout = 'assets/images/workout.png';
  static const noDataAvailable = 'assets/images/no_data_available.png';
  static const internetError = 'assets/images/internet_error.png';
  static const profileFlow = 'assets/images/profileFlow.gif';
}

//Files
class Files {
  static const countryCodes = 'assets/jsons/country_codes.json';
}
