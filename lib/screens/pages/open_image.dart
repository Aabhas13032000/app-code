import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/config.dart';

class OpenImage extends StatefulWidget {
  final String url;
  const OpenImage({Key? key, required this.url}) : super(key: key);

  @override
  _OpenImageState createState() => _OpenImageState();
}

class _OpenImageState extends State<OpenImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18.0,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontFamily: 'EuclidCircularA Medium',
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
        shadowColor: const Color(0xffFFF0D0).withOpacity(0.2),
        centerTitle: true,
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: widget.url,
          placeholder: (context, url) => placeholder(),
          errorWidget: (context, url, error) => placeholder(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget placeholder() {
    return Container(
      color: AppColors.lightYellow,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 80.0,
        ),
      ),
    );
  }
}
