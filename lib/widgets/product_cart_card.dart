part of widgets;

class ProductCartCard extends StatelessWidget {
  const ProductCartCard({
    super.key,
    required this.product,
    this.onProductPressed,
    this.onIncreaseQuantity,
    this.onDecreaseQuantity,
    this.onDeleteCartProduct,
    this.showDeleteButton = false,
    this.quantity = 0,
  });

  final Cart product;
  final Function()? onProductPressed;
  final Function()? onIncreaseQuantity;
  final Function()? onDecreaseQuantity;
  final Function()? onDeleteCartProduct;
  final bool? showDeleteButton;
  final int? quantity;

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: onProductPressed,
                    child: SizedBox(
                      height: 115.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: ImagePlaceholder(
                          url: Constants.imgFinalUrl +
                              (product.coverPhoto ?? Images.curectLogo),
                          height: 125.0,
                          width: 200.0,
                          isProductImage: true,
                        ),
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
                      GestureDetector(
                        onTap: onProductPressed,
                        child: Text(
                          product.name ?? "",
                          maxLines: 2,
                          style: const TextStyle(
                            color: AppColors.richBlack,
                            fontSize: 14.0,
                            fontFamily: Fonts.gilroySemiBold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Size: ${product.description}',
                        maxLines: 2,
                        style: const TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 14.0,
                          fontFamily: Fonts.gilroySemiBold,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: onDecreaseQuantity,
                            child: const CustomIcon(
                              icon: Icons.remove,
                              borderWidth: 0.0,
                              borderColor: AppColors.white,
                              isShowDot: false,
                              radius: 30.0,
                              iconSize: 20.0,
                              iconColor: AppColors.white,
                              top: 0,
                              right: 0,
                              borderRadius: 50.0,
                              isShowBorder: false,
                              bgColor: AppColors.congrats,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '$quantity',
                            style: const TextStyle(
                              color: AppColors.richBlack,
                              fontSize: 16.0,
                              fontFamily: Fonts.gilroySemiBold,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: onIncreaseQuantity,
                            child: const CustomIcon(
                              icon: Icons.add,
                              borderWidth: 0.0,
                              borderColor: AppColors.white,
                              isShowDot: false,
                              radius: 30.0,
                              iconSize: 20.0,
                              iconColor: AppColors.white,
                              top: 0,
                              right: 0,
                              borderRadius: 50.0,
                              isShowBorder: false,
                              bgColor: AppColors.congrats,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
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
              children: [
                Text(
                  "Total : Rs ${(product.discountPrice ?? 0) * (quantity ?? 0)}",
                  style: const TextStyle(
                    color: AppColors.richBlack,
                    fontSize: 16.0,
                    fontFamily: Fonts.gilroySemiBold,
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                showDeleteButton ?? false
                    ? GestureDetector(
                        onTap: onDeleteCartProduct,
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
                      )
                    : const SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
