part of widgets;

class ProgramCardTwo extends StatelessWidget {
  const ProgramCardTwo({
    Key? key,
    required this.photoUrl,
    required this.price,
    required this.title,
    required this.width,
  }) : super(key: key);

  final String photoUrl;
  final String price;
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ImagePlaceholder(
              url: photoUrl,
              height: double.infinity,
              width: width,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.black.withOpacity(0.8),
                      AppColors.black.withOpacity(0.0),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    bottom: 15.0,
                    top: 40.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 18.0,
                                fontFamily: Fonts.montserratSemiBold,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Starting from Rs $price',
                              style: const TextStyle(
                                color: AppColors.defaultInputBorders,
                                fontSize: 16.0,
                                fontFamily: Fonts.montserratMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      const CustomIcon(
                        icon: Icons.arrow_forward_ios_rounded,
                        borderWidth: 0.0,
                        borderColor: AppColors.highlight,
                        isShowDot: false,
                        radius: 45.0,
                        iconSize: 24.0,
                        iconColor: AppColors.white,
                        top: 0,
                        right: 0,
                        borderRadius: 0.0,
                        isShowBorder: false,
                        bgColor: AppColors.highlight,
                      )
                    ],
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
