part of config;

class Constants {
  // Make true for Development otherwise false
  static bool isDevelopment = false;

  //BackendUrls
  static String devBackendUrl = 'http://172.20.10.4:3000/api';
  static String devProductBackendUrl = 'http://172.20.10.4:3000';
  static String devImgBackendUrl = 'http://172.20.10.4:3000';
  static String prodBackendUrl = 'https://curect.in/api';
  static String prodProductBackendUrl = 'https://curect.in/api';
  static String imgBackendUrl = 'https://curect.in';
  static String internetCheckUrl = 'curect.in';
  static String finalUrl =
      isDevelopment ? devBackendUrl : prodProductBackendUrl;
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
  static const Color defaultInputBorders = Color(0xffECEFF4);
  static const Color highlight = Color(0xff15141A);
  static const Color newhighlight = Color(0xffFFCE30);
  static const Color lightYellow = Color(0xffFFFAEA);
  static const Color placeholder = Color(0xffBDCBCE);
  static const Color white = Color(0xffffffff);
  static const Color background = Color(0xffEFF1F7);
  static const Color newbackground = Color(0xffFAFAFB);
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
  static const String montserratBold = 'Montserrat-Bold';
  static const String montserratBlack = 'Montserrat-Black';
  static const String montserratLight = 'Montserrat-Light';
  static const String montserratExtraBold = 'Montserrat-ExtraBold';
  static const String montserratMedium = 'Montserrat-Medium';
  static const String montserratSemiBold = 'Montserrat-SemiBold';
  static const String montserratRegular = 'Montserrat-Regular';
}

//Application images
class Images {
  static const logo = 'assets/images/logo.png';
  static const curectLogo = 'assets/images/curectLogo.png';
  static const curect = 'assets/images/curect.png';
  static const splashCurect = 'assets/images/splash_curect.png';
  static const curectName = 'assets/images/curect_name.png';
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

//Application svg icons
class SvgIcons {
  static Widget cart = SvgPicture.asset(
    'assets/icons/cart.svg',
    semanticsLabel: 'Acme Logo',
    width: 20.0,
    color: AppColors.unselectedIconColor,
  );
  static Widget profileCart = SvgPicture.asset(
    'assets/icons/cart.svg',
    semanticsLabel: 'Acme Logo',
    width: 16.0,
    color: AppColors.richBlack,
  );
  static Widget cartFilled = SvgPicture.asset(
    'assets/icons/cart_filled.svg',
    semanticsLabel: 'Acme Logo',
    width: 20.0,
    color: AppColors.highlight,
  );
  static Widget deleteIcon = SvgPicture.asset(
    'assets/icons/delete_icon.svg',
    semanticsLabel: 'Acme Logo',
    width: 20.0,
    color: AppColors.unselectedIconColor,
  );
  static Widget favourite = SvgPicture.asset(
    'assets/icons/favourite.svg',
    semanticsLabel: 'Acme Logo',
    width: 28.0,
    color: AppColors.unselectedIconColor,
  );
  static Widget favouriteFilled = SvgPicture.asset(
    'assets/icons/favourite_filled.svg',
    semanticsLabel: 'Acme Logo',
    width: 28.0,
    color: AppColors.highlight,
  );
  static Widget favouriteEachProduct = SvgPicture.asset(
    'assets/icons/favourite.svg',
    semanticsLabel: 'Acme Logo',
    width: 24.0,
    color: AppColors.highlight,
  );
  static Widget favouriteEachProductFilled = SvgPicture.asset(
    'assets/icons/favourite_filled.svg',
    semanticsLabel: 'Acme Logo',
    width: 24.0,
    color: AppColors.highlight,
  );
  static Widget feed = SvgPicture.asset(
    'assets/icons/feed.svg',
    semanticsLabel: 'Acme Logo',
    width: 24.0,
    color: AppColors.unselectedIconColor,
  );
  static Widget feedFilled = SvgPicture.asset(
    'assets/icons/feed_filled.svg',
    semanticsLabel: 'Acme Logo',
    width: 24.0,
    color: AppColors.highlight,
  );
  static Widget home = SvgPicture.asset(
    'assets/icons/home.svg',
    semanticsLabel: 'Acme Logo',
    width: 24.0,
    color: AppColors.unselectedIconColor,
  );
  static Widget homeFilled = SvgPicture.asset(
    'assets/icons/home_filled.svg',
    semanticsLabel: 'Acme Logo',
    width: 24.0,
    color: AppColors.highlight,
  );
  static Widget search = SvgPicture.asset(
    'assets/icons/search.svg',
    semanticsLabel: 'Acme Logo',
    width: 20.0,
    color: AppColors.subText,
  );
  static Widget address = SvgPicture.asset(
    'assets/icons/address.svg',
    semanticsLabel: 'Acme Logo',
    width: 16.0,
    color: AppColors.richBlack,
  );
  static Widget contact = SvgPicture.asset(
    'assets/icons/contact.svg',
    semanticsLabel: 'Acme Logo',
    width: 20.0,
    color: AppColors.richBlack,
  );
  static Widget faq = SvgPicture.asset(
    'assets/icons/faq.svg',
    semanticsLabel: 'Acme Logo',
    width: 20.0,
    color: AppColors.richBlack,
  );
  static Widget logOut = SvgPicture.asset(
    'assets/icons/log_out.svg',
    semanticsLabel: 'Acme Logo',
    width: 20.0,
    color: AppColors.richBlack,
  );
  static Widget mail = SvgPicture.asset(
    'assets/icons/mail.svg',
    semanticsLabel: 'Acme Logo',
    width: 20.0,
    color: AppColors.richBlack,
  );
  static Widget privacy = SvgPicture.asset(
    'assets/icons/privacy.svg',
    semanticsLabel: 'Acme Logo',
    width: 20.0,
    color: AppColors.richBlack,
  );
  static Widget profile = SvgPicture.asset(
    'assets/icons/profile.svg',
    semanticsLabel: 'Acme Logo',
    width: 20.0,
    color: AppColors.richBlack,
  );
  static Widget shipping = SvgPicture.asset(
    'assets/icons/shipping.svg',
    semanticsLabel: 'Acme Logo',
    width: 20.0,
    color: AppColors.richBlack,
  );
  static Widget tandc = SvgPicture.asset(
    'assets/icons/tandc.svg',
    semanticsLabel: 'Acme Logo',
    width: 20.0,
    color: AppColors.richBlack,
  );
}

//Files
class Files {
  static const countryCodes = 'assets/jsons/country_codes.json';
}
