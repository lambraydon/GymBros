import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gymbros/screens/workoutRecommender/api_constants.dart';
import 'package:mockito/mockito.dart';
import 'package:gymbros/services/gpt_api_service.dart';
import 'package:gymbros/screens/workoutRecommender/recommended_model.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {
  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    const String responseBody = '''
      {
        "name": "Sample Workout",
        "description": "Sample description",
        "exercises": [
          {
            "name": "Exercise 1",
            "sets": [
              {"weight": 60.0, "reps": 10}
            ]
          }
        ]
      }
      ''';

    if (url.toString() == "$BASE_URL/completions") {
      return http.Response(responseBody, 200);
    } else {
      throw Exception('Unexpected URL: ${url.toString()}');
    }
  }
}

void main() {
  group('GPTApiService', () {
    final mockClient = MockClient();
    GPTApiService apiService = GPTApiService(httpClient: mockClient);

    test('sendMessage returns RecommenderModel', () async {
      // Call the sendMessage method and await the result
      final result = await apiService.sendMessage(
        message: "Recommend me a pull workout",
        modelId: "gpt-3.5-turbo",
      );

      // Verify that the http.post method was called with the correct arguments
      verify(mockClient.post(
        Uri.parse("$BASE_URL/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          'Content-Type': 'application/json',
        },
        body: argThat(isA<String>(), named: 'body'),
      ));

      // Verify that the result is of type RecommenderModel
      expect(result, isA<RecommenderModel>());

      // Verify that the model properties are parsed correctly
      expect(result.description, "Sample description");
      expect(result.workout.name, "Sample Workout");
      expect(result.workout.exercises, isEmpty);
    });

    test('sendMessage throws HttpException on error', () async {
      // Define the expected error response
      const errorResponse = '{"error": {"message": "Sample error"}}';
      final errorResponseObject = http.Response(errorResponse, 400);

      // Call the sendMessage method and expect an HttpException to be thrown
      expect(
        () async => await apiService.sendMessage(
          message: "Recommend me a pull workout",
          modelId: "gpt-3.5-turbo",
        ),
        throwsA(isInstanceOf<HttpException>()),
      );
    });
  });
}
