import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherService {
  // Fetch weather for a given city
  static Future<Map<String, dynamic>> getCurrentWeather(String cityName) async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherAPIKey&units=metric',
        ),
      );
      final data = jsonDecode(res.body);
      if (int.tryParse(data['cod'].toString()) != 200) {
        throw 'An unexpected error occurred';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }
}
