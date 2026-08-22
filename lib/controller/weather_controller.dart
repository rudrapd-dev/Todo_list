import 'package:get/get.dart';
import 'package:todo_list/services/api_service.dart';

class WeatherController extends GetxController {
  final ApiService apiService = ApiService();

  Rxn<Map<String, dynamic>> weatherData =
      Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    getWeather();
  }

  Future<void> getWeather() async {
    final data = await apiService.weatherApi("Agartala");

    weatherData.value = data;
  }
}