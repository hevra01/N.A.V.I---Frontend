import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'location.dart';

const ApiKey = "f8ac1e165a26eca0c929ce905e2e7c0c";

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

      currentTempurature = currentWeather['main']
          ['temp']; // jSon nesnesinde mainin altında temp var onu çağırdık.

    }
  }
}
