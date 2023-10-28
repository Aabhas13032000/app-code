part of screens;

class ViewAllBlogs extends StatefulWidget {
  const ViewAllBlogs({Key? key}) : super(key: key);

  @override
  State<ViewAllBlogs> createState() => _ViewAllBlogsState();
}

class _ViewAllBlogsState extends State<ViewAllBlogs> {
  int offset = 0;
  int totalBlogs = 0;
  List<Blogs> blogList = [];
  List<Blogs> popularBlogs = [];
  bool isVerticalLoading = false;
  bool isLoading = false;
  TextEditingController commentController = TextEditingController();
  List<Comment> comments = [];
  bool isCommentVerticalLoading = false;
  int commentOffset = 0;
  int totalComments = 0;

  void getBlogs() async {
    if (offset == 0) {
      Utility.showProgress(true);
    }
    String url =
        '${Constants.finalUrl}/blogs?offset=$offset&imp=1&user_id=${Application.user?.id}';
    Map<String, dynamic> blogData =
        await ApiFunctions.getApiResult(url, Application.deviceToken);
    bool status = blogData['status'];
    var data = blogData['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        if (offset == 0) {
          blogList.clear();
          popularBlogs.clear();
          data[ApiKeys.popularBlogs].forEach((blog) => {
                popularBlogs.add(Blogs.fromJson(blog)),
              });
          totalBlogs = data[ApiKeys.totalBlogs];
        }
        data[ApiKeys.blogs].forEach((blog) => {
              blogList.add(Blogs.fromJson(blog)),
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
    getBlogs();
    super.initState();
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

  Future _loadMoreComentVertical(String itemId, int offset) async {
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
                            borderRadius: 0.0,
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
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(0.0),
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
                                        message: 'No comments available.',
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
                                          _loadMoreComentVertical(
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
                                  fontFamily: Fonts.montserratMedium,
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
                                          topRight: Radius.circular(0.0),
                                          bottomRight: Radius.circular(0.0),
                                        ),
                                      ),
                                      child: Center(
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
                                    fontFamily: Fonts.montserratMedium,
                                  ),
                                  focusColor: AppColors.placeholder,
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
          borderRadius: BorderRadius.circular(0.0),
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
                        fontFamily: Fonts.montserratMedium,
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
                        fontFamily: Fonts.montserratRegular,
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
                        fontFamily: Fonts.montserratRegular,
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
  void likeDislike(int index, String value) async {
    Blogs selectedBlog =
        value == 'popularBlogs' ? popularBlogs[index] : blogList[index];
    Map<String, String> params = {
      "id": selectedBlog.id,
      "user_id": Application.user?.id ?? '0',
    };
    String url = selectedBlog.isLiked
        ? '${Constants.finalUrl}/blogs/deleteLikeComment'
        : '${Constants.finalUrl}/blogs/likeEachBlog';
    Map<String, dynamic> likeDislikeQuery =
        await ApiFunctions.postApiResult(url, Application.deviceToken, params);
    bool status = likeDislikeQuery['status'];
    var data = likeDislikeQuery['data'];
    if (status) {
      if (data[ApiKeys.message].toString() == 'success') {
        Utility.showProgress(false);
        if (selectedBlog.isLiked) {
          Blogs newBlog = Blogs(
            id: selectedBlog.id,
            title: selectedBlog.title,
            description: selectedBlog.description,
            coverPhoto: selectedBlog.coverPhoto,
            shareUrl: selectedBlog.shareUrl,
            status: selectedBlog.status,
            views: selectedBlog.views,
            totalLikes: selectedBlog.totalLikes - 1,
            createdAt: selectedBlog.createdAt,
            isLiked: false,
          );
          if (value == 'popularBlogs') {
            popularBlogs.removeAt(index);
            popularBlogs.insert(index, newBlog);
          } else {
            blogList.removeAt(index);
            blogList.insert(index, newBlog);
          }
        } else {
          Blogs newBlog = Blogs(
            id: selectedBlog.id,
            title: selectedBlog.title,
            description: selectedBlog.description,
            coverPhoto: selectedBlog.coverPhoto,
            shareUrl: selectedBlog.shareUrl,
            status: selectedBlog.status,
            views: selectedBlog.views,
            totalLikes: selectedBlog.totalLikes + 1,
            createdAt: selectedBlog.createdAt,
            isLiked: true,
          );
          if (value == 'popularBlogs') {
            popularBlogs.removeAt(index);
            popularBlogs.insert(index, newBlog);
          } else {
            blogList.removeAt(index);
            blogList.insert(index, newBlog);
          }
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

  Future _loadMoreVertical() async {
    Utility.printLog('scrolling');
    getBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        preferredSize: const Size.fromHeight(70.0),
        showLeadingIcon: true,
        centerTitle: true,
        title: const Text(
          'Popular blogs',
          style: TextStyle(
            color: AppColors.richBlack,
            fontSize: 18.0,
            fontFamily: Fonts.montserratSemiBold,
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
                  transition: Transition.rightToLeft,
                );
              },
              child: CustomIcon(
                icon: MdiIcons.cartOutline,
                borderWidth: 2.0,
                borderColor: AppColors.defaultInputBorders,
                isShowDot: true,
                radius: 45.0,
                iconSize: 24.0,
                iconColor: AppColors.richBlack,
                top: 8.0,
                right: 8.0,
                borderRadius: 0.0,
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
              borderRadius: 0.0,
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
          : LazyLoadScrollView(
              isLoading: isVerticalLoading,
              onEndOfPage: () {
                if (totalBlogs > blogList.length) {
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
                          itemCount: blogList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => EachBlog(id: blogList[index].id),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              child: BlogCardTwo(
                                title: blogList[index].title,
                                likes: int.parse(
                                    blogList[index].totalLikes.toString()),
                                date: DateTime.parse(blogList[index].createdAt)
                                    .toString()
                                    .substring(0, 10),
                                photoUrl: Constants.imgFinalUrl +
                                    blogList[index].coverPhoto,
                                height: 110.0,
                                isLiked: blogList[index].isLiked,
                                onBlogClicked: () {
                                  Get.to(
                                    () => EachBlog(
                                      id: blogList[index].id,
                                    ),
                                    preventDuplicates: false,
                                    transition: Transition.rightToLeft,
                                  );
                                },
                                onCommentClicked: () {
                                  getComments(blogList[index].id, 0);
                                },
                                onLikeClicked: () {
                                  likeDislike(index, 'blogList');
                                },
                                onShareClicked: () {
                                  Utility.showProgress(true);
                                  String shareUrl =
                                      blogList[index].shareUrl != 'null'
                                          ? blogList[index].shareUrl
                                          : '';
                                  Utility.printLog(shareUrl);
                                  if (shareUrl.isEmpty) {
                                    Application.generateShareLink(
                                            blogList[index].id.toString(),
                                            'blog',
                                            '/each-blog/${blogList[index].id}?item_id=${blogList[index].id}')
                                        .then((value) {
                                      if (value != 'error') {
                                        Blogs newBlog = Blogs(
                                          id: blogList[index].id,
                                          title: blogList[index].title,
                                          description:
                                              blogList[index].description,
                                          coverPhoto:
                                              blogList[index].coverPhoto,
                                          shareUrl: value,
                                          status: blogList[index].status,
                                          views: blogList[index].views,
                                          totalLikes:
                                              blogList[index].totalLikes,
                                          createdAt: blogList[index].createdAt,
                                          isLiked: blogList[index].isLiked,
                                        );
                                        blogList.removeAt(index);
                                        blogList.insert(index, newBlog);
                                        Application.createFileOfPdfUrl(
                                                Constants.imgFinalUrl +
                                                    blogList[index].coverPhoto)
                                            .then((f) {
                                          Utility.showProgress(false);
                                          _onShare(f.path,
                                              '${blogList[index].title}\nto explore more blogs click on the link given below\n👇\n$value\nDownload our application and enjoy more features\nFor Android:\nhttps://play.google.com/store/apps/details?id=com.healfit.heal_fit\n\nFor IOS:\nhttps://apps.apple.com/in/app/healfit/id1645721639\nOr visit our website:\nhttps://healfit.in');
                                        });
                                      } else {
                                        showSnackBar(
                                            AlertMessages.getMessage(4),
                                            AppColors.lightRed,
                                            AppColors.warning,
                                            50.0);
                                      }
                                    });
                                  } else {
                                    Application.createFileOfPdfUrl(
                                            Constants.imgFinalUrl +
                                                blogList[index].coverPhoto)
                                        .then((f) {
                                      Utility.showProgress(false);
                                      _onShare(f.path,
                                          '${blogList[index].title}\nto explore more blogs click on the link given below\n👇\n${blogList[index].shareUrl != 'null' ? blogList[index].shareUrl : ''}\nDownload our application and enjoy more features\nFor Android:\nhttps://play.google.com/store/apps/details?id=com.healfit.heal_fit\nFor IOS:\nhttps://apps.apple.com/in/app/healfit/id1645721639\nOr visit our website:\nhttps://healfit.in');
                                    });
                                  }
                                },
                              ),
                            );
                          },
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
    );
  }
}
