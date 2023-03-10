part of screens;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  String state = "";
  String selectedImage = '';
  String url = Constants.finalUrl;
  bool isLoading = false;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightFeetController = TextEditingController();
  TextEditingController heightInchController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController targetWeightController = TextEditingController();
  TextEditingController medicalConditionsController = TextEditingController();
  TextEditingController foodAllergiesController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  String gender = '';
  bool isFullNameFocused = false;
  bool isEmailFocused = false;
  bool isAgeFocused = false;
  bool isHeightFeetFocused = false;
  bool isHeightInchFocused = false;
  bool isWeightFocused = false;
  bool isTargetWeightFocused = false;
  bool isMedicalConditionsFocused = false;
  bool isFoodAllergiesFocused = false;
  bool isGoalFocused = false;
  final FocusNode _focus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  FocusNode _ageFocus = FocusNode();
  FocusNode _heightFeetFocus = FocusNode();
  FocusNode _heightInchFocus = FocusNode();
  FocusNode _weightFocus = FocusNode();
  FocusNode _targetWeightFocus = FocusNode();
  FocusNode _medicalConditionsFocus = FocusNode();
  FocusNode _foodAllergiesFocus = FocusNode();
  FocusNode _goalFocus = FocusNode();

  void saveData() async {
    Utility.showProgress(true);
    Map<String, String> params = {
      'name': fullNameController.text,
      'email': emailController.text,
      'gender': gender == 'female'
          ? 'FEMALE'
          : gender == 'male'
              ? 'MALE'
              : 'OTHERS',
      'age': ageController.text,
      'weight': weightController.text,
      'target_weight': targetWeightController.text.isEmpty
          ? '0'
          : targetWeightController.text,
      'profile_image': image == null
          ? gender == 'female'
              ? '/images/local/female.png'
              : gender == 'male'
                  ? '/images/local/male.png'
                  : '/images/local/trans.png'
          : selectedImage,
      'height': '${heightFeetController.text}.${heightInchController.text}',
      'user_id': Application.user?.id ?? '0',
      "medical_conditions": medicalConditionsController.text.trim(),
      "food_allergies": foodAllergiesController.text.trim(),
      "goal": goalController.text.trim(),
    };
    String url = '${Constants.finalUrl}/updateData';
    Map<String, dynamic> loginData =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = loginData['status'];
    var data = loginData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'Updated_successfully') {
        Application.profileImage = selectedImage ?? "";
        Application.loggedIn = true;
        Application.user = Users.fromJson(data[ApiKeys.user][0]);
        Application.isPaymentAllowed = data[ApiKeys.isPaymentAllowed] ?? false;
        Utility.showProgress(false);
        Provider.of<MainContainerProvider>(context, listen: false).setIndex(0);
        Provider.of<MainContainerProvider>(context, listen: false)
            .setRefreshValue(true);
        showSnackBar(AlertMessages.getMessage(12), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        Get.back();
        Get.back();
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

  Future pickImage() async {
    Utility.showProgress(true);
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
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

  Future<void> urlToImage(String url) async {
    final http.Response responseData = await http.get(Uri.parse(url));
    Uint8List unit8list = responseData.bodyBytes;
    var buffer = unit8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();
    File file = await File(
            '${tempDir.path}/img${DateTime.now().millisecondsSinceEpoch.toString()}')
        .writeAsBytes(
            buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    setState(() {
      image = File(file.path);
      isLoading = true;
    });
    Utility.showProgress(false);
  }

  void initData() async {
    setState(() {
      fullNameController.text = Application.user?.name ?? "";
      emailController.text = Application.user?.email ?? "";
      gender = (Application.user?.gender ?? "") == 'FEMALE'
          ? 'female'
          : (Application.user?.gender ?? "") == 'MALE'
              ? 'male'
              : 'others';
      selectedImage = (Application.user?.profileImage ?? "").isNotEmpty
          ? Application.user?.profileImage ?? ""
          : gender == 'female'
              ? '/images/local/female.png'
              : gender == 'male'
                  ? '/images/local/male.png'
                  : '/images/local/trans.png';
      ageController.text = (Application.user?.age ?? 0).toString();
      weightController.text = (Application.user?.weight ?? 0).toString();
      targetWeightController.text =
          (Application.user?.targetWeight ?? 0).toString();
      heightFeetController.text =
          (Application.user?.height ?? 0).toString().split('.')[0];
      heightInchController.text =
          (Application.user?.height ?? 0).toString().split('.')[1];
      medicalConditionsController.text =
          (Application.user?.medicalConditions ?? '');
      foodAllergiesController.text = (Application.user?.foodAllergies ?? '');
      goalController.text = (Application.user?.goal ?? '');
    });
    await urlToImage(Constants.imgFinalUrl + selectedImage);
  }

  @override
  void initState() {
    Utility.showProgress(true);
    super.initState();
    _focus.addListener(_onFocusChange);
    _emailFocus.addListener(_onEmailFocusChange);
    _ageFocus.addListener(() {
      if (isAgeFocused) {
        setState(() {
          isAgeFocused = false;
        });
      } else {
        setState(() {
          isAgeFocused = true;
        });
      }
    });
    _heightFeetFocus.addListener(() {
      if (isHeightFeetFocused) {
        setState(() {
          isHeightFeetFocused = false;
        });
      } else {
        setState(() {
          isHeightFeetFocused = true;
        });
      }
    });
    _heightInchFocus.addListener(() {
      if (isHeightInchFocused) {
        setState(() {
          isHeightInchFocused = false;
        });
      } else {
        setState(() {
          isHeightInchFocused = true;
        });
      }
    });
    _weightFocus.addListener(() {
      if (isWeightFocused) {
        setState(() {
          isWeightFocused = false;
        });
      } else {
        setState(() {
          isWeightFocused = true;
        });
      }
    });
    _targetWeightFocus.addListener(() {
      if (isTargetWeightFocused) {
        setState(() {
          isTargetWeightFocused = false;
        });
      } else {
        setState(() {
          isTargetWeightFocused = true;
        });
      }
    });
    _medicalConditionsFocus.addListener(() {
      if (isMedicalConditionsFocused) {
        setState(() {
          isMedicalConditionsFocused = false;
        });
      } else {
        setState(() {
          isMedicalConditionsFocused = true;
        });
      }
    });
    _foodAllergiesFocus.addListener(() {
      if (isFoodAllergiesFocused) {
        setState(() {
          isFoodAllergiesFocused = false;
        });
      } else {
        setState(() {
          isFoodAllergiesFocused = true;
        });
      }
    });
    _goalFocus.addListener(() {
      if (isGoalFocused) {
        setState(() {
          isGoalFocused = false;
        });
      } else {
        setState(() {
          isGoalFocused = true;
        });
      }
    });
    initData();
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
      appBar: CustomAppBar(
        preferredSize: const Size.fromHeight(70.0),
        showLeadingIcon: true,
        centerTitle: true,
        title: const Text(
          'Edit profile',
          style: TextStyle(
            color: AppColors.richBlack,
            fontSize: 18.0,
            fontFamily: Fonts.helixSemiBold,
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
      body: !isLoading
          ? const SizedBox()
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
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
                                            borderRadius:
                                                BorderRadius.circular(50.0),
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
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
                    SizedBox(
                      height: 55.0,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: 55.0,
                            child: TextField(
                              focusNode: _ageFocus,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                color: AppColors.richBlack,
                                fontSize: 16.0,
                                fontFamily: Fonts.gilroyMedium,
                              ),
                              controller: ageController,
                              cursorColor: AppColors.defaultInputBorders,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textInputAction: TextInputAction.done,
                              maxLength: 3,
                              cursorWidth: 1.5,
                              decoration: InputDecoration(
                                hintMaxLines: 1,
                                hintText: '0',
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(
                                  'Age',
                                  style: TextStyle(
                                    color: isAgeFocused
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
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 55.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  height: 55.0,
                                  child: TextField(
                                    focusNode: _heightFeetFocus,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      color: AppColors.richBlack,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroyMedium,
                                    ),
                                    controller: heightFeetController,
                                    cursorColor: AppColors.defaultInputBorders,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textInputAction: TextInputAction.done,
                                    maxLength: 2,
                                    cursorWidth: 1.5,
                                    decoration: InputDecoration(
                                      hintMaxLines: 1,
                                      hintText: '0',
                                      counterText: '',
                                      suffixIcon: const Center(
                                        child: Text(
                                          'ft',
                                          style: TextStyle(
                                            color: AppColors.subText,
                                            fontSize: 16.0,
                                            fontFamily: Fonts.gilroySemiBold,
                                          ),
                                        ),
                                      ),
                                      suffixIconConstraints:
                                          const BoxConstraints(
                                        minHeight: 55.0,
                                        minWidth: 50.0,
                                        maxHeight: 55.0,
                                        maxWidth: 50.0,
                                      ),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.highlight,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Text(
                                        'Height (Feet)',
                                        style: TextStyle(
                                          color: isHeightFeetFocused
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
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 55.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  height: 55.0,
                                  child: TextField(
                                    focusNode: _heightInchFocus,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      color: AppColors.richBlack,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroyMedium,
                                    ),
                                    controller: heightInchController,
                                    cursorColor: AppColors.defaultInputBorders,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textInputAction: TextInputAction.done,
                                    maxLength: 3,
                                    cursorWidth: 1.5,
                                    decoration: InputDecoration(
                                      hintMaxLines: 1,
                                      hintText: '0',
                                      counterText: '',
                                      suffixIcon: const Center(
                                        child: Text(
                                          'in',
                                          style: TextStyle(
                                            color: AppColors.subText,
                                            fontSize: 16.0,
                                            fontFamily: Fonts.gilroySemiBold,
                                          ),
                                        ),
                                      ),
                                      suffixIconConstraints:
                                          const BoxConstraints(
                                        minHeight: 55.0,
                                        minWidth: 50.0,
                                        maxHeight: 55.0,
                                        maxWidth: 50.0,
                                      ),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.highlight,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Text(
                                        'Height (Inch)',
                                        style: TextStyle(
                                          color: isHeightInchFocused
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
                        ),
                      ],
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
                              focusNode: _weightFocus,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                color: AppColors.richBlack,
                                fontSize: 16.0,
                                fontFamily: Fonts.gilroyMedium,
                              ),
                              controller: weightController,
                              cursorColor: AppColors.defaultInputBorders,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[0-9.]")),
                                TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                  try {
                                    final text = newValue.text;
                                    if (text.isNotEmpty) double.parse(text);
                                    return newValue;
                                  } catch (e) {}
                                  return oldValue;
                                }),
                              ],
                              textInputAction: TextInputAction.done,
                              maxLength: 7,
                              cursorWidth: 1.5,
                              decoration: InputDecoration(
                                hintMaxLines: 1,
                                hintText: '0.0',
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
                                suffixIcon: const Center(
                                  child: Text(
                                    'kg',
                                    style: TextStyle(
                                      color: AppColors.subText,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroySemiBold,
                                    ),
                                  ),
                                ),
                                suffixIconConstraints: const BoxConstraints(
                                  minHeight: 55.0,
                                  minWidth: 50.0,
                                  maxHeight: 55.0,
                                  maxWidth: 50.0,
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(
                                  'Weight',
                                  style: TextStyle(
                                    color: isWeightFocused
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
                              focusNode: _targetWeightFocus,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                color: AppColors.richBlack,
                                fontSize: 16.0,
                                fontFamily: Fonts.gilroyMedium,
                              ),
                              controller: targetWeightController,
                              cursorColor: AppColors.defaultInputBorders,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[0-9.]")),
                                TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                  try {
                                    final text = newValue.text;
                                    if (text.isNotEmpty) double.parse(text);
                                    return newValue;
                                  } catch (e) {}
                                  return oldValue;
                                }),
                              ],
                              textInputAction: TextInputAction.done,
                              maxLength: 7,
                              cursorWidth: 1.5,
                              decoration: InputDecoration(
                                hintMaxLines: 1,
                                hintText: '0.0',
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
                                suffixIcon: const Center(
                                  child: Text(
                                    'kg',
                                    style: TextStyle(
                                      color: AppColors.subText,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.gilroySemiBold,
                                    ),
                                  ),
                                ),
                                suffixIconConstraints: const BoxConstraints(
                                  minHeight: 55.0,
                                  minWidth: 50.0,
                                  maxHeight: 55.0,
                                  maxWidth: 50.0,
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(
                                  'Target weight (optional)',
                                  style: TextStyle(
                                    color: isTargetWeightFocused
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
                      height: 90.0,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: 90.0,
                            child: TextField(
                              focusNode: _medicalConditionsFocus,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                color: AppColors.richBlack,
                                fontSize: 16.0,
                                fontFamily: Fonts.gilroyMedium,
                              ),
                              controller: medicalConditionsController,
                              cursorColor: AppColors.defaultInputBorders,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              cursorWidth: 1.5,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintMaxLines: 1,
                                hintText:
                                    'Mention your medical conditions here',
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(
                                  'Medical Conditionals (optional)',
                                  style: TextStyle(
                                    color: isMedicalConditionsFocused
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
                      height: 90.0,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: 90.0,
                            child: TextField(
                              focusNode: _foodAllergiesFocus,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                color: AppColors.richBlack,
                                fontSize: 16.0,
                                fontFamily: Fonts.gilroyMedium,
                              ),
                              controller: foodAllergiesController,
                              cursorColor: AppColors.defaultInputBorders,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              cursorWidth: 1.5,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintMaxLines: 1,
                                hintText: 'Mention your food allergies here',
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(
                                  'Food Allergies (optional)',
                                  style: TextStyle(
                                    color: isFoodAllergiesFocused
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
                      height: 90.0,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: 90.0,
                            child: TextField(
                              focusNode: _goalFocus,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                color: AppColors.richBlack,
                                fontSize: 16.0,
                                fontFamily: Fonts.gilroyMedium,
                              ),
                              controller: goalController,
                              cursorColor: AppColors.defaultInputBorders,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              cursorWidth: 1.5,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintMaxLines: 1,
                                hintText: 'Enter your goal here',
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(
                                  'Goal (optional)',
                                  style: TextStyle(
                                    color: isGoalFocused
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
                    CustomButton(
                      title: 'Save',
                      textColor: AppColors.white,
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
                        } else if (ageController.text.isEmpty) {
                          Utility.showSnacbar(
                            context,
                            'Please enter your age.',
                            AppColors.lightRed,
                            AppColors.warning,
                            duration: 2,
                            50.0,
                          );
                        } else if (heightFeetController.text.isEmpty ||
                            heightInchController.text.isEmpty) {
                          Utility.showSnacbar(
                            context,
                            'Please fill your height properly.',
                            AppColors.lightRed,
                            AppColors.warning,
                            duration: 2,
                            50.0,
                          );
                        } else if (weightController.text.isEmpty) {
                          Utility.showSnacbar(
                            context,
                            'Please enter your weight.',
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
