part of widgets;

class ProgramCardOne extends StatelessWidget {
  const ProgramCardOne({
    Key? key,
    required this.photoUrl,
    required this.title,
    required this.price,
    required this.isJoined,
    required this.numberOfTrainers,
    required this.firstTrainerUrl,
    required this.secondTrainerUrl, this.onCardClicked,
  }) : super(key: key);

  final String photoUrl;
  final String title;
  final String price;
  final bool isJoined;
  final int numberOfTrainers;
  final String firstTrainerUrl;
  final String secondTrainerUrl;
  final Function()? onCardClicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardClicked,
      child: Container(
        width: 230.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 125.0,
              width: 230.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  topLeft: Radius.circular(12.0),
                ),
                child: ImagePlaceholder(
                  url: photoUrl,
                  height: 125.0,
                  width: 230.0,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              child: Text(
                title,
                maxLines: 2,
                style: const TextStyle(
                  color: AppColors.richBlack,
                  fontSize: 16.0,
                  fontFamily: Fonts.helixSemiBold,
                ),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              child: Text(
                isJoined ? 'Already purchased' : 'Starting from Rs $price',
                style: const TextStyle(
                  color: AppColors.subText,
                  fontSize: 14.0,
                  fontFamily: Fonts.gilroyMedium,
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Row(
              children: [
                // const SizedBox(
                //   width: 10.0,
                // ),
                // Expanded(
                //   child: Stack(
                //     alignment: Alignment.centerLeft,
                //     children: [
                //       const CircularAvatar(
                //         url:
                //             'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8ZmVtYWxlJTIwcG9ydHJhaXR8ZW58MHx8MHx8&w=1000&q=80',
                //         radius: 40.0,
                //         borderColor: AppColors.white,
                //         borderWidth: 2.0,
                //       ),
                //       numberOfTrainers >= 2
                //           ? const Positioned(
                //               top: 0,
                //               left: 25,
                //               child: CircularAvatar(
                //                 url:
                //                     'https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg?w=2000',
                //                 radius: 40.0,
                //                 borderColor: AppColors.white,
                //                 borderWidth: 2.0,
                //               ),
                //             )
                //           : const SizedBox(),
                //       numberOfTrainers >= 3
                //           ? Positioned(
                //               top: 0,
                //               left: 50,
                //               child: Container(
                //                 height: 40.0,
                //                 width: 40.0,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(50.0),
                //                     color: AppColors.defaultInputBorders,
                //                     border: Border.all(
                //                       width: 2.0,
                //                       color: AppColors.white,
                //                     )),
                //                 child: Center(
                //                   child: Text(
                //                     '+${numberOfTrainers - 2}',
                //                     style: const TextStyle(
                //                       fontFamily: Fonts.gilroyMedium,
                //                       fontSize: 13.0,
                //                       color: AppColors.richBlack,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             )
                //           : const SizedBox(),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: CustomButton(
                    title: isJoined ? 'Join now' : 'Book now',
                    paddingVertical: 10.5,
                    paddingHorizontal: 13.5,
                    borderRadius: 8.0,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
