import 'package:location/location.dart';
import 'package:http/http.dart';

class LocationHelper {
  late double latitude;
  late double longitude;

  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled; // Is system enable or not ?
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // location control

    _permissionGranted = await location
        .hasPermission(); // Is permitted to reach location or not?

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location
          .requestPermission(); // if users denied wait and check again

      if (_permissionGranted == PermissionStatus.denied) {
        // If users denied again return
        return;
      }
    }

    // If permissions are okay then,

    _locationData = await location.getLocation();
    latitude = _locationData.latitude!;
    longitude = _locationData.longitude!;
  }
}
