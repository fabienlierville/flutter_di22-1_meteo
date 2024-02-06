import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meteo/models/city.dart';
import 'package:meteo/models/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<City> villes = [];
  City? villeChoisie;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("${DeviceInfo.latitude},${DeviceInfo.longitude}");
    getVilles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Météo"),
      ),
      body: Column(
        children: [
          FilledButton(
              onPressed: () async {
                print(villes);
                await supprimer("Rouen");
                print(villes);
              },
              child: Text("Ajouter une ville"))
        ],
      ),
    );
  }

  Future<void> getVilles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonVille = prefs.getString("villes");
    if (jsonVille != null) {
      List<dynamic> jsonList = jsonDecode(jsonVille);
      List<City> listeVille =
          jsonList.map((json) => City.fromJson(json)).toList();
      setState(() {
        villes = listeVille;
      });
    }
  }

  Future<void> ajouter(String nom, double latitude, double longitude) async {
    bool villeExistante = villes.any((city) => city.name == nom);
    if (villeExistante) {
      return;
    }

    City nouvelleVille =
        City(name: nom, latitude: latitude, longitude: longitude);
    villes.add(nouvelleVille);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList =
        villes.map((city) => city.toJson()).toList();
    await prefs.setString("villes", jsonEncode(jsonList));
    await getVilles(); // Récupère + refresh VUE
  }

  Future<void> supprimer(String nom) async {
    // [ {"name":"Rouen"}, {},{}]
    int indexVille = villes.indexWhere((city) => city.name == nom);
    if (indexVille != -1) {
      villes.removeAt(indexVille);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> jsonList =
          villes.map((city) => city.toJson()).toList();
      await prefs.setString("villes", jsonEncode(jsonList));
      await getVilles(); // Récupère + refresh VUE
    }
  }
}
