part of widgets;

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.onCancelOrder,
    this.onProductPressed,
  });

  final Orders order;
  final Function()? onCancelOrder;
  final Function()? onProductPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.0),
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
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: onProductPressed,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 115.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: ImagePlaceholder(
                          url: Constants.imgFinalUrl +
                              (order.coverPhoto ?? "/images/local/logo.png"),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.productName ?? "",
                          maxLines: 2,
                          style: const TextStyle(
                            color: AppColors.richBlack,
                            fontSize: 14.0,
                            fontFamily: Fonts.montserratSemiBold,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Size: ${order.details}',
                          maxLines: 2,
                          style: const TextStyle(
                            color: AppColors.richBlack,
                            fontSize: 14.0,
                            fontFamily: Fonts.montserratSemiBold,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Date: ${DateTime.parse(order.datePurchased ?? '').toString().substring(0, 10)}',
                          maxLines: 2,
                          style: const TextStyle(
                            color: AppColors.richBlack,
                            fontSize: 14.0,
                            fontFamily: Fonts.montserratSemiBold,
                          ),
                        ),
                      ],
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "User Details : ",
                  style: TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.montserratSemiBold,
                  ),
                ),
                Text(
                  order.fullName ?? "",
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.montserratMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Address : ",
                  style: TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.montserratSemiBold,
                  ),
                ),
                Expanded(
                  child: Text(
                    order.address ?? "",
                    style: const TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 14.0,
                      fontFamily: Fonts.montserratMedium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quantity : ",
                  style: TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.montserratSemiBold,
                  ),
                ),
                Text(
                  order.quantity.toString(),
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.montserratMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Price : ",
                  style: TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.montserratSemiBold,
                  ),
                ),
                Text(
                  'Rs. ${order.paidPrice ?? ""}',
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.montserratMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Payment method : ",
                  style: TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.montserratSemiBold,
                  ),
                ),
                Text(
                  order.paymentMethod == 'online'
                      ? 'Online'
                      : 'Pay On Delivery',
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 14.0,
                    fontFamily: Fonts.montserratMedium,
                  ),
                ),
              ],
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
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: order.status == 'REJECTED' ||
                      order.status == 'CANCELLED' ||
                      order.status == 'DISPATCHED' ||
                      order.status == 'ON THE WAY' ||
                      order.status == 'DELIVERED'
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.0),
                      color: order.status == 'REJECTED' ||
                              order.status == 'CANCELLED'
                          ? AppColors.lightRed
                          : order.status == 'DELIVERED'
                              ? AppColors.lightGreen
                              : AppColors.background,
                      border: Border.all(
                        width: 1.0,
                        color: order.status == 'REJECTED' ||
                                order.status == 'CANCELLED'
                            ? AppColors.warning
                            : order.status == 'DELIVERED'
                                ? AppColors.congrats
                                : AppColors.background,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10.5,
                      left: 12.0,
                      bottom: 10.5,
                      right: 12.0,
                    ),
                    child: Text(
                      order.status ?? '',
                      style: TextStyle(
                        color: order.status == 'REJECTED' ||
                                order.status == 'CANCELLED'
                            ? AppColors.warning
                            : order.status == 'DELIVERED'
                                ? AppColors.congrats
                                : AppColors.highlight,
                        fontSize: 14.0,
                        fontFamily: Fonts.montserratMedium,
                      ),
                    ),
                  ),
                ),
                const SizedBox(),
                order.status == 'REJECTED' ||
                        order.status == 'CANCELLED' ||
                        order.status == 'DISPATCHED' ||
                        order.status == 'ON THE WAY' ||
                        order.status == 'DELIVERED'
                    ? const SizedBox()
                    : CustomButton(
                        title: 'Cancel Order',
                        paddingVertical: 18,
                        paddingHorizontal: 20,
                        borderRadius: 0.0,
                        onPressed: onCancelOrder,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
