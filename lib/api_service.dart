import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> sendImageToAPI(String base64Image) async {
    String apiKey = "AIzaSyANpbN9KfJE0jtqylkBSHmLJysaZOrKxck";
    String apiUrl =
        "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$apiKey";

    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "inline_data": {"mime_type": "image/jpeg", "data": base64Image}
            },
            {
              "text":
                  "Analyze this food image and provide details such as calories, protein, and other nutritional information but don't write extra."
            }
          ]
        }
      ]
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      var json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return json['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return '';
      }
    } catch (e) {
      print("Exception: $e");
    }
    return '';
  }
}
