part of widgets;

class BlogCardTwo extends StatelessWidget {
  const BlogCardTwo({
    Key? key,
    required this.title,
    required this.likes,
    required this.date,
    required this.photoUrl,
    required this.height,
    this.onBlogClicked,
    this.onLikeClicked,
    this.onCommentClicked,
    this.onShareClicked,
    this.isLiked = false,
  }) : super(key: key);

  final String title;
  final int likes;
  final double height;
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
      height: height,
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.06),
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
        borderRadius: BorderRadius.circular(0.0),
        child: Row(
          children: [
            ImagePlaceholder(
              url: photoUrl,
              width: 130,
              height: height,
            ),
            const SizedBox(
              width: 2.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        color: AppColors.subText,
                        fontSize: 12.0,
                        fontFamily: Fonts.montserratRegular,
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
                        fontFamily: Fonts.montserratSemiBold,
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
                                    fontFamily: Fonts.montserratMedium,
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
            )
          ],
        ),
      ),
    );
  }
}
