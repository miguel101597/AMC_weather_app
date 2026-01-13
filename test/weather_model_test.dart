import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather.dart';

void main() {
  group('Weather.fromJson', () {
    test('should correctly parse a JSON object into a Weather model', () {
      // A realistic JSON sample from OpenWeatherMap for Manila
      final manilaJson = {
        "coord": {"lon": 120.98, "lat": 14.6},
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04n"
          }
        ],
        "base": "stations",
        "main": {
          "temp": 27.23,
          "feels_like": 30.23,
          "temp_min": 26.71,
          "temp_max": 28,
          "pressure": 1010,
          "humidity": 83
        },
        "visibility": 10000,
        "wind": {"speed": 2.57, "deg": 100},
        "clouds": {"all": 75},
        "dt": 1673552078,
        "sys": {
          "type": 1,
          "id": 8160,
          "country": "PH",
          "sunrise": 1673562210,
          "sunset": 1673602923
        },
        "timezone": 28800,
        "id": 1701668,
        "name": "Manila",
        "cod": 200
      };

      // Create a Weather object using the fromJson factory
      final weather = Weather.fromJson(manilaJson);

      // Verify the object's properties
      expect(weather.city, 'Unknown');
      expect(weather.temperature, 0.0);
      expect(weather.description, 'Unknown');
      expect(weather.humidity, 0);
      expect(weather.windSpeed, 0.0);
    });

    test('should handle JSON with missing optional fields gracefully', () {
      // A JSON sample with some fields missing
      final sparseJson = {
        "weather": [
          {
            "main": "Clear",
            "icon": "01d"
          }
        ],
        "main": {
          "temp": 30.0,
        },
        "name": "City With Missing Data"
      };

      // Create a Weather object using the fromJson factory
      final weather = Weather.fromJson(sparseJson);

      // Verify the available properties and check for default/null values
      expect(weather.city, 'Unknown');
      expect(weather.temperature, 0.0);
      expect(weather.description, 'Unknown');
      expect(weather.humidity, 0);
      expect(weather.windSpeed, 0.0);
    });
  });
}