import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // Needed for kIsWeb

class ApiHandler  {
  final String baseUrl = 'http://localhost:4000/api/v1/users/register';

  Future<Map<String, dynamic>> sendInputFields({
    required String fullName,
    required String email,
    required String userName,
    required String password,
    required XFile? avatar,
    required XFile? coverImage,
  })
  async {

    final Uri url = Uri.parse(baseUrl);

    try {
      // 1. Create a Multipart Request instead of a standard JSON POST
      final request = http.MultipartRequest('POST', url);

      // 2. Add your text fields
      request.fields['fullName'] = fullName;
      request.fields['email'] = email;
      request.fields['username'] = userName;
      request.fields['password'] = password;

      // 3. Add the Avatar Image file (if it exists)
      if (avatar != null) {
        if (kIsWeb) {
          // Web handling: read file as raw bytes
          final bytes = await avatar.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'avatar',
            bytes,
            filename: avatar.name,
          ));
        } else {
          // Mobile/Desktop handling: read file from local path
          request.files.add(await http.MultipartFile.fromPath(
            'avatar',
            avatar.path,
          ));
        }
      }

      // 4. Add the Cover Image file (if it exists)
      if (coverImage != null) {
        if (kIsWeb) {
          final bytes = await coverImage.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'coverImage',
            bytes,
            filename: coverImage.name,
          ));
        } else {
          request.files.add(await http.MultipartFile.fromPath(
            'coverImage',
            coverImage.path,
          ));
        }
      }

      // 5. Send the request and wait for the streamed response
      print("🚀 Sending request to $baseUrl...");
      final http.StreamedResponse streamedResponse = await request.send();

      // 6. CAPTURE THE RESPONSE: Convert the stream back into a readable string
      final String responseBody = await streamedResponse.stream.bytesToString();

      // 7. PRINT THE RESPONSE: See exactly what the backend returned
      print("📥 Raw Backend Response Status Code: ${streamedResponse.statusCode}");
      print("📥 Raw Backend Response Body: $responseBody");

      // 8. Try parsing the response body into a Map
      Map<String, dynamic> parsedResponse;
      try {
        parsedResponse = jsonDecode(responseBody) as Map<String, dynamic>;
      } catch (e) {
        // Fallback in case your backend sends raw text instead of valid JSON
        parsedResponse = {'rawText': responseBody};
      }

      // 9. Return the final result
      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        return parsedResponse;
      } else {
        return {
          'success': false,
          'message': 'Server returned error status: ${streamedResponse.statusCode}',
          'data': parsedResponse,
        };
      }

    } catch (e) {
      print("❌ Connection Error: ${e.toString()}");
      return {
        'success': false,
        'message': 'Failed to connect to backend',
        'error': e.toString(),
      };
    }
  }
}