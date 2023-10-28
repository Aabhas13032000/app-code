part of widgets;

class TextToHtmlTwo extends StatelessWidget {
  final String description;
  final Color textColor;
  final double fontSize;
  final String font;
  const TextToHtmlTwo({
    Key? key,
    required this.description,
    required this.textColor,
    required this.fontSize,
    required this.font,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      //to show HTML as widget.
      description.toString(),
      textStyle: TextStyle(
        fontSize: fontSize,
        fontFamily: Fonts.montserratRegular,
        color: textColor,
        fontStyle: FontStyle.normal,
      ),
      customWidgetBuilder: (element) {
        if (element.attributes['src'] != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(0.0),
            child: ImagePlaceholder(
              url: (element.attributes['src'] ?? '').contains('/images/uploads')
                  ? Constants.imgFinalUrl +
                      (element.attributes['src'] ?? '/images/local/logo.png')
                  : (element.attributes['src'] ?? '/images/local/logo.png'),
              height: 200.0,
              width: double.infinity,
              openImage: true,
            ),
          );
        }

        return null;
      },
      onErrorBuilder: (context, element, error) =>
          Text('$element error: $error'),
      onLoadingBuilder: (context, element, loadingProgress) =>
          const CircularProgressIndicator(),
      onTapUrl: (url) {
        Utility.printLog("Opening $url...");
        launchUrl(Uri.parse(url));
        return true;
      },
    );
  }
}
