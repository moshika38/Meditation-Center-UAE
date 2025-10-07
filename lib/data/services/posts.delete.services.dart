import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class _CloudinaryConfig {
  String? cloudName;
  String? apiKey;
  String? apiSecret;
  bool isLoaded = false;
}

final _config = _CloudinaryConfig();

class PostsDeleteServices {
  static Future<bool> _loadEnvironmentVariables() async {
    if (_config.isLoaded) return true;

    try {
      if (File('.env').existsSync()) {
        await dotenv.load(fileName: ".env");
      }

      _config.cloudName = dotenv.get('CLOUDINARY_CLOUD_NAME');
      _config.apiKey = dotenv.get('CLOUDINARY_API_KEY');
      _config.apiSecret = dotenv.get('CLOUDINARY_API_SECRET');

      if (_config.apiKey == null ||
          _config.apiSecret == null ||
          _config.cloudName == null) {
        throw Exception(
            "One or more Cloudinary keys are missing from the environment.");
      }

      _config.isLoaded = true;
      debugPrint("DEBUG: Cloudinary Keys loaded successfully.");
      return true;
    } catch (e) {
      debugPrint(
          '🚨 ENVIRONMENT ERROR: Failed to load Cloudinary keys. Check .env file or CI/CD vars. $e');
      _config.isLoaded = false;
      return false;
    }
  }

  static Map<String, String> _getAuthHeader() {
    final auth = '${_config.apiKey!}:${_config.apiSecret!}';
    final encodedAuth = base64Encode(utf8.encode(auth));
    return {'Authorization': 'Basic $encodedAuth'};
  }

  static Future<bool> deleteFolderAssets(String folderPrefix) async {
    if (!await _loadEnvironmentVariables()) return false;

    final prefix = 'posts/$folderPrefix/';
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/${_config.cloudName!}/resources/image/upload?prefix=$prefix&invalidate=true');

    try {
      final response = await http.delete(
        url,
        headers: _getAuthHeader(),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final deletedImageCount = responseBody['deleted_counts']?['image'] ?? 0;

        if (deletedImageCount > 0) {
          debugPrint(
              '✅ Successfully deleted $deletedImageCount images from $folderPrefix.');
          return true;
        } else {
          debugPrint(
              '⚠️ 200 OK, but no images were found or deleted. Folder may already be empty.');
          return true;
        }
      } else {
        debugPrint('❌ Failed to delete assets. Status: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('🚨 Error during asset deletion: $e');
      return false;
    }
  }

  static Future<bool> deleteEmptyFolder(String folderName) async {
    if (!await _loadEnvironmentVariables()) return false;

    final fullFolderPath = 'posts/$folderName';

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/${_config.cloudName!}/folders/$fullFolderPath');

    try {
      final response = await http.delete(
        url,
        headers: _getAuthHeader(),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Successfully deleted the folder: $fullFolderPath');
        return true;
      } else {
        debugPrint('❌ Failed to delete folder. Status: ${response.statusCode}');
        if (response.statusCode == 400 &&
            response.body.contains('Folder is not empty')) {
          debugPrint(
              '💡 Note: The folder is not considered empty (perhaps due to derived images or backups).');
        }
        return false;
      }
    } catch (e) {
      debugPrint('🚨 Error during folder deletion: $e');
      return false;
    }
  }
}
