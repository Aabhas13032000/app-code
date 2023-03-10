library screens;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:heal_fit/provider/provider.dart';
import 'package:heal_fit/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:launch_review/launch_review.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx/webviewx.dart';

import '../api/api_functions.dart';
import '../common/common.dart';
import '../config/config.dart';
import '../models/models.dart';
import '../utils/utility.dart';
import 'pages/open_image.dart';

part '../screens/home/main_container.dart';
part '../screens/pages/blog.dart';
part '../screens/pages/books.dart';
part '../screens/pages/calorie_counter_page.dart';
part '../screens/pages/calorie_workout_page.dart';
part '../screens/pages/cart_page.dart';
part '../screens/pages/each_blog.dart';
part '../screens/pages/each_expert.dart';
part '../screens/pages/each_program.dart';
part '../screens/pages/edit_profile.dart';
part '../screens/pages/experts.dart';
part '../screens/pages/home.dart';
part '../screens/pages/my_programs.dart';
part '../screens/pages/notification.dart';
part '../screens/pages/profile.dart';
part '../screens/pages/programs.dart';
part '../screens/pages/purchased_books.dart';
part '../screens/pages/utils.dart';
part '../screens/pages/view_all_blogs.dart';
part '../screens/pages/webview_screen.dart';
part '../screens/startup/login_screen.dart';
part '../screens/startup/otp_screen.dart';
part '../screens/startup/splash_screen.dart';
part '../screens/startup/user_detail_screen.dart';
part '../screens/startup/user_height_weight_screen.dart';
//Product
part '../screens/product/product.dart';
part '../screens/product/category_wise_products.dart';
part '../screens/product/each_product.dart';
part '../screens/product/checkout_product.dart';
part '../screens/product/add_edit_address.dart';
part '../screens/product/my_orders.dart';