import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinarySdk {
  static final cloudinary = Cloudinary.full(
    apiKey: dotenv.env['CLOUDINARY_API_KEY']!,
    apiSecret: dotenv.env['CLOUDINARY_API_SECRET']!,
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!,
  );
}
