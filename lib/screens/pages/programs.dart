part of screens;

class ProgramPage extends StatefulWidget {
  const ProgramPage({Key? key}) : super(key: key);

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  TextEditingController searchController = TextEditingController();
  int offset = 0;
  int totalPrograms = 0;
  List<Program> programList = [];
  List<Program> topPrograms = [];
  bool isVerticalLoading = false;
  bool isLoading = false;

  void getPrograms() async {
    if (offset == 0) {
      Utility.showProgress(true);
    }
    String url = '${Constants.finalUrl}/programs?offset=$offset';
    Map<String, dynamic> programData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = programData['status'];
    var data = programData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        if (offset == 0) {
          programList.clear();
          topPrograms.clear();
          data[ApiKeys.topSelling].forEach((program) => {
                topPrograms.add(Program.fromJson(program)),
              });
          totalPrograms = data[ApiKeys.total];
        }
        data[ApiKeys.morePrograms].forEach((program) => {
              programList.add(Program.fromJson(program)),
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

  void getSearchPrograms(String value) async {
    Utility.showProgress(true);
    setState(() {
      isLoading = false;
      isVerticalLoading = false;
    });
    String url =
        '${Constants.finalUrl}/programs/getSearchPrograms?title=$value';
    Map<String, dynamic> programData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = programData['status'];
    var data = programData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        programList.clear();
        topPrograms.clear();
        data[ApiKeys.morePrograms].forEach((program) => {
              programList.add(Program.fromJson(program)),
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
    getPrograms();
    super.initState();
  }

  Future _loadMoreVertical() async {
    Utility.printLog('scrolling');
    getPrograms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        preferredSize: const Size.fromHeight(138.0),
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
                    getPrograms();
                  } else {
                    getSearchPrograms(value);
                  }
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    getPrograms();
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
                if (totalPrograms > programList.length) {
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
                        height: topPrograms.isEmpty ? 0.0 : 20.0,
                      ),
                      topPrograms.isEmpty
                          ? const SizedBox()
                          : topSellingPrograms(),
                      SizedBox(
                        height: topPrograms.isEmpty ? 0.0 : 5.0,
                      ),
                      topPrograms.isNotEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                              ),
                              child: HeadingViewAll(
                                title: 'More programs',
                                isShowViewAll: false,
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GridView.builder(
                          itemCount: programList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Get.to(
                                () => EachProgram(id: programList[index].id),
                              );
                            },
                            child: ProgramCardThree(
                              photoUrl: Constants.imgFinalUrl +
                                  programList[index].coverPhoto,
                              title: programList[index].title,
                              price: programList[index].price.toString(),
                            ),
                          ),
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
                            ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget topSellingPrograms() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: HeadingViewAll(
            title: 'Top selling programs',
            isShowViewAll: false,
          ),
        ),
        SizedBox(
          height: 300.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: topPrograms.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                  top: 20.0,
                  bottom: 20.0,
                  right: index == topPrograms.length - 1 ? 20.0 : 0.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => EachProgram(id: topPrograms[index].id),
                    );
                  },
                  child: ProgramCardOne(
                    photoUrl:
                        Constants.imgFinalUrl + topPrograms[index].coverPhoto,
                    title: topPrograms[index].title,
                    price: topPrograms[index].price.toString(),
                    isJoined: false,
                    numberOfTrainers: 0,
                    firstTrainerUrl: '',
                    secondTrainerUrl: '',
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
