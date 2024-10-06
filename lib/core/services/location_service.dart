import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static Future<LatLng?> getCurrentLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      log('Failed to fetch location.');
      return null;
    }
  }

  static Future<LatLng?> getLatLngFromAddress(String address) async {
    try {
      final List<Location> locations = await locationFromAddress(address);
      if (locations.isEmpty) throw Exception('No location found.');

      return LatLng(locations.first.latitude, locations.first.longitude);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
