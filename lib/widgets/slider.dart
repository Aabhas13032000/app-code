part of widgets;

class AppSlider extends StatefulWidget {
  final List<String> slider;
  final double height;
  final double width;
  final double viewPortFraction;
  final EdgeInsets margin;
  final double borderRadius;
  final double aspectRatio;
  final int duration;
  final double bottomIndicatorVerticalPadding;
  final Function(String imageUrl)? onImageClicked;
  final bool? isProductImage;
  const AppSlider({
    Key? key,
    required this.slider,
    required this.height,
    required this.viewPortFraction,
    required this.margin,
    required this.borderRadius,
    required this.aspectRatio,
    required this.width,
    required this.duration,
    required this.bottomIndicatorVerticalPadding,
    this.onImageClicked,
    this.isProductImage = false,
  }) : super(key: key);

  @override
  State<AppSlider> createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            width: widget.width,
            child: CarouselSlider.builder(
              itemCount: widget.slider.length,
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: widget.aspectRatio,
                viewportFraction: widget.viewPortFraction,
                autoPlayAnimationDuration:
                    Duration(milliseconds: widget.duration),
                enlargeCenterPage: false,
                enableInfiniteScroll: widget.slider.length == 1 ? false : true,
                onPageChanged: (index, reason) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIdx) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.richBlack.withOpacity(0.1),
                        blurRadius: 6.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: const Offset(
                          0.0, // Move to right 10  horizontally
                          0.0, // Move to bottom 10 Vertically
                        ),
                      ),
                    ],
                  ),
                  margin: widget.margin,
                  height: widget.height,
                  child: InkWell(
                    onTap: () {
                      if (widget.onImageClicked != null) {
                        Utility.printLog('ImageClicked');
                        widget.onImageClicked!(widget.slider[index]);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      child: ImagePlaceholder(
                        url: widget.slider[index],
                        height: widget.height,
                        width: widget.width,
                        openImage: widget.onImageClicked != null ? false : true,
                        isProductImage: widget.isProductImage,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: widget.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.black.withOpacity(0.5),
                  AppColors.black.withOpacity(0.0),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: widget.bottomIndicatorVerticalPadding,
                  horizontal: 0.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 5.0,
                  maxHeight: 5.0,
                ),
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.slider.length,
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                        width: selectedIndex == index ? 50.0 : 20.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: selectedIndex == index
                              ? AppColors.white
                              : AppColors.white.withOpacity(0.5),
                        ),
                        duration: const Duration(milliseconds: 300),
                      );
                    },
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
