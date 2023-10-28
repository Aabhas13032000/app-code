part of screens;

class EachProductPage extends StatefulWidget {
  final String id;
  const EachProductPage({
    super.key,
    required this.id,
  });

  @override
  State<EachProductPage> createState() => _EachProductPageState();
}

class _EachProductPageState extends State<EachProductPage> {
  bool isLoading = false;
  Product? product;
  List<Product> moreProducts = [];
  List<Product> similiarColorProducts = [];
  List<String> slider = [];
  List<Sizes> sizes = [];
  double priceToPay = 0;
  String productName = '';
  String address = '';
  String sizeChart = '';
  String selectedSize = '';
  bool outOfStock = false;
  int sizeCounter = 0;
  int whislist = 0;
  int selectedSizeQuantity = 0;

  void getEachProduct() async {
    Utility.showProgress(true);
    String url =
        '${Constants.finalUrl}/products/getEachProduct?id=${widget.id}&user_id=${Application.user?.id ?? "0"}';
    Map<String, dynamic> programData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = programData['status'];
    var data = programData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        moreProducts.clear();
        similiarColorProducts.clear();
        sizes.clear();
        slider.clear();
        if (data[ApiKeys.data].length != 0) {
          product = Product.fromJson(data[ApiKeys.data][0]);
          productName = Product.fromJson(data[ApiKeys.data][0]).name;
        }
        sizeChart = data[ApiKeys.sizeChart];
        whislist = int.parse(data[ApiKeys.whislist].toString());
        data[ApiKeys.images].forEach((image) => {
              slider.add(Constants.imgFinalUrl + image[ApiKeys.path]),
            });
        data[ApiKeys.eachQuantity].forEach((size) {
          sizes.add(Sizes.fromJson(size));
          if (Sizes.fromJson(size).quantity == 0) {
            sizeCounter++;
          }
        });
        if (sizeCounter == data[ApiKeys.eachQuantity].length) {
          outOfStock = true;
        } else {
          outOfStock = false;
        }
        data[ApiKeys.moreProducts].forEach((product) => {
              moreProducts.add(Product.fromJson(product)),
            });
        data[ApiKeys.similiarColors].forEach((product) => {
              similiarColorProducts.add(Product.fromJson(product)),
            });
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
        setState(() {
          isLoading = true;
        });
      }
      Utility.showProgress(false);
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
      setState(() {
        isLoading = true;
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

  void addToCart(String cartCategory) async {
    Map<String, String> params = {
      "item_category": 'product',
      "item_id": widget.id,
      "user_id": Application.user?.id ?? "0",
      "description": selectedSize,
      "cart_category": cartCategory
    };
    String url = '${Constants.finalUrl}/cart/addProductToCart';
    Map<String, dynamic> updateSessionCount =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = updateSessionCount['status'];
    var data = updateSessionCount['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        showSnackBar(
            cartCategory == 'cart'
                ? AlertMessages.getMessage(20)
                : AlertMessages.getMessage(59),
            AppColors.lightGreen,
            AppColors.congrats,
            50.0);
        if (cartCategory == 'cart') {
          setState(() {
            selectedSize = '';
            selectedSizeQuantity = 0;
          });
        } else {
          getEachProduct();
        }
      } else if (data[ApiKeys.message].toString() == 'already_added') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(23), AppColors.background,
            AppColors.subText, 50.0);
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

  @override
  void initState() {
    super.initState();
    getEachProduct();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void goBack() {
    Utility.printLog('back button clicked');
    if (Provider.of<DeepLink>(context, listen: false).deepLinkUrl.isNotEmpty) {
      context.read<DeepLink>().setDeepLinkUrl('');
      Get.offAll(
        () => const MainContainer(),
      );
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goBack();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: !isLoading
            ? Container()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: slider.isNotEmpty ? 600.0 : 20.0,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          slider.isNotEmpty
                              ? AppSlider(
                                  slider: slider,
                                  height: 600,
                                  viewPortFraction: 1,
                                  margin: const EdgeInsets.all(0.0),
                                  borderRadius: 0.0,
                                  aspectRatio: 16 / 25,
                                  width: double.infinity,
                                  duration: 1500,
                                  bottomIndicatorVerticalPadding: 34.0,
                                  isProductImage: true,
                                )
                              : const SizedBox(),
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () {
                                goBack();
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  left: 20.0,
                                  top: 40.0,
                                ),
                                child: CustomIcon(
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
                                  bgColor: AppColors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 30.0,
                      ),
                      child: Text(
                        (product?.name ?? ''),
                        maxLines: 2,
                        style: const TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 20.0,
                          fontFamily: Fonts.montserratSemiBold,
                        ),
                      ),
                    ),
                    outOfStock
                        ? const Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 20.0,
                            ),
                            child: Text(
                              'Out of stock',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontSize: 18.0,
                                fontFamily: Fonts.montserratSemiBold,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 20.0,
                      ),
                      child: priceRow(),
                    ),
                    SizedBox(
                      height: similiarColorProducts.isEmpty ? 0.0 : 20.0,
                    ),
                    similiarColorProducts.isEmpty
                        ? const SizedBox()
                        : moreColors(),
                    SizedBox(
                      height: similiarColorProducts.isEmpty ? 0.0 : 15.0,
                    ),
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        initiallyExpanded: true,
                        childrenPadding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        collapsedTextColor: AppColors.richBlack,
                        textColor: AppColors.richBlack,
                        collapsedIconColor: AppColors.richBlack,
                        iconColor: AppColors.richBlack,
                        expandedAlignment: Alignment.topLeft,
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        title: const Text(
                          'Description',
                          style: TextStyle(
                            color: AppColors.richBlack,
                            fontSize: 18.0,
                            fontFamily: Fonts.montserratSemiBold,
                          ),
                        ),
                        children: <Widget>[
                          TextToHtmlTwo(
                            description: product?.description ?? '',
                            textColor: AppColors.richBlack,
                            fontSize: 16.0,
                            font: Fonts.montserratRegular,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    eachQuantity(),
                    selectedSizeQuantity <= 2 && selectedSize.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 10.0,
                            ),
                            child: Text(
                              'Only $selectedSizeQuantity in stock',
                              style: const TextStyle(
                                color: AppColors.warning,
                                fontSize: 16.0,
                                fontFamily: Fonts.montserratSemiBold,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 30.0,
                      ),
                      child: CustomButton(
                        title: 'Buy now',
                        paddingVertical: 18,
                        paddingHorizontal: 13.5,
                        borderRadius: 0.0,
                        onPressed: () {
                          if (outOfStock) {
                            showSnackBar(AlertMessages.getMessage(34),
                                AppColors.lightRed, AppColors.warning, 50.0);
                          } else {
                            if (selectedSize.isEmpty) {
                              showSnackBar(AlertMessages.getMessage(35),
                                  AppColors.lightRed, AppColors.warning, 50.0);
                            } else {
                              Get.to(
                                () => CheckoutProductPage(
                                  id: widget.id,
                                  selectedSize: selectedSize,
                                ),
                                transition: Transition.rightToLeft,
                              );
                            }
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 20.0,
                      ),
                      child: CustomButton(
                        title: 'Add to cart',
                        isShowBorder: true,
                        borderWidth: 1.0,
                        bgColor: AppColors.white,
                        textColor: AppColors.highlight,
                        paddingVertical: 18,
                        paddingHorizontal: 13.5,
                        borderRadius: 0.0,
                        onPressed: () {
                          if (outOfStock) {
                            showSnackBar(AlertMessages.getMessage(34),
                                AppColors.lightRed, AppColors.warning, 50.0);
                          } else {
                            if (selectedSize.isEmpty) {
                              showSnackBar(AlertMessages.getMessage(35),
                                  AppColors.lightRed, AppColors.warning, 50.0);
                            } else {
                              addToCart('cart');
                            }
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 20.0,
                      ),
                      child: CustomButton(
                        title: 'Favourites',
                        isShowBorder: true,
                        borderWidth: 1.0,
                        showFavIcon: true,
                        favValue: whislist,
                        bgColor: AppColors.white,
                        textColor: AppColors.highlight,
                        paddingVertical: 18,
                        paddingHorizontal: 13.5,
                        borderRadius: 0.0,
                        onPressed: () {
                          if (whislist == 1) {
                            showSnackBar(AlertMessages.getMessage(58),
                                AppColors.background, AppColors.subText, 50.0);
                          } else {
                            addToCart('whislist');
                          }
                        },
                      ),
                    ),
                    (product?.longDescription ?? '').isEmpty
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 30.0,
                            ),
                            child: TextToHtmlTwo(
                              description: product?.longDescription ?? '',
                              textColor: AppColors.richBlack,
                              fontSize: 16.0,
                              font: Fonts.montserratRegular,
                            ),
                          ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    moreProducts.isEmpty ? const SizedBox() : relatedProducts(),
                    SizedBox(
                      height: moreProducts.isEmpty ? 0.0 : 20.0,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget priceRow() {
    return product?.discountPrice == product?.price
        ? product?.discountPrice == 0 && product?.price == 0
            ? const Text(
                "Free",
                maxLines: 1,
                style: TextStyle(
                  color: AppColors.highlight,
                  fontSize: 20.0,
                  fontFamily: Fonts.montserratSemiBold,
                ),
              )
            : Text(
                'Rs ${product?.price}',
                maxLines: 1,
                style: const TextStyle(
                  color: AppColors.highlight,
                  fontSize: 20.0,
                  fontFamily: Fonts.montserratSemiBold,
                ),
              )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Rs. ${product?.discountPrice}',
                maxLines: 1,
                style: const TextStyle(
                  color: AppColors.highlight,
                  fontSize: 20.0,
                  fontFamily: Fonts.montserratMedium,
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(
                'Rs. ${product?.price}',
                maxLines: 1,
                style: const TextStyle(
                  color: AppColors.subText,
                  fontSize: 20.0,
                  fontFamily: Fonts.montserratRegular,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                  color: AppColors.highlight,
                ),
                child: Text(
                  '${((((product?.price ?? 0) - (product?.discountPrice ?? 0)) / (product?.price ?? 1)) * 100).ceil()}% Off',
                  maxLines: 1,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20.0,
                    fontFamily: Fonts.montserratSemiBold,
                  ),
                ),
              ),
            ],
          );
  }

  Widget eachQuantity() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: HeadingViewAll(
            title: 'Choose Size',
            isShowViewAll: true,
            isShowSizeChart: true,
            onViewAllPressed: () {
              Get.to(
                () => OpenImage(
                    url: Constants.imgFinalUrl +
                        (sizeChart.isEmpty
                            ? '/images/local/curectLogo.png'
                            : sizeChart)),
                transition: Transition.rightToLeft,
              );
            },
          ),
        ),
        SizedBox(
          height: 90.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              right: 0.0,
              left: 20.0,
            ),
            shrinkWrap: true,
            itemCount: sizes.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 0.0,
                  right: 10.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    if ((sizes[index].quantity ?? 0) > 0) {
                      setState(() {
                        selectedSize = (sizes[index].size ?? '');
                        selectedSizeQuantity = (sizes[index].quantity ?? 0);
                      });
                    } else {
                      setState(() {
                        selectedSize = '';
                        selectedSizeQuantity = 0;
                      });
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: sizes[index].quantity == 0
                              ? AppColors.white
                              : selectedSize == (sizes[index].size ?? '')
                                  ? AppColors.highlight
                                  : AppColors.white,
                          border: Border.all(
                            width: 1.0,
                            color: sizes[index].quantity == 0
                                ? AppColors.background
                                : AppColors.highlight,
                          ),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: Text(
                              sizes[index].size ?? '',
                              style: TextStyle(
                                color: sizes[index].quantity == 0
                                    ? AppColors.placeholder
                                    : selectedSize == (sizes[index].size ?? '')
                                        ? AppColors.white
                                        : AppColors.richBlack,
                                fontSize: 16.0,
                                fontFamily: sizes[index].quantity == 0
                                    ? Fonts.montserratMedium
                                    : selectedSize == (sizes[index].size ?? '')
                                        ? Fonts.montserratSemiBold
                                        : Fonts.montserratMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                      (sizes[index].quantity ?? 0) == 0
                          ? Container(
                              padding: const EdgeInsets.only(
                                left: 4.0,
                                right: 4.0,
                                top: 2.0,
                                bottom: 2.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0.0),
                                color: AppColors.background.withOpacity(1.0),
                              ),
                              child: const Text(
                                'Sold Out',
                                maxLines: 1,
                                style: TextStyle(
                                  color: AppColors.subText,
                                  fontSize: 10.0,
                                  fontFamily: Fonts.montserratMedium,
                                ),
                              ),
                            )
                          : (sizes[index].quantity ?? 0) <= 2
                              ? Container(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    top: 2.0,
                                    bottom: 2.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.0),
                                    color:
                                        AppColors.placeholder.withOpacity(0.5),
                                  ),
                                  child: Text(
                                    '${(sizes[index].quantity ?? 0)} left',
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: AppColors.richBlack,
                                      fontSize: 11.0,
                                      fontFamily: Fonts.montserratSemiBold,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget moreColors() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: HeadingViewAll(
            title: 'More Colors',
            isShowViewAll: false,
          ),
        ),
        SizedBox(
          height: 120.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              right: 0.0,
              left: 20.0,
            ),
            shrinkWrap: true,
            itemCount: similiarColorProducts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 0.0,
                  right: 10.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => EachProductPage(
                        id: similiarColorProducts[index].id,
                      ),
                      preventDuplicates: false,
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Container(
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
                              (similiarColorProducts[index].coverPhoto ?? ""),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget relatedProducts() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: HeadingViewAll(
            title: 'Related products',
            isShowViewAll: false,
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
            itemCount: moreProducts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 10.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => EachProductPage(
                        id: moreProducts[index].id,
                      ),
                      transition: Transition.rightToLeft,
                      preventDuplicates: false,
                    );
                  },
                  child: ProductCard(
                    name: moreProducts[index].name,
                    photoUrl: Constants.imgFinalUrl +
                        (moreProducts[index].coverPhoto ??
                            "/images/local/curectLogo.png"),
                    width: 285.0,
                    inStock: moreProducts[index].stock ?? true,
                    price: moreProducts[index].price ?? 0,
                    discountPrice: moreProducts[index].discountPrice ?? 0,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
