import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../config/config.dart';

class Utility {
  //Print statement function
  static void printLog(String msg) {
    // if (Constants.isDevelopment) {
    print(msg);
    // }
  }

  //show progress
  static void showProgress(bool status) {
    if (status) {
      EasyLoading.show(
        status: 'Please Wait',
        maskType: EasyLoadingMaskType.black,
      );
    } else {
      EasyLoading.dismiss();
    }
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnacbar(
      BuildContext context,
      String message,
      Color bgColor,
      Color borderColor,
      double height,
      {int duration = 1,
      Function? onClicked}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: GestureDetector(
          onTap: () {
            if (onClicked != null) {
              onClicked();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: 1.5,
                color: borderColor,
              ),
            ),
            height: height,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: borderColor,
                        fontSize: 14.0,
                        fontFamily: Fonts.gilroySemiBold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  icon: const Icon(Icons.close),
                  iconSize: 24.0,
                  color: borderColor,
                )
              ],
            ),
          ),
        ),
        backgroundColor: AppColors.richBlack.withOpacity(0.0),
        padding:
            const EdgeInsets.only(bottom: 20, left: 8.0, right: 8.0, top: 20),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        elevation: 0,
      ),
    );
  }

  //Two button Popup
  static Future<void> twoButtonPopup(
    BuildContext context,
    IconData icon,
    double iconSize,
    Color iconColor,
    String message,
    String buttonOneText,
    String buttonTwoText, {
    Function? onFirstButtonClicked,
    Function? onSecondButtonClicked,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: const EdgeInsets.all(0.0),
          title: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
          content: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: Fonts.gilroyMedium,
                        fontSize: 18.0,
                        color: AppColors.richBlack,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            onFirstButtonClicked!();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                width: 2.0,
                                color: AppColors.highlight,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 0.0),
                                child: Text(
                                  buttonOneText,
                                  style: const TextStyle(
                                    fontFamily: Fonts.gilroySemiBold,
                                    fontSize: 16.0,
                                    color: AppColors.highlight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            onSecondButtonClicked!();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.highlight,
                              border: Border.all(
                                width: 2.0,
                                color: AppColors.highlight,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 0.0),
                                child: Text(
                                  buttonTwoText,
                                  style: const TextStyle(
                                    fontFamily: Fonts.gilroySemiBold,
                                    fontSize: 16.0,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //Single Button popup
  static Future<void> singleButtonPopup(
    BuildContext context,
    IconData icon,
    double iconSize,
    Color iconColor,
    String message,
    String buttonText, {
    Function? onButtonClicked,
    bool isForceUpdate = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => isForceUpdate ? false : true,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: const EdgeInsets.all(0.0),
            title: Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
            content: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: Fonts.gilroyMedium,
                          fontSize: 18.0,
                          color: AppColors.richBlack,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              onButtonClicked!();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.highlight,
                                border: Border.all(
                                  width: 2.0,
                                  color: AppColors.highlight,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 0.0),
                                  child: Text(
                                    buttonText,
                                    style: const TextStyle(
                                      fontFamily: Fonts.gilroySemiBold,
                                      fontSize: 16.0,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
