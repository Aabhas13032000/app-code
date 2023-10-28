part of screens;

class WhislistPage extends StatefulWidget {
  const WhislistPage({super.key});

  @override
  State<WhislistPage> createState() => _WhislistPageState();
}

class _WhislistPageState extends State<WhislistPage> {
  List<Product> productWhislistItems = [];
  bool isLoading = false;

  void getMyWhislist() async {
    Utility.showProgress(true);
    String url =
        '${Constants.finalUrl}/cart/getUserProductWhislist?user_id=${Application.user?.id}';
    Map<String, dynamic> cartData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = cartData['status'];
    var data = cartData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        productWhislistItems.clear();
        data[ApiKeys.data].forEach((product) => {
              productWhislistItems.add(Product.fromJson(product)),
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
      }
      setState(() {
        isLoading = true;
      });
      Utility.showProgress(false);
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
    }
  }

  void removeFromCart(String id, int index) async {
    Utility.showProgress(true);
    Map<String, String> params = {
      "cart_id": id,
    };
    String url = '${Constants.finalUrl}/cart/removeFromCart';
    Map<String, dynamic> updateSessionCount =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = updateSessionCount['status'];
    var data = updateSessionCount['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        showSnackBar(AlertMessages.getMessage(57), AppColors.lightGreen,
            AppColors.congrats, 50.0);
        getMyWhislist();
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

  @override
  void initState() {
    super.initState();
    getMyWhislist();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  (productWhislistItems.isEmpty)
                      ? const SizedBox(
                          height: 500.0,
                          child: Center(
                            child: NoDataAvailable(
                              message:
                                  'No items present in Favourites, add some.',
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            right: 20.0,
                            left: 20.0,
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: (itemWidth / itemHeight),
                              mainAxisSpacing: 16.0,
                              crossAxisSpacing: 16.0,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: productWhislistItems.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => EachProductPage(
                                          id: productWhislistItems[index].id,
                                        ),
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    child: Container(
                                      height: itemHeight - 100,
                                      margin: const EdgeInsets.only(
                                        right: 0.0,
                                        bottom: 0.0,
                                      ),
                                      child: ProductCard(
                                        name: productWhislistItems[index].name,
                                        leftpadding: 0,
                                        photoUrl: Constants.imgFinalUrl +
                                            (productWhislistItems[index]
                                                    .coverPhoto ??
                                                "/images/local/curectLogo.png"),
                                        width: double.infinity,
                                        inStock:
                                            productWhislistItems[index].stock ??
                                                true,
                                        price:
                                            productWhislistItems[index].price ??
                                                0,
                                        discountPrice:
                                            productWhislistItems[index]
                                                    .discountPrice ??
                                                0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 0.0),
                                    child: Row(
                                      children: [
                                        CustomButton(
                                          title: 'Add to cart',
                                          isShowBorder: true,
                                          bgColor: AppColors.white,
                                          textColor: AppColors.highlight,
                                          borderWidth: 1.0,
                                          paddingVertical: 9,
                                          paddingHorizontal: 10.0,
                                          borderRadius: 0.0,
                                          onPressed: () {
                                            Get.to(
                                              () => EachProductPage(
                                                id: productWhislistItems[index]
                                                    .id,
                                              ),
                                              transition:
                                                  Transition.rightToLeft,
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        const Expanded(
                                          child: SizedBox(),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Utility.twoButtonPopup(
                                                context,
                                                Icons.warning_amber_rounded,
                                                40.0,
                                                AppColors.highlight,
                                                AlertMessages.getMessage(61),
                                                'No',
                                                'Yes',
                                                onFirstButtonClicked: () {
                                              Get.back();
                                            }, onSecondButtonClicked: () {
                                              Get.back();
                                              Utility.printLog(
                                                  'Cart Id = ${productWhislistItems[index].cartId}');
                                              removeFromCart(
                                                  productWhislistItems[index]
                                                          .cartId ??
                                                      '',
                                                  index);
                                            });
                                          },
                                          child: const CustomIcon(
                                            icon: Icons.delete_outline,
                                            borderWidth: 0.0,
                                            borderColor: AppColors.white,
                                            isShowDot: false,
                                            radius: 40.0,
                                            iconSize: 24.0,
                                            iconColor: AppColors.highlight,
                                            top: 0,
                                            right: 0,
                                            borderRadius: 0.0,
                                            isShowBorder: false,
                                            bgColor: AppColors.background,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
    );
  }
}
