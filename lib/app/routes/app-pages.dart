import 'package:get/get.dart';
import 'package:snapchat_flutter/app/modules/home/views/home_view.dart';
import 'package:snapchat_flutter/app/modules/lenses/views/lens_list_view.dart';
import 'package:snapchat_flutter/app/modules/media/views/media_result_view.dart';


class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.LENSES,
      page: () => const LensListView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.MEDIA_RESULT,
      page: () => const MediaResultView(),
      transition: Transition.zoom,
    ),
  ];
}

abstract class Routes {
  static const HOME = '/home';
  static const LENSES = '/lenses';
  static const MEDIA_RESULT = '/media-result';
}
