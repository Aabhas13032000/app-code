part of screens;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Program> exclusivePrograms = [];
  List<Program> spotlightPrograms = [];
  List<Testimonial> userReviews = [];
  List<UsersCalories> userCalories = [];
  List<UsersExercise> userExercise = [];
  List<Program> myProgram = [];
  List<Trainer> trainers = [];
  List<Book> ourBooks = [];
  List<Blogs> popularBlogs = [];
  List<String> clothSlider = [];
  List<Product> products = [];
  List<CurectCategories> clothCategories = [];
  List<CurectCategories> productCategories = [];
  double calorieBurnedValue = 0;
  double calorieEatenValue = 0;
  int breakfast = 0;
  int snacks = 0;
  int lunch = 0;
  int dinner = 0;
  int total = 0;
  int totalWorkout = 0;
  int totalCalories = 0;
  String date = 'Today';
  String bookId = '0';
  String pdfUrl = '';
  String bookTitle = '';
  DateTime selectedDate = DateTime.now();
  DateTime todaysDate = DateTime.now();
  TextEditingController commentController = TextEditingController();
  List<Comment> comments = [];
  bool isCommentVerticalLoading = false;
  int commentOffset = 0;
  int totalComments = 0;

  late Razorpay _razorpay;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date == 'Today'
          ? DateTime.parse(todaysDate.toString().substring(0, 10))
          : DateTime.parse(date),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.parse(todaysDate.toString().substring(0, 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.highlight,
              onPrimary: AppColors.richBlack,
              onSurface: AppColors.richBlack,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.richBlack, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      getCurrentDateData(selectedDate.toString().substring(0, 10));
    }
  }

  void getPreviousDate() async {
    var today = DateTime.now();
    if (date == 'Today') {
      today = DateTime.now();
    } else {
      today = DateTime.parse(date);
    }
    var previous = today.subtract(const Duration(days: 1));
    getCurrentDateData(previous.toString().substring(0, 10));
  }

  void getNextDate() async {
    var today = DateTime.parse(date);
    var next = today.add(const Duration(days: 1));
    getCurrentDateData(next.toString().substring(0, 10));
  }

  void getCurrentDateData(String newDate) async {
    Utility.showProgress(true);
    String url =
        '${Constants.finalUrl}/getCalorieData?user_id=${Application.user?.id}&date=$newDate';
    Map<String, dynamic> currentDateData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = currentDateData['status'];
    var data = currentDateData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        calorieBurnedValue = 0;
        calorieEatenValue = 0;
        breakfast = 0;
        snacks = 0;
        lunch = 0;
        dinner = 0;
        total = 0;
        totalWorkout = 0;
        var actualToday = DateTime.now();
        var today = DateTime.parse(newDate);
        if (today.toString().substring(0, 10) ==
            actualToday.toString().substring(0, 10)) {
          date = 'Today';
        } else {
          date = newDate;
        }
        data[ApiKeys.userCalories].forEach((userCalorie) {
          var calorie = UsersCalories.fromJson(userCalorie);
          if (calorie.meal == 'BREAKFAST') {
            breakfast = breakfast + (calorie.calories ?? 0).ceil();
          }
          if (calorie.meal == 'LUNCH') {
            lunch = lunch + (calorie.calories ?? 0.0).ceil();
          }
          if (calorie.meal == 'DINNER') {
            dinner = dinner + (calorie.calories ?? 0.0).ceil();
          }
          if (calorie.meal == 'SNACKS') {
            snacks = snacks + (calorie.calories ?? 0.0).ceil();
          }
        });
        data[ApiKeys.userExercise].forEach((userExercise) {
          var exercise = UsersExercise.fromJson(userExercise);
          totalWorkout = totalWorkout + (exercise.calories ?? 0.0).ceil();
        });
        total = breakfast + lunch + dinner + snacks;
        calorieEatenValue = (total / totalCalories);
        calorieBurnedValue = (totalWorkout / totalCalories);
        Utility.showProgress(false);
        setState(() {
          isLoading = true;
        });
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
        setState(() {
          isLoading = true;
        });
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

  void getInitialData() async {
    Utility.showProgress(true);
    String url =
        '${Constants.finalUrl}/getInitialData?user_id=${Application.user?.id}&date=${date == 'Today' ? todaysDate.toString().substring(0, 10) : date}';
    Map<String, dynamic> initialData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = initialData['status'];
    var data = initialData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        calorieBurnedValue = 0;
        calorieEatenValue = 0;
        breakfast = 0;
        snacks = 0;
        lunch = 0;
        dinner = 0;
        total = 0;
        totalWorkout = 0;
        totalCalories = 0;
        double heightInCm = (Application.user?.height ?? 0) * 30.48;
        double weight = (Application.user?.weight ?? 0);
        int age = (Application.user?.age ?? 0);
        var s = Application.user?.gender == 'MALE'
            ? 5
            : Application.user?.gender == 'FEMALE'
                ? -161
                : 5;
        totalCalories =
            ((10.0 * weight) + (6.25 * heightInCm) - (5.0 * age) + s).ceil();
        exclusivePrograms.clear();
        spotlightPrograms.clear();
        userReviews.clear();
        userCalories.clear();
        userExercise.clear();
        trainers.clear();
        ourBooks.clear();
        popularBlogs.clear();
        data[ApiKeys.popular].forEach((blog) => {
              popularBlogs.add(Blogs.fromJson(blog)),
            });
        data[ApiKeys.exclusivePrograms].forEach((program) => {
              exclusivePrograms.add(Program.fromJson(program)),
            });
        data[ApiKeys.experts].forEach((trainer) => {
              trainers.add(Trainer.fromJson(trainer)),
            });
        // data[ApiKeys.myPrograms].forEach((program) => {
        //       myProgram.add(Program.fromJson(program)),
        //     });
        data[ApiKeys.clothCategories].forEach((category) {
          clothCategories.add(CurectCategories.fromJson(category));
          if (CurectCategories.fromJson(category).homeImp ?? false) {
            clothSlider.add(Constants.imgFinalUrl +
                (CurectCategories.fromJson(category).mobileSlider ??
                    "/images/local/curectLogo.png"));
          }
        });
        data[ApiKeys.productCategories].forEach((category) => {
              if (CurectCategories.fromJson(category).homeImp ?? false)
                {
                  productCategories.add(CurectCategories.fromJson(category)),
                }
            });
        data[ApiKeys.impProducts].forEach((product) => {
              products.add(Product.fromJson(product)),
            });
        data[ApiKeys.ourBooks].forEach((book) => {
              ourBooks.add(Book.fromJson(book)),
            });
        data[ApiKeys.spotlightPrograms].forEach((program) => {
              spotlightPrograms.add(Program.fromJson(program)),
            });
        data[ApiKeys.testimonials].forEach((testimonial) => {
              userReviews.add(Testimonial.fromJson(testimonial)),
            });
        data[ApiKeys.userCalories].forEach((userCalorie) {
          var calorie = UsersCalories.fromJson(userCalorie);
          if (calorie.meal == 'BREAKFAST') {
            breakfast = breakfast + (calorie.calories ?? 0).ceil();
          }
          if (calorie.meal == 'LUNCH') {
            lunch = lunch + (calorie.calories ?? 0.0).ceil();
          }
          if (calorie.meal == 'DINNER') {
            dinner = dinner + (calorie.calories ?? 0.0).ceil();
          }
          if (calorie.meal == 'SNACKS') {
            snacks = snacks + (calorie.calories ?? 0.0).ceil();
          }
        });
        data[ApiKeys.userExercise].forEach((userExercise) {
          var exercise = UsersExercise.fromJson(userExercise);
          totalWorkout = totalWorkout + (exercise.calories ?? 0.0).ceil();
        });
        total = breakfast + lunch + dinner + snacks;
        calorieEatenValue = (total / totalCalories);
        calorieBurnedValue = (totalWorkout / totalCalories);
        setState(() {
          isLoading = true;
        });
        setCategories();
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
        setState(() {
          isLoading = true;
        });
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

  void setCategories() {
    Provider.of<MainContainerProvider>(context, listen: false)
        .setClothCategory(clothCategories);
    Provider.of<MainContainerProvider>(context, listen: false)
        .setProductCategory(productCategories);
    Utility.showProgress(false);
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
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getInitialData();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        preferredSize: const Size.fromHeight(70.0),
        showLeadingIcon: false,
        title: GestureDetector(
          onTap: () {
            Get.to(
              () => const ProfilePage(),
            );
          },
          child: CircularAvatar(
            url: Constants.imgFinalUrl +
                ((Application.user?.profileImage ?? "").isEmpty
                    ? Application.profileImage
                    : (Application.user?.profileImage ?? "")),
            radius: 45.0,
            borderColor: AppColors.highlight,
            borderWidth: 2.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12.5,
              bottom: 12.5,
              left: 0.0,
              right: 0.0,
            ),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => const NotificationPage(),
                );
              },
              child: const CustomIcon(
                icon: MdiIcons.bellOutline,
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
          Padding(
            padding: const EdgeInsets.only(
              top: 12.5,
              bottom: 12.5,
              left: 15.0,
              right: 20.0,
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
        leadingWidget: const SizedBox(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Container(
            height: 0.0,
          ),
        ),
      ),
      body: !isLoading
          ? Container()
          : FocusDetector(
              onFocusGained: () {
                if (Provider.of<MainContainerProvider>(context, listen: false)
                    .isRefreshed) {
                  Provider.of<MainContainerProvider>(context, listen: false)
                      .setRefreshValue(false);
                  getInitialData();
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    productHomeSlider(),
                    const SizedBox(
                      height: 25.0,
                    ),
                    calorieWorkoutLog(),
                    const SizedBox(
                      height: 24.0,
                    ),
                    myPrograms(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    exclusivePrograms.isEmpty
                        ? const SizedBox()
                        : Container(
                            color: AppColors.cardBg,
                            child: exclusiveForUsers(),
                          ),
                    SizedBox(
                      height: ourBooks.isEmpty ? 0.0 : 30.0,
                    ),
                    ourBooks.isEmpty ? const SizedBox() : books(),
                    SizedBox(
                      height: spotlightPrograms.isEmpty ? 0.0 : 5.0,
                    ),
                    spotlightPrograms.isEmpty ? const SizedBox() : topSlider(),
                    products.isEmpty
                        ? const SizedBox()
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: productCategories.length,
                            itemBuilder: (context, index) {
                              return productCategory(productCategories[index]);
                            },
                          ),
                    SizedBox(
                      height: popularBlogs.isEmpty ? 0.0 : 15.0,
                    ),
                    popularBlogs.isEmpty ? const SizedBox() : blogs(),
                    SizedBox(
                      height: userReviews.isEmpty ? 0.0 : 10.0,
                    ),
                    userReviews.isEmpty
                        ? const SizedBox()
                        : Container(
                            color: AppColors.cardBg,
                            child: testimonials(),
                          ),
                    SizedBox(
                      height: trainers.isEmpty ? 0.0 : 30.0,
                    ),
                    trainers.isEmpty ? const SizedBox() : experts(),
                    const SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget productHomeSlider() {
    return clothSlider.isNotEmpty
        ? AppSlider(
            slider: clothSlider,
            height: 450,
            viewPortFraction: 1,
            margin: const EdgeInsets.all(0.0),
            borderRadius: 0.0,
            aspectRatio: 16 / 19,
            width: double.infinity,
            duration: 1500,
            bottomIndicatorVerticalPadding: 30.0,
            isProductImage: true,
            onImageClicked: (imageUrl) {
              Utility.printLog('Category');
              var item = clothCategories.firstWhere((element) =>
                  (Constants.imgFinalUrl +
                      (element.mobileSlider ?? Images.curectLogo)) ==
                  imageUrl);

              Get.to(
                () => CategoryWiseProducts(
                  isClothCategory: true,
                  clothCategory: item.name ?? "",
                ),
              );
            },
          )
        : const SizedBox();
  }

  Widget productCategory(CurectCategories productCategory) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 25.0,
            bottom: 15.0,
          ),
          child: HeadingViewAll(
            title: productCategory.name ?? "",
            onViewAllPressed: () {
              Get.to(
                () => CategoryWiseProducts(
                  isCategory: true,
                  category: productCategory.name ?? "All",
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 340.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              right: 20.0,
            ),
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              if ((products[index].category ?? '')
                  .contains(productCategory.name ?? "")) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        () => EachProductPage(
                          id: products[index].id,
                        ),
                      );
                    },
                    child: ProductCard(
                      name: products[index].name,
                      photoUrl: Constants.imgFinalUrl +
                          (products[index].coverPhoto ?? Images.curectLogo),
                      width: 285.0,
                      inStock: products[index].stock ?? true,
                      price: products[index].price ?? 0,
                      discountPrice: products[index].discountPrice ?? 0,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget experts() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: HeadingViewAll(
            title: 'Meet our experts',
            onViewAllPressed: () {
              Get.to(
                () => const ExpertsPage(),
              );
            },
          ),
        ),
        SizedBox(
          height: 280.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: trainers.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                  top: 20.0,
                  bottom: 20.0,
                  right: index == trainers.length - 1 ? 20.0 : 0.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => EachExpertPage(
                        id: trainers[index].id,
                      ),
                    );
                  },
                  child: ExpertCard(
                    width: 190,
                    name: trainers[index].name,
                    photoUrl:
                        Constants.imgFinalUrl + trainers[index].profileImage,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget testimonials() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
            bottom: 10.0,
          ),
          child: HeadingViewAll(
            title: 'What people say about us',
            isShowViewAll: false,
          ),
        ),
        TestimonialSlider(
            slider: userReviews,
            height: 250.0,
            width: double.infinity,
            viewPortFraction: 1.0,
            margin: const EdgeInsets.all(20.0),
            borderRadius: 10,
            aspectRatio: 16 / 12.4,
            duration: 1500,
            onTestimonialPressed: (Testimonial testimonial) {
              testimonialPopup(context, testimonial);
            }),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  //Show Testimonial Popup
  Future<void> testimonialPopup(BuildContext context, Testimonial testimonial) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.0),
      enableDrag: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) => Container(
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
                    constraints: const BoxConstraints(maxHeight: 500.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 0.0, right: 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 16.0,
                              ),
                              CircularAvatar(
                                url: Constants.imgFinalUrl +
                                    testimonial.profileImage,
                                borderWidth: 0.0,
                                borderColor: AppColors.richBlack,
                                radius: 60.0,
                                isShowBorder: false,
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      testimonial.name,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: AppColors.richBlack,
                                        fontSize: 18.0,
                                        fontFamily: Fonts.helixSemiBold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      testimonial.tagLine,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: AppColors.subText,
                                        fontSize: 16.0,
                                        fontFamily: Fonts.gilroyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Divider(
                            height: 20.0,
                            thickness: 1.0,
                            color:
                                AppColors.defaultInputBorders.withOpacity(0.7),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: testimonial.message.contains('<p>')
                                ? TextToHtmlTwo(
                                    description: testimonial.message ?? '',
                                    textColor: AppColors.richBlack,
                                    fontSize: 16.0,
                                    font: Fonts.gilroyRegular,
                                  )
                                : Text(
                                    testimonial.message,
                                    maxLines: 6,
                                    style: const TextStyle(
                                      color: AppColors.richBlack,
                                      fontSize: 14.0,
                                      fontFamily: Fonts.gilroyRegular,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget blogs() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: HeadingViewAll(
            title: 'Popular Feeds',
            onViewAllPressed: () {
              // Get.to(() => const ViewAllBlogs());
              Provider.of<MainContainerProvider>(context, listen: false)
                  .navigationQueue
                  .addLast(0);
              Provider.of<MainContainerProvider>(context, listen: false)
                  .setIndex(1);
            },
          ),
        ),
        SizedBox(
          height: 412.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: popularBlogs.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                  top: 20.0,
                  bottom: 20.0,
                  right: index == popularBlogs.length - 1 ? 20.0 : 0.0,
                ),
                child: BlogCardThree(
                  description: popularBlogs[index].description,
                  likes: popularBlogs[index].totalLikes,
                  width: 280,
                  height: 350.0,
                  isLiked: popularBlogs[index].isLiked,
                  date: DateTime.parse(popularBlogs[index].createdAt)
                      .toString()
                      .substring(0, 10),
                  photoUrl:
                      Constants.imgFinalUrl + popularBlogs[index].coverPhoto,
                  onBlogClicked: () {
                    if (('<div>${popularBlogs[index].description}</div>')
                            .length >
                        100) {
                      Get.to(
                        () => EachBlog(
                          id: popularBlogs[index].id,
                        ),
                        preventDuplicates: false,
                      );
                    }
                  },
                  onCommentClicked: () {
                    getComments(popularBlogs[index].id, 0);
                  },
                  onLikeClicked: () {
                    likeDislike(index);
                  },
                  onShareClicked: () {
                    Utility.showProgress(true);
                    String shareUrl = popularBlogs[index].shareUrl != 'null'
                        ? popularBlogs[index].shareUrl
                        : '';
                    Utility.printLog(shareUrl);
                    if (shareUrl.isEmpty) {
                      Application.generateShareLink(
                              popularBlogs[index].id.toString(),
                              'blog',
                              '/each-blog/${popularBlogs[index].id}?item_id=${popularBlogs[index].id}')
                          .then((value) {
                        if (value != 'error') {
                          Blogs newBlog = Blogs(
                            id: popularBlogs[index].id,
                            title: popularBlogs[index].title,
                            description: popularBlogs[index].description,
                            coverPhoto: popularBlogs[index].coverPhoto,
                            shareUrl: value,
                            status: popularBlogs[index].status,
                            views: popularBlogs[index].views,
                            totalLikes: popularBlogs[index].totalLikes,
                            createdAt: popularBlogs[index].createdAt,
                            isLiked: popularBlogs[index].isLiked,
                          );
                          popularBlogs.removeAt(index);
                          popularBlogs.insert(index, newBlog);
                          Application.createFileOfPdfUrl(Constants.imgFinalUrl +
                                  popularBlogs[index].coverPhoto)
                              .then((f) {
                            Utility.showProgress(false);
                            _onShare(f.path,
                                '${popularBlogs[index].title}\nto explore more blogs click on the link given below\n👇\n$value\nDownload our application and enjoy more features\nFor Android:\nhttps://play.google.com/store/apps/details?id=com.healfit.heal_fit\n\nFor IOS:\nhttps://apps.apple.com/in/app/healfit/id1645721639\nOr visit our website:\nhttps://healfit.in');
                          });
                        } else {
                          showSnackBar(AlertMessages.getMessage(4),
                              AppColors.lightRed, AppColors.warning, 50.0);
                        }
                      });
                    } else {
                      Application.createFileOfPdfUrl(Constants.imgFinalUrl +
                              popularBlogs[index].coverPhoto)
                          .then((f) {
                        Utility.showProgress(false);
                        _onShare(f.path,
                            '${popularBlogs[index].title}\nto explore more blogs click on the link given below\n👇\n${popularBlogs[index].shareUrl != 'null' ? popularBlogs[index].shareUrl : ''}\nDownload our application and enjoy more features\nFor Android:\nhttps://play.google.com/store/apps/details?id=com.healfit.heal_fit\nFor IOS:\nhttps://apps.apple.com/in/app/healfit/id1645721639\nOr visit our website:\nhttps://healfit.in');
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void getComments(String itemId, int offset) async {
    if (offset == 0) {
      Utility.showProgress(true);
    }
    setState(() {
      commentOffset = offset;
    });
    String url =
        '${Constants.finalUrl}/blogs/getEachBlogComments?offset=$offset&item_id=$itemId';
    Map<String, dynamic> blogData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = blogData['status'];
    var data = blogData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        if (offset == 0) {
          comments.clear();
          totalComments = data[ApiKeys.totalComments];
        }
        data[ApiKeys.comments].forEach((comment) => {
              comments.add(Comment.fromJson(comment)),
            });
        Utility.showProgress(false);
        setState(() {
          isLoading = true;
          isCommentVerticalLoading = false;
        });
        setCommentContent();
        if (offset == 0) {
          openCommentBox(itemId);
        }
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
        setState(() {
          isLoading = true;
          isCommentVerticalLoading = false;
        });
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

  void setCommentContent() {
    Provider.of<MainContainerProvider>(context, listen: false)
        .setComment(comments);
  }

  Future _loadMoreVertical(String itemId, int offset) async {
    Utility.printLog('scrolling');
    getComments(itemId, offset);
  }

  //Comment Box
  void openCommentBox(String itemId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.0),
      enableDrag: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom - 70.0 < 0
                  ? 0
                  : MediaQuery.of(context).viewInsets.bottom - 70.0,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 3 / 5 + 70.0,
              color: AppColors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MediaQuery.of(context).viewInsets.bottom != 0
                      ? const SizedBox()
                      : GestureDetector(
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
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 3 / 5,
                        minHeight: MediaQuery.of(context).size.height * 3 / 5,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: [
                            context
                                    .watch<MainContainerProvider>()
                                    .comments
                                    .isEmpty
                                ? const Expanded(
                                    child: Center(
                                      child: NoDataAvailable(
                                        message: 'No comments available!!',
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: LazyLoadScrollView(
                                      isLoading: isCommentVerticalLoading,
                                      onEndOfPage: () {
                                        if (totalComments >
                                            Provider.of<MainContainerProvider>(
                                                    context,
                                                    listen: false)
                                                .comments
                                                .length) {
                                          setState(() {
                                            commentOffset = commentOffset + 20;
                                            isCommentVerticalLoading = true;
                                          });
                                          _loadMoreVertical(
                                              itemId, commentOffset);
                                        }
                                      },
                                      child: Scrollbar(
                                        child: ListView.builder(
                                          itemCount: context
                                              .watch<MainContainerProvider>()
                                              .comments
                                              .length,
                                          itemBuilder: (context, index) {
                                            return commentCard(
                                                context
                                                    .watch<
                                                        MainContainerProvider>()
                                                    .comments[index],
                                                index);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 50.0,
                              child: TextField(
                                autofocus: false,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                  color: AppColors.richBlack,
                                  fontSize: 16.0,
                                  fontFamily: Fonts.gilroyMedium,
                                ),
                                controller: commentController,
                                cursorColor: AppColors.defaultInputBorders,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.send,
                                cursorWidth: 1.5,
                                maxLines: 3,
                                minLines: 1,
                                onSubmitted: (value) {
                                  addComment(itemId, value);
                                },
                                decoration: InputDecoration(
                                  hintMaxLines: 1,
                                  hintText: 'Write your comment here',
                                  counterText: '',
                                  contentPadding: const EdgeInsets.only(
                                      top: 20.0, left: 20.0),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      addComment(
                                          itemId, commentController.text);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: AppColors.cardBg,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          MdiIcons.send,
                                          size: 24.0,
                                          color: AppColors.subText,
                                        ),
                                      ),
                                    ),
                                  ),
                                  suffixIconConstraints: const BoxConstraints(
                                    minHeight: 55.0,
                                    minWidth: 50.0,
                                    maxHeight: 55.0,
                                    maxWidth: 50.0,
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
                            const SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //Add comment
  void addComment(String itemId, String message) async {
    if (message.trim().isEmpty) {
      showPopup(32);
    } else {
      Utility.showProgress(true);
      Map<String, String> params = {
        "id": itemId,
        "user_id": Application.user?.id ?? '0',
        "message": message.trim(),
      };
      String url = '${Constants.finalUrl}/blogs/commentEachBlog';
      Map<String, dynamic> updateSessionCount =
          await ApiFunctions.postApiResult(
              url, Application.deviceToken, params);
      bool status = updateSessionCount['status'];
      var data = updateSessionCount['data'];
      if (status) {
        if (data[ApiKeys.message].toString() == 'success') {
          Utility.showProgress(false);
          setState(() {
            commentController.text = '';
          });
          Get.back();
          showSnackBar(AlertMessages.getMessage(33), AppColors.lightGreen,
              AppColors.congrats, 50.0);
        } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
            data[ApiKeys.message].toString() == 'Database_connection_error') {
          Utility.showProgress(false);
          setState(() {
            commentController.text = '';
          });
          Get.back();
          showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
              AppColors.warning, 50.0);
        } else {
          Utility.showProgress(false);
          showSnackBar(data[ApiKeys.message].toString(), AppColors.lightRed,
              AppColors.warning, 50.0);
        }
        Utility.showProgress(false);
      } else {
        setState(() {
          commentController.text = '';
        });
        Utility.printLog('Something went wrong while saving token.');
        Utility.printLog('Some error occurred');
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
      }
    }
  }

  void showPopup(int message) {
    Utility.singleButtonPopup(
        context,
        Icons.warning_amber_rounded,
        40.0,
        AppColors.warning,
        AlertMessages.getMessage(message),
        'Ok', onButtonClicked: () {
      Get.back();
    });
  }

  //comment card
  Widget commentCard(Comment comment, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(
          top: index == 0 ? 20.0 : 0.0,
          bottom: 15.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(width: 1.5, color: AppColors.defaultInputBorders),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircularAvatar(
                url: Constants.imgFinalUrl + (comment.profileImage),
                radius: 40.0,
                borderColor: AppColors.highlight,
                borderWidth: 0.0,
                isShowBorder: false,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.name,
                      style: const TextStyle(
                        color: AppColors.richBlack,
                        fontSize: 16.0,
                        fontFamily: Fonts.gilroyMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      comment.message,
                      style: const TextStyle(
                        color: AppColors.subText,
                        fontSize: 14.0,
                        fontFamily: Fonts.gilroyRegular,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      DateTime.parse(comment.createdAt)
                          .toString()
                          .substring(0, 10),
                      style: const TextStyle(
                        color: AppColors.subText,
                        fontSize: 14.0,
                        fontFamily: Fonts.gilroyRegular,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Like Dislike
  void likeDislike(int index) async {
    Blogs blog = popularBlogs[index];
    Map<String, String> params = {
      "id": blog.id,
      "user_id": Application.user?.id ?? '0',
    };
    String url = blog.isLiked
        ? '${Constants.finalUrl}/blogs/deleteLikeComment'
        : '${Constants.finalUrl}/blogs/likeEachBlog';
    Map<String, dynamic> likeDislikeQuery =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = likeDislikeQuery['status'];
    var data = likeDislikeQuery['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        if (blog.isLiked) {
          Blogs newBlog = Blogs(
            id: blog.id,
            title: blog.title,
            description: blog.description,
            coverPhoto: blog.coverPhoto,
            shareUrl: blog.shareUrl,
            status: blog.status,
            views: blog.views,
            totalLikes: blog.totalLikes - 1,
            createdAt: blog.createdAt,
            isLiked: false,
          );
          popularBlogs.removeAt(index);
          popularBlogs.insert(index, newBlog);
        } else {
          Blogs newBlog = Blogs(
            id: blog.id,
            title: blog.title,
            description: blog.description,
            coverPhoto: blog.coverPhoto,
            shareUrl: blog.shareUrl,
            status: blog.status,
            views: blog.views,
            totalLikes: blog.totalLikes + 1,
            createdAt: blog.createdAt,
            isLiked: true,
          );
          popularBlogs.removeAt(index);
          popularBlogs.insert(index, newBlog);
        }
        setState(() {});
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

  void _onShare(String remotePDFpath, String shareText) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.shareFiles(
      [remotePDFpath],
      text: shareText,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  Widget books() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: HeadingViewAll(
            title: 'Our books',
            isShowViewAll: false,
            onViewAllPressed: () {
              Get.to(
                () => const BooksPage(),
              );
            },
          ),
        ),
        SizedBox(
          height: 265.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: ourBooks.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                  top: 20.0,
                  bottom: 20.0,
                  right: index == ourBooks.length - 1 ? 20.0 : 0.0,
                ),
                child: BookCardOne(
                  title: ourBooks[index].title,
                  price: ourBooks[index].price.toString(),
                  author: ourBooks[index].author,
                  width: 340,
                  photoUrl: Constants.imgFinalUrl + ourBooks[index].coverPhoto,
                  discountPrice: ourBooks[index].discountPrice.toString(),
                  downloads: ourBooks[index].downloads.toString(),
                  onDownloadClicked: () {
                    checkDownloadPdf(ourBooks[index].id, ourBooks[index].title,
                        ourBooks[index].pdf, ourBooks[index].discountPrice);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget exclusiveForUsers() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
            bottom: 10.0,
          ),
          child: HeadingViewAll(
            title: 'Exclusive for users',
            isShowViewAll: false,
            onViewAllPressed: () {
              Provider.of<MainContainerProvider>(context, listen: false)
                  .navigationQueue
                  .addLast(0);
              Provider.of<MainContainerProvider>(context, listen: false)
                  .setIndex(3);
              Provider.of<MainContainerProvider>(context, listen: false)
                  .navigationQueue
                  .addLast(3);
            },
          ),
        ),
        SizedBox(
          height: 320.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: exclusivePrograms.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                  top: 20.0,
                  bottom: 20.0,
                  right: index == exclusivePrograms.length - 1 ? 20.0 : 0.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => EachProgram(
                        id: exclusivePrograms[index].id,
                      ),
                    );
                  },
                  child: ProgramCardTwo(
                    photoUrl: Constants.imgFinalUrl +
                        exclusivePrograms[index].coverPhoto,
                    price: exclusivePrograms[index].price.toString(),
                    title: exclusivePrograms[index].title,
                    width: 242.0,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Widget myPrograms() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Purchased items",
                style: TextStyle(
                  color: AppColors.richBlack,
                  fontSize: 18.0,
                  fontFamily: Fonts.gilroySemiBold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Divider(
                height: 20.0,
                thickness: 1.0,
                color: AppColors.defaultInputBorders.withOpacity(0.7),
              ),
              const SizedBox(
                height: 5.0,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => const MyPrograms(),
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
                      children: const [
                        Text(
                          'Programs',
                          maxLines: 2,
                          style: TextStyle(
                            color: AppColors.richBlack,
                            fontSize: 16.0,
                            fontFamily: Fonts.helixSemiBold,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        CustomIcon(
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
              ),
              const SizedBox(
                height: 15.0,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => const PurchasedBooks(),
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
                      children: const [
                        Text(
                          'Books',
                          maxLines: 2,
                          style: TextStyle(
                            color: AppColors.richBlack,
                            fontSize: 16.0,
                            fontFamily: Fonts.helixSemiBold,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        CustomIcon(
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
              ),
              const SizedBox(
                height: 15.0,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => const MyOrders(),
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
                      children: const [
                        Text(
                          'Orders',
                          maxLines: 2,
                          style: TextStyle(
                            color: AppColors.richBlack,
                            fontSize: 16.0,
                            fontFamily: Fonts.helixSemiBold,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        CustomIcon(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topSlider() {
    return HorizontalSlider(
      slider: spotlightPrograms,
      height: double.infinity,
      width: double.infinity,
      viewPortFraction: 1.0,
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      borderRadius: 10.0,
      aspectRatio: 16 / 5,
      duration: 1500,
      bottomIndicatorVerticalPadding: 10,
    );
  }

  Widget calorieWorkoutLog() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.richBlack.withOpacity(0.04),
              blurRadius: 30.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: const Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              topCalender(),
              const SizedBox(
                height: 20.0,
              ),
              calorieEaten(total.toString(), 'Calories Eaten'),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CalorieCounterPage(
                            isAddFood: false,
                            date: date,
                            meal: 'breakfast',
                          ),
                        );
                      },
                      child: meals('BreakFast', Images.breakfast,
                          breakfast.toString(), 110.0, -16, -47),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CalorieCounterPage(
                            isAddFood: false,
                            date: date,
                            meal: 'snacks',
                          ),
                        );
                      },
                      child: meals('Snacks', Images.snacks, snacks.toString(),
                          100.0, -8, -42),
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
              Row(
                children: [
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CalorieCounterPage(
                            isAddFood: false,
                            date: date,
                            meal: 'lunch',
                          ),
                        );
                      },
                      child: meals('Lunch', Images.lunch, lunch.toString(),
                          115.0, -17, -47),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CalorieCounterPage(
                            isAddFood: false,
                            date: date,
                            meal: 'dinner',
                          ),
                        );
                      },
                      child: meals('Dinner', Images.dinner, dinner.toString(),
                          115.0, -17, -47),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                child: Divider(
                  thickness: 1.0,
                  height: 40.0,
                  color: AppColors.defaultInputBorders,
                ),
              ),
              // const SizedBox(
              //   height: 10.0,
              // ),
              // calorieBurned(totalWorkout.toString(), 'Calories burned'),
              const SizedBox(
                height: 0.0,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CalorieWorkoutPage(
                            isAddFood: false,
                            date: date,
                          ),
                        );
                      },
                      child: workoutInsights(),
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
  }

  Widget workoutInsights() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.cardBg,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Positioned(
              top: -20,
              left: -45,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.only(topRight: Radius.circular(150.0)),
                child: Image.asset(
                  Images.workout,
                  width: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    ' To see your\nworkout insights ',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: Fonts.helixMedium,
                      color: AppColors.richBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: AppColors.white,
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                      child: Text(
                        'Click here',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: Fonts.gilroySemiBold,
                          color: AppColors.highlight,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget topCalender() {
    return Container(
      color: AppColors.cardBg,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                getPreviousDate();
              },
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 20.0,
                color: AppColors.richBlack,
              ),
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Text(
                date,
                style: const TextStyle(
                  fontFamily: Fonts.helixMedium,
                  color: AppColors.richBlack,
                  fontSize: 16.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (date != 'Today') {
                  getNextDate();
                }
              },
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20.0,
                color: date != 'Today'
                    ? AppColors.richBlack
                    : AppColors.placeholder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget calorieEaten(String cal, String name) {
    return Row(
      children: [
        const SizedBox(
          width: 20.0,
        ),
        GestureDetector(
          onTap: () {
            Get.to(
              () => CalorieCounterPage(
                isAddFood: false,
                date: date,
              ),
            );
          },
          child: SizedBox(
            height: 60,
            width: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    value: calorieEatenValue,
                    backgroundColor: AppColors.cardBg,
                    strokeWidth: 5.0,
                    color: AppColors.highlight,
                  ),
                ),
                Image.asset(
                  Images.fork,
                  height: 30.0,
                  width: 30.0,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(
                () => CalorieCounterPage(
                  isAddFood: false,
                  date: date,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$cal kcal',
                  style: const TextStyle(
                    fontFamily: Fonts.helixMedium,
                    color: AppColors.richBlack,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: Fonts.gilroyMedium,
                    color: AppColors.placeholder,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        GestureDetector(
          onTap: () {
            Get.to(
              () => CalorieCounterPage(
                isAddFood: false,
                date: date,
              ),
            );
          },
          child: Image.asset(
            Images.insights,
            height: 35.0,
            width: 35.0,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        GestureDetector(
          onTap: () {
            Get.to(
              () => CalorieCounterPage(
                isAddFood: true,
                date: date,
              ),
            );
          },
          child: Image.asset(
            Images.add,
            height: 35.0,
            width: 35.0,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
      ],
    );
  }

  Widget calorieBurned(String cal, String name) {
    return Row(
      children: [
        const SizedBox(
          width: 20.0,
        ),
        GestureDetector(
          onTap: () {
            Get.to(
              () => CalorieWorkoutPage(
                isAddFood: false,
                date: date,
              ),
            );
          },
          child: SizedBox(
            height: 60,
            width: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    value: calorieBurnedValue,
                    backgroundColor: AppColors.cardBg,
                    strokeWidth: 5.0,
                    color: AppColors.highlight,
                  ),
                ),
                Image.asset(
                  Images.fork,
                  height: 30.0,
                  width: 30.0,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(
                () => CalorieWorkoutPage(
                  isAddFood: false,
                  date: date,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$cal kcal',
                  style: const TextStyle(
                    fontFamily: Fonts.helixMedium,
                    color: AppColors.richBlack,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: Fonts.gilroyMedium,
                    color: AppColors.placeholder,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        GestureDetector(
          onTap: () {
            Get.to(
              () => CalorieWorkoutPage(
                isAddFood: false,
                date: date,
              ),
            );
          },
          child: Image.asset(
            Images.insights,
            height: 35.0,
            width: 35.0,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        GestureDetector(
          onTap: () {
            Get.to(
              () => CalorieWorkoutPage(
                isAddFood: true,
                date: date,
              ),
            );
          },
          child: Image.asset(
            Images.add,
            height: 35.0,
            width: 35.0,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
      ],
    );
  }

  Widget meals(String name, String image, String cal, double width, double top,
      double left) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.cardBg,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Positioned(
              top: top,
              left: left,
              child: Image.asset(
                image,
                width: width,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontFamily: Fonts.helixMedium,
                      color: AppColors.richBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '$cal kcal',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontFamily: Fonts.helixSemiBold,
                      color: AppColors.subText,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkDownloadPdf(
      String id, String title, String downloadUrl, double price) async {
    String url =
        '${Constants.finalUrl}/books/checkBookSubscription?user_id=${Application.user?.id}&id=$id';
    Map<String, dynamic> bookData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = bookData['status'];
    var data = bookData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'can_download') {
        print(data);
        downloadFile(Constants.imgFinalUrl + downloadUrl, title);
      } else if (data[ApiKeys.message].toString() ==
              'cannot_download_subscription_expired' ||
          data[ApiKeys.message].toString() == 'not_purchased_yet') {
        Utility.showProgress(false);
        _initiatePayment(price, title, id, pdfUrl);
      } else {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
        setState(() {
          isLoading = true;
        });
      }
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
    }
  }

  Future<void> downloadFile(String mediaUrl, String title) async {
    Utility.showProgress(true);
    bool permissionsGranted = false;
    Utility.printLog('Media Url = $mediaUrl');
    Future.delayed(const Duration(microseconds: 100), () async {
      Map<Permission, PermissionStatus> permissions = await [
        Permission.storage,
      ].request();
      permissionsGranted = permissions[Permission.storage]!.isGranted;
      if (permissionsGranted) {
        Directory documents = await getApplicationDocumentsDirectory();
        String outputFile =
            '${documents.path}/${title.trim().replaceAll(' ', '-')}_${DateTime.now().millisecondsSinceEpoch.toString()}.pdf';
        try {
          await Dio().download(mediaUrl, outputFile);
          Utility.printLog("Document saved");
          String message = "Book is successfully downloaded";
          showSnackBar(message, AppColors.lightGreen, AppColors.congrats, 50.0);
        } catch (e) {
          Utility.showProgress(false);
          Utility.printLog("urlToFile ${e.toString()}");
        }
        Utility.showProgress(false);
        await OpenFilex.open(File(outputFile).path);
      } else if (permissions[Permission.storage]!.isPermanentlyDenied) {
        Utility.showProgress(false);
        openAppSettings();
      }
    });
  }

  Future _initiatePayment(
      double value, String title, String book, String pdf) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "total": value.toString(),
      "name": Application.user?.name ?? '',
      "email": Application.user?.email ?? '',
      "phone": Application.user?.phoneNumber ?? '',
      "user_id": Application.user?.id ?? '',
      "companyName": title,
      "description": "Payment for the book"
    };
    String url = '${Constants.imgFinalUrl}/subscription/paymentInitiate';
    Map<String, dynamic> initiatePayment =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = initiatePayment['status'];
    var data = initiatePayment['data'];
    if (status) {
      Utility.showProgress(false);
      try {
        setState(() {
          bookId = book;
          bookTitle = title;
          pdfUrl = pdf;
        });
        _razorpay.open(data!);
      } catch (e) {
        Utility.printLog("Payment Payment error $e");
      }
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Utility.printLog("Payment Checkout Success ${response.paymentId}");
    // _razorpay?.clear();
    Utility.showProgress(true);
    Map<String, String> params = {
      "user_id": Application.user?.id ?? '',
    };
    String url =
        '${Constants.imgFinalUrl}/subscription/purchasedItemMobile?item_id=$bookId&item_category=book&user_id=${Application.user?.id}';
    Map<String, dynamic> paymentSuccess =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = paymentSuccess['status'];
    var data = paymentSuccess['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'payment_success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(14), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        setState(() {
          bookId = '0';
          // bookTitle = '';
          // pdfUrl = '';
        });
        Future.delayed(const Duration(seconds: 1), () {
          downloadFile(Constants.imgFinalUrl + pdfUrl, bookTitle);
        });
      } else if (data[ApiKeys.message].toString() == 'payment_failed' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(15), AppColors.lightRed,
            AppColors.warning, 50.0);
      } else {
        Utility.showProgress(false);
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

  void _handlePaymentError(PaymentFailureResponse response) {
    Utility.printLog(
        "Payment Checkout Failure ${response.code} ${response.message}");
    // _razorpay?.clear();

    showSnackBar(AlertMessages.getMessage(15), AppColors.lightRed,
        AppColors.warning, 50.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    Utility.printLog("Payment Checkout Wallet ${response.walletName}");
    // _razorpay?.clear();
    Utility.showProgress(true);
    Map<String, String> params = {
      "user_id": Application.user?.id ?? '',
    };
    String url =
        '${Constants.imgFinalUrl}/subscription/purchasedItemMobile?item_id=$bookId&item_category=book&user_id=${Application.user?.id}';
    Map<String, dynamic> paymentSuccess =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = paymentSuccess['status'];
    var data = paymentSuccess['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'payment_success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(14), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        setState(() {
          bookId = '0';
          // bookTitle = '';
          // pdfUrl = '';
        });
        Future.delayed(const Duration(seconds: 1), () {
          downloadFile(Constants.imgFinalUrl + pdfUrl, bookTitle);
        });
      } else if (data[ApiKeys.message].toString() == 'payment_failed' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(15), AppColors.lightRed,
            AppColors.warning, 50.0);
      } else {
        Utility.showProgress(false);
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
}
