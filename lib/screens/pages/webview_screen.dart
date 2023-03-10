part of screens;

class WebviewScreens extends StatefulWidget {
  final String url;
  final String title;
  final List<String>? tabs;
  final List<String>? tabsUrl;
  final bool? isShowTab;
  const WebviewScreens({
    Key? key,
    required this.url,
    required this.title,
    this.tabs,
    this.tabsUrl,
    this.isShowTab = false,
  }) : super(key: key);

  @override
  State<WebviewScreens> createState() => _WebviewScreensState();
}

class _WebviewScreensState extends State<WebviewScreens> {
  late WebViewXController webviewController;
  late bool isFullscreen;
  late bool isLoading = false;
  Size get screenSize => MediaQuery.of(context).size;
  String selectedTab = '';
  String selectedUrl = '';

  void changeTab(String value, String url, bool isFirstLoad) {
    setState(() {
      selectedTab = value;
      selectedUrl = url;
      isLoading = true;
    });
    if (!isFirstLoad) {
      webviewController.reload();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isShowTab ?? false) {
      changeTab(widget.tabs?[0] ?? '', widget.tabsUrl?[0] ?? '', true);
    } else {
      changeTab('', widget.url, true);
    }
  }

  @override
  void dispose() {
    webviewController.dispose();
    super.dispose();
  }

  void showSnackBar(String content, BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(content),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        preferredSize: const Size.fromHeight(70.0),
        showLeadingIcon: true,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppColors.richBlack,
            fontSize: 18.0,
            fontFamily: Fonts.helixSemiBold,
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
          : Column(
              children: [
                SizedBox(
                  height: widget.isShowTab ?? false ? 15.0 : 0.0,
                ),
                widget.isShowTab ?? false
                    ? SizedBox(
                        width: double.infinity,
                        height: 40.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 20.0,
                          ),
                          children: [
                            eachTab(widget.tabs?[0] ?? '',
                                widget.tabsUrl?[0] ?? ''),
                            eachTab(widget.tabs?[1] ?? '',
                                widget.tabsUrl?[1] ?? ''),
                          ],
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: widget.isShowTab ?? false ? 10.0 : 0.0,
                ),
                Expanded(
                  child: WebViewX(
                    key: const ValueKey('webviewx'),
                    initialContent: selectedUrl,
                    initialSourceType: SourceType.url,
                    height: screenSize.height,
                    width: screenSize.width,
                    onWebViewCreated: (controller) {
                      webviewController = controller;
                    },
                    onPageStarted: (src) {
                      Utility.showProgress(true);
                      debugPrint('A new page has started loading: $src\n');
                      if (src.toString().contains('mailto') ||
                          src.toString().contains('tel') ||
                          src.toString().contains('whatsapp') ||
                          src.toString().contains('wa.me')) {
                        if (src.toString().contains('whatsapp') ||
                            src.toString().contains('wa.me')) {
                          launchUrl(
                            Uri.parse(
                                "https://wa.me/${(src.toString().split('phone=')[1]).split('&text')[0].replaceAll('%2B', "+")}/"),
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          launchUrl(Uri.parse(src));
                        }
                        webviewController.goBack();
                      } else {
                        Utility.showProgress(false);
                      }
                    },
                    onPageFinished: (src) {
                      debugPrint('The page has finished loading: $src\n');
                      Utility.showProgress(false);
                    },
                    jsContent: const {
                      EmbeddedJsContent(
                        js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
                      ),
                      EmbeddedJsContent(
                        webJs:
                            "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
                        mobileJs:
                            "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
                      ),
                    },
                    dartCallBacks: {
                      DartCallback(
                        name: 'TestDartCallback',
                        callBack: (msg) =>
                            showSnackBar(msg.toString(), context),
                      )
                    },
                    webSpecificParams: const WebSpecificParams(
                      printDebugInfo: true,
                    ),
                    mobileSpecificParams: const MobileSpecificParams(
                      androidEnableHybridComposition: true,
                    ),
                    navigationDelegate: (navigation) {
                      debugPrint(navigation.content.sourceType.toString());
                      return NavigationDecision.navigate;
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget eachTab(String name, String url) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            // changeTab('program');
            changeTab(name, url, false);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 15.0),
            decoration: BoxDecoration(
              color: selectedTab == (name)
                  ? AppColors.highlight
                  : AppColors.background,
              borderRadius: BorderRadius.circular(8.0),
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
                      ? Fonts.gilroySemiBold
                      : Fonts.gilroyMedium,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
