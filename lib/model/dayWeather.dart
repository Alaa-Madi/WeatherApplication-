class DayWeather {
  final String date;
  final double high;
  final double low;
  final String icon;
  final String condition;

  DayWeather({
    required this.date,
    required this.high,
    required this.low,
    required this.icon,
    required this.condition,
  });

  factory DayWeather.fromJson(Map<String, dynamic> json) {
    return DayWeather(
      // dayNumber: json['date_epoch'],
      date: json['date'],
      high: json['day']['maxtemp_c'],
      low: json['day']['mintemp_c'],
      condition: json['day']['condition']['text'],
      icon: json['day']['condition']['icon'],
    );
  }
}