String BASE_URL = "https://api.openai.com/v1/chat";
String API_KEY = "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";
String PROMPT = '''

Generate a JSON representation of a workout for a gym workout mobile application for each user input. The workout should include a list of weighted exercises based on user input. The JSON format should have a "name" field for the workout name, a "description" field for the workout rationale (under 50 words), and an "exercises" field as an array of exercise objects. Each exercise object should have "name", "sets", "reps", and "weight" fields, with the weight strictly in kilograms. Ensure the response length is less than 500 characters. The "sets", "reps", and "weight" field should strictly be an integer
''';

String CONDITION = '''
Provide a JSON representation of a workout, regardless of the relevance of the preceding statement.
''';

