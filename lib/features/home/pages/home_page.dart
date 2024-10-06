import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/ui_helpers.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/radio_tile_view.dart';
import '../../../router/router.dart';
import '../blocs/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bloc = HomeBloc();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            noOp: () {},
            modeSwitched: () {},
            formSubmitted: (latLng) =>
                context.pushNamed(Routes.map.name, queryParameters: {
              'lat': latLng.latitude.toString(),
              'lng': latLng.longitude.toString(),
            }),
            loading: () => _isLoading = true,
            loaded: () => _isLoading = false,
            showSnackBar: (text) {
              UiHelpers.showSnackBar(text, context);
            },
          );
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('PinPoint'),
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.all(20.r),
                  child: Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Text(
                            'Select if to search by address or directly specify the latitude and longitude.',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                          SizedBox(height: 5.h),
                          RadioTileView<FormMode>(
                            options: FormMode.values
                                .map((e) =>
                                    RadioTileOption(value: e, text: e.title))
                                .toList(),
                            groupValue: _bloc.formMode,
                            onChanged: (value) =>
                                _bloc.add(HomeEvent.switchMode(value)),
                          ),
                          SizedBox(height: 30.h),
                          _buildForm(),
                          SizedBox(height: 100.h),
                        ],
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: CustomButton(
                          type: ButtonType.elevated,
                          text: 'Find Location',
                          onTap: () => _bloc.add(const HomeEvent.submitForm()),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    Widget buildAddressForm() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _bloc.addressController,
              hintText: 'Enter street or city name',
              validator: _bloc.addressValidator,
              keyboardType: TextInputType.streetAddress,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                LengthLimitingTextInputFormatter(255),
              ],
            )
          ],
        );

    Widget buildLatLngForm() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _bloc.latController,
              hintText: 'Latitude',
              validator: _bloc.latValidator,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.none,
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              controller: _bloc.lngController,
              hintText: 'Longitude',
              validator: _bloc.lngValidator,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.none,
            ),
          ],
        );

    return Form(
      key: _bloc.formKey,
      child: switch (_bloc.formMode) {
        FormMode.address => buildAddressForm(),
        FormMode.latLng => buildLatLngForm(),
      },
    );
  }
}
