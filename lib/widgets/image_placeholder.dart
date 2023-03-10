part of widgets;

class ImagePlaceholder extends StatelessWidget {
  final String url;
  final double? height;
  final double width;
  final bool? openImage;
  final bool? isProductImage;
  const ImagePlaceholder({
    Key? key,
    required this.url,
    required this.height,
    required this.width,
    this.openImage = false,
    this.isProductImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        onTap: openImage ?? false
            ? () {
                Get.to(() => OpenImage(url: url));
              }
            : null,
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (context, url) {
            return placeholder();
          },
          errorWidget: (context, url, error) {
            return placeholder();
          },
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget placeholder() {
    return Container(
      color: AppColors.lightYellow,
      child: Center(
        child: Image.asset(
          isProductImage ?? false ? Images.curectLogo : Images.logo,
          width: 80.0,
        ),
      ),
    );
  }
}
