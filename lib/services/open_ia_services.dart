import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const String _apiKey = "api_key_removed";
  static const String _baseUrl = "https://api.openai.com/v1/chat/completions";

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiKey",
      },
      body: jsonEncode({
        "model": "gpt-5.1",
        "messages": [
          {"role": "user", "content": message},
        ],
        "temperature": 0.5,
      }),
    );

    final data = jsonDecode(response.body);

    return data["choices"][0]["message"]["content"];
  }

  Future<String> analyzeImage(String base64Image) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o", // GPT-5.1 todavía no hace visión directa
        "messages": [
          {
            "role": "user",
            "content": [
              {"type": "text", "text": "Analyze this image"},
              {
                "type": "image_url",
                "image_url": "data:image/jpeg;base64,$base64Image",
              },
            ],
          },
        ],
      }),
    );

    final data = jsonDecode(response.body);

    return data["choices"][0]["message"]["content"];
  }
}
