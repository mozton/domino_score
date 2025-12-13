import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DominosCounter {
  final dio = Dio();

  Future<int> getDominosPointFromImg(String base64Image) async {
    final apiKey = dotenv.env['ROBOFLOW_API_KEY'] ?? "";

    final response = await dio.post(
      "https://serverless.roboflow.com/dominoe-pips-tachy/1",
      queryParameters: {
        "api_key": apiKey,
        "confidence": 70.0,
        "threshold": 70.0,
      },
      data: base64Image,
      options: Options(
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    num total = 0;

    for (var dominos in response.data['predictions']) {
      total += dominos["class_id"];
    }

    return total.toInt();
  }
}
