import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meteo/models/city.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Météo"),),
      body: Column(
        children: [],
      ),
    );
  }

  Future<void> getVilles() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonVille = prefs.getString("villes");
    if(jsonVille != null){
      List<dynamic> jsonList = jsonDecode(jsonVille);
      List<City> listeVille = jsonList.map((json) => City.fromJson(json)).toList();
      setState(() {
        villes = listeVille;
      });
    }


  }


}
