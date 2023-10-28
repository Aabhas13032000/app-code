part of widgets;

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    this.onClosed,
    required this.iconColor,
    required this.bgColor,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String message;
  final String time;
  final Function()? onClosed;
  final Color iconColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height,
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.06),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIcon(
                  icon: icon,
                  borderWidth: 0.0,
                  borderColor: AppColors.background,
                  isShowDot: false,
                  radius: 45.0,
                  iconSize: 25.0,
                  iconColor: iconColor,
                  top: 0,
                  right: 0,
                  borderRadius: 0.0,
                  isShowBorder: false,
                  bgColor: bgColor,
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 16.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        message,
                        style: const TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 14.0,
                          fontFamily: Fonts.montserratRegular,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppColors.subText,
                          fontSize: 12.0,
                          fontFamily: Fonts.montserratMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
              ],
            ),
          ),
          Positioned(
            top: -5.0,
            right: -5.0,
            child: IconButton(
              icon: const Icon(
                Icons.clear,
                size: 25.0,
                color: AppColors.subText,
              ),
              onPressed: onClosed,
            ),
          )
        ],
      ),
    );
  }
}
