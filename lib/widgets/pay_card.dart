part of widgets;

class PayCard extends StatelessWidget {
  const PayCard({
    super.key,
    required this.initiatePayment,
    required this.payOnDelivery,
    this.showPayOnDelivery,
    this.total,
    this.totalItems,
    this.shippingCharges = 0,
    this.maximumCharges = 0,
    this.codCharges = 0,
    this.paymentMethod = 'online',
  });

  final Function() initiatePayment;
  final Function() payOnDelivery;
  final bool? showPayOnDelivery;
  final double? total;
  final double? shippingCharges;
  final double? maximumCharges;
  final double? codCharges;
  final int? totalItems;
  final String? paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
          color: AppColors.white,
          border: Border.all(
            width: 1.5,
            color: AppColors.defaultInputBorders,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total : ",
                    style: TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 18.0,
                      fontFamily: Fonts.montserratSemiBold,
                    ),
                  ),
                  Text(
                    'Rs. $total',
                    style: const TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 18.0,
                      fontFamily: Fonts.montserratSemiBold,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Items : ",
                    style: TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 14.0,
                      fontFamily: Fonts.montserratMedium,
                    ),
                  ),
                  Text(
                    totalItems.toString(),
                    style: const TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 14.0,
                      fontFamily: Fonts.montserratMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Shipping cost : ",
                    style: TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 14.0,
                      fontFamily: Fonts.montserratMedium,
                    ),
                  ),
                  Text(
                    'Rs. $shippingCharges',
                    style: const TextStyle(
                      color: AppColors.richBlack,
                      fontSize: 14.0,
                      fontFamily: Fonts.montserratMedium,
                    ),
                  ),
                ],
              ),
              paymentMethod == 'cod'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        'Note : Pay on delivery charges Rs. $codCharges',
                        style: const TextStyle(
                          color: AppColors.warning,
                          fontSize: 14.0,
                          fontFamily: Fonts.montserratRegular,
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                height: ((maximumCharges ?? 0) > (total ?? 0)) ? 5.0 : 0.0,
              ),
              ((maximumCharges ?? 0) > (total ?? 0))
                  ? Text(
                      "Note : Shipping is free above Rs. $maximumCharges",
                      style: const TextStyle(
                        color: AppColors.warning,
                        fontSize: 14.0,
                        fontFamily: Fonts.montserratRegular,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: 'Proceed to pay',
                      paddingVertical: 18,
                      paddingHorizontal: 20,
                      borderRadius: 0.0,
                      onPressed: () {
                        if ((paymentMethod ?? '') == 'online') {
                          initiatePayment();
                        } else {
                          payOnDelivery();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: showPayOnDelivery ?? false ? 15.0 : 0.0,
                  ),
                  showPayOnDelivery ?? false
                      ? Expanded(
                          child: CustomButton(
                            title: 'Pay on delivery',
                            isShowBorder: true,
                            bgColor: AppColors.white,
                            textColor: AppColors.highlight,
                            paddingVertical: 18,
                            paddingHorizontal: 13.5,
                            borderRadius: 0.0,
                            onPressed: () {
                              payOnDelivery();
                            },
                          ),
                        )
                      : const SizedBox(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
