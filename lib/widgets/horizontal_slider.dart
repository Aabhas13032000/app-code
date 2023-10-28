part of widgets;

class HorizontalSlider extends StatefulWidget {
  final List<Program> slider;
  final double height;
  final double width;
  final double viewPortFraction;
  final EdgeInsets margin;
  final double borderRadius;
  final double aspectRatio;
  final int duration;
  final double bottomIndicatorVerticalPadding;
  const HorizontalSlider({
    Key? key,
    required this.slider,
    required this.height,
    required this.width,
    required this.viewPortFraction,
    required this.margin,
    required this.borderRadius,
    required this.aspectRatio,
    required this.duration,
    required this.bottomIndicatorVerticalPadding,
  }) : super(key: key);

  @override
  State<HorizontalSlider> createState() => _HorizontalSliderState();
}

class _HorizontalSliderState extends State<HorizontalSlider> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              return GestureDetector(
                onTap: () {},
                child: Container(
                  margin: widget.margin,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.richBlack.withOpacity(0.04),
                        blurRadius: 10.0, // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: const Offset(
                          2.0, // Move to right 10  horizontally
                          4.0, // Move to bottom 10 Vertically
                        ),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: ClipRRect(
                                child: ImagePlaceholder(
                                  url: Constants.imgFinalUrl +
                                      widget.slider[index].coverPhoto,
                                  height: widget.height,
                                  width: widget.width,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: widget.height,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.slider[index].title,
                                        textAlign: TextAlign.right,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: Fonts.montserratSemiBold,
                                          color: AppColors.richBlack,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          color: AppColors.congrats,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 10.0),
                                          child: Text(
                                            widget.slider[index].tag ??
                                                "LIVE NOW",
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              fontFamily:
                                                  Fonts.montserratSemiBold,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: widget.height,
                          width: 145.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              colors: [
                                AppColors.white.withOpacity(0.0),
                                AppColors.white.withOpacity(0.3),
                                AppColors.white.withOpacity(1.0),
                                AppColors.white.withOpacity(0.0),
                              ],
                            ),
                          ),
                        )
                      ],
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
                AppColors.black.withOpacity(0.0),
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
                minHeight: 10.0,
                maxHeight: 10.0,
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
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        color: selectedIndex == index
                            ? AppColors.subText
                            : AppColors.defaultInputBorders,
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
    );
  }
}
