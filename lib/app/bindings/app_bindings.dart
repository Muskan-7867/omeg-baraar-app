import 'package:get/get.dart';
import 'package:omeg_bazaar/app/controller/home_controller.dart';


class AppBindings implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AppBindingsController>(() => AppBindingsController(
    //    AppBindingsRepository(MyApi())));
    Get.lazyPut<HomeViewController>(() => HomeViewController());
  }
}


 final HomeViewController homeViewController = Get.find<HomeViewController>();