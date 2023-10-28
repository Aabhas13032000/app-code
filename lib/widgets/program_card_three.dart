part of widgets;

class ProgramCardThree extends StatelessWidget {
  const ProgramCardThree({
    Key? key,
    required this.photoUrl,
    required this.title,
    required this.price,
    this.isGridView = true,
  }) : super(key: key);

  final String photoUrl;
  final String title;
  final String price;
  final bool? isGridView;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.1),
            blurRadius: 15.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: const Offset(
              0.0, // Move to right 10  horizontally
              0.0, // Move to bottom 10 Vertically
            ),
          ),
        ],
      ),
      child: Stack(
        children: [
          SizedBox(
            height: 230.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 115.0,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(0.0),
                      topLeft: Radius.circular(0.0),
                    ),
                    child: ImagePlaceholder(
                      url: photoUrl,
                      height: 125.0,
                      width: 200.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0 + (45 / 2),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Text(
                    title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 16.0,
                      fontFamily: Fonts.montserratSemiBold,
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(0.0),
                        border:
                            Border.all(color: AppColors.highlight, width: 1.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 3.0),
                      child: Center(
                        child: Text(
                          'Starting from Rs ${price.split('.')[0]}',
                          style: const TextStyle(
                            color: AppColors.highlight,
                            fontSize: 12.0,
                            fontFamily: Fonts.montserratSemiBold,
                          ),
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
          Positioned(
            top: 115 - (45 / 2),
            left: isGridView ?? false
                ? ((MediaQuery.of(context).size.width - 60.0) / 4) - (45 / 2)
                : ((200) / 2) - (45 / 2),
            child: const CustomIcon(
              icon: Icons.arrow_forward_ios_rounded,
              borderWidth: 2.0,
              borderColor: AppColors.white,
              isShowDot: false,
              radius: 45.0,
              iconSize: 20.0,
              iconColor: AppColors.white,
              top: 0,
              right: 0,
              borderRadius: 0.0,
              isShowBorder: true,
              bgColor: AppColors.highlight,
            ),
          )
        ],
      ),
    );
  }
}
