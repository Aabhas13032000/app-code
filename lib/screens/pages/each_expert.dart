part of screens;

class EachExpertPage extends StatefulWidget {
  final String id;
  const EachExpertPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<EachExpertPage> createState() => _EachExpertPageState();
}

class _EachExpertPageState extends State<EachExpertPage> {
  bool isLoading = false;
  Trainer? trainer;
  List<Program> programs = [];
  List<String> slider = [];

  void getEachTrainer() async {
    Utility.showProgress(true);
    String url =
        '${Constants.finalUrl}/experts/getEachTrainers?id=${widget.id}';
    Map<String, dynamic> programData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = programData['status'];
    var data = programData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        programs.clear();
        slider.clear();
        if (data[ApiKeys.data].length != 0) {
          trainer = Trainer.fromJson(data[ApiKeys.data][0]);
        }
        data[ApiKeys.images].forEach((image) => {
              slider.add(Constants.imgFinalUrl + image[ApiKeys.path]),
            });
        data[ApiKeys.programs].forEach((program) => {
              programs.add(Program.fromJson(program)),
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
    getEachTrainer();
    super.initState();
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
        appBar: CustomAppBar(
          preferredSize: const Size.fromHeight(70.0),
          showLeadingIcon: true,
          centerTitle: true,
          title: const Text(
            '',
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
            child: Container(
              height: 0.0,
            ),
          ),
        ),
        body: !isLoading
            ? Container()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: slider.isNotEmpty
                          ? MediaQuery.of(context).size.height * 3 / 5
                          : 20.0,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          slider.isNotEmpty
                              ? AppSlider(
                                  slider: slider,
                                  height: MediaQuery.of(context).size.height *
                                      3 /
                                      5,
                                  viewPortFraction: 1,
                                  margin: const EdgeInsets.all(0.0),
                                  borderRadius: 0.0,
                                  aspectRatio: 9 / 16,
                                  width: double.infinity,
                                  duration: 1500,
                                  bottomIndicatorVerticalPadding: 55.0,
                                )
                              : const SizedBox(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 20.0,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0),
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
                      ),
                      child: Text(
                        (trainer?.name ?? ''),
                        style: const TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 24.0,
                          fontFamily: Fonts.helixSemiBold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        'Vision',
                        style: TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 16.0,
                          fontFamily: Fonts.gilroySemiBold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: TextToHtmlTwo(
                        description: trainer?.vision ?? '',
                        textColor: AppColors.richBlack,
                        fontSize: 16.0,
                        font: Fonts.gilroyRegular,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        'About',
                        style: TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 16.0,
                          fontFamily: Fonts.gilroySemiBold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: TextToHtmlTwo(
                        description: trainer?.about ?? '',
                        textColor: AppColors.richBlack,
                        fontSize: 16.0,
                        font: Fonts.gilroyRegular,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        'Qualification',
                        style: TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 16.0,
                          fontFamily: Fonts.gilroySemiBold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: TextToHtmlTwo(
                        description: trainer?.qualification ?? '',
                        textColor: AppColors.richBlack,
                        fontSize: 16.0,
                        font: Fonts.gilroyRegular,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        'Expertise',
                        style: TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 16.0,
                          fontFamily: Fonts.gilroySemiBold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: TextToHtmlTwo(
                        description: trainer?.expertise ?? '',
                        textColor: AppColors.richBlack,
                        fontSize: 16.0,
                        font: Fonts.gilroyRegular,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    programs.isEmpty ? const SizedBox() : moreProgram(),
                    SizedBox(
                      height: programs.isEmpty ? 0.0 : 10.0,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget moreProgram() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: HeadingViewAll(
            title: 'Programs offered',
            isShowViewAll: false,
          ),
        ),
        SizedBox(
          height: 270.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: programs.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                  top: 20.0,
                  bottom: 20.0,
                  right: index == programs.length - 1 ? 20.0 : 0.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Utility.printLog('Program is clicked');
                    Get.to(
                      () => EachProgram(id: programs[index].id),
                      preventDuplicates: false,
                    );
                  },
                  child: ProgramCardThree(
                    photoUrl:
                        Constants.imgFinalUrl + programs[index].coverPhoto,
                    title: programs[index].title,
                    price: programs[index].price.toString(),
                    isGridView: false,
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
