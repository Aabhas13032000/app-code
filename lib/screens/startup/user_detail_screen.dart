part of screens;

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  File? image;
  String state = "";
  String selectedImage = '';
  String url = Constants.finalUrl;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String gender = '';
  bool isFullNameFocused = false;
  bool isEmailFocused = false;
  final FocusNode _focus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  Future pickImage() async {
    Utility.showProgress(true);
    bool permissionsGranted = false;
    if (Platform.isIOS) {
      Future.delayed(const Duration(microseconds: 100), () async {
        Map<Permission, PermissionStatus> permissions = await [
          Permission.storage,
        ].request();
        permissionsGranted = permissions[Permission.storage]!.isGranted;
        if (permissionsGranted) {
          try {
            final image =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (image == null) {
              Utility.showProgress(false);
              return;
            }
            final imageTemporary = File(image.path);
            var res = await uploadImage(image.path, '$url/saveUserOrderImage');
            Utility.showProgress(false);
            setState(() {
              this.image = imageTemporary;
              state = res!;
              selectedImage = res;
            });
          } on PlatformException catch (e) {
            Utility.printLog('Failed to pick image $e');
            Utility.showProgress(false);
          }
        } else if (permissions[Permission.storage]!.isPermanentlyDenied) {
          openAppSettings();
        }
      });
    } else {
      var deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt <= 29) {
        Future.delayed(const Duration(microseconds: 100), () async {
          Map<Permission, PermissionStatus> permissions = await [
            Permission.storage,
          ].request();
          permissionsGranted = permissions[Permission.storage]!.isGranted;
          if (permissionsGranted) {
            try {
              final image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (image == null) {
                Utility.showProgress(false);
                return;
              }
              final imageTemporary = File(image.path);
              var res =
                  await uploadImage(image.path, '$url/saveUserOrderImage');
              Utility.showProgress(false);
              setState(() {
                this.image = imageTemporary;
                state = res!;
                selectedImage = res;
              });
            } on PlatformException catch (e) {
              Utility.printLog('Failed to pick image $e');
              Utility.showProgress(false);
            }
          } else if (permissions[Permission.storage]!.isPermanentlyDenied) {
            openAppSettings();
          }
        });
      } else {
        try {
          final image =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (image == null) {
            Utility.showProgress(false);
            return;
          }
          final imageTemporary = File(image.path);
          var res = await uploadImage(image.path, '$url/saveUserOrderImage');
          Utility.showProgress(false);
          setState(() {
            this.image = imageTemporary;
            state = res!;
            selectedImage = res;
          });
        } on PlatformException catch (e) {
          Utility.printLog('Failed to pick image $e');
          Utility.showProgress(false);
        }
      }
    }
    Utility.showProgress(false);
  }

  void saveData() async {
    Utility.showProgress(true);
    Map<String, String> params = {
      'name': fullNameController.text.trim(),
      'email': emailController.text.trim(),
      'gender': gender == 'female'
          ? 'FEMALE'
          : gender == 'male'
              ? 'MALE'
              : 'OTHERS',
      'age': '0',
      'weight': '0',
      'target_weight': '0',
      'profile_image': image == null ? '' : selectedImage,
      'height': '0',
      'user_id': Application.user?.id ?? '0',
      'phoneNumber': Application.user?.phoneNumber ?? '',
      "medical_conditions": '',
      "food_allergies": '',
      "goal": '',
      "country_code": Application.user?.countryCode ?? '0',
    };
    String url = '${Constants.finalUrl}/updateData';
    Map<String, dynamic> loginData =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = loginData['status'];
    var data = loginData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'Updated_successfully') {
        Application.profileImage = image == null
            ? gender == 'female'
                ? '/images/local/female.png'
                : gender == 'male'
                    ? '/images/local/male.png'
                    : '/images/local/trans.png'
            : selectedImage;
        Application.loggedIn = true;
        Application.user = Users.fromJson(data[ApiKeys.user][0]);
        Application.isPaymentAllowed = data[ApiKeys.isPaymentAllowed] ?? false;
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(10), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAll(
            () => const MainContainer(),
          );
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

  Future<String?> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    final responseData = await res.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    return json.decode(responseString)['path'].toString();
  }

  @override
  void initState() {
    // Utility.showProgress(true);
    _focus.addListener(_onFocusChange);
    _emailFocus.addListener(_onEmailFocusChange);
    super.initState();
  }

  void _onFocusChange() {
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

  void _onEmailFocusChange() {
    if (isEmailFocused) {
      setState(() {
        isEmailFocused = false;
      });
    } else {
      setState(() {
        isEmailFocused = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50.0,
              ),
              const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: Fonts.montserratSemiBold,
                  color: AppColors.richBlack,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'Tell us something about yourself',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: Fonts.montserratMedium,
                  color: AppColors.subText,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pickImage();
                          },
                          child: imageSelector(),
                        ),
                        image == null
                            ? const SizedBox()
                            : Positioned(
                                bottom: 8,
                                right: -2,
                                child: GestureDetector(
                                  onTap: () {
                                    Utility.twoButtonPopup(
                                        context,
                                        Icons.warning_amber_rounded,
                                        40.0,
                                        AppColors.warning,
                                        AlertMessages.getMessage(3),
                                        'No',
                                        'Yes', onFirstButtonClicked: () {
                                      Get.back();
                                    }, onSecondButtonClicked: () {
                                      setState(() {
                                        image = null;
                                        state = '';
                                        selectedImage = '';
                                      });
                                      Get.back();
                                    });
                                  },
                                  child: Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                      color: AppColors.warning,
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.delete_outline,
                                        size: 20.0,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
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
                        focusNode: _focus,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 16.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                        controller: fullNameController,
                        cursorColor: AppColors.defaultInputBorders,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                        cursorWidth: 1.5,
                        decoration: InputDecoration(
                          hintMaxLines: 1,
                          hintText: 'Enter your full name',
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
                            'Full name',
                            style: TextStyle(
                              color: isFullNameFocused
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
              SizedBox(
                height: 55.0,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 55.0,
                      child: TextField(
                        focusNode: _emailFocus,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 16.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                        controller: emailController,
                        cursorColor: AppColors.defaultInputBorders,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        cursorWidth: 1.5,
                        decoration: InputDecoration(
                          hintMaxLines: 1,
                          hintText: 'Enter your email',
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
                            'Email (optional)',
                            style: TextStyle(
                              color: isEmailFocused
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
                height: 20.0,
              ),
              const Text(
                'Select your gender',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: Fonts.montserratMedium,
                  color: AppColors.richBlack,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              genderSelection(),
              const SizedBox(
                height: 30.0,
              ),
              CustomButton(
                title: 'Save',
                textColor: AppColors.white,
                paddingVertical: 18,
                onPressed: () {
                  if (fullNameController.text.isEmpty) {
                    Utility.showSnacbar(
                      context,
                      'Please enter your full name.',
                      AppColors.lightRed,
                      AppColors.warning,
                      duration: 2,
                      50.0,
                    );
                  } else if (gender.isEmpty) {
                    Utility.showSnacbar(
                      context,
                      'Please select a gender.',
                      AppColors.lightRed,
                      AppColors.warning,
                      duration: 2,
                      50.0,
                    );
                  } else {
                    saveData();
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
    );
  }

  Widget imageSelector() {
    return Container(
      height: 140.0,
      width: 140.0,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(
          width: 3.0,
          color: AppColors.highlight,
        ),
      ),
      child: Center(
        child: Container(
          height: 120.0,
          width: 120.0,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(
                    150.0,
                  ),
                  child: Image.file(
                    image!,
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                )
              : const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 32,
                      color: AppColors.highlight,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Add profile photo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: Fonts.montserratMedium,
                        color: AppColors.highlight,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget genderSelection() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                gender = 'female';
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color:
                    gender == 'female' ? AppColors.background : AppColors.white,
                borderRadius: BorderRadius.circular(
                  0.0,
                ),
                border: Border.all(
                  width: 2.0,
                  color: gender == 'female'
                      ? AppColors.background
                      : AppColors.defaultInputBorders,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   Images.female,
                    //   height: 40.0,
                    //   width: 40.0,
                    //   fit: BoxFit.cover,
                    // ),
                    // const SizedBox(
                    //   height: 15.0,
                    // ),
                    Text(
                      'Women',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: Fonts.montserratSemiBold,
                        color: AppColors.richBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                gender = 'male';
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color:
                    gender == 'male' ? AppColors.background : AppColors.white,
                borderRadius: BorderRadius.circular(
                  0.0,
                ),
                border: Border.all(
                  width: 2.0,
                  color: gender == 'male'
                      ? AppColors.background
                      : AppColors.defaultInputBorders,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   Images.male,
                    //   height: 40.0,
                    //   width: 40.0,
                    //   fit: BoxFit.cover,
                    // ),
                    // const SizedBox(
                    //   height: 15.0,
                    // ),
                    Text(
                      'Men',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: Fonts.montserratSemiBold,
                        color: AppColors.richBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                gender = 'others';
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color:
                    gender == 'others' ? AppColors.background : AppColors.white,
                borderRadius: BorderRadius.circular(
                  0.0,
                ),
                border: Border.all(
                  width: 2.0,
                  color: gender == 'others'
                      ? AppColors.background
                      : AppColors.defaultInputBorders,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   Images.trans,
                    //   height: 40.0,
                    //   width: 40.0,
                    //   fit: BoxFit.cover,
                    // ),
                    // const SizedBox(
                    //   height: 15.0,
                    // ),
                    Text(
                      'Others',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: Fonts.montserratSemiBold,
                        color: AppColors.richBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
