part of screens;

class UserHeightWeight extends StatefulWidget {
  final String name;
  final String? selectedImage;
  final String? email;
  final String gender;
  const UserHeightWeight({
    Key? key,
    required this.name,
    this.selectedImage,
    this.email = '',
    required this.gender,
  }) : super(key: key);

  @override
  State<UserHeightWeight> createState() => _UserHeightWeightState();
}

class _UserHeightWeightState extends State<UserHeightWeight> {
  File? image;
  String state = "";
  String selectedImage = '';
  String url = Constants.finalUrl;
  TextEditingController ageController = TextEditingController();
  TextEditingController heightFeetController = TextEditingController();
  TextEditingController heightInchController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController targetWeightController = TextEditingController();
  TextEditingController medicalConditionsController = TextEditingController();
  TextEditingController foodAllergiesController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  bool isAgeFocused = false;
  bool isHeightFeetFocused = false;
  bool isHeightInchFocused = false;
  bool isWeightFocused = false;
  bool isTargetWeightFocused = false;
  bool isMedicalConditionsFocused = false;
  bool isFoodAllergiesFocused = false;
  bool isGoalFocused = false;
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
      'name': widget.name,
      'email': widget.email ?? "",
      'gender': widget.gender,
      'age': ageController.text,
      'weight': weightController.text,
      'target_weight': targetWeightController.text.isEmpty
          ? '0'
          : targetWeightController.text,
      'profile_image': widget.selectedImage ?? "",
      'height': '${heightFeetController.text}.${heightInchController.text}',
      'user_id': Application.user?.id ?? '0',
      'phoneNumber': Application.user?.phoneNumber ?? '',
      "medical_conditions": medicalConditionsController.text.trim(),
      "food_allergies": foodAllergiesController.text.trim(),
      "goal": goalController.text.trim(),
      "country_code": Application.user?.countryCode ?? '0',
    };
    String url = '${Constants.finalUrl}/updateData';
    Map<String, dynamic> loginData =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = loginData['status'];
    var data = loginData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'Updated_successfully') {
        Application.profileImage = widget.selectedImage ?? "";
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

  @override
  void initState() {
    // Utility.showProgress(true);
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
    super.initState();
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
              Text(
                'Hello, ${widget.name}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontFamily: Fonts.montserratSemiBold,
                  color: AppColors.richBlack,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'Tell us about your age, height and weight',
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
                          fontFamily: Fonts.montserratMedium,
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
                            'Age',
                            style: TextStyle(
                              color: isAgeFocused
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
                                fontFamily: Fonts.montserratMedium,
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
                                      fontFamily: Fonts.montserratSemiBold,
                                    ),
                                  ),
                                ),
                                suffixIconConstraints: const BoxConstraints(
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(
                                  'Height (Feet)',
                                  style: TextStyle(
                                    color: isHeightFeetFocused
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
                                fontFamily: Fonts.montserratMedium,
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
                                      fontFamily: Fonts.montserratSemiBold,
                                    ),
                                  ),
                                ),
                                suffixIconConstraints: const BoxConstraints(
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(
                                  'Height (Inch)',
                                  style: TextStyle(
                                    color: isHeightInchFocused
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
                          fontFamily: Fonts.montserratMedium,
                        ),
                        controller: weightController,
                        cursorColor: AppColors.defaultInputBorders,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                          TextInputFormatter.withFunction((oldValue, newValue) {
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
                            fontFamily: Fonts.montserratMedium,
                          ),
                          suffixIcon: const Center(
                            child: Text(
                              'kg',
                              style: TextStyle(
                                color: AppColors.subText,
                                fontSize: 16.0,
                                fontFamily: Fonts.montserratSemiBold,
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
                            'Weight',
                            style: TextStyle(
                              color: isWeightFocused
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
                        focusNode: _targetWeightFocus,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 16.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                        controller: targetWeightController,
                        cursorColor: AppColors.defaultInputBorders,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                          TextInputFormatter.withFunction((oldValue, newValue) {
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
                            fontFamily: Fonts.montserratMedium,
                          ),
                          suffixIcon: const Center(
                            child: Text(
                              'kg',
                              style: TextStyle(
                                color: AppColors.subText,
                                fontSize: 16.0,
                                fontFamily: Fonts.montserratSemiBold,
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
                            'Target weight (optional)',
                            style: TextStyle(
                              color: isTargetWeightFocused
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
                          fontFamily: Fonts.montserratMedium,
                        ),
                        controller: medicalConditionsController,
                        cursorColor: AppColors.defaultInputBorders,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        cursorWidth: 1.5,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintMaxLines: 1,
                          hintText: 'Mention your medical conditions here',
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
                            'Medical Conditionals (optional)',
                            style: TextStyle(
                              color: isMedicalConditionsFocused
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
                          fontFamily: Fonts.montserratMedium,
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
                            'Food Allergies (optional)',
                            style: TextStyle(
                              color: isFoodAllergiesFocused
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
                          fontFamily: Fonts.montserratMedium,
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
                            'Goal (optional)',
                            style: TextStyle(
                              color: isGoalFocused
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
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: 'Previous',
                      onPressed: () {
                        Get.back();
                      },
                      bgColor: AppColors.white,
                      textColor: AppColors.highlight,
                      borderColor: AppColors.highlight,
                      borderWidth: 2.0,
                      isShowBorder: true,
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: CustomButton(
                      title: 'Save',
                      borderColor: AppColors.highlight,
                      borderWidth: 2.0,
                      isShowBorder: true,
                      onPressed: () {
                        if (ageController.text.isEmpty) {
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
                  ),
                ],
              ),
              const SizedBox(
                height: 0.0,
              ),
              Center(
                child: Image.asset(
                  Images.profileFlow,
                  width: 450.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
