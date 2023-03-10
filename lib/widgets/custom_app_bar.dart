part of widgets;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.preferredSize,
    required this.bottom,
    required this.showLeadingIcon,
    required this.leadingWidget,
    required this.actions,
    required this.title,
    this.centerTitle = false,
    this.leadingWidth = 50.0,
    this.opacity = 0.2,
    this.bgColor = AppColors.white,
  }) : super(key: key);

  @override
  final Size preferredSize;
  final PreferredSizeWidget bottom;
  final bool showLeadingIcon;
  final bool? centerTitle;
  final Widget leadingWidget;
  final Widget title;
  final List<Widget> actions;
  final double? leadingWidth;
  final double? opacity;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      title: title,
      titleSpacing: 20.0,
      leading: showLeadingIcon ? leadingWidget : null,
      centerTitle: centerTitle,
      backgroundColor: bgColor,
      elevation: 15.0,
      shadowColor: AppColors.black.withOpacity(opacity ?? 0.2),
      automaticallyImplyLeading: showLeadingIcon,
      bottom: bottom,
      actions: actions,
      leadingWidth: showLeadingIcon ? leadingWidth : null,
    );
  }
}
