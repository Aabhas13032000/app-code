part of widgets;

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    Key? key,
    required this.icon,
    required this.borderWidth,
    required this.borderColor,
    required this.isShowDot,
    required this.radius,
    required this.iconSize,
    required this.iconColor,
    required this.top,
    required this.right,
    this.borderRadius = 10.0,
    this.fontSize = 20.0,
    this.isShowBorder = true,
    this.isNameInitial = false,
    this.bgColor = AppColors.white,
    this.name = '',
  }) : super(key: key);

  final IconData icon;
  final double borderWidth;
  final double iconSize;
  final double top;
  final double right;
  final Color borderColor;
  final Color iconColor;
  final bool isShowDot;
  final double radius;
  final double? fontSize;
  final double? borderRadius;
  final bool? isShowBorder;
  final bool? isNameInitial;
  final Color? bgColor;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 0.0),
        border: isShowBorder ?? true
            ? Border.all(
                width: borderWidth,
                color: borderColor,
              )
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          isNameInitial ?? false
              ? Text(
                  (name ?? '').toUpperCase(),
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: fontSize,
                    fontFamily: Fonts.montserratRegular,
                  ),
                )
              : Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                ),
          isShowDot
              ? Positioned(
                  top: top,
                  right: right,
                  child: Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        color: AppColors.congrats,
                        border: Border.all(
                          width: 1.0,
                          color: AppColors.white,
                        )),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
