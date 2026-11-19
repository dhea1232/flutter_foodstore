
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_foodstore/resource/model/checkout_model.dart';
import 'package:flutter_foodstore/resource/model/location_model.dart';
import 'package:flutter_foodstore/resource/model/shipping_cost_model.dart';

class CheckoutRemoteResource {
  final Dio _dio;

  CheckoutRemoteResource(this._dio);

  /// Mengambil pesan error dari server
  String _errorMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    return e.message ?? e.toString();
  }

  /// Mencari alamat / tujuan pengiriman
  Future<Either<String, List<LocationModel>>> getLocation(
    String search,
  ) async {
    try {
      final response = await _dio.get(
        'public/search-destination',
        queryParameters: {
          'search': search,
        },
      );

      final responseBody = response.data;

      if (responseBody is! Map) {
        return Left('Format respons pencarian alamat tidak sesuai');
      }

      final apiResponse = responseBody['response'];

      if (apiResponse is! Map) {
        return Left('Data pencarian alamat tidak ditemukan');
      }

      final List<dynamic> data = apiResponse['data'] ?? [];

      final result = data
          .map((e) => LocationModel.fromMap(e))
          .toList();

      return Right(result);
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Menghitung ongkos kirim
  Future<Either<String, List<ShippingCostModel>>> getShippingCost(
    int cityId,
    int weight,
    String courierName,
  ) async {
    try {
      final response = await _dio.post(
        'public/check-ongkir',
        data: {
          'destination': cityId,
          'weight': weight,
          'courier': courierName,
        },
      );

      final responseBody = response.data;

      if (responseBody is! List) {
        return Left('Format respons ongkos kirim tidak sesuai');
      }

      final result = responseBody
          .map((e) => ShippingCostModel.fromMap(e))
          .toList();

      return Right(result);
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Melakukan checkout
  Future<Either<String, String>> checkOut(
    CheckoutModel checkout,
  ) async {
    try {
      final response = await _dio.post(
        'public/checkout',
        data: {
          'province_name': checkout.provinceName,
          'city_name': checkout.cityName,
          'district_name': checkout.districtName,
          'subdistrict_name': checkout.subdistrictName,
          'zip_code': checkout.zipCode,
          'full_address': checkout.fullAddress,
          'weight': checkout.weight,
          'shipping_courier': checkout.shippingCourier,
          'shipping_service': checkout.shippingService,
          'shipping_cost': checkout.shippingCost,
          'total': checkout.total,
        },
      );

      return Right(response.data['data']['snap_token']);
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
