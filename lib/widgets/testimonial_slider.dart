part of widgets;

class TestimonialSlider extends StatelessWidget {
  const TestimonialSlider({
    Key? key,
    required this.slider,
    required this.height,
    required this.width,
    required this.viewPortFraction,
    required this.margin,
    required this.borderRadius,
    required this.aspectRatio,
    required this.duration,
    this.onTestimonialPressed,
  }) : super(key: key);

  final List<Testimonial> slider;
  final double height;
  final double width;
  final double viewPortFraction;
  final EdgeInsets margin;
  final double borderRadius;
  final double aspectRatio;
  final int duration;
  final Function(Testimonial testimonial)? onTestimonialPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: CarouselSlider.builder(
        itemCount: slider.length,
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: aspectRatio,
          viewportFraction: viewPortFraction,
          autoPlayAnimationDuration: Duration(milliseconds: duration),
          enlargeCenterPage: false,
          enableInfiniteScroll: slider.length == 1 ? false : true,
        ),
        itemBuilder: (context, index, realIdx) {
          var desc = '<div>${slider[index].message}</div>';
          return GestureDetector(
            onTap: () {
              if (desc.length > 250) {
                if (onTestimonialPressed != null) {
                  onTestimonialPressed!(slider[index]);
                }
              }
            },
            child: Container(
              margin: margin,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: AppColors.white,
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
                borderRadius: BorderRadius.circular(borderRadius),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularAvatar(
                            url: Constants.imgFinalUrl +
                                slider[index].profileImage,
                            borderWidth: 0.0,
                            borderColor: AppColors.richBlack,
                            radius: 60.0,
                            isShowBorder: false,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  slider[index].name,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: AppColors.richBlack,
                                    fontSize: 18.0,
                                    fontFamily: Fonts.helixSemiBold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  slider[index].tagLine,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: AppColors.subText,
                                    fontSize: 16.0,
                                    fontFamily: Fonts.gilroyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      slider[index].message.contains('<p>')
                          ? TextToHtml(
                              description:
                                  '<div>${slider[index].message}</div>',
                              textColor: AppColors.subText,
                              fontSize: 14.0,
                              maxLines: 2,
                              font: Fonts.gilroyRegular,
                              fontStyleNew: FontStyle.italic,
                              maxChar: slider[index].message.length > 250
                                  ? 250
                                  : slider[index].message.length - 20,
                            )
                          : Text(
                              slider[index].message,
                              maxLines: 6,
                              style: const TextStyle(
                                color: AppColors.richBlack,
                                fontSize: 14.0,
                                fontFamily: Fonts.gilroyRegular,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              // slider[index]['stars'] >= 1
                              //     ? const Icon(
                              //         Icons.star,
                              //         color: AppColors.highlight,
                              //         size: 20.0,
                              //       )
                              //     : const SizedBox(),
                              // slider[index]['stars'] >= 2
                              //     ? const Icon(
                              //         Icons.star,
                              //         color: AppColors.highlight,
                              //         size: 20.0,
                              //       )
                              //     : const SizedBox(),
                              // slider[index]['stars'] >= 3
                              //     ? const Icon(
                              //         Icons.star,
                              //         color: AppColors.highlight,
                              //         size: 20.0,
                              //       )
                              //     : const SizedBox(),
                              // slider[index]['stars'] >= 4 &&
                              //         slider[index]['stars'] < 5
                              //     ? const Icon(
                              //         Icons.star,
                              //         color: AppColors.highlight,
                              //         size: 20.0,
                              //       )
                              //     : const SizedBox(),
                              // slider[index]['stars'] >= 4
                              //     ? const Icon(
                              //         Icons.star,
                              //         color: AppColors.highlight,
                              //         size: 20.0,
                              //       )
                              //     : const SizedBox(),
                              Icon(
                                Icons.star,
                                color: AppColors.highlight,
                                size: 20.0,
                              ),
                              Icon(
                                Icons.star,
                                color: AppColors.highlight,
                                size: 20.0,
                              ),
                              Icon(
                                Icons.star,
                                color: AppColors.highlight,
                                size: 20.0,
                              ),
                              Icon(
                                Icons.star,
                                color: AppColors.highlight,
                                size: 20.0,
                              ),
                              Icon(
                                Icons.star,
                                color: AppColors.highlight,
                                size: 20.0,
                              ),
                            ],
                          ),
                          // const Text(
                          //   'Read more',
                          //   style: TextStyle(
                          //     color: AppColors.highlight,
                          //     fontSize: 16.0,
                          //     fontFamily: Fonts.helixSemiBold,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
