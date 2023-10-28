part of widgets;

class CustomButton extends StatelessWidget {
  final String title;
  final bool? isShowBorder;
  final double? borderWidth;
  final Color? bgColor;
  final Color? borderColor;
  final Color? textColor;
  final Function()? onPressed;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? borderRadius;
  final IconData? icon;
  final bool? showIcon;
  final bool? showFavIcon;
  final int? favValue;
  const CustomButton({
    Key? key,
    required this.title,
    this.isShowBorder = false,
    this.borderWidth = 2.0,
    this.bgColor = AppColors.highlight,
    this.borderColor = AppColors.highlight,
    this.onPressed,
    this.textColor = AppColors.white,
    this.paddingHorizontal = 15.0,
    this.paddingVertical = 15.0,
    this.borderRadius = 0.0,
    this.icon,
    this.showIcon = false,
    this.showFavIcon = false,
    this.favValue = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(
            borderRadius ?? 10.0,
          ),
          border: (isShowBorder ?? false)
              ? Border.all(
                  width: borderWidth ?? 2.0,
                  color: borderColor ?? AppColors.highlight,
                )
              : null,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: paddingVertical ?? 15.0,
              horizontal: paddingHorizontal ?? 15.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                showIcon ?? false
                    ? Icon(
                        icon,
                        size: 20.0,
                        color: textColor,
                      )
                    : const SizedBox(),
                showIcon ?? false
                    ? const SizedBox(
                        width: 5.0,
                      )
                    : const SizedBox(),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: Fonts.montserratSemiBold,
                    fontSize: 16.0,
                    color: textColor,
                  ),
                ),
                showFavIcon ?? false
                    ? const SizedBox(
                        width: 10.0,
                      )
                    : const SizedBox(),
                showFavIcon ?? false
                    ? (favValue ?? 0) == 1
                        ? SvgIcons.favouriteEachProductFilled
                        : SvgIcons.favouriteEachProduct
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
