import 'package:calib_tracker_dangote/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InternalChecks {
  DateTime curdate;
  DateTime? datedone, datedue, oldDateDue, lastDoneDate;
  int id, postponedays;
  String location, lane,calibPath;

  InternalChecks(
      {required this.curdate,
      this.datedue,
      this.oldDateDue,
      required this.lane,
      this.postponedays = 0,
      this.location = "",
      this.datedone,
      this.calibPath="",
      this.lastDoneDate,
      this.id = 0});

  Map<String, dynamic> toMap() {
    return {
      'curdate': curdate.toString(),
      'datedue': datedue?.toString() ?? "",
      'olddatedue': oldDateDue?.toString() ?? "",
      'datedone': datedone?.toString() ?? "",
      'lastdonedate': lastDoneDate?.toString() ?? "",
      'postponedays': postponedays,
      'lane': lane,
      'location': location
    };
  }

  factory InternalChecks.fromMap(Map<String, dynamic> map) {
    return InternalChecks(
      curdate: DateTime.parse(map['curdate']),
      lastDoneDate: DateTime.tryParse(map['lastdonedate'] ?? ""),
      datedue: DateTime.tryParse(map['datedue'] ?? ""),
      oldDateDue: DateTime.tryParse(map['olddatedue'] ?? ""),
      datedone: DateTime.tryParse(map['datedone'] ?? ""),
      calibPath: map['calibpath'] ?? "",
      postponedays: map['postponedays'],
      location: map['location'],
      lane: map['lane'],
      id: map['id'],
    );
  }
}
