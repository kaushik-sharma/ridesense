part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;

  const factory HomeState.noOp() = _NoOp;

  const factory HomeState.modeSwitched() = _ModeSwitched;

  const factory HomeState.formSubmitted(LatLng latLng) = _FormSubmitted;

  const factory HomeState.loading() = _Loading;

  const factory HomeState.loaded() = _Loaded;

  const factory HomeState.showSnackBar(String text) = _ShowSnackBar;
}
