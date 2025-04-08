import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../services/credential_service.dart';
import '../utils/utils.dart';
import './front_id_screen.dart';
import '../candidates/candidates.dart';
class SuccessScreen extends StatelessWidget {
  Future<void> _handleVerification(BuildContext context) async {
    // Generate fake credentials
    await CredentialService.storeFakeCredentials();

    // Check if credentials were properly stored
    if (CredentialService.hasCredentials()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ElectionScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FrontIDScreen()),
      );
      showSnackbar(
          context,
          "❌ فشل التحقق من الهوية، يرجى المحاولة مرة أخرى",
          errorRed
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _handleVerification(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildSuccessUI();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSuccessUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: successGreen, size: 100),
          SizedBox(height: 20),
          Text(
            "تم التحقق بنجاح!",
            style: TextStyle(fontSize: 24, fontFamily: arabicFont),
          ),
          SizedBox(height: 20),
          Text(
            "جاري تحميل بيانات التصويت...",
            style: TextStyle(fontSize: 16, fontFamily: arabicFont),
          )
        ],
      ),
    );
  }
}