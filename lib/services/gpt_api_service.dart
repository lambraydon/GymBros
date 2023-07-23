import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../screens/workoutRecommender/api_constants.dart';
import '../screens/workoutRecommender/recommended_model.dart';

class GPTApiService {
  final http.Client httpClient;

  GPTApiService({required this.httpClient});

  Future<RecommenderModel> sendMessage(
      {required String message, required String modelId}) async {
    try {
      String newMessage = "$message\n$CONDITION";
      var response = await httpClient.post(
        Uri.parse("$BASE_URL/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "temperature": 0.2,
            "messages": [
              {
                "role": "system",
                "content": PROMPT,
              },
              {"role": "user", "content": newMessage},
            ],
            "model": modelId,
            "max_tokens": 600,
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      // if (jsonResponse["choices"].length > 0) {
      //   log("jsonResponse[choices]text ${jsonResponse['choices'][0]['message']['content']}");
      // }

      Map output = jsonDecode(jsonResponse['choices'][0]['message']['content']);
      return RecommenderModel.fromJson(output);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
