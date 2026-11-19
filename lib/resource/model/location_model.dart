
import 'dart:convert';

import 'package:flutter_foodstore/core/utils/parse_helper.dart';

class LocationModel {
  final int? id;
  final String? label;
  final String? provinceName;
  final String? cityName;
  final String? districtName;
  final String? subdistrictName;
  final String? zipCode;

  LocationModel({
    this.id,
    this.label,
    this.provinceName,
    this.cityName,
    this.districtName,
    this.subdistrictName,
    this.zipCode,
  });

  factory LocationModel.fromJson(String str) {
    return LocationModel.fromMap(json.decode(str));
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromMap(Map<String, dynamic> json) {
    return LocationModel(
      id: toIntOrNull(json['id']),
      label: json['label']?.toString(),
      provinceName: json['province_name']?.toString(),
      cityName: json['city_name']?.toString(),
      districtName: json['district_name']?.toString(),
      subdistrictName: json['subdistrict_name']?.toString(),
      zipCode: json['zip_code']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'province_name': provinceName,
      'city_name': cityName,
      'district_name': districtName,
      'subdistrict_name': subdistrictName,
      'zip_code': zipCode,
    };
  }
}
