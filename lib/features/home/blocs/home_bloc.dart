import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/services/location_service.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

enum FormMode {
  address('Enter Address'),
  latLng('Enter Latitude & Longitude'),
  ;

  final String title;

  const FormMode(this.title);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  FormMode _formMode = FormMode.address;
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  HomeBloc() : super(const HomeState.initial()) {
    on<_SwitchMode>((event, emit) {
      emit(const _NoOp());
      _formMode = event.formMode;
      _formKey.currentState!.reset();
      _addressController.clear();
      _latController.clear();
      _lngController.clear();
      emit(const _ModeSwitched());
    });
    on<_SubmitForm>((event, emit) async {
      emit(const _NoOp());

      if (!_formKey.currentState!.validate()) return;

      emit(const _Loading());
      final latLng = await _getLatLng(emit);
      emit(const _Loaded());
      if (latLng != null) {
        emit(_FormSubmitted(latLng));
      }
    });
  }

  FormMode get formMode => _formMode;

  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController get addressController => _addressController;

  TextEditingController get latController => _latController;

  TextEditingController get lngController => _lngController;

  Future<LatLng?> _getLatLng(Emitter<HomeState> emit) async {
    switch (_formMode) {
      case FormMode.address:
        final address = _addressController.text.trim();

        final LatLng? latLng =
            await LocationService.getLatLngFromAddress(address);

        if (latLng == null) {
          emit(const _ShowSnackBar(
              'We could not find the location with the given information.'));
          return null;
        }

        return latLng;
      case FormMode.latLng:
        final lat = double.parse(_latController.text.trim());
        final lng = double.parse(_lngController.text.trim());
        return LatLng(lat, lng);
    }
  }

  String? addressValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }
    return null;
  }

  String? latValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    if (double.tryParse(value.trim()) == null) {
      return 'Must be a number';
    }
    final lat = double.parse(value);
    if (lat < -90 || lat > 90) {
      return 'Latitude range: [-90, 90]';
    }
    return null;
  }

  String? lngValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    if (double.tryParse(value.trim()) == null) {
      return 'Must be a number';
    }
    final lng = double.parse(value);
    if (lng < -180 || lng > 180) {
      return 'Longitude range: [-180, 180]';
    }
    return null;
  }
}
