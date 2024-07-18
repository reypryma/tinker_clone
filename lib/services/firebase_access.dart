import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FirebaseAccessToken {
  static String firebaseMsgScope = "https://www.googleapis.com/auth/firebase.messaging";
  static String firebaseUserInfoEmailScope = "https://www.googleapis.com/auth/userinfo.email";
  static String firebaseDbScope = "https://www.googleapis.com/auth/firebase.database";

  // "https://www.googleapis.com/auth/firebase/firebase.messaging";
  Future<String> getAccessToken() async {

    try {
      final String serviceAccountJson = await rootBundle.loadString('assets/json/serviceAccountKey.json');
      log("read jsonString $serviceAccountJson");

      final client = await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson(
              /*
         Replace the placeholder JSON content in the code with the actual content
         from the generated private key JSON file.
        */
              //--------------------replace here--------------------//
              json.decode(serviceAccountJson)
              //---------------------------------------------------//
              ),
          [firebaseMsgScope, firebaseUserInfoEmailScope, firebaseDbScope]);

      // client.close();

      // final token = client.credentials.accessToken.data;
      // return token;
      AccessCredentials credentials = await obtainAccessCredentialsViaServiceAccount(ServiceAccountCredentials.fromJson(serviceAccountJson), [firebaseMsgScope, firebaseUserInfoEmailScope, firebaseDbScope], client);

      client.close();

      return credentials.accessToken.data;
    } catch (e) {
      print('Error getting token: $e');
      rethrow;
    }
  }
}
