import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:navi/pages/navigation.dart';
import 'package:navi/utils/location.dart';
import 'package:navi/utils/weather.dart';
import 'package:navi/utils/weatherFetch.dart';

class MockLocationHelper extends Mock implements LocationHelper {}

class MockWeatherData extends Mock implements WeatherData {}



void main() {
  testWidgets('weatherPopUp displays weather data correctly',

          (WidgetTester tester) async {
        // Mock location data and weather data
        final locationHelper = MockLocationHelper();
        final weatherData = MockWeatherData();
        when(getLocationData()).thenAnswer((_) async => locationHelper);
        when(getWeatherData(locationHelper))
            .thenAnswer((_) async => weatherData);
        when(weatherData.currentTempurature).thenReturn(15);

        // Build the widget tree
        await tester.pumpWidget(MaterialApp(home: Navigation()));

        // Tap the start navigation button
        await tester.tap(find.text('Start Navigation'));
        await tester.pumpAndSettle();

        // Tap the weather button
        await tester.tap(find.byIcon(Icons.cloud));
        await tester.pumpAndSettle();

        // Check if the weather pop up is displayed correctly
        expect(find.text('Weather Data'), findsOneWidget);
        expect(find.text('The temperature is 15 degrees Celsius'), findsOneWidget);
      });
}

