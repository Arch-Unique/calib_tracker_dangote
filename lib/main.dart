import 'package:calib_tracker_dangote/src/views/dashboard/explorer2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'src/controllers/app_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init("calib_tracker_dangote");
  await AppDependency.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       
        home: ExplorerScreen(),
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 247, 247, 247),
          fontFamily: "Garnett"),
            
            );
  }
}

class AppDependency {
  static init() async {
    await Get.putAsync(() async {
      final appService = AppService();
      await appService.init();
      return appService;
    });
    await Get.putAsync(() async {
      final appcontroller = AppController();
      await appcontroller.initApp();
      return appcontroller;
    });
  }
}

class AppService extends GetxService {
  final pref = GetStorage();

  static const String mpHasSetup = "mpHasSetup";
  static const String mpLaneNo = "mpLaneNo";
  static const String mpDepotName = "mpDepotName";
  static const String mpInternalFreq = "mpInternalFreq";
  static const String mpExternalFreq = "mpExternalFreq";
  static const String mpDBPath = "mpDBPath";
  static const String mpAdminPass = "mpiulfhif";
  static const String mpInternalAlarm = "mpInternalAlarm";
  static const String mpExternalAlarm = "mpExternalAlarm";

  String winPth = "";

  saveSetup() async {
    await pref.write(mpHasSetup, true);
  }

  saveAppDetails(String b, int a) async {
    await pref.write(mpLaneNo, a);
    await pref.write(mpDepotName, b);
  }

  saveAlarms(int a, int b) async {
    await pref.write(mpInternalAlarm, a);
    await pref.write(mpExternalAlarm, b);
  }


  saveInternalFreq(int a) async {
    await pref.write(mpInternalFreq, a);
  }

  saveExternalFreq(int a) async {
    await pref.write(mpExternalFreq, a);
  }

  saveDBPath(String db) async {
    await pref.write(mpDBPath, db);
  }

  saveAdminPassword(String db) async {
    await pref.write(mpAdminPass, db);
  }

  init() async {

  }
}
