import 'package:calib_tracker_dangote/src/controllers/app_controller.dart';
import 'package:calib_tracker_dangote/src/models/lane.dart';
import 'package:calib_tracker_dangote/src/views/shared/containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExplorerScreen extends StatelessWidget {
  ExplorerScreen({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideTableWidget(),
      key: scaffoldKey,
      body: Column(
        children: [
          ExplorerHeader(),
          Container(
            height: 1,
            width: Ui.width(context),
            color: const Color.fromARGB(255, 236, 236, 236),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 304,
                  child: Column(
                    children: [OverviewWidget(), Expanded(child: SingleChildScrollView(child: FilterWidget()))],
                  ),
                ),
                Expanded(child: LaneTableWidget(scaffoldKey))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ExplorerHeader extends StatelessWidget {
  const ExplorerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      trailing: Row(
        children: [
          ShadowContainer(
              padding: 8,
              margin: 0,
              onPressed: () {
                final w = ((Ui.width(context) / 3) - 24) / 2;
                Get.dialog(AppDialog(
                    title: AppText.bold("Bulk Configuration"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          runSpacing: 16,
                          spacing: 16,
                          children: [
                            CustomTextField(
                              "Scope",
                              TextEditingController(),
                              ww: w,
                              hasBottomPadding: false,
                            ),
                            CustomTextField("Internal Check Frequency (days)",
                                TextEditingController(),
                                ww: w, hasBottomPadding: false),
                            CustomTextField("Calibration Frequency (days)",
                                TextEditingController(),
                                ww: w, hasBottomPadding: false),
                            SizedBox(
                              width: w,
                              child: Column(
                                children: [
                                  AppText.thin("", color: Colors.black),
                                  AppButton(
                                    onPressed: () {},
                                    text: "Apply",
                                  ),
                                ],
                              ),
                            ),
                            Ui.boxHeight(24),
                            AppText.thin(
                                "Changes apply immediately. Next-due dates are recalculated based on last done dates.",
                                fontSize: 12,
                                color: Colors.grey.shade400)
                          ],
                        )
                      ],
                    )));
              },
              child: Row(
                children: [
                  Ui.boxWidth(12),
                  AppIcon(
                    Icons.dashboard_outlined,
                    size: 18,
                    color: Colors.black,
                  ),
                  Ui.boxWidth(4),
                  AppText.thin("Bulk Settings"),
                  Ui.boxWidth(12),
                ],
              )),
          Ui.boxWidth(24),
          ShadowContainer(
              padding: 8,
              margin: 0,
              onPressed: () {
                Get.dialog(AppDialog(
                    title: AppText.thin("Admin Config"),
                    content: Column(
                      children: [],
                    )));
              },
              child: Row(
                children: [
                  Ui.boxWidth(12),
                  AppIcon(
                    Icons.admin_panel_settings_outlined,
                    size: 18,
                    color: Colors.black,
                  ),
                  Ui.boxWidth(4),
                  AppText.thin("Admin Config"),
                  Ui.boxWidth(12),
                ],
              )),
        ],
      ),
    );
  }
}

class OverviewWidget extends StatelessWidget {
  const OverviewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "Total Bays",
      "Enabled Bays",
      "Due This Month",
      "Overdue"
    ];
    final List<int> values = [90, 70, 60, 70];
    return ShadowContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(),
          AppText.bold("Overview"),
          Ui.boxHeight(16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(4, (i) {
              return ShadowContainer(
                  width: 120,
                  height: 64,
                  margin: 0,
                  padding: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText.thin(titles[i],
                          fontSize: 13, color: Colors.grey.shade700, att: true),
                      Ui.boxHeight(4),
                      Row(
                        children: [
                          if (i == 2)
                            AppIcon(
                              Icons.calendar_month,
                              size: 20,
                            ),
                          if (i == 3)
                            AppIcon(
                              Icons.history,
                              size: 20,
                              color: Colors.red,
                            ),
                          if (i > 1) Ui.boxWidth(8),
                          AppText.bold(values[i].toString()),
                        ],
                      )
                    ],
                  ));
            }),
          )
        ],
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    RxList<String> allGantries = (List.generate(9, (i) => "G${i + 1}")).obs;
    RxList<String> allGantriesSelected = <String>[].obs;
    RxList<String> allProducts = ["PMS", "AGO", "DPK", "JETA1"].obs;
    RxList<String> allProductsSelected = <String>[].obs;
    RxList<String> allWorkStatus = ["Pending", "Overdue", "Done"].obs;
    RxList<String> allWorkStatusSelected = <String>[].obs;
    RxList<String> allPendingStatus =
        ["PO Issued", "Calibration Done", "Certificate Issued"].obs;
    RxList<String> allPendingStatusSelected = <String>[].obs;
    return ShadowContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bold("Gantry Filter"),
        AppDivider(),
        filterBox("Product", allProducts, allProductsSelected),
        AppDivider(),
        filterBox("Work Status", allWorkStatus, allWorkStatusSelected),
        AppDivider(),
        filterBox("Pending Status", allPendingStatus, allPendingStatusSelected),
        AppDivider(),
        filterBox("Gantry", allGantries, allGantriesSelected),
        Ui.boxHeight(8),
      ],
    ));
  }

  filterBox(
    String title,
    RxList<String> filters,
    RxList<String> selected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.bold(title, fontSize: 14),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.thin("Select All",
                    fontSize: 12, color: Colors.grey.shade400),
                Obx(() {
                  return Checkbox(
                      value: filters.length == selected.length,
                      activeColor: AppColors.primary,
                      onChanged: (v) {
                        if (v == true) {
                          selected.value = List.from(filters);
                        } else {
                          selected.value = [];
                        }
                      });
                })
              ],
            )
          ],
        ),
        Ui.boxHeight(8),
        ...List.generate(filters.length, (i) {
          return Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.thin(filters[i]),
                Checkbox(
                    value: selected.contains(filters[i]),
                    activeColor: AppColors.primary,
                    onChanged: (j) {
                      if (j ?? false) {
                        selected.addIf(
                            !selected.contains(filters[i]), filters[i]);
                      } else {
                        selected.remove(filters[i]);
                      }
                    }),
              ],
            );
          });
        }),
        Ui.boxHeight(8),
      ],
    );
  }
}

