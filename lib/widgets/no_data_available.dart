part of widgets;

class NoDataAvailable extends StatelessWidget {
  const NoDataAvailable({
    Key? key,
    required this.message,
    this.image = Images.noDataAvailable,
    this.width = 150.0,
  }) : super(key: key);

  final String message;
  final String? image;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          image ?? Images.noDataAvailable,
          width: width,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.richBlack,
            fontSize: 16.0,
            fontFamily: Fonts.gilroySemiBold,
          ),
        ),
      ],
    );
  }
}
