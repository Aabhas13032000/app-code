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
    if(Platform.isIOS) {
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
      if (androidInfo.version.sdkInt! <= 29) {
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
                  fontFamily: Fonts.helixSemiBold,
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
                  fontFamily: Fonts.gilroyMedium,
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
                                      borderRadius: BorderRadius.circular(50.0),
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
                          fontFamily: Fonts.gilroyMedium,
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
                            fontFamily: Fonts.gilroyMedium,
                          ),
                          focusColor: AppColors.placeholder,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: AppColors.highlight,
                              width: 2.0,
                            ),
                          ),
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                              fontFamily: Fonts.gilroySemiBold,
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
                          fontFamily: Fonts.gilroyMedium,
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
                            fontFamily: Fonts.gilroyMedium,
                          ),
                          focusColor: AppColors.placeholder,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: AppColors.highlight,
                              width: 2.0,
                            ),
                          ),
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                              fontFamily: Fonts.gilroySemiBold,
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
                  fontFamily: Fonts.gilroyMedium,
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
                title: 'Next',
                textColor: AppColors.white,
                onPressed: () {
                  // if (image == null) {
                  //   Utility.showSnacbar(
                  //     context,
                  //     'Please select a profile image.',
                  //     AppColors.lightRed,
                  //     AppColors.warning,
                  //     duration: 2,
                  //     50.0,
                  //   );
                  // } else
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
                    Get.to(() => UserHeightWeight(
                          name: fullNameController.text,
                          email: emailController.text,
                          selectedImage: image == null
                              ? gender == 'female'
                                  ? '/images/local/female.png'
                                  : gender == 'male'
                                      ? '/images/local/male.png'
                                      : '/images/local/trans.png'
                              : selectedImage,
                          gender: gender == 'female'
                              ? 'FEMALE'
                              : gender == 'male'
                                  ? 'MALE'
                                  : 'OTHERS',
                        ));
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
        borderRadius: BorderRadius.circular(150.0),
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
            color: AppColors.lightYellow,
            borderRadius: BorderRadius.circular(150.0),
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
                        fontFamily: Fonts.gilroyMedium,
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
                color: gender == 'female'
                    ? AppColors.lightYellow
                    : AppColors.white,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                border: Border.all(
                  width: 2.0,
                  color: gender == 'female'
                      ? AppColors.highlight
                      : AppColors.defaultInputBorders,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Images.female,
                      height: 40.0,
                      width: 40.0,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text(
                      'Women',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: Fonts.gilroySemiBold,
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
          width: 15.0,
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
                    gender == 'male' ? AppColors.lightYellow : AppColors.white,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                border: Border.all(
                  width: 2.0,
                  color: gender == 'male'
                      ? AppColors.highlight
                      : AppColors.defaultInputBorders,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Images.male,
                      height: 40.0,
                      width: 40.0,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text(
                      'Men',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: Fonts.gilroySemiBold,
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
          width: 15.0,
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
                color: gender == 'others'
                    ? AppColors.lightYellow
                    : AppColors.white,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                border: Border.all(
                  width: 2.0,
                  color: gender == 'others'
                      ? AppColors.highlight
                      : AppColors.defaultInputBorders,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Images.trans,
                      height: 40.0,
                      width: 40.0,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text(
                      'Others',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: Fonts.gilroySemiBold,
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
