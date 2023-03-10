part of widgets;

class TextToHtml extends StatelessWidget {
  final String description;
  final Color textColor;
  final double fontSize;
  final int maxChar;
  final int maxLines;
  final String font;
  final FontStyle? fontStyleNew;
  final TextOverflow? overflow;
  const TextToHtml({
    Key? key,
    required this.description,
    required this.textColor,
    required this.fontSize,
    required this.maxLines,
    required this.font,
    this.overflow = TextOverflow.clip,
    this.fontStyleNew = FontStyle.normal,
    required this.maxChar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return HtmlWidget(
      //to show HTML as widget.
      description.length > maxChar
          ? '${(description.replaceAll(exp, "")).toString().substring(0, maxChar)}... <span style="font-weight:700">Read More</span>'
          : (description.replaceAll(exp, "")).toString(),
      textStyle: TextStyle(
        fontSize: fontSize,
        fontFamily: Fonts.gilroyRegular,
        color: textColor,
        fontStyle: fontStyleNew,
        overflow: TextOverflow.clip,
      ),
      onErrorBuilder: (context, element, error) =>
          Text('$element error: $error'),
      onLoadingBuilder: (context, element, loadingProgress) =>
          const CircularProgressIndicator(),
      onTapUrl: (url) {
        Utility.printLog("Opening $url...");
        launchUrl(Uri.parse(url ?? ""));
        return true;
      },
    );
  }
}
