part of widgets;

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    this.address,
    this.onButtonPressed,
    required this.showChangeAddress,
  });

  final Address? address;
  final Function()? onButtonPressed;
  final bool showChangeAddress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Shipping Address",
                style: TextStyle(
                  color: AppColors.richBlack,
                  fontSize: 20.0,
                  fontFamily: Fonts.helixSemiBold,
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
              showChangeAddress
                  ? address?.defaultAddress ?? false
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 0.0),
                              decoration: BoxDecoration(
                                color: AppColors.cardBg,
                                borderRadius: BorderRadius.circular(50.0),
                                border: Border.all(
                                  width: 1.0,
                                  color: AppColors.defaultInputBorders,
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  'Default Address',
                                  style: TextStyle(
                                    color: AppColors.subText,
                                    fontSize: 14.0,
                                    fontFamily: Fonts.gilroyRegular,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox()
                  : const SizedBox(),
              SizedBox(
                height: showChangeAddress ? 10.0 : 0.0,
              ),
              showChangeAddress
                  ? Text(
                      '${address?.fullName}, ${address?.phoneNumber}',
                      style: const TextStyle(
                        color: AppColors.richBlack,
                        fontSize: 16.0,
                        fontFamily: Fonts.gilroyRegular,
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                height: showChangeAddress ? 5.0 : 0.0,
              ),
              showChangeAddress
                  ? Text(
                      '${address?.flatNo} ${address?.area}, ${(address?.landmark ?? '').isEmpty ? '' : '${address?.landmark},'} ${address?.city}, ${address?.state}(${address?.pincode})',
                      style: const TextStyle(
                        color: AppColors.richBlack,
                        fontSize: 16.0,
                        fontFamily: Fonts.gilroyRegular,
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                height: showChangeAddress ? 20.0 : 0.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title:
                          showChangeAddress ? 'Change address' : 'Add address',
                      paddingVertical: 10.5,
                      paddingHorizontal: 20,
                      borderRadius: 8.0,
                      onPressed: onButtonPressed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
