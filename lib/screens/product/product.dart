part of screens;

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isLoading = false;
  List<Product> products = [];
  List<Blogs> popular = [];
  List<CurectCategories> productCategories = [];
  List<String> clothSlider = [];
  List<CurectCategories> productSlider = [];
  List<CurectCategories> clothCategories = [];
  final CardSwiperController controller = CardSwiperController();

  void getInitialProductData() async {
    Utility.showProgress(true);
    String url = '${Constants.finalUrl}/products/getProductsInitialData';
    Map<String, dynamic> initialData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = initialData['status'];
    var data = initialData['data'];
    if (status) {
      // print(data);
      if (data[ApiKeys.message].toString() == 'success') {
        data[ApiKeys.clothCategories].forEach((category) {
          clothCategories.add(CurectCategories.fromJson(category));
        });
        data[ApiKeys.productSlider].forEach((category) {
          if ((CurectCategories.fromJson(category).mobileSlider ?? "")
              .isNotEmpty) {
            productSlider.add(CurectCategories.fromJson(category));
            clothSlider.add(Constants.imgFinalUrl +
                (CurectCategories.fromJson(category).mobileSlider ??
                    "/images/local/curectLogo.png"));
          }
        });
        data[ApiKeys.productCategories].forEach((category) => {
              productCategories.add(CurectCategories.fromJson(category)),
            });
        data[ApiKeys.popular].forEach((blog) => {
              popular.add(Blogs.fromJson(blog)),
            });
        data[ApiKeys.impProducts].forEach((product) => {
              products.add(Product.fromJson(product)),
            });
        setState(() {
          isLoading = true;
        });
        Utility.showProgress(false);
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
    getInitialProductData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        preferredSize: const Size.fromHeight(70.0),
        showLeadingIcon: false,
        title: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Image.asset(
                Images.curectLogo,
                width: 25.0,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Image.asset(
                Images.curectLogoName,
                width: 100.0,
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12.5,
              bottom: 12.5,
              left: 0.0,
              right: 20.0,
            ),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => const ProfilePage(),
                  transition: Transition.rightToLeft,
                );
              },
              child: CustomIcon(
                icon: Icons.close,
                borderWidth: 0.0,
                borderColor: AppColors.transparent,
                isShowDot: false,
                radius: 45.0,
                iconSize: 30.0,
                iconColor: AppColors.white,
                top: 0,
                right: 0,
                borderRadius: 0.0,
                isShowBorder: false,
                bgColor: AppColors.background,
                isNameInitial: true,
                name: (Application.user?.name ?? '')[0],
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  clothSlider.isNotEmpty
                      ? AppSlider(
                          slider: clothSlider,
                          height: 600,
                          viewPortFraction: 1,
                          margin: const EdgeInsets.all(0.0),
                          borderRadius: 0.0,
                          aspectRatio: 16 / 28,
                          width: double.infinity,
                          duration: 1500,
                          bottomIndicatorVerticalPadding: 30.0,
                          isProductImage: true,
                          onImageClicked: (imageUrl) {
                            Utility.printLog('Category');
                            var item = productSlider.firstWhere((element) =>
                                (Constants.imgFinalUrl +
                                    (element.mobileSlider ??
                                        Images.curectLogo)) ==
                                imageUrl);

                            if ((item.name ?? "").isEmpty) {
                              Get.to(
                                () => EachProductPage(
                                  id: item.id ?? "",
                                ),
                                transition: Transition.rightToLeft,
                              );
                            } else {
                              Get.to(
                                () => CategoryWiseProducts(
                                  isClothCategory: true,
                                  clothCategory: item.name ?? "",
                                ),
                                transition: Transition.rightToLeft,
                              );
                            }
                          },
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 25.0,
                  ),
                  genderTabs(),
                  const SizedBox(
                    height: 0.0,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: productCategories.length,
                    itemBuilder: (context, index) {
                      return productCategory(productCategories[index]);
                    },
                  ),
                  clothCategory(),
                  const SizedBox(
                    height: 30.0,
                  ),
                  popular.isNotEmpty ? feedSection() : const SizedBox(),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
    );
  }

  Widget genderTabs() {
    return Row(
      children: [
        const SizedBox(
          width: 20.0,
        ),
        genderEachTab(
          'Men',
          CategoryWiseProducts(
            isGender: true,
            gender: 'MALE',
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        genderEachTab(
          'Women',
          CategoryWiseProducts(
            isGender: true,
            gender: 'WOMEN',
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        genderEachTab(
          'Unisex',
          CategoryWiseProducts(
            isGender: true,
            gender: 'UNISEX',
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
      ],
    );
  }

  Widget genderEachTab(String name, Widget widget) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => widget,
            transition: Transition.rightToLeft,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(0.0),
            border: Border.all(
              width: 1.0,
              color: AppColors.highlight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 10.0,
              bottom: 10.0,
            ),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Icon(Icons.male),
                  // const SizedBox(
                  //   width: 3.0,
                  // ),
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 16.0,
                      fontFamily: Fonts.montserratSemiBold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
            bottom: 20.0,
          ),
          child: HeadingViewAll(
            title: productCategory.name ?? "",
            onViewAllPressed: () {
              Get.to(
                () => CategoryWiseProducts(
                  isCategory: true,
                  category: productCategory.name ?? "All",
                ),
                transition: Transition.rightToLeft,
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
                    top: 0.0,
                    bottom: 0.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        () => EachProductPage(
                          id: products[index].id,
                        ),
                        transition: Transition.rightToLeft,
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

  Widget clothCategory() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 15.0,
            bottom: 15.0,
          ),
          child: HeadingViewAll(
            title: 'Top Categories',
            onViewAllPressed: () {},
            isShowViewAll: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 20.0,
              runAlignment: WrapAlignment.start,
              runSpacing: 20.0,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                for (var category in clothCategories)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CategoryWiseProducts(
                            isClothCategory: true,
                            clothCategory: category.name ?? "",
                          ),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: ImagePlaceholder(
                                  url: Constants.imgFinalUrl +
                                      (category.coverPhoto ?? ""),
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: 90.0,
                            child: Text(
                              category.name ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 14.0,
                                fontFamily: Fonts.montserratMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget feedSection() {
    return Column(
      children: [
        const Text(
          'Feeds',
          style: TextStyle(
            color: AppColors.richBlack,
            fontSize: 20.0,
            fontFamily: Fonts.montserratSemiBold,
          ),
        ),
        SizedBox(
          height: 500.0,
          child: CardSwiper(
            controller: controller,
            cardsCount: popular.length,
            onSwipe: _onSwipe,
            onUndo: _onUndo,
            numberOfCardsDisplayed: popular.length < 3 ? popular.length : 3,
            backCardOffset: const Offset(0, 35),
            isLoop: true,
            scale: 0.9,
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 0.0),
            cardBuilder: (
              BuildContext context,
              int index,
              int horizontalThresholdPercentage,
              int verticalThresholdPercentage,
            ) {
              return BlogCardThree(
                description: popular[index].description,
                title: popular[index].title,
                likes: int.parse(popular[index].totalLikes.toString()),
                date: DateTime.parse(popular[index].createdAt)
                    .toString()
                    .substring(0, 10),
                photoUrl: Constants.imgFinalUrl + popular[index].coverPhoto,
                height: 350.0,
                width: double.infinity,
                isLiked: true,
                onBlogClicked: () {
                  Get.to(
                    () => EachBlog(
                      id: popular[index].id,
                    ),
                    preventDuplicates: false,
                    transition: Transition.rightToLeft,
                  );
                },
                onCommentClicked: () {},
                onLikeClicked: () {},
                onShareClicked: () {},
              );
            },
          ),
        ),
      ],
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }
}
