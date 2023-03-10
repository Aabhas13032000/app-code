part of widgets;

class BookCardOne extends StatelessWidget {
  const BookCardOne({
    Key? key,
    required this.title,
    required this.price,
    required this.width,
    required this.photoUrl,
    required this.discountPrice,
    required this.downloads,
    this.onDownloadClicked,
    required this.author,
  }) : super(key: key);

  final String title;
  final String photoUrl;
  final String price;
  final String discountPrice;
  final double width;
  final String downloads;
  final String author;
  final Function()? onDownloadClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 125.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  width: 2.5,
                  color: AppColors.highlight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ImagePlaceholder(
                      url: photoUrl,
                      height: double.infinity,
                      width: 125.0,
                    ),
                    const Positioned(
                      top: -5,
                      right: 15.0,
                      child: Icon(
                        Icons.bookmark,
                        color: AppColors.highlight,
                        size: 30.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(
                    author,
                    maxLines: 2,
                    style: const TextStyle(
                      color: AppColors.subText,
                      fontSize: 14.0,
                      fontFamily: Fonts.gilroyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: AppColors.highlight,
                        size: 15.0,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '$downloads Downloads',
                        style: const TextStyle(
                          color: AppColors.highlight,
                          fontSize: 14.0,
                          fontFamily: Fonts.helixMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Rs. $price',
                        style: const TextStyle(
                          color: AppColors.subText,
                          fontSize: 16.0,
                          fontFamily: Fonts.helixSemiBold,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Rs. $discountPrice',
                        style: const TextStyle(
                          color: AppColors.subText,
                          fontSize: 16.0,
                          fontFamily: Fonts.helixSemiBold,
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  CustomButton(
                    title: 'Download PDF',
                    paddingVertical: 10.5,
                    borderRadius: 8.0,
                    onPressed: onDownloadClicked,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
