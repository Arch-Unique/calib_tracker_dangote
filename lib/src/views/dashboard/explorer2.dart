import 'package:calib_tracker_dangote/src/controllers/app_controller.dart';
import 'package:calib_tracker_dangote/src/models/lane.dart';
import 'package:calib_tracker_dangote/src/views/shared/containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:win32/win32.dart';

class ExplorerScreen extends StatelessWidget {
  ExplorerScreen({super.key});
  final Map<String, Color> fuelColors = {
    'PMS': Color(0xFFc0392b),
    'AGO': Color(0xFF27ae60),
    'JETA1': Color(0xFF2980b9),
    'DPK': Color(0xFF8e44ad),
    'SLURRY': Color(0xFF34495e),
    'LPG': Color(0xFFe67e22),
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    return Scaffold(
      body: Column(
        children: [
          ExplorerHeader(),
          Container(
            height: 1,
            width: Ui.width(context),
            color: const Color.fromARGB(255, 236, 236, 236),
          ),
          Expanded(
              child: LaneTableWidget(
            controller.allProducts.map((f) => f.name).toList(),
            color: fuelColors.values.toList(),
            lanes: controller.allLaneLEntries,
            // [
            //   generateArms(0),
            //   generateArms(1),
            //   generateArms(2),
            //   generateArms(3),
            //   generateArms(4),
            //   generateArms(5),
            // ],
          ))
        ],
      ),
    );
  }

  // List<LaneEntry> generateArms(int a) {
  //   switch (a) {
  //     case 0:
  //       return _generate4Gantries();
  //     case 1:
  //       return _generateAGOGantries();
  //     case 2:
  //       return _generateLaneEntries("G7", 10);
  //     case 3:
  //       return _generateLaneEntries("G8", 11);
  //     case 4:
  //       return _generateLaneEntries("G9", 3);
  //     default:
  //       return _generateLaneEntries("G11", 5);
  //   }
  // }

  // List<LaneEntry> _generate4Gantries() {
  //   final List<LaneEntry> entries = [];

  //   // G1 patterns: 1-10 with .1 and .2 (each added twice)
  //   for (int i = 1; i <= 10; i++) {
  //     entries.add(LaneEntry("G1.$i.1"));
  //     entries.add(LaneEntry("G1.$i.1", isEthanol: true));
  //     entries.add(LaneEntry("G1.$i.2"));
  //     entries.add(LaneEntry("G1.$i.2", isEthanol: true));
  //   }

  //   // G2-G4 patterns: each with 1-10 and .1
  //   for (int gantry = 2; gantry <= 4; gantry++) {
  //     for (int i = 1; i <= 10; i++) {
  //       entries.add(LaneEntry("G$gantry.$i"));
  //       entries.add(LaneEntry("G$gantry.$i", isEthanol: true));
  //     }
  //   }

  //   return entries;
  // }

  // List<LaneEntry> _generateAGOGantries() {
  //   final List<LaneEntry> entries = [];
  //   for (int i = 1; i <= 10; i++) {
  //     entries.add(LaneEntry("G5.$i"));
  //   }
  //   for (int i = 1; i <= 7; i++) {
  //     entries.add(LaneEntry("G6.$i"));
  //   }

  //   return entries;
  // }

  // List<LaneEntry> _generateLaneEntries(String gantry, int count) {
  //   return List.generate(count, (i) => LaneEntry("$gantry.${i + 1}"));
  // }

}

class LaneTableWidget extends StatelessWidget {
  LaneTableWidget(this.product,
      {this.color = const [],
      this.lanes = const [],
      this.isContinuation = false,
      super.key});
  final List<String> product;
  final List<Color> color;
  final bool isContinuation;
  final List<List<LaneEntry>> lanes;
  final RxBool useEthanol = true.obs;

