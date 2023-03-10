part of widgets;

class BlogCard extends StatelessWidget {
  const BlogCard({
    Key? key,
    required this.title,
    required this.description,
    required this.likes,
    required this.width,
    required this.date,
    required this.photoUrl,
    this.onBlogClicked,
    this.onLikeClicked,
    this.onCommentClicked,
    this.onShareClicked,
    this.isLiked = false,
  }) : super(key: key);

  final String title;
  final String description;
  final int likes;
  final double width;
  final String date;
  final String photoUrl;
  final Function()? onBlogClicked;
  final Function()? onLikeClicked;
  final Function()? onCommentClicked;
  final Function()? onShareClicked;
  final bool? isLiked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.08),
            blurRadius: 30.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: const Offset(
              0.0, // Move to right 10  horizontally
              0.0, // Move to bottom 10 Vertically
            ),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GestureDetector(
              onTap: onBlogClicked,
              child: ImagePlaceholder(
                url: photoUrl,
                height: double.infinity,
                width: width,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  // height: 145.0,
                  constraints: const BoxConstraints(
                    minHeight: 145.0,
                    maxHeight: 170.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      bottom: 10.0,
                      top: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: onBlogClicked,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                  color: AppColors.subText,
                                  fontSize: 14.0,
                                  fontFamily: Fonts.helixRegular,
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                title,
                                maxLines: 2,
                                style: const TextStyle(
                                  color: AppColors.richBlack,
                                  fontSize: 16.0,
                                  fontFamily: Fonts.helixSemiBold,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              description.contains('<p>')
                                  ? TextToHtml(
                                      description: '<div>$description</div>',
                                      textColor: AppColors.subText,
                                      fontSize: 14.0,
                                      maxLines: 2,
                                      font: Fonts.gilroyRegular,
                                      maxChar: 65,
                                    )
                                  : Text(
                                      description,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        color: AppColors.subText,
                                        fontSize: 14.0,
                                        fontFamily: Fonts.gilroyRegular,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: onLikeClicked,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      isLiked ?? false
                                          ? Icons.thumb_up
                                          : Icons.thumb_up_off_alt_outlined,
                                      color: isLiked ?? false
                                          ? AppColors.highlight
                                          : AppColors.subText,
                                      size: 18.0,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      '$likes',
                                      style: TextStyle(
                                        color: isLiked ?? false
                                            ? AppColors.highlight
                                            : AppColors.subText,
                                        fontSize: 16.0,
                                        fontFamily: Fonts.helixMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            GestureDetector(
                              onTap: onCommentClicked,
                              child: const Icon(
                                Icons.mode_comment_outlined,
                                color: AppColors.subText,
                                size: 18.0,
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            GestureDetector(
                              onTap: onShareClicked,
                              child: const Icon(
                                Icons.share_rounded,
                                color: AppColors.subText,
                                size: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
