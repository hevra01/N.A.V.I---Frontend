import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'location.dart';

const ApiKey = "f8ac1e165a26eca0c929ce905e2e7c0c";

class WeatherDisplayData {
  Icon weatherIcon;
  AssetImage weatherImage;

  WeatherDisplayData({required this.weatherIcon, required this.weatherImage});
}

class WeatherData {
  WeatherData(@required this.locationData);

  late LocationHelper locationData;
  late double currentTempurature;
  late int currentCondition;
  late String city;

  Future<double?> getCurrentTempurature() async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${ApiKey}&units=metric'); // get weather with using apikey
    Response response = await get(url);

    if (response.statusCode == 200) {
      String data = response.body;

      var currentWeather =
          jsonDecode(data); // gelen veriler jSon nesnesi olarak gelir.

      return currentTempurature = currentWeather['main']
          ['temp']; // jSon nesnesinde mainin altında temp var onu çağırdık.

    }

    WeatherDisplayData getWeatherDisplayData() {
      if (currentCondition < 600) {
        return WeatherDisplayData(
            weatherIcon:
                Icon(FontAwesomeIcons.cloud, size: 90.0, color: Colors.white),
            weatherImage: AssetImage('assets/cloudy.jpg'));
      } else {
        var now = new DateTime.now(); // get current time
        print(now.hour);
        if (now.hour > 16.41) {
          print(now.hour);
          return WeatherDisplayData(

              // if clock is greater that 17 means nightTime
              weatherIcon:
                  Icon(FontAwesomeIcons.moon, size: 90.0, color: Colors.white),
              weatherImage: AssetImage('assets/night.jpg'));
        } else {
          return WeatherDisplayData(
              // if clock is greater that 17 means nightTime
              weatherIcon:
                  Icon(FontAwesomeIcons.sun, size: 90.0, color: Colors.white),
              weatherImage: AssetImage('assets/sunny.jpg'));
        }
      }
    }
  }
}
