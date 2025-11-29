import 'package:dio/dio.dart';

class DominosCounter {
  final dio = Dio();

  Future<int> getDominosPointFromImg(String base64Image) async {
    final apiKey = "";

    final response = await dio.post(
      "https://serverless.roboflow.com/dominoe-pips/9",
      queryParameters: {
        "api_key": apiKey,
        "confidence": 50.0,
        "threshold": 50.0,
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
