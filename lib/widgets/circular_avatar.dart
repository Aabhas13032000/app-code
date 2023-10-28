part of widgets;

class CircularAvatar extends StatelessWidget {
  const CircularAvatar({
    Key? key,
    required this.url,
    required this.borderWidth,
    required this.borderColor,
    required this.radius,
    this.isShowBorder = true,
  }) : super(key: key);

  final String url;
  final double borderWidth;
  final Color borderColor;
  final double radius;
  final bool? isShowBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        border: isShowBorder ?? true
            ? Border.all(
                width: borderWidth,
                color: borderColor,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0.0),
        child: ImagePlaceholder(
          url: url,
          height: radius,
          width: radius,
          openImage: radius >= 90.0 ? true : false,
        ),
      ),
    );
  }
}
