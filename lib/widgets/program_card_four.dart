part of widgets;

class ProgramCardFour extends StatelessWidget {
  const ProgramCardFour({
    Key? key,
    required this.subscription,
    required this.showDaysLeft,
    this.onProgramPressed,
    this.onJoinButtonPressed,
    this.onDeleteButtonPressed,
    this.onDownloadPdfClicked,
  }) : super(key: key);

  final Subscription subscription;
  final bool showDaysLeft;
  final Function()? onProgramPressed;
  final Function()? onJoinButtonPressed;
  final Function()? onDeleteButtonPressed;
  final Function()? onDownloadPdfClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
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
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: onProgramPressed,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 115.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: ImagePlaceholder(
                          url: Constants.imgFinalUrl +
                              (subscription.coverPhoto ??
                                  "/images/local/logo.png"),
                          height: 125.0,
                          width: 200.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      subscription.title ?? "",
                      maxLines: 2,
                      style: const TextStyle(
                        color: AppColors.richBlack,
                        fontSize: 20.0,
                        fontFamily: Fonts.gilroyMedium,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Divider(
              height: 20.0,
              thickness: 1.0,
              color: AppColors.defaultInputBorders.withOpacity(0.7),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Trainer Name : ",
                  style: TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.gilroySemiBold,
                  ),
                ),
                Text(
                  subscription.trainerName ?? "",
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.gilroyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Days : ",
                  style: TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.gilroySemiBold,
                  ),
                ),
                Text(
                  subscription.dayId ?? "",
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.gilroyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sessions : ",
                  style: TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.gilroySemiBold,
                  ),
                ),
                Text(
                  subscription.sessionId ?? "",
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.gilroyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Session Type : ",
                  style: TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.gilroySemiBold,
                  ),
                ),
                Text(
                  subscription.sessionType ?? "",
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.gilroyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Time : ",
                  style: TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.gilroySemiBold,
                  ),
                ),
                Text(
                  subscription.timeId ?? "",
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.gilroyMedium,
                  ),
                ),
              ],
            ),
            showDaysLeft
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Sessions left : ",
                        style: TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 14.0,
                          fontFamily: Fonts.gilroySemiBold,
                        ),
                      ),
                      Text(
                        subscription.daysLeft.toString() ?? "",
                        style: const TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 14.0,
                          fontFamily: Fonts.gilroyMedium,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(
              height: 10.0,
            ),
            Divider(
              height: 20.0,
              thickness: 1.0,
              color: AppColors.defaultInputBorders.withOpacity(0.7),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                showDaysLeft
                    ? const SizedBox()
                    : Text(
                        "Total : Rs ${subscription.price}",
                        style: const TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 16.0,
                          fontFamily: Fonts.gilroySemiBold,
                        ),
                      ),
                const Expanded(
                  child: SizedBox(),
                ),
                showDaysLeft
                    ? ((subscription.pdfPath ?? "").isNotEmpty &&
                            (subscription.pdfPath ?? "") != 'null')
                        ? CustomButton(
                            title: 'PDF',
                            paddingVertical: 8.0,
                            paddingHorizontal: 20,
                            borderRadius: 8.0,
                            isShowBorder: true,
                            onPressed: onDownloadPdfClicked,
                            borderWidth: 1.5,
                            bgColor: AppColors.white,
                            textColor: AppColors.highlight,
                            icon: Icons.file_download_outlined,
                            showIcon: true,
                          )
                        : const SizedBox()
                    : const SizedBox(),
                showDaysLeft
                    ? const SizedBox(
                        width: 10.0,
                      )
                    : const SizedBox(),
                showDaysLeft
                    ? CustomButton(
                        title: 'Join now',
                        paddingVertical: 10.5,
                        paddingHorizontal: 20,
                        borderRadius: 8.0,
                        onPressed: onJoinButtonPressed,
                      )
                    : GestureDetector(
                        onTap: onDeleteButtonPressed,
                        child: const CustomIcon(
                          icon: Icons.delete_outline,
                          borderWidth: 0.0,
                          borderColor: AppColors.white,
                          isShowDot: false,
                          radius: 40.0,
                          iconSize: 24.0,
                          iconColor: AppColors.white,
                          top: 0,
                          right: 0,
                          borderRadius: 50.0,
                          isShowBorder: false,
                          bgColor: AppColors.warning,
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
