
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodstore/resource/model/location_model.dart';
import 'package:flutter_foodstore/resource/remote/checkout_remote_resource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_state.dart';
part 'location_cubit.freezed.dart';

class LocationCubit extends Cubit<LocationState> {
  final CheckoutRemoteResource checkoutRemoteResource;

  LocationCubit(this.checkoutRemoteResource)
      : super(LocationState.initial());

  Future<void> getLocation(String search) async {
    final keyword = search.trim();

    if (keyword.isEmpty) {
      emit(LocationState.error('Silakan masukkan nama lokasi'));
      return;
    }

    emit(LocationState.loading());

    try {
      final result = await checkoutRemoteResource.getLocation(keyword);

      if (isClosed) return;

      result.fold(
        (message) => emit(LocationState.error(message)),
        (locations) => emit(LocationState.loaded(locations)),
      );
    } catch (e) {
      if (!isClosed) {
        emit(LocationState.error(e.toString()));
      }
    }
  }

  void clearLocation() {
    emit(LocationState.initial());
  }
}
