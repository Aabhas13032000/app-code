part of screens;

class CategoryWiseProducts extends StatefulWidget {
  final bool? isGender;
  final String? gender;
  final bool? isCategory;
  final String? category;
  final bool? isClothCategory;
  final String? clothCategory;

  const CategoryWiseProducts({
    Key? key,
    this.isGender = false,
    this.gender = '',
    this.isCategory = false,
    this.category = '',
    this.isClothCategory = false,
    this.clothCategory = '',
  }) : super(key: key);

  @override
  State<CategoryWiseProducts> createState() => _CategoryWiseProductsState();
}

class _CategoryWiseProductsState extends State<CategoryWiseProducts> {
  int offset = 0;
  int totalProducts = 0;
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  List<Product> products = [];
  List<CurectCategories> clothCategories = [];
  bool isVerticalLoading = false;
  String selectedTab = '';

  void getData(String selectedTabValue) async {
    Utility.showProgress(true);
    setState(() {
      selectedTab = selectedTabValue;
    });
    String url = widget.isGender ?? false
        ? '${Constants.finalUrl}/products/getProductsByGender?gender=${(widget.gender ?? "").isNotEmpty ? widget.gender : "All"}&offset=$offset${selectedTabValue == "ALL" ? "" : "&category=$selectedTabValue"}'
        : widget.isCategory ?? false
            ? '${Constants.finalUrl}/products/getProductsByCategory?category=${(widget.category ?? "").isNotEmpty ? widget.category : "All"}&offset=$offset&cloth_category=$selectedTabValue'
            : widget.isClothCategory ?? false
                ? '${Constants.finalUrl}/products/getProductsByGender?gender=All&offset=$offset&category=${widget.clothCategory ?? ""}'
                : '';
    Map<String, dynamic> productData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = productData['status'];
    var data = productData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        products.clear();
        clothCategories.clear();
        data[ApiKeys.products].forEach((product) => {
              products.add(Product.fromJson(product)),
            });
        data[ApiKeys.clothcategory].forEach((category) {
          clothCategories.add(CurectCategories.fromJson(category));
        });
        totalProducts = data[ApiKeys.totalProducts];
        Utility.showProgress(false);
        setState(() {
          isLoading = true;
          isVerticalLoading = false;
        });
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
        setState(() {
          isLoading = true;
          isVerticalLoading = false;
        });
      } else {
        Utility.showProgress(false);
        showSnackBar(data[ApiKeys.message].toString(), AppColors.lightRed,
            AppColors.warning, 50.0);
        setState(() {
          isLoading = true;
          isVerticalLoading = false;
        });
      }
      setState(() {
        isLoading = true;
        isVerticalLoading = false;
      });
      Utility.showProgress(false);
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
      setState(() {
        isLoading = true;
        isVerticalLoading = false;
      });
    }
  }

  void getSearchData(String value) async {
    Utility.showProgress(true);
    setState(() {
      isLoading = false;
      isVerticalLoading = false;
    });
    String url = widget.isGender ?? false
        ? '${Constants.finalUrl}/products/getSearchProductsByGender?gender=${(widget.gender ?? "").isNotEmpty ? widget.gender : "All"}&name=$value${selectedTab == "ALL" ? "" : "&category=$selectedTab"}'
        : widget.isCategory ?? false
            ? '${Constants.finalUrl}/products/getSearchProductsByCategory?category=${(widget.category ?? "").isNotEmpty ? widget.category : "All"}&name=$value&cloth_category=$selectedTab'
            : widget.isClothCategory ?? false
                ? '${Constants.finalUrl}/products/getSearchProductsByGender?gender=All&name=$value&category=${widget.clothCategory ?? ""}'
                : '';
    Map<String, dynamic> blogData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = blogData['status'];
    var data = blogData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        products.clear();
        data[ApiKeys.products].forEach((product) => {
              products.add(Product.fromJson(product)),
            });
        totalProducts = products.length;
        Utility.showProgress(false);
        setState(() {
          isLoading = true;
          isVerticalLoading = false;
        });
      } else if (data[ApiKeys.message].toString() == 'Auth_token_failure' ||
          data[ApiKeys.message].toString() == 'Database_connection_error') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
            AppColors.warning, 50.0);
        setState(() {
          isLoading = true;
          isVerticalLoading = false;
        });
      } else {
        showSnackBar(data[ApiKeys.message].toString(), AppColors.lightRed,
            AppColors.warning, 50.0);
      }
      setState(() {
        isLoading = true;
        isVerticalLoading = false;
      });
      Utility.showProgress(false);
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
      setState(() {
        isLoading = true;
        isVerticalLoading = false;
      });
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

  Future _loadMoreVertical() async {
    Utility.printLog('scrolling');
    getData(selectedTab);
  }

  @override
  void initState() {
    getData('ALL');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Application.goBack(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          preferredSize: const Size.fromHeight(138.0),
          showLeadingIcon: true,
          centerTitle: true,
          title: GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
              padding: const EdgeInsets.symmetric(
                vertical: 12.5,
                horizontal: 20.0,
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
          leadingWidget: Padding(
            padding: const EdgeInsets.only(
              top: 12.5,
              left: 20.0,
              bottom: 12.5,
              right: 0.0,
            ),
            child: GestureDetector(
              onTap: () {
                Application.goBack(context);
              },
              child: const CustomIcon(
                icon: Icons.arrow_back_ios_rounded,
                borderWidth: 0.0,
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
            child: Padding(
              padding: const EdgeInsets.only(
                top: 3.5,
                left: 20.0,
                right: 20.0,
                bottom: 15.0,
              ),
              child: SizedBox(
                height: 50.0,
                child: TextField(
                  autofocus: false,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 16.0,
                    fontFamily: Fonts.montserratMedium,
                  ),
                  controller: searchController,
                  cursorColor: AppColors.defaultInputBorders,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.search,
                  cursorWidth: 1.5,
                  onSubmitted: (value) {
                    if (value.isEmpty) {
                      getData(selectedTab);
                    } else {
                      getSearchData(value);
                    }
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      getData(selectedTab);
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.background,
                    hintMaxLines: 1,
                    hintText: 'Search by name',
                    counterText: '',
                    contentPadding: const EdgeInsets.only(top: 20.0),
                    prefixIcon: const Center(
                      child: Icon(
                        Icons.search_sharp,
                        size: 24.0,
                        color: AppColors.subText,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minHeight: 55.0,
                      minWidth: 50.0,
                      maxHeight: 55.0,
                      maxWidth: 50.0,
                    ),
                    hintStyle: const TextStyle(
                      color: AppColors.subText,
                      fontSize: 16.0,
                      fontFamily: Fonts.montserratMedium,
                    ),
                    focusColor: AppColors.subText,
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
                        color: AppColors.background,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: !isLoading
            ? Container()
            : LazyLoadScrollView(
                isLoading: isVerticalLoading,
                onEndOfPage: () {
                  if (totalProducts > products.length) {
                    setState(() {
                      offset = offset + 20;
                      isVerticalLoading = true;
                    });
                    _loadMoreVertical();
                  }
                },
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: (widget.isClothCategory ?? false) ||
                                  (widget.isCategory ?? false)
                              ? 5.0
                              : 15.0,
                        ),
                        (widget.isClothCategory ?? false) ||
                                (widget.isCategory ?? false)
                            ? const SizedBox()
                            : SizedBox(
                                width: double.infinity,
                                height: 40.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.only(
                                    left: 5.0,
                                    right: 20.0,
                                  ),
                                  itemCount: clothCategories.length,
                                  itemBuilder: (context, index) {
                                    return eachTab(
                                        clothCategories[index].clothCategory ??
                                            "");
                                  },
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => EachProductPage(
                                      id: products[index].id,
                                    ),
                                    transition: Transition.rightToLeft,
                                  );
                                },
                                child: Container(
                                  height: 420.0,
                                  margin: const EdgeInsets.only(
                                    right: 20.0,
                                    bottom: 0.0,
                                  ),
                                  child: ProductCard(
                                    name: products[index].name,
                                    photoUrl: Constants.imgFinalUrl +
                                        (products[index].coverPhoto ??
                                            "/images/local/curectLogo.png"),
                                    width: double.infinity,
                                    inStock: products[index].stock ?? true,
                                    price: products[index].price ?? 0,
                                    discountPrice:
                                        products[index].discountPrice ?? 0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        !isVerticalLoading
                            ? const Center()
                            : const Padding(
                                padding:
                                    EdgeInsets.only(top: 0.0, bottom: 20.0),
                                child: Center(
                                  child: Text(
                                    'Loading...',
                                    style: TextStyle(
                                      color: AppColors.richBlack,
                                      fontSize: 16.0,
                                      fontFamily: Fonts.montserratMedium,
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget eachTab(String name) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            // changeTab('program');
            getData(name);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 15.0),
            decoration: BoxDecoration(
              color:
                  selectedTab == (name) ? AppColors.highlight : AppColors.white,
              borderRadius: BorderRadius.circular(0.0),
              border: Border.all(
                width: 1.0,
                color: selectedTab == (name)
                    ? AppColors.highlight
                    : AppColors.placeholder,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 8.0,
                bottom: 8.0,
              ),
              child: Text(
                name,
                style: TextStyle(
                  color:
                      selectedTab == (name) ? AppColors.white : AppColors.black,
                  fontSize: 16.0,
                  fontFamily: selectedTab == (name)
                      ? Fonts.montserratSemiBold
                      : Fonts.montserratMedium,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
