import 'package:calib_tracker_dangote/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExternalChecks {
  DateTime lastcalibdate;
  DateTime? datedone;
  int id, isActive;
  double kfactor, cfactor;
  String location, lane, certPath,poPath,calibPath, estatus, remark;

  ExternalChecks(
      {required this.lastcalibdate,
      required this.lane,
      this.kfactor = 0,
      this.cfactor = 0,
      this.isActive = 1,
      this.location = "",
      this.certPath = "",
      this.poPath = "",
      this.calibPath = "",
      this.estatus = "",
      this.remark = "",
      this.datedone,
      this.id = 0});

  Map<String, dynamic> toMap() {
    return {
      'lastcalibdate': lastcalibdate.toString(),
      'datedone': datedone?.toString() ?? "",
      'kfactor': kfactor,
      'cfactor': cfactor,
      'lane': lane,
      'isactive': isActive,
      'certpath': certPath,
      'location': location,
      'estatus': estatus,
      'remark': remark
    };
  }

  factory ExternalChecks.fromMap(Map<String, dynamic> map) {
    return ExternalChecks(
      certPath: map['certpath'] ?? "",
      calibPath: map['calibpath'] ?? "",
      poPath: map['popath'] ?? "",
      lastcalibdate: DateTime.parse(map['lastcalibdate'] ?? ""),
      datedone: DateTime.tryParse(map['datedone'] ?? ""),
      kfactor: map['kfactor'] ?? 0,
      cfactor: map['cfactor'] ?? 0,
      location: map['location'] ?? "",
      lane: map['lane'],
      estatus: map['estatus'] ?? "",
      remark: map['remark'] ?? "",
      isActive: map['isactive'],
      id: map['id'],
    );
  }
}
