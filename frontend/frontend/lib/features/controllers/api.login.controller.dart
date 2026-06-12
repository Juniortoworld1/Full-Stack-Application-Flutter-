import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiLogin {

  final String BASEURL = kIsWeb
      ? 'http://localhost:4000/api/v1/users/login'
      : (Platform.isAndroid
      ? 'http://10.0.2.2:4000/api/v1/users/login'
      : 'http://localhost:4000/api/v1/users/login');

  Future<Map<String, dynamic>> fetchdata(String username, String password) async {
    final Uri uri = Uri.parse(BASEURL) ;
    try{

      final Map<String , String > bodyData = {
        'password':password,
      };

      if(!username.contains('@')){
        bodyData['username'] = username ;
      }else{
        bodyData['email'] = username ;
      }

      print("🚀 Sending request to $BASEURL...");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json", // Tells backend JSON is coming
        },
        body: jsonEncode(bodyData), // Encodes map to JSON string
      );



      if (response.statusCode == 200) {
        // 1. Decode the raw response body string into a Map
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // 2. Safely extract the 'createdUser' data from the nested structure
        final Map<String,
            dynamic> userData = responseData['data']['createdUser'];

        print("🎉 Login Success! Welcome, ${userData['fullName']}");

        // Return the user data map so your UI can use it
        return userData;
      } else {

        print("❌ Server Error Body: ${response.body}");
        return {
          "success":false ,
          "message":"server error ${response.statusCode}"
        };
      }




    } catch(error){
      print("getting come error on api");

      return {
        "success":false ,
        "message":"Something went wrong . Please try again"
      } ;
    }
  }


}
