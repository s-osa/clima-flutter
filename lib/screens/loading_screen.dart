import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert' as convert;

import 'package:clima_flutter/services/location.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final String apiKey = env["OPEN_WEATHER_APP_ID"];

  double latitude;
  double longitude;

  void setLocation() async {
    Location location = Location();
    await location.getCurrentLocation();

    latitude = location.latitude;
    longitude = location.longitude;

    getData();
  }

  void getData() async {
    final url = "https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=${apiKey}";

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final String body = response.body;
      final json = convert.jsonDecode(body);

      double temperature = json['main']['temp'];
      int condition = json['weather'][0]['id'];
      String cityName = json['name'];

      print(temperature);
      print(condition);
      print(cityName);
    }
  }

  @override
  void initState() {
    super.initState();
    setLocation();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold();
  }
}
