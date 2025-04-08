import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';

class IDProcessor {
  static Future<File?> detectAndCropID(File imageFile) async {
    try {
      // 1. Initialize text recognizer
      final textRecognizer = TextRecognizer();
      final inputImage = InputImage.fromFilePath(imageFile.path);

      // 2. Detect text to find ID card area
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      // Find the largest text block (likely the ID card)
      TextBlock? largestBlock;
      for (final block in recognizedText.blocks) {
        final area = (block.boundingBox?.width ?? 0) * (block.boundingBox?.height ?? 0);
        if (largestBlock == null || area > ((largestBlock.boundingBox?.width ?? 0) * (largestBlock.boundingBox?.height ?? 0))) {
          largestBlock = block;
        }
      }

      // 3. Initialize object detector for document detection
      final options = ObjectDetectorOptions(
        mode: DetectionMode.single,
        classifyObjects: true,
        multipleObjects: false,
      );
      final objectDetector = ObjectDetector(options: options);
      final List<DetectedObject> objects = await objectDetector.processImage(inputImage);

      // Find the largest document-like object
      DetectedObject? documentObject;
      for (final object in objects) {
        final area = (object.boundingBox?.width ?? 0) * (object.boundingBox?.height ?? 0);
        if (object.labels.any((label) => label.text.toLowerCase().contains('document')) ||
            object.labels.any((label) => label.text.toLowerCase().contains('card'))) {
          if (documentObject == null || area > ((documentObject.boundingBox?.width ?? 0) * (documentObject.boundingBox?.height ?? 0))) {
            documentObject = object;
          }
        }
      }

      // 4. Determine cropping area
      final Rect? cropRect = documentObject?.boundingBox ?? largestBlock?.boundingBox;

      if (cropRect == null) return imageFile; // Return original if no detection

      // 5. Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.6), // ID card ratio
        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop ID',
            toolbarColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop ID',
            cancelButtonTitle: 'Cancel',
            doneButtonTitle: 'Done',
          ),
        ],
        cropStyle: CropStyle.rectangle,
      );

      // 6. Clean up
      await textRecognizer.close();
      await objectDetector.close();

      return croppedFile != null ? File(croppedFile.path) : imageFile;
    } catch (e) {
      print('Error processing ID: $e');
      return imageFile; // Return original if error occurs
    }
  }
}
