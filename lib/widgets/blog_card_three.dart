part of widgets;

class BlogCardThree extends StatelessWidget {
  const BlogCardThree({
    super.key,
    required this.description,
    required this.title,
    required this.likes,
    required this.date,
    required this.photoUrl,
    required this.height,
    required this.width,
    this.onBlogClicked,
    this.onLikeClicked,
    this.onCommentClicked,
    this.onShareClicked,
    this.isLiked = false,
  });

  final String description;
  final String title;
  final int likes;
  final double width;
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
      width: width,
      height: height,
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.05),
            blurRadius: 10.0, // soften the shadow
            spreadRadius: 10.0, //extend the shadow
            offset: const Offset(
              0.0, // Move to right 10  horizontally
              10.0, // Move to bottom 10 Vertically
            ),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(
          //   height: 10.0,
          // ),
          // description.contains('<p>')
          //     ? GestureDetector(
          //         onTap: onBlogClicked,
          //         child: Padding(
          //           padding: const EdgeInsets.only(
          //             left: 24.0,
          //             right: 24.0,
          //             top: 0.0,
          //             bottom: 0.0,
          //           ),
          //           child: TextToHtml(
          //             description: '<div>$description</div>',
          //             textColor: AppColors.richBlack,
          //             fontSize: 15.0,
          //             maxLines: 2,
          //             font: Fonts.montserratRegular,
          //             maxChar: 100,
          //           ),
          //         ),
          //       )
          //     :
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: ImagePlaceholder(
                url: photoUrl,
                height: 300.0,
                width: width,
                openImage: true,
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: GestureDetector(
              onTap: onBlogClicked,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 0.0,
                  bottom: 0.0,
                ),
                child: Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 16.0,
                    fontFamily: Fonts.montserratMedium,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 0.0,
              bottom: 0.0,
            ),
            child: CustomButton(
              title: 'Read More',
              textColor: AppColors.white,
              paddingVertical: 18,
              onPressed: onBlogClicked,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     left: 24.0,
          //     right: 24.0,
          //     top: 0.0,
          //     bottom: 0.0,
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Row(
          //         children: [
          //           Expanded(
          //             child: GestureDetector(
          //               onTap: onLikeClicked,
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   Icon(
          //                     isLiked ?? false
          //                         ? Icons.thumb_up
          //                         : Icons.thumb_up_off_alt_outlined,
          //                     color: isLiked ?? false
          //                         ? AppColors.highlight
          //                         : AppColors.subText,
          //                     size: 18.0,
          //                   ),
          //                   const SizedBox(
          //                     width: 5.0,
          //                   ),
          //                   Text(
          //                     '$likes',
          //                     style: TextStyle(
          //                       color: isLiked ?? false
          //                           ? AppColors.highlight
          //                           : AppColors.subText,
          //                       fontSize: 16.0,
          //                       fontFamily: Fonts.montserratMedium,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           const SizedBox(
          //             width: 5.0,
          //           ),
          //           GestureDetector(
          //             onTap: onCommentClicked,
          //             child: const Icon(
          //               Icons.mode_comment_outlined,
          //               color: AppColors.subText,
          //               size: 18.0,
          //             ),
          //           ),
          //           const SizedBox(
          //             width: 10.0,
          //           ),
          //           GestureDetector(
          //             onTap: onShareClicked,
          //             child: const Icon(
          //               Icons.share_rounded,
          //               color: AppColors.subText,
          //               size: 18.0,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 20.0,
          ),
          // Divider(
          //   height: 0.0,
          //   thickness: 1.0,
          //   color: AppColors.defaultInputBorders.withOpacity(0.9),
          // ),
        ],
      ),
    );
  }
}
