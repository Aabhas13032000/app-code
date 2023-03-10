part of screens;

class ExpertsPage extends StatefulWidget {
  const ExpertsPage({Key? key}) : super(key: key);

  @override
  State<ExpertsPage> createState() => _ExpertsPageState();
}

class _ExpertsPageState extends State<ExpertsPage> {
  TextEditingController searchController = TextEditingController();
  int offset = 0;
  int totalExperts = 0;
  List<Trainer> experts = [];
  bool isVerticalLoading = false;
  bool isLoading = false;

  void getExperts() async {
    if (offset == 0) {
      Utility.showProgress(true);
    }
    String url = '${Constants.finalUrl}/experts?offset=$offset';
    Map<String, dynamic> expertData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = expertData['status'];
    var data = expertData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        if (offset == 0) {
          experts.clear();
          totalExperts = data[ApiKeys.total];
        }
        data[ApiKeys.data].forEach((expert) => {
              experts.add(Trainer.fromJson(expert)),
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

  void getSearchExperts(String value) async {
    Utility.showProgress(true);
    setState(() {
      isLoading = false;
      isVerticalLoading = false;
    });
    String url = '${Constants.finalUrl}/experts/getSearchTrainers?name=$value';
    Map<String, dynamic> expertData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = expertData['status'];
    var data = expertData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        experts.clear();
        data[ApiKeys.data].forEach((expert) => {
              experts.add(Trainer.fromJson(expert)),
            });
        totalExperts = experts.length;
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
    getExperts();
    super.initState();
  }

  Future _loadMoreVertical() async {
    Utility.printLog('scrolling');
    getExperts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        centerTitle: true,
        preferredSize: const Size.fromHeight(138.0),
        showLeadingIcon: true,
        title: const Text(
          'Experts',
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
                    getExperts();
                  } else {
                    getSearchExperts(value);
                  }
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    getExperts();
                  }
                },
                decoration: InputDecoration(
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
                if (totalExperts > experts.length) {
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
                        child: GridView.builder(
                          itemCount: experts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => EachExpertPage(
                                    id: experts[index].id,
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 280.0,
                                child: ExpertCard(
                                  width: double.infinity,
                                  name: experts[index].name,
                                  photoUrl: Constants.imgFinalUrl +
                                      experts[index].profileImage,
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20.0,
                                  crossAxisSpacing: 20.0,
                                  mainAxisExtent: 230.0),
                        ),
                      ),
                      !isVerticalLoading
                          ? const Center()
                          : const Padding(
                              padding: EdgeInsets.only(top: 0.0, bottom: 20.0),
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
    );
  }
}
