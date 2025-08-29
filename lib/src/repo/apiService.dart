import 'package:dio/dio.dart';

import '../models/lane.dart';

class Product {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Gantry {
  final int id;
  final String name;
  final int productId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Gantry({
    required this.id,
    required this.name,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Gantry.fromJson(Map<String, dynamic> json) {
    return Gantry(
      id: json['id'],
      name: json['name'],
      productId: json['productId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Lane {
  final int id;
  final String name;
  final int productId;
  final int gantryId;
  final String make;
  final String model;
  final String? serialNo;
  final String flowRange;
  final bool isEthanol;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product? product;
  final Gantry? gantry;

  Lane({
    required this.id,
    required this.name,
    required this.productId,
    required this.gantryId,
    required this.make,
    required this.model,
    this.serialNo,
    required this.flowRange,
    required this.isEthanol,
    required this.createdAt,
    required this.updatedAt,
    this.product,
    this.gantry,
  });

  factory Lane.fromJson(Map<String, dynamic> json) {
    return Lane(
      id: json['id'],
      name: json['name'],
      productId: json['productId'],
      gantryId: json['gantryId'],
      make: json['make'],
      model: json['model'],
      serialNo: json['serialNo'] ?? "",
      flowRange: json['flowRange'],
      isEthanol: json['isEthanol'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      gantry: json['gantry'] != null ? Gantry.fromJson(json['gantry']) : null,
    );
  }
}

class Calibration {
  final int id;
  final String? certPath;
  final String? calibPath;
  final String? poPath;
  final DateTime lastCalibDate;
  final DateTime? dateDone;
  final double kFactor;
  final int laneId;
  final String eStatus;
  final String? remark;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Lane? lane;

  Calibration({
    required this.id,
    this.certPath,
    this.calibPath,
    this.poPath,
    required this.lastCalibDate,
    this.dateDone,
    required this.kFactor,
    required this.laneId,
    required this.eStatus,
    this.remark,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.lane,
  });

  factory Calibration.fromJson(Map<String, dynamic> json) {
    return Calibration(
      id: json['id'],
      certPath: json['certPath'],
      calibPath: json['calibPath'],
      poPath: json['poPath'],
      lastCalibDate: DateTime.parse(json['lastCalibDate']),
      dateDone:
          json['dateDone'] != null ? DateTime.parse(json['dateDone']) : null,
      kFactor: json['kFactor'].toDouble(),
      laneId: json['laneId'],
      eStatus: json['eStatus'] ?? '',
      remark: json['remark'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      lane: json['lane'] != null ? Lane.fromJson(json['lane']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certPath': certPath,
      'calibPath': calibPath,
      'poPath': poPath,
      'lastCalibDate': lastCalibDate.toIso8601String(),
      'dateDone': dateDone?.toIso8601String(),
      'kFactor': kFactor,
      'laneId': laneId,
      'eStatus': eStatus,
      'remark': remark,
      'isActive': isActive,
    };
  }

  LaneEntry toLaneEntry() {
    return LaneEntry(
      lane?.name ?? '',
      active: isActive,
      certPath: certPath ?? '',
      ecalibPath: calibPath ?? '',
      poPath: poPath ?? '',
      eStatus:
          0, // You might want to map eStatus string to int based on your logic
      kfactor: kFactor,
      remarks: remark ?? '',
      isEthanol: lane?.isEthanol ?? false,
      dateDone: dateDone,
      product: lane?.product?.name ?? "",
      lastCalibDate: lastCalibDate,
      // Following fields are left empty as they're not in Calibration
      lastDoneDate: null,
      dateDue: null,
      oldDateDue: null,
      calibDate: null,
      correctionFactor: 0,
      postponeDays: 0,
      iid: 0,
      eid: id, // Using calibration id as external id
    );
  }
}

class ApiClient {
  final Dio _dio;
  final String baseUrl;

  ApiClient({required this.baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Get latest calibrations
  Future<List<Calibration>> getLatestCalibrations() async {
    try {
      final response = await _dio.get('/calib/latest');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Calibration.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Update calibration
  Future<void> updateCalibration(Calibration calibration) async {
    try {
      await _dio.put(
        '/calib/${calibration.id}',
        data: calibration.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update calibration: $e');
    }
  }

  // Get all lanes
  Future<List<Lane>> getLanes() async {
    try {
      final response = await _dio.get('/lane');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Lane.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Get all gantries
  Future<List<Gantry>> getGantries() async {
    try {
      final response = await _dio.get('/gantry');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Gantry.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Get all products
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/product');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
