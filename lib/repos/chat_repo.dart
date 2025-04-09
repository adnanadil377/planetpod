import "dart:developer";

import "package:dio/dio.dart";
import "package:planets_pod/models/chat_message_model.dart";
import "package:planets_pod/utils/constants.dart";

class ChatRepo {
  static Future<String> chatTextGenerationRepo(
      List<ChatMessageModel> previousMessages) async {
    try {
      Dio dio = Dio();
      final response = await dio.post(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=${apiKey}",
          data: {
            "contents": previousMessages.map((e) => e.toMap()).toList(),
            "systemInstruction": {
              "role": "user",
              "parts": [
                {
                  "text":
                      "give me short answer in a friendly way, tell things only related to space"
                }
              ]
            },
            "generationConfig": {
              "temperature": 1,
              "topK": 64,
              "topP": 0.95,
              "maxOutputTokens": 8192,
              "responseMimeType": "text/plain"
            }
          });
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response
            .data['candidates'].first['content']['parts'].first['text'];
      }
      return '';
    } catch (e) {
      log(e.toString());
      return '';
    }
  }
}