  static const List<String> headerTitles = [
    "Arm",
    "Last Calibration",
    "Due Date",
    "KFactor",
  ];
  static const double laneWidth = 390;
  final controller = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return laneItem(context, product, lanes, color);
  }

  laneItem(BuildContext context, List<String> pd, List<List<LaneEntry>> lanes,
      List<Color> colors) {
    final allw = List.generate(pd.length, (i) {
      return [
        SizedBox(
          width: laneWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              subHeader(title: pd[i], color: colors[i]),
              header(color: colors[i]),
              Ui.boxHeight(2),
            ],
          ),
        ),
        if (i == 0) ...[
          ...List.generate(50, (j) {
            return SizedBox(
              width: laneWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  mcRow(lanes[i][2 * j].obs, lanes[i][(2 * j) + 1].obs, j),
                  // if (j != lanes[i].length - 1)
                  Container(
                    height: 1,
                    width: double.maxFinite,
                    color: Colors.grey.shade200,
                  )
                ],
              ),
            );
          }),
        ],
        if (i != 0)
          ...List.generate(lanes[i].length, (j) {
            return SizedBox(
              width: laneWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  cRow(lanes[i][j].obs, j),
                  // if (j != lanes[i].length - 1)
                  Container(
                    height: 1,
                    width: double.maxFinite,
                    color: Colors.grey.shade200,
                  )
                ],
              ),
            );
          }),
        Ui.boxHeight(24),
        Obx(() {
          if (useEthanol.value && i == 1) {
            return Ui.boxHeight(64);
          }
          return SizedBox();
        })
      ];
    });
    final allww = allw.expand(
      (element) {
        return element;
      },
    ).toList();
    print(allww.length);

    return SizedBox(
      width: Ui.width(context),
      height: Ui.height(context) - 12,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Wrap(
            direction: Axis.vertical,
            runAlignment: WrapAlignment.spaceEvenly,
            children: allww),
      ),
    );
  }

  header({Color color = AppColors.primary}) {
    return Row(
        children: List.generate(headerTitles.length, (i) {
      double w = laneWidth / headerTitles.length;

      return CurvedContainer(
        radius: 0,
        color: color,
        width: w,
        height: 24,
        padding: const EdgeInsets.all(2),
        child: Center(
            child: AppText.thin(headerTitles[i].capitalize!,
                att: true,
                alignment: TextAlign.center,
                color: Colors.white,
                fontSize: 10)),
      );
    }));
  }

  subHeader({Color color = AppColors.primary, String title = "PMS"}) {
    return CurvedContainer(
      radius: 0,
      color: color,
      width: laneWidth,
      brad: BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      height: 24,
      padding: const EdgeInsets.all(2),
      child: title == "PMS"
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.bold(title,
                    att: true,
                    alignment: TextAlign.center,
                    color: Colors.white,
                    fontSize: 10),

                // Ui.boxWidth(4),
                // Checkbox(value: true, onChanged: (v){}),
                Ui.boxWidth(32),
                AppText.bold("ETHANOL",
                    att: true,
                    alignment: TextAlign.center,
                    color: Colors.white,
                    fontSize: 10),

                Ui.boxWidth(4),
                Obx(() {
                  return Checkbox(
                      value: useEthanol.value,
                      onChanged: (v) {
                        useEthanol.value = v ?? false;
                      });
                }),
              ],
            )
          : Center(
              child: AppText.bold(title,
                  att: true,
                  alignment: TextAlign.center,
                  color: Colors.white,
                  fontSize: 10)),
    );
  }

  cRow(Rx<LaneEntry> laneEntry, int j) {
    double w = laneWidth / headerTitles.length;
    return Obx(() {
      return Opacity(
          opacity: laneEntry.value.active ? 1 : 0.2,
          child: ShadowContainer(
            radius: 0,
            padding: 0,
            margin: 0,
            height: 24,
            onPressed: () {
              Get.dialog(AppDialog.empty(SideTableWidget(laneEntry)));
            },
            color: Colors.white,
            child: Row(
                children: List.generate(headerTitles.length, (i) {
              Widget c = SizedBox();
              if (i == 0) {
                c = AppText.bold(laneEntry.value.name,
                    fontSize: 12, alignment: TextAlign.center);
              }
              if (i == 1) {
                c = AppText.thin(laneEntry.value.lastCalibString,
                    fontSize: 10, alignment: TextAlign.center);
              }
              if (i == 2) {
                c = getCalibStatus(laneEntry, c);
              }
              if (i == 3) {
                c = AppText.thin(laneEntry.value.kfactor.toString(),
                    fontSize: 10, alignment: TextAlign.center);
              }
              return SizedBox(
                width: w,
                height: 24,
                child: Center(child: c),
              );
            })),
          ));
    });
  }

  mcRow(Rx<LaneEntry> laneEntryA, Rx<LaneEntry> laneEntryB, int j) {
    double w = laneWidth / headerTitles.length;
    return Obx(() {
      double h = useEthanol.value ? 49 : 24;
      List<Widget> er = [];
      if (useEthanol.value) {
        er = [
          ethRows(laneEntryA),
          Container(
            width: double.maxFinite,
            height: 1,
            color: Colors.grey.shade200,
          ),
          ethRows(laneEntryB)
        ];
      } else {
        er = [ethRows(laneEntryA)];
      }
      return Opacity(
          opacity: laneEntryA.value.active || laneEntryB.value.active ? 1 : 0.2,
          child: ShadowContainer(
            radius: 0,
            padding: 0,
            margin: 0,
            height: h,
            
            color: Colors.white,
            child: Row(children: [
              SizedBox(
                width: w,
                height: h,
                child: Center(
                    child: AppText.bold(laneEntryA.value.name,
                        fontSize: 12, alignment: TextAlign.center)),
              ),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: er)),
            ]),
          ));
    });
  }

  ethRows(Rx<LaneEntry> laneEntry) {
    return InkWell(
      onTap: (){
        Get.dialog(AppDialog.empty(SideTableWidget(laneEntry)));
      },
      child: Opacity(
        opacity: laneEntry.value.active ? 1 : 0.2,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            Widget c = SizedBox();
            double w = laneWidth / headerTitles.length;
            if (i == 0) {
              c = AppText.thin(laneEntry.value.lastCalibString,
                  fontSize: 10, alignment: TextAlign.center);
            }
            if (i == 1) {
              c = getCalibStatus(laneEntry, c);
            }
            if (i == 2) {
              c = AppText.thin(laneEntry.value.kfactor.toString(),
                  fontSize: 10, alignment: TextAlign.center);
            }
      
            return SizedBox(
              width: w,
              height: 24,
              child: Center(child: c),
            );
          }),
        ),
      ),
    );
  }

  Widget getCalibStatus(Rx<LaneEntry> laneEntry, Widget c) {
    Color col = Colors.green.withOpacity(0.3);
    if (laneEntry.value
                .getExternalPending(controller.externalFreq.value) <=
            0 &&
        laneEntry.value.calibDate == null) {
      col = Colors.red.withOpacity(0.3);
    } else if (laneEntry.value.calibDate != null) {
      col = Colors.green.withOpacity(0.3);
    } else if (laneEntry.value.isExternalAlarm(
        controller.externalFreq.value,
        controller.externalAlarm.value)) {
      col = Colors.orange.withOpacity(0.3);
    }
    c = Obx(
       () {
        return AppChip2(
          laneEntry.value
              .getExternalNextDueDateString(controller.externalFreq.value),
          col,
          Colors.black,
          fontsize: 10,
        );
      }
    );
    return c;
  }
}

