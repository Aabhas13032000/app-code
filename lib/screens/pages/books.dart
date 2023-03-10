part of screens;

class BooksPage extends StatefulWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  TextEditingController searchController = TextEditingController();
  int offset = 0;
  int totalBooks = 0;
  List<Book> bookList = [];
  bool isVerticalLoading = false;
  bool isLoading = false;
  String bookId = '0';
  String pdfUrl = '';
  String bookTitle = '';

  late Razorpay _razorpay;

  void checkDownloadPdf(
      String id, String title, String downloadUrl, double price) async {
    Utility.showProgress(true);
    String url =
        '${Constants.finalUrl}/books/checkBookSubscription?user_id=${Application.user?.id}&id=$id';
    Map<String, dynamic> bookData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = bookData['status'];
    var data = bookData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'can_download') {
        Utility.showProgress(false);
        downloadFile(Constants.imgFinalUrl + downloadUrl, title);
      } else if (data[ApiKeys.message].toString() ==
              'cannot_download_subscription_expired' ||
          data[ApiKeys.message].toString() == 'not_purchased_yet') {
        Utility.showProgress(false);
        _initiatePayment(price, title, id, downloadUrl);
      } else {
        Utility.showProgress(false);
        showSnackBar(data[ApiKeys.message].toString(), AppColors.lightRed,
            AppColors.warning, 50.0);
        setState(() {
          isLoading = true;
          isVerticalLoading = false;
        });
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

  Future<void> downloadFile(String mediaUrl, String title) async {
    Utility.showProgress(true);
    bool permissionsGranted = false;
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

  void getBooks() async {
    if (offset == 0) {
      Utility.showProgress(true);
    }
    String url = '${Constants.finalUrl}/books?offset=$offset';
    Map<String, dynamic> bookData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = bookData['status'];
    var data = bookData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        if (offset == 0) {
          bookList.clear();
          totalBooks = data[ApiKeys.totalBooks];
        }
        data[ApiKeys.books].forEach((book) => {
              bookList.add(Book.fromJson(book)),
            });
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
      Utility.showProgress(false);
    } else {
      Utility.printLog('Something went wrong while saving token.');
      Utility.printLog('Some error occurred');
      Utility.showProgress(false);
      showSnackBar(AlertMessages.getMessage(4), AppColors.lightRed,
          AppColors.warning, 50.0);
    }
  }

  void getSearchBooks(String value) async {
    Utility.showProgress(true);
    setState(() {
      isLoading = false;
      isVerticalLoading = false;
    });
    String url = '${Constants.finalUrl}/books/getSearchBooks?title=${value}';
    Map<String, dynamic> bookData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = bookData['status'];
    var data = bookData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        bookList.clear();
        data[ApiKeys.books].forEach((book) => {
              bookList.add(Book.fromJson(book)),
            });
        totalBooks = bookList.length;
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
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getBooks();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future _loadMoreVertical() async {
    Utility.printLog('scrolling');
    getBooks();
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
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          centerTitle: true,
          preferredSize: const Size.fromHeight(138.0),
          showLeadingIcon: true,
          title: const Text(
            'Books',
            style: TextStyle(
              color: AppColors.richBlack,
              fontSize: 20.0,
              fontFamily: Fonts.helixSemiBold,
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
          leadingWidget: Padding(
            padding: const EdgeInsets.only(
              top: 12.5,
              left: 20.0,
              bottom: 12.5,
              right: 0.0,
            ),
            child: GestureDetector(
              onTap: () {
                goBack();
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
                    fontFamily: Fonts.gilroyMedium,
                  ),
                  controller: searchController,
                  cursorColor: AppColors.defaultInputBorders,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.search,
                  cursorWidth: 1.5,
                  onSubmitted: (value) {
                    if (value.isEmpty) {
                      getBooks();
                    } else {
                      getSearchBooks(value);
                    }
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      getBooks();
                    }
                  },
                  decoration: InputDecoration(
                    hintMaxLines: 1,
                    hintText: 'Search by title',
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
            ),
          ),
        ),
        body: !isLoading
            ? Container()
            : LazyLoadScrollView(
                isLoading: isVerticalLoading,
                onEndOfPage: () {
                  if (totalBooks > bookList.length) {
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
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 230.0,
                                margin: const EdgeInsets.only(bottom: 15.0),
                                child: BookCardOne(
                                  title: bookList[index].title,
                                  price: bookList[index].price.toString(),
                                  author: bookList[index].author,
                                  width: double.infinity,
                                  photoUrl: Constants.imgFinalUrl +
                                      bookList[index].coverPhoto,
                                  discountPrice:
                                      bookList[index].discountPrice.toString(),
                                  downloads:
                                      bookList[index].downloads.toString(),
                                  onDownloadClicked: () {
                                    checkDownloadPdf(
                                        bookList[index].id,
                                        bookList[index].title,
                                        bookList[index].pdf,
                                        bookList[index].discountPrice);
                                  },
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
                                      fontFamily: Fonts.gilroyMedium,
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
