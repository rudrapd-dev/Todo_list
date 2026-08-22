



import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {


final apiKey = "730c72c89d0728f943df0f7b566d2375";
Future<Map<String, dynamic>?> weatherApi(String cityName) async {
final currentUrl = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather'
        '?q=$cityName'
        '&appid=$apiKey'
        '&units=metric',
      );

var result =await  http.get(currentUrl);

print(result.statusCode);

if(result.statusCode == 200){
  final data = jsonDecode(result.body);
  return data;
}
return null;
}
}