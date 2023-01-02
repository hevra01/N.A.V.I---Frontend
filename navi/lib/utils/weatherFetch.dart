import 'package:navi/utils/location.dart';
import 'package:navi/utils/weather.dart';

// this function will be used to get the user location
Future<LocationHelper?> getLocationData() async {
  var locationData = LocationHelper();
  await locationData.getCurrentLocation();
  if (locationData.latitude == null || locationData.longitude == null) {
    return null;
  } else {
    return locationData;
  }
}

// this function will be used to get the weather based on the user location
Future<WeatherData> getWeatherData(LocationHelper? locationData) async {
  WeatherData weatherData = WeatherData(locationData!);
  // this will initialize the currentTemperature attribute
  await weatherData.getCurrentTempurature();

  return weatherData;
}
