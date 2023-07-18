import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../shared/apiConstants.dart';

class GPTApiService {
  // Send Message fct
  static Future<void> sendMessage(
      {required String message, required String modelId}) async {
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "messages": [
              {
                "role": "system",
                "content":
                    "You are a helpful assistant in a Gym Mobile Application that recommends workouts."
              },
              {"role": "user", "content": message}
            ],
            "model": modelId,
            "max_tokens": 100,
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }

      if (jsonResponse["choices"].length > 0) {
        log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
      }
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}

void main() async {
  try {
    await GPTApiService.sendMessage(
        message: "Recommend me a gym workout", modelId: "gpt-3.5-turbo");
  } catch (error) {
    print(error);
  }
}
