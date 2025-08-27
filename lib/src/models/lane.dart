import 'package:calib_tracker_dangote/src/models/externalChecks.dart';
import 'package:calib_tracker_dangote/src/models/internalChecks.dart';
import 'package:intl/intl.dart';

class LaneEntry {
  String name, remarks, certPath, icalibPath, ecalibPath, poPath,product;
  int eStatus, postponeDays, iid, eid;
  double kfactor, correctionFactor;
  bool active,isEthanol;
  DateTime? dateDone,
      lastDoneDate,
      lastCalibDate,
      calibDate,
      oldDateDue,
      dateDue;

  //iPending,ePending,nextDueDate;

  int getInternalPending(int a) {
    final f = getInternalNextDueDate(a)?.difference(DateTime.now());
    if (f == null) {
      return 0;
    }
    return f.inDays;
  }

  bool get isInSameMoments => dateDue == null;

  int getExternalPending(int a) {
    final f = getExternalNextDueDate(a)?.difference(DateTime.now());
    if (f == null) {
      return 0;
    }
    return f.inDays;
  }

  bool isInternalAlarm(int a, int b) {
    final f = getInternalPending(a);
    return f > 0 && f <= b;
  }

  bool isExternalAlarm(int a, int b) {
    final f = getExternalPending(a);
    return f > 0 && f <= b;
  }

  DateTime? getExternalNextDueDate(int a) {
    return (calibDate ?? lastCalibDate)?.add(Duration(days: a)) ??
        lastCalibDate;
  }

  DateTime? getInternalNextDueDate(int a) {
    DateTime newDueDate = oldDateDue ?? DateTime.now();
    if (lastDoneDate != null) {
      final gj = newDueDate.add(Duration(days: a));
      if (gj.difference(lastDoneDate!).inDays <= a) {
        newDueDate = lastDoneDate!;
      }
    }
    return dateDue ?? newDueDate.add(Duration(days: a + postponeDays));
  }

  String getExternalNextDueDateString(int a) {
    final gnd = getExternalNextDueDate(a);
    return gnd == null ? "" : DateFormat("dd/MM/yyyy").format(gnd);
  }

  String getInternalNextDueDateString(int a) {
    final gnd = getInternalNextDueDate(a);
    return gnd == null ? "" : DateFormat("dd/MM/yyyy").format(gnd);
  }

  String get lastCalibString => lastCalibDate == null
      ? ""
      : DateFormat("dd/MM/yyyy").format(lastCalibDate!);
  String get calibDateString =>
      calibDate == null ? "" : DateFormat("dd/MM/yyyy").format(calibDate!);
  // String get oldDateDueString =>
  //     oldDateDue == null ? "" : DateFormat("dd/MM/yyyy").format(oldDateDue!);

  LaneEntry(
    this.name, {
    this.active = true,
    this.iid = 0,
    this.eid = 0,
    this.certPath = "",
    this.icalibPath = "",
    this.ecalibPath = "",
    this.poPath = "",
    this.product = "",
    this.eStatus = 0,
    this.kfactor = 0,
    this.postponeDays = 0,
    this.remarks = "",
    this.isEthanol=false,
    this.dateDone,
    this.lastCalibDate,
    this.lastDoneDate,
    this.dateDue,
    this.oldDateDue,
    this.calibDate,
    this.correctionFactor = 0,
  });


  InternalChecks toInternalCheck(
      DateTime dt, String location, int a, bool shdUpdateDue) {
    return InternalChecks(
      curdate: dt,
      lane: name,
      lastDoneDate: lastDoneDate ?? dateDone ?? oldDateDue ?? dateDue ?? DateTime.now(),
      datedone: dateDone,
      datedue: shdUpdateDue ? getInternalNextDueDate(a) : dateDue,
      oldDateDue: oldDateDue,
      id: iid,
      location: location,
      postponedays: postponeDays,
    );
  }

  ExternalChecks toExternalCheck(String location, String status) {
    return ExternalChecks(
        lastcalibdate: lastCalibDate!,
        lane: name,
        id: eid,
        certPath: certPath,
        cfactor: correctionFactor,
        kfactor: kfactor,
        estatus: status,
        isActive: active ? 1 : 0,
        location: location,
        remark: remarks,
        datedone: calibDate);
  }

  int getPendingNumber(int a, int b, int c, int d) {
    final iip = getInternalPending(a);
    final eip = getExternalPending(b);
    final ip = dateDone == null
        ? iip <= 0
            ? 2
            : 1
        : 0;
    final ep = calibDate == null
        ? eip <= 0
            ? 2
            : 1
        : 0;

    if (ip == 0 && ep == 0) {
      return 0;
    }
    if (ip == 2 || ep == 2) {
      return 2;
    }

    if (isInternalAlarm(a, c) || isInternalAlarm(b, d)) return 1;
    return 3;
  }
}