class ExplorerHeader extends StatelessWidget {
  const ExplorerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeader2(
      trailing: Row(
        children: [
          // ShadowContainer(
          //     padding: 8,
          //     margin: 0,
          //     onPressed: () async {
          //       final b = await Get.dialog(MonthPicker());
          //       print(b);
          //     },
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         AppIcon(
          //           Icons.calendar_month_rounded,
          //           size: 18,
          //         ),
          //         AppText.thin("   August 2025   "),
          //       ],
          //     )),
          SimpleTextClock(),
          Ui.boxWidth(24),
          ShadowContainer(
            padding: 8,
            margin: 0,
            onPressed: () {
              final w = ((Ui.width(context) / 3) - 24) / 2;
              final tecs = [TextEditingController(), TextEditingController()];
              final controller = Get.find<AppController>();
              tecs[0].text = controller.externalFreq.value.toString();
              tecs[1].text = controller.externalAlarm.value.toString();
              Get.dialog(AppDialog(
                  title: AppText.bold("Bulk Configuration"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField("Calibration Frequency (days)", tecs[0]),
                      CustomTextField("Calibration Alarm (days)", tecs[1]),
                      AppButton(
                        onPressed: () {
                          if (tecs[0].text.isEmpty || tecs[1].text.isEmpty) {
                            return Ui.showError("Cannot be empty");
                          }
                          controller.externalAlarm.value =
                              int.tryParse(tecs[1].text) ?? 30;
                          controller.externalFreq.value =
                              int.tryParse(tecs[0].text) ?? 180;
                        },
                        text: "Apply",
                      ),
                      Ui.boxHeight(24),
                      AppText.thin(
                          "Changes apply immediately. Next-due dates are recalculated based on last done dates.",
                          fontSize: 12,
                          color: Colors.grey.shade400)
                    ],
                  )));
            },
            child: Row(
              children: [
                Ui.boxWidth(12),
                AppText.thin("Settings"),
                Ui.boxWidth(12),
                AppIcon(
                  Icons.settings,
                  size: 18,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          // Ui.boxWidth(24),
          // ShadowContainer(
          //   padding: 8,
          //   margin: 0,
          //   onPressed: () {
          //     Get.dialog(AppDialog(
          //         title: AppText.thin("Admin Config"),
          //         content: Column(
          //           children: [],
          //         )));
          //   },
          //   child: AppIcon(
          //     Icons.admin_panel_settings_outlined,
          //     size: 18,
          //     color: Colors.black,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class SideTableWidget extends StatelessWidget {
  const SideTableWidget(this.laneentry, {super.key});
  final Rx<LaneEntry> laneentry;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    final ww = (Ui.width(context) / 6) - 32;
    final tecs = List.generate(7, (i) => TextEditingController());
    tecs[0].text = laneentry.value.lastCalibString;
    tecs[1].text = laneentry.value
        .getExternalNextDueDateString(controller.externalFreq.value);
    tecs[2].text = controller.externalFreq.value.toString();
    tecs[3].text = laneentry.value.calibDateString;
    tecs[4].text = laneentry.value.kfactor.toString();
    tecs[5].text = laneentry.value.calibDateString;
    tecs[6].text = laneentry.value.remarks;
    DateTime? doneDate;
    return CurvedContainer(
      width: Ui.width(context) / 3,
      padding: EdgeInsets.all(16),
      child: Column(
        
              mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Ui.boxHeight(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.bold("Edit Lane - ${laneentry.value.name}  ${laneentry.value.isEthanol ? "|  ETHANOL": ""}",
                        fontSize: 24),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: AppIcon(
                          Icons.close,
                        ))
                  ],
                ),
                Ui.boxHeight(8),
                AppText.thin("Update calibration details (Admin Only)"),
                Ui.boxHeight(16),
                AppDivider(),
                // AppText.bold("Internal Checks"),
                // Ui.boxHeight(8),
                // Wrap(
                //   runSpacing: 16,
                //   spacing: 16,
                //   children: [
                //     CustomTextField("Frequency (days)", TextEditingController(),
                //         ww: ww, hasBottomPadding: false),
                //     CustomTextField("Due Date", TextEditingController(),
                //         ww: ww, hasBottomPadding: false),
                //     CustomTextField("Done Date", TextEditingController(),
                //         ww: ww, hasBottomPadding: false),
                //     CustomTextField("Postponed (days)", TextEditingController(),
                //         ww: ww, hasBottomPadding: false),
                //   ],
                // ),
                // Ui.boxHeight(24),
                // AppDivider(),
                AppText.bold("External Calibration"),
                Ui.boxHeight(8),
                Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: [
                    CustomTextField(
                      "Last Calibration",
                      tecs[0],
                      ww: ww,
                      hasBottomPadding: false,
                      readOnly: true,
                    ),
                    CustomTextField("Next Due", tecs[1],
                        ww: ww, hasBottomPadding: false, readOnly: true),
                    CustomTextField("Frequency (days)", tecs[2],
                        ww: ww, hasBottomPadding: false, readOnly: true),
                    CustomTextField(
                      "Done Date",
                      tecs[3],
                      ww: ww,
                      hasBottomPadding: false,
                      readOnly: true,
                      onTap: () async {
                        final dt = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2024),
                            lastDate: DateTime.now());
                        if (dt != null) {
                          doneDate = dt;
                          tecs[3].text = DateFormat("dd/MM/yyyy").format(dt);
                        }
                      },
                    ),
                    CustomTextField(
                      "K-Factor",
                      tecs[4],
                      ww: ww,
                      hasBottomPadding: false,
                    ),
                    // CustomTextField(
                    //   "Work Status",
                    //   tecs[5],
                    //   ww: ww,
                    //   hasBottomPadding: false,
                    // ),
                    CustomDropdown<int>("Work Status", List.generate(4, (j){
                      return DropdownMenuItem(value: j,child: AppText.thin(controller.statusText[j]),);
                    }),ww: ww,hasBottomPadding: false,
                    // value: ,
                    onChanged: (v){
                      tecs[5].text = v.toString();
                    },
                    )
                  ],
                ),
                Ui.boxHeight(24),
                CustomTextField(
                  "Remarks",
                  tecs[6],
                  tk: TextInputType.multiline,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.bold("Enabled"),
                    Ui.boxWidth(24),
                    Obx(() {
                      return Switch(
                          value: laneentry.value.active,
                          activeTrackColor: Colors.green,
                          onChanged: (f) async {
                            laneentry.value.active = f;
                            laneentry.refresh();
                            // await controller.saveAction(AppActions.toggleLane,lane: laneEntry.value.name,location: controller.depotName.value);

                            // laneEntry.refresh();
                          });
                    }),
                  ],
                ),
                Ui.boxHeight(24),
                Row(
                  children: [
                    
                    Spacer(),
                    // SizedBox(
                    //     width: 160,
                    //     child: AppButton(
                    //         onPressed: () {},
                    //         text: "Cancel",
                    //         color: Colors.white)),
                    // Ui.boxWidth(16),
                    SizedBox(
                        width: 160,
                        child: AppButton(
                          onPressed: () async {
                            if (doneDate != null) {
                              laneentry.value.calibDate = doneDate;
                              laneentry.value.lastCalibDate = doneDate;
                              laneentry.value.calibDate = null;
                            }
                            laneentry.value.kfactor =
                                double.tryParse(tecs[4].text) ?? 0;
                            laneentry.value.remarks = tecs[6].text;

                            laneentry.refresh();
                            Get.back();
                          },
                          text: "Save Changes",
                          color: AppColors.primary,
                        )),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

    //     allSize.last += ih;
    //     allWno +=
    //   }
    // }
    // return ShadowContainer(
    //     width: laneWidth,
    //     padding: 0,
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         if (!isContinuation) subHeader(title: pd),
    //         if (!isContinuation) header(),
    //         if (!isContinuation) Ui.boxHeight(2),
    //         ListView.separated(
    //           shrinkWrap: true,
    //           itemCount: ln.length,
    //           itemBuilder: (c, i) {
    //             return cRow(ln[i].obs, i);
    //           },
    //           separatorBuilder: (c, i) {
    //             return Container(
    //               height: 1,
    //               width: double.maxFinite,
    //               color: Colors.grey.shade400,
    //             );
    //           },
    //         )
    //       ],
    //     ));