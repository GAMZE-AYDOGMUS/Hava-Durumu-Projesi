import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'weather_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner:
          false, // Uygulamanın üstünde debug yazısını gizler.
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatelessWidget {
  final WeatherController controller = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hava Durumu Uygulaması"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              if (controller.icon.value.isNotEmpty) {
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.5),
                    BlendMode.color,
                  ),
                  child: Image.network(
                    controller.icon.value,
                    width: 200,
                    height: 200,
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            }),
            SizedBox(height: 20),

            TextField(
              onChanged: (value) {
                controller.cityName.value = value;
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  controller.fetchWeather(value);
                }
              },
              decoration: InputDecoration(
                labelText: "Şehir Adı",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            Obx(() {
              if (controller.isLoading.value) {
                return CircularProgressIndicator();
              } else {
                return Text(
                  controller.temperature.value,
                  style: TextStyle(fontSize: 24),
                );
              }
            }),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (controller.cityName.value.isNotEmpty) {
                  controller.fetchWeather(controller.cityName.value);
                }
              },
              child: Text("Hava Durumunu Getir"),
            ),
            SizedBox(height: 20),

            // Daha önce sorgulanan şehirler listesi
            Obx(() {
              if (controller.cityHistory.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daha Önce Sorgulanan Şehirler:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ...controller.cityHistory.entries
                        .map((entry) => Text("${entry.key}: ${entry.value}")),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
