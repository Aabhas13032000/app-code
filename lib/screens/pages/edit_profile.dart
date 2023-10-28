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
  String gender = '';
  bool isFullNameFocused = false;
  bool isEmailFocused = false;
  final FocusNode _focus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

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
      'age': '0',
      'weight': '0',
      'target_weight': '0',
      'profile_image': image == null
          ? gender == 'female'
              ? '/images/local/female.png'
              : gender == 'male'
                  ? '/images/local/male.png'
                  : '/images/local/trans.png'
          : selectedImage,
      'height': '0',
      'user_id': Application.user?.id ?? '0',
      "medical_conditions": '0',
      "food_allergies": '0',
      "goal": '0',
      "country_code": Application.user?.countryCode ?? '0',
    };
    String url = '${Constants.finalUrl}/updateData';
    Map<String, dynamic> loginData =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = loginData['status'];
    var data = loginData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'Updated_successfully') {
        Application.profileImage = selectedImage;
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
          : '';
    });
    await urlToImage(Constants.imgFinalUrl + selectedImage);
  }

  @override
  void initState() {
    Utility.showProgress(true);
    super.initState();
    _focus.addListener(_onFocusChange);
    _emailFocus.addListener(_onEmailFocusChange);
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
                              image == null || selectedImage.isEmpty
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
                                              AppColors.highlight,
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
                                            color: AppColors.background,
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.delete_outline,
                                              size: 20.0,
                                              color: AppColors.highlight,
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
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
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
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
          color: AppColors.background,
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
          child: image != null && selectedImage.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(
                    0.0,
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
