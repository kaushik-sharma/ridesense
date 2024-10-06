import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/helpers/ui_helpers.dart';
import '../../../core/services/location_service.dart';
import '../../../core/widgets/custom_map.dart';

class MapPage extends StatefulWidget {
  final double lat;
  final double lng;

  const MapPage({super.key, required this.lat, required this.lng});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.15),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            CustomMap(
                latLng: _currentLocation ?? LatLng(widget.lat, widget.lng)),
            Positioned(
              right: 20.r,
              bottom: 20.r,
              child: GestureDetector(
                onTap: () async {
                  final latLng = await LocationService.getCurrentLocation();
                  if (latLng == null) {
                    UiHelpers.showSnackBar(
                        'We could not fetch your current location. Please allow access to device location to enable this feature.',
                        context);
                    return;
                  }
                  setState(() {
                    _currentLocation = latLng;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 10.r,
                          spreadRadius: 5.r,
                        )
                      ]),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.r),
                  child: Icon(Icons.my_location, size: 25.r),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
