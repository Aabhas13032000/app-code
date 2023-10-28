part of widgets;

class HeadingViewAll extends StatelessWidget {
  const HeadingViewAll({
    Key? key,
    required this.title,
    this.onViewAllPressed,
    this.isShowViewAll = true,
    this.isShowClearAll = false,
    this.isShowSizeChart = false,
  }) : super(key: key);

  final String title;
  final Function()? onViewAllPressed;
  final bool? isShowViewAll;
  final bool? isShowClearAll;
  final bool? isShowSizeChart;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.richBlack,
            fontSize: 18.0,
            fontFamily: Fonts.montserratSemiBold,
          ),
        ),
        isShowViewAll ?? true
            ? GestureDetector(
                onTap: onViewAllPressed,
                child: isShowSizeChart ?? false
                    ? const Text(
                        'Size Chart',
                        style: TextStyle(
                          color: AppColors.subText,
                          fontSize: 16.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                      )
                    : isShowClearAll ?? false
                        ? const Text(
                            'Clear All',
                            style: TextStyle(
                              color: AppColors.subText,
                              fontSize: 16.0,
                              fontFamily: Fonts.montserratMedium,
                            ),
                          )
                        : Row(
                            children: [
                              const Text(
                                'View All',
                                style: TextStyle(
                                  color: AppColors.subText,
                                  fontSize: 16.0,
                                  fontFamily: Fonts.montserratMedium,
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Icon(
                                MdiIcons.arrowRight,
                                size: 20.0,
                                color: AppColors.subText,
                              )
                            ],
                          ),
              )
            : const SizedBox(),
      ],
    );
  }
}
