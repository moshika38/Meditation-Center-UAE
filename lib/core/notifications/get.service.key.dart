import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';

class GetServiceKey {
  Future<String> getServiceKey() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    // Local .env load (only if exists)
    if (File('.env').existsSync()) {
      await dotenv.load(fileName: ".env");
    }

    // Helper to get variable from env or Codemagic environment
    String? env(String key) {
      return dotenv.env[key] ?? Platform.environment[key];
    }

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "meditation-center-44aad",
        "private_key_id": env('PRIVATE_KEY_ID'),
        "private_key": env('PRIVATE_KEY')?.replaceAll(r'\n', '\n'),
        "client_email": env('CLIENT_EMAIL'),
        "client_id": env('CLIENT_ID'),
        "auth_uri": env('AUTH_URI'),
        "token_uri": env('TOKEN_URI'),
        "auth_provider_x509_cert_url": env('AUTH_PROVIDER_X509_CERT_URL'),
        "client_x509_cert_url": env('CLIENT_X509_CERT_URL'),
        "universe_domain": "googleapis.com"
      }),
      scopes,
    );

    final accessServiceKey = client.credentials.accessToken.data;
    debugPrint("Service key is : $accessServiceKey");
    return accessServiceKey;
  }
}
