class City{
  String name;
  double latitude;
  double longitude;
  String? display_name;// Pour le champ AutoComplete

  City({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.display_name,
  });

  Map<String,dynamic> toJson(){
    return {
      "name": this.name,
      "latitude": this.latitude,
      "longitude": this.longitude,
    };
  }

  factory City.fromJson(Map<String,dynamic> json){
    return City(
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"]
    );
  }


}