import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/theme.dart'; // Your Egyptian theme file
import '../services/credential_service.dart';
import '../screens/front_id_screen.dart';
import '../candidates/candidates.dart';

Future<void> uploadImage({
  required BuildContext context,
  required File? image,
  required String uploadUrl,
  required Widget nextScreen,
  required String filename,
}) async {
  if (image == null) {
    showSnackbar(context, "⚠️ يرجى اختيار صورة أولاً", errorRed);
    return;
  }

  bool isUploading = true;
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => EgyptianLoadingScreen(
        customMessage: "جاري رفع المستند...",
        onCancel: () {
          isUploading = false;
          Navigator.pop(context);
        },
      ),
    ),
  );

  try {
    final stream = http.ByteStream(image.openRead());
    final length = await image.length();

    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
      ..headers.addAll({'Accept': 'application/json'})
      ..files.add(http.MultipartFile(
        'photo',
        stream,
        length,
        filename: filename,
      ));

    final response = await request.send();

    if (!isUploading) return;

    Navigator.pop(context);

    if (response.statusCode == 200) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
            title: Text("تم بنجاح", style: TextStyle(color: successGreen)),
            content: Text("تم رفع المستند بنجاح", style: TextStyle(fontFamily: arabicFont)),
            actions: [
            TextButton(
            onPressed: () {
      Navigator.pop(_);
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
      );
      },
        child: Text("متابعة", style: TextStyle(color: nileBlue)),
            )],
      ),
  );
  } else {
  showSnackbar(context, "⚠️ فشل الرفع (${response.statusCode})", errorRed);
  }
  } catch (e) {
  if (!isUploading) return;
  Navigator.pop(context);
  showSnackbar(context, "⚠️ خطأ غير متوقع: ${e.toString()}", errorRed);
  }
}
/// Utility Functions

/// ======================
/// Optimized Loading Screen (No Time Limit)
/// ======================
class EgyptianLoadingScreen extends StatelessWidget {
  final String? customMessage;
  final VoidCallback? onCancel;

  const EgyptianLoadingScreen({super.key, this.customMessage, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: desertSand.withOpacity(0.95),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Egyptian-themed progress indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(gold),
                      backgroundColor: nileBlue.withOpacity(0.1),
                    ),
                  ),
                  Icon(Icons.how_to_vote, color: nileBlue, size: 32),
                ],
              ),
              const SizedBox(height: 24),

              // Arabic status messages
              Text(
                customMessage ?? "جاري المعالجة...", // "Processing..."
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: pharaohGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "سيتم الانتهاء قريباً", // "Will finish shortly"
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: secondaryText,
                ),
              ),
              const SizedBox(height: 24),

              // Cancel button (Arabic)
              if (onCancel != null)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: nileBlue),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onCancel,
                  child: Text(
                    "إلغاء", // "Cancel"
                    style: TextStyle(
                      color: nileBlue,
                      fontSize: 16,
                      fontFamily: arabicFont,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ======================
/// ======================
void showSnackbar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(fontFamily: arabicFont)),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
Future<void> checkCredentialsAndNavigate(BuildContext context) async {
  // Get credentials from Hive
  final credentials = CredentialService.getCredentials();

  if (credentials == null) {
    _showInvalidAlert(context);
    return;
  }

  try {
    // Send request to check credentials
    final response = await http.get(
      Uri.parse('http://192.168.1.5:5000/check-credentials'),
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'found') {
      // Navigate to ElectionScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ElectionScreen()),
      );
    } else {
      _showInvalidAlert(context);
    }
  } catch (error) {
    // Handle any errors (e.g., no server connection)
    _showInvalidAlert(context, "⚠️ لا يمكن الاتصال بالخادم");
  }
}

// Function to show alert and navigate to FrontIDScreen
void _showInvalidAlert(BuildContext context, [String? customMessage]) {
  final message = customMessage ?? "⚠️ لم يتم التحقق من الهوية، يرجى البدء من جديد";

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => FrontIDScreen()),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.amber,
    ),
  );
}
void showAlert(BuildContext context, String message, Color color) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "تنبيه",
          style: TextStyle(color: color),
        ),
        content: Text(
          message,
          style: TextStyle(color: color),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "حسنًا",
              style: TextStyle(color: color),
            ),
          ),
        ],
      );
    },
  );
}
