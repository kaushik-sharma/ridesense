part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.switchMode(FormMode formMode) = _SwitchMode;

  const factory HomeEvent.submitForm() = _SubmitForm;
}
