import 'weather_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String selectedCity = 'Howrah'; // default city
  final List<String> cities = [
    'Asansol',
    'Gurugram',
    'Raiganj',
    'Howrah',
    'Siliguri',
    'Mumbai',
    'Delhi',
    'Bengaluru',
    'Kolkata',
    'Chennai',
    'Hyderabad',
    'Pune',
    'Ahmedabad',
    'Jaipur',
    'Lucknow',
    'Kanpur',
    'Nagpur',
    'Indore',
    'Thane',
    'Bhopal',
    'Visakhapatnam',
    'Patna',
    'Vadodara',
    'Ghaziabad',
    'Ludhiana',
    'Guru',
  ];

  Future<Map<String, dynamic>> getCurrentWeather() async {
    return await WeatherService.getCurrentWeather(selectedCity);
  }

  // icon display
  String getWeatherIcon(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains("rain")) return "🌧️";
    if (condition.contains("cloud")) return "☁️";
    if (condition.contains("clear")) return "☀️";
    if (condition.contains("snow")) return "❄️";
    if (condition.contains("storm") || condition.contains("thunder")) {
      return "⛈️";
    }
    return "🌡️"; // default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  // getCurrentWeather();  // ! unnecessary since setstate triggers FutureBuilder
                });
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState
                  .waiting) // refers to loading state before getting data from api
          {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
            // displays error
          }

          final data = snapshot.data!; // ! means non nullable
          final currentWeatherData = data['list'][0]['main'];
          final currentTemp = (currentWeatherData['temp'] as num).toDouble();
          final pressure = (currentWeatherData['pressure'] as num).toDouble();
          final windSpeed = (data['list'][0]['wind']['speed'] as num)
              .toDouble();
          final mainWeather = data['list'][0]['weather'][0]['main'];
          final humidity = (currentWeatherData['humidity'] as num).toDouble();

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 19,
              right: 19,
              top: 19,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom +
                  19, // adjust for keyboard
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return cities.where(
                      (city) => city.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                    );
                  },
                  onSelected: (value) {
                    setState(() {
                      selectedCity = value;
                    });
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onEditingComplete) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          decoration: InputDecoration(
                            hintText: 'Select city',
                            filled: true,
                            fillColor: Color.fromARGB(255, 24, 28, 36),
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        );
                      },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Material(
                      color: Color.fromARGB(255, 24, 28, 36),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: options
                            .map(
                              (option) => ListTile(
                                title: Text(
                                  option,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () => onSelected(option),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // Show selected city
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    selectedCity,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: const Color.fromARGB(255, 24, 28, 36),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "$currentTemp°C",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            getWeatherIcon(mainWeather),
                            style: TextStyle(fontSize: 50),
                          ),

                          Text(
                            '$mainWeather',
                            style: TextStyle(fontSize: 19.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hourly Forecast',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < 10; i++)
                        HourlyForecastItem(
                          icon: getWeatherIcon(
                            data['list'][i + 1]['weather'][0]['main'],
                          ),
                          time: DateFormat.jm().format(
                            DateTime.parse(data['list'][i + 1]['dt_txt']),
                          ),
                          value:
                              "${data['list'][i + 1]['main']['temp'].toString()}°C",
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Additional Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalItem(
                      icon: '💧',
                      label: 'Humidity',
                      value: '$humidity',
                    ),
                    AdditionalItem(
                      icon: '💨',
                      label: 'Wind Speed',
                      value: '$windSpeed',
                    ),
                    AdditionalItem(
                      icon: '⏲️',
                      label: 'Pressure',
                      value: '$pressure',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
