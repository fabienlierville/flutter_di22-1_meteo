import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meteo/models/city.dart';

class GeocoderService {
  static Future<String> getCityFromCoordinates(
      {required double latitude, required double longitude}) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&accept-language=fr'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      if (json["address"]["town"] != null) {
        return json["address"]["town"];
      }
      return json["address"]["city"];
    } else {
      throw Exception("API OpenStreetMap error");
    }
  }

  static Future<List<City>> searchCity(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&accept-language=fr'),
    );
    if (response.statusCode == 200) {
      print(response.body);
      print('https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&accept-language=fr');
      List<dynamic> json = jsonDecode(response.body);
      return json.map((mapCity){
        return City(
            name: mapCity["name"],
            latitude: double.parse(mapCity["lat"]),
            longitude: double.parse(mapCity["lon"]),
            display_name: mapCity["display_name"]
        );
      }).toList();
    } else {
      throw Exception("Erreur API OSM");
    }
  }
}
