class City{
  int? id ;
  String cityName;


  City({ this.id, required this.cityName});

  factory City.fromMap(Map<String, dynamic> record){
    return City(
        id: record['id'],
        cityName: record['cityName']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id':id,
      'name': cityName,
    };
  }
}