class LaneTableWidget extends StatelessWidget {
  const LaneTableWidget(this.ctx, {super.key});
  final GlobalKey<ScaffoldState> ctx;
  static const List<String> headerTitles = [
    "Arm",
    "Date Due",
    "Date Done",
    "Postponed Days",
    "Last Calibration Date",
    "Date Due",
    "Date Done",
    "K-Factor",
    "Work Status",
    "Enabled",
    "Remarks",
    "Action"
  ];

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
        child: Column(
      children: [
        Row(
          children: [
            AppText.bold("Bays"),
            Spacer(),
            ShadowContainer(
                padding: 8,
                onPressed: () async {
                  final b = await Get.dialog(MonthPicker());
                  print(b);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcon(
                      Icons.calendar_month_rounded,
                    ),
                    AppText.thin("   August 2025   "),
                  ],
                )),
            AppText.thin("Showing 90 of 90 Bays",
                fontSize: 12, color: Colors.grey.shade500)
          ],
        ),
        subHeader(Ui.width(context) - 320 - 32),
        header(Ui.width(context) - 320 - 32),
        Ui.boxHeight(8),
        Expanded(
          child: ListView.separated(
            itemCount: 90,
            itemBuilder: (c, i) {
              return cRow(LaneEntry("A1").obs, Ui.width(context) - 320 - 32);
            },
            separatorBuilder: (c, i) {
              return AppDivider();
            },
          ),
        )
      ],
    ));
  }

  header(double width) {
    return Row(
        children: List.generate(headerTitles.length, (i) {
      double w = width / headerTitles.length;
      if (i == 9 || i == 11) {
        w = width / 24;
      }
      Widget c = CurvedContainer(
        radius: 0,
        color: AppColors.primary,
        width: w,
        brad: BorderRadius.only(
          topLeft: Radius.circular(i == 0 ? 16 : 0),
          topRight: Radius.circular(i == headerTitles.length - 1 ? 16 : 0),
        ),
        height: 48,
        padding: const EdgeInsets.all(2),
        child: Center(
            child: AppText.thin(headerTitles[i].capitalize!,
                att: true,
                alignment: TextAlign.center,
                color: Colors.white,
                fontSize: 12)),
      );
      if (i == headerTitles.length - 2) {
        c = Expanded(child: c);
      }
      return c;
    }));
  }

  subHeader(double width) {
    double w = width / headerTitles.length;
    final titles = ["Monthly Targets","External Calibration"];
    return Row(children: [
      SizedBox(
        width: w,
      ),
      ...List.generate(2,(i) => CurvedContainer(
        color: AppColors.primary,
        radius: 0,
        padding: EdgeInsets.only(top: 4),
        brad: BorderRadius.only(
          topLeft: Radius.circular(i == 0 ? 16 : 0),
          topRight: Radius.circular(i == 1 ? 16 : 0),
        ),
        width: w * (i == 0 ?  3:  4),
        
        child: AppText.bold(titles[i],
            alignment: TextAlign.center, color: Colors.white),
      ),),
      
    ]);
  }

  cRow(Rx<LaneEntry> laneEntry, double width) {
    double w = width / headerTitles.length;
    return Obx(() {
      return Opacity(
          opacity: laneEntry.value.active ? 1 : 0.5,
          child: Row(
              children: List.generate(headerTitles.length, (i) {
            Widget c = SizedBox();
            if (i == headerTitles.length - 2) {
              c = Expanded(
                  child: AppText.thin("laneEntry.value.remarks",
                      alignment: TextAlign.center));
            }
            if (i == headerTitles.length - 1) {
              c = Center(
                child: ShadowContainer(
                  padding: 8,
                  margin: 8,
                  onPressed: () {
                    ctx.currentState?.openEndDrawer();
                  },
                  child: AppIcon(
                    Icons.edit_outlined,
                  ),
                ),
              );
            }
            if (i == headerTitles.length - 3) {
              c = Switch(
                  value: laneEntry.value.active,
                  activeTrackColor: Colors.green,
                  onChanged: (f) async {});
            }

            if (i == 8) {
              c = AppChip("PO Issued", Colors.blue);
            }

            if (i == 6) {
              c = AppTextCell(
                "PENDING",
                color: const Color.fromARGB(255, 131, 109, 10),
                boldTitle: true,
              );
            }

            if (i == 7) {
              c = AppChip("1.56473", Colors.black);
            }

            if (i == 5) {
              c = AppChipCell(
                "Overdue",
                status: 0,
                desc: "08-Aug-2025",
              );
            }

            if (i == 4) {
              c = AppTextCell(
                "08-Aug-2024",
              );
            }
            if (i == 3) {
              c = AppTextCell("0 days");
            }
            if (i == 2) {
              c = AppTextCell(
                "PENDING",
                desc: "Last: 08-Aug-2025",
                boldTitle: true,
                color: const Color.fromARGB(255, 131, 109, 10),
              );
            }
            if (i == 1) {
              c = AppChipCell(
                "53d left",
                status: 1,
                desc: "08-Aug-2025",
              );
            }
            if (i == 0) {
              c = AppTextCell(
                "G1-B2-A1",
                desc: "G1 • Bay 2 • Arm 1",
                boldTitle: true,
              );
            }

            return i < 9
                ? SizedBox(
                    width: w,
                    child: Center(child: c),
                  )
                : c;
          })));
    });
  }
}

class SideTableWidget extends StatelessWidget {
  const SideTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ww = (Ui.width(context) / 6) - 32;
    return CurvedContainer(
      width: Ui.width(context) / 3,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Ui.boxHeight(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.bold("Edit Lane - G1-B1-A1", fontSize: 24),
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
                AppText.thin(
                    "Update internal checks and calibration details (Admin Only)"),
                Ui.boxHeight(16),
                AppDivider(),
                AppText.bold("Internal Checks"),
                Ui.boxHeight(8),
                Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: [
                    CustomTextField("Frequency (days)", TextEditingController(),
                        ww: ww, hasBottomPadding: false),
                    CustomTextField("Due Date", TextEditingController(),
                        ww: ww, hasBottomPadding: false),
                    CustomTextField("Done Date", TextEditingController(),
                        ww: ww, hasBottomPadding: false),
                    CustomTextField("Postponed (days)", TextEditingController(),
                        ww: ww, hasBottomPadding: false),
                  ],
                ),
                Ui.boxHeight(24),
                AppDivider(),
                AppText.bold("External Calibration"),
                Ui.boxHeight(8),
                Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: [
                    CustomTextField("Last Calibraion", TextEditingController(),
                        ww: ww, hasBottomPadding: false),
                    CustomTextField("Next Due", TextEditingController(),
                        ww: ww, hasBottomPadding: false),
                    CustomTextField("Frequency (days)", TextEditingController(),
                        ww: ww, hasBottomPadding: false),
                    CustomTextField("Done Date", TextEditingController(),
                        ww: ww, hasBottomPadding: false),
                    CustomTextField("K-Factor", TextEditingController(),
                        ww: ww, hasBottomPadding: false),
                    CustomTextField(
                      "Work Status",
                      TextEditingController(),
                      ww: ww,
                      hasBottomPadding: false,
                    ),
                  ],
                ),
                Ui.boxHeight(24),
                CustomTextField(
                  "Remarks",
                  TextEditingController(),
                  tk: TextInputType.multiline,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.bold("Enabled"),
                    Ui.boxWidth(24),
                    Switch(
                        value: true,
                        activeTrackColor: Colors.green,
                        onChanged: (f) async {
                          // laneEntry.value.active = f;
                          // await controller.saveAction(AppActions.toggleLane,lane: laneEntry.value.name,location: controller.depotName.value);

                          // laneEntry.refresh();
                        }),
                  ],
                ),
                Ui.boxHeight(24),
                Row(
                  children: [
                    ShadowContainer(
                        padding: 8,
                        margin: 0,
                        child: Row(
                          children: [
                            Ui.boxWidth(8),
                            AppIcon(
                              Icons.calendar_month,
                              size: 18,
                            ),
                            Ui.boxWidth(4),
                            AppText.thin("Recalculate Next Dues"),
                            Ui.boxWidth(8),
                          ],
                        )),
                    Spacer(),
                    SizedBox(
                        width: 160,
                        child: AppButton(
                            onPressed: () {},
                            text: "Cancel",
                            color: Colors.white)),
                    Ui.boxWidth(16),
                    SizedBox(
                        width: 160,
                        child: AppButton(
                          onPressed: () {},
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
