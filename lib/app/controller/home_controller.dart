import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxInt currentIndex = 0.obs;
  void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    } else {
      Get.snackbar("Error", "Drawer not available");
    }
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
