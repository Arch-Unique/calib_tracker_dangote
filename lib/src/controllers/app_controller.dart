import 'dart:async';

import 'package:calib_tracker_dangote/main.dart';
import 'package:calib_tracker_dangote/src/models/externalChecks.dart';
import 'package:calib_tracker_dangote/src/models/internalChecks.dart';
import 'package:calib_tracker_dangote/src/models/lane.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repo/apiService.dart';

class AppController extends GetxController {
  RxInt laneNumber = 0.obs;
  RxInt internalAlarm = 0.obs;
  RxInt externalAlarm = 30.obs;
  RxInt internalFreq = 30.obs;
  RxInt externalFreq = 180.obs;
  RxBool isLoading = true.obs;
  RxBool isAdmin = false.obs;

  final statusText = ["", "PR Issued", "PO Issued", "Certificate Issued"];
  final appService = Get.find<AppService>();
  Timer? timer;

  RxList<Product> allProducts = <Product>[].obs;
  RxList<Lane> allLanes = <Lane>[].obs;
  RxList<Gantry> allGantries = <Gantry>[].obs;
  RxList<Calibration> latestCalibs = <Calibration>[].obs;
  RxList<LaneEntry> allLaneEntries = <LaneEntry>[].obs;
  RxList<List<LaneEntry>> allLaneLEntries = <List<LaneEntry>>[].obs;

  final apiClient = ApiClient(baseUrl: "http://localhost:3000/api");

  initApp() async {
    allProducts.value = await apiClient.getProducts();
    allLanes.value = await apiClient.getLanes();
    allGantries.value = await apiClient.getGantries();
    latestCalibs.value = await apiClient.getLatestCalibrations();
    allLaneEntries.value = latestCalibs.map((f) => f.toLaneEntry()).toList();
    for (var element in allProducts) {
      allLaneLEntries.add(allLaneEntries.where((test) => test.product == element.name).toList());
    }
  }

}

enum AppActions {
  uploadedPO("Uploaded PO"),
  uploadedExternalCalib("Uploaded External Calib"),
  uploadedInternalCalib("Uploaded Internal Check"),
  uploadedCertificate("Uploaded Certificate"),
  setPR("Set Purchase Request"),
  setInternalCheckDate("Set InternalCheck Date"),
  setExternalCheckDate("Set ExternalCheck Date"),
  toggleLane("Toggled Lane"),
  changedPassword("Changed Password"),
  changedAlarms("Changed Internal/External Alarm"),
  adminLogin("Admin logged In"),
  adminLogout("Admin logged Out"),
  addedRemark("Added Remark");

  final String title;
  const AppActions(this.title);
}

class AppColors {
  static const Color internalCheck = Colors.black;
  static const Color externalCheck = Color.fromARGB(255, 31, 31, 31);
  static const Color general = Color.fromARGB(255, 56, 56, 56);
  static const Color primary = Color(0xFF1F1D5E);
}

class LanePending {
  String loc;
  int pending, overdue;
  LanePending(this.loc, this.pending, this.overdue);
}
