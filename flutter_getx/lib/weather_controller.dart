import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherController extends GetxController {
  var cityName = "".obs;
  var temperature = "".obs;
  var icon = "".obs; // İkon URL'si için değişken
  var isLoading =
      false.obs; // Yükleniyor simgesinin gösterilmesi için kullanılacak.
  var cityHistory = <String, String>{}
      .obs; // Daha önce sorgulanan şehirleri ve sıcaklıkları tutan liste

  Future<void> fetchWeather(String city) async {
    // API'den veri çekmek için HTTP GET isteği yapar.
    try {
      isLoading.value = true; // Yükleniyor durumunu göster

      final apiKey = "f816b3ef3ed397d467163b43b9d607f3"; // API anahtarı
      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey";
      final response =
          await http.get(Uri.parse(url)); // API isteği HTTP ve GET isteği

      if (response.statusCode == 200) {
        // API'den gelen yanıtın durumu 200 (başarılı)
        final data = jsonDecode(response.body);

        // Sıcaklık bilgisini al
        double fetchedTemperature = data['main']['temp'];
        temperature.value = "${fetchedTemperature.toStringAsFixed(1)}°C";

        // İkon kodunu al ve URL oluştur
        final iconCode = data['weather'][0]['icon']; // İkon kodu
        final iconUrl = "https://openweathermap.org/img/wn/$iconCode@2x.png";
        icon.value = iconUrl; // İkon URL'sini atayın

        // Şehri geçmiş listesine ekle (tekrarları önlemek için kontrol)
        cityHistory[city] = temperature.value;
      } else {
        temperature.value = "Şehir bulunamadı!";
        icon.value = ""; // İkonu sıfırla
      }
    } catch (e) {
      temperature.value = "Bir hata oluştu!";
      icon.value = ""; // Hata durumunda ikonu sıfırla
    } finally {
      isLoading.value = false; // Yükleme durumu bitti
    }
  }
}
