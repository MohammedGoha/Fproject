import 'dart:io';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ApiService {
  static Future<bool> uploadImage(String url, File image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // static Future<File?> saveImageLocally(File image, String filename) async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     print("Directory path: ${directory.path}");

  //     final localPath = "${directory.path}/$filename";
  //     final localFile = File(localPath);
  //     await image.copy(localFile.path);

  //     print("Image saved at: $localPath");
  //     return localFile;
  //   } catch (e) {
  //     print("Error saving image: $e");
  //     return null;
  //   }
  // }
  static Future<String> saveImageLocally(File image, String filename) async {
    try {
      final directory =
          await getApplicationDocumentsDirectory(); // Get storage path
      final localPath = '${directory.path}/$filename'; // Create full path

      await image.copy(localPath); // Save the image

      return localPath; // Return saved file path
    } catch (e) {
      print("Error saving image: $e");
      return ""; // Return empty string if save fails
    }
  }

  static Future<String?> saveImageToDCIM(File image, String filename) async {
    try {
      // Request storage permission (Android 10 and below)
      if (await Permission.storage.request().isGranted) {
        Directory? directory =
            Directory('/storage/emulated/0/DCIM'); // DCIM path

        if (!directory.existsSync()) {
          directory.createSync(recursive: true); // Ensure the directory exists
        }

        final String localPath = '${directory.path}/$filename'; // Full path
        await image.copy(localPath); // Save the file

        return localPath; // Return saved file path
      } else {
        print("Permission denied to save in DCIM.");
        return null;
      }
    } catch (e) {
      print("Error saving image: $e");
      return null;
    }
  }
}
