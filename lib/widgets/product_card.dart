part of widgets;

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.photoUrl,
    required this.width,
    required this.price,
    required this.discountPrice,
    this.leftpadding = 20.0,
    required this.inStock,
  });

  final String name;
  final double price;
  final double discountPrice;
  final String photoUrl;
  final double width;
  final double? leftpadding;
  final bool inStock;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(left: leftpadding ?? 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.0),
            blurRadius: 8.0, // soften the shadow
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                  child: ImagePlaceholder(
                    url: photoUrl,
                    height: double.infinity,
                    width: width,
                    isProductImage: true,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        style: const TextStyle(
                          color: AppColors.richBlack,
                          fontSize: 15.0,
                          fontFamily: Fonts.montserratRegular,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      discountPrice == price
                          ? discountPrice == 0 && price == 0
                              ? const Text(
                                  "Free",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: AppColors.richBlack,
                                    fontSize: 17.0,
                                    fontFamily: Fonts.montserratSemiBold,
                                  ),
                                )
                              : Text(
                                  'Rs $price',
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: AppColors.richBlack,
                                    fontSize: 17.0,
                                    fontFamily: Fonts.montserratSemiBold,
                                  ),
                                )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Rs. $discountPrice',
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: AppColors.richBlack,
                                    fontSize: 17.0,
                                    fontFamily: Fonts.montserratSemiBold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Rs. $price',
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: AppColors.richBlack,
                                    fontSize: 17.0,
                                    fontFamily: Fonts.montserratRegular,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  '${(((price - discountPrice) / price) * 100).ceil()}% Off',
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: AppColors.congrats,
                                    fontSize: 17.0,
                                    fontFamily: Fonts.montserratSemiBold,
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              )
            ],
          ),
          inStock
              ? const SizedBox()
              : Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                          color: AppColors.warning,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                            top: 5.0,
                            left: 10.0,
                            bottom: 5.0,
                            right: 10.0,
                          ),
                          child: Text(
                            'Out of stock',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14.0,
                              fontFamily: Fonts.montserratMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
