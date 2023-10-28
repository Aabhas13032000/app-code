part of widgets;

class ExpertCard extends StatelessWidget {
  const ExpertCard({
    Key? key,
    required this.photoUrl,
    required this.name,
    required this.width,
  }) : super(key: key);

  final String photoUrl;
  final String name;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(0.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.05),
            blurRadius: 30.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: const Offset(
              0.0, // Move to right 10  horizontally
              0.0, // Move to bottom 10 Vertically
            ),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0.0),
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
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.defaultInputBorders,
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  bottom: 15.0,
                  top: 15.0,
                ),
                child: Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 16.0,
                      fontFamily: Fonts.montserratSemiBold,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
