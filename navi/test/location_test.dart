import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:navi/utils/location.dart';


class MockLocation extends Mock implements Location {}

class MockClient extends Mock implements Client {}

void main() {
  group('LocationHelper', () {
    late MockLocation mockLocation;
    //late MockClient mockClient;
    late LocationHelper locationHelper;

    setUp(() {
      mockLocation = MockLocation();
      //mockClient = MockClient();
      locationHelper = LocationHelper();
    });

    test('getCurrentLocation should set latitude and longitude', () async {
      // Mock the location data returned by Location.getLocation()
      final locationData = LocationData.fromMap({
        'latitude': 37.4219983,
        'longitude': -122.084,
      });
      when(mockLocation.getLocation()).thenAnswer((_) async => locationData);

      await locationHelper.getCurrentLocation();

      expect(locationHelper.latitude, equals(37.4219983));
      expect(locationHelper.longitude, equals(-122.084));
    });

    test('getCurrentLocation should return if location service is not enabled', () async {
      when(mockLocation.serviceEnabled()).thenAnswer((_) async => false);
      when(mockLocation.requestService()).thenAnswer((_) async => false);

      await locationHelper.getCurrentLocation();

      expect(locationHelper.latitude, isNull);
      expect(locationHelper.longitude, isNull);
    });

    test('getCurrentLocation should return if location permission is denied', () async {
      when(mockLocation.serviceEnabled()).thenAnswer((_) async => true);
      when(mockLocation.hasPermission()).thenAnswer((_) async => PermissionStatus.denied);
      when(mockLocation.requestPermission()).thenAnswer((_) async => PermissionStatus.denied);

      await locationHelper.getCurrentLocation();

      expect(locationHelper.latitude, isNull);
      expect(locationHelper.longitude, isNull);
    });
  });
}
