import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/theme.dart';
import '../utils/utils.dart';
import 'back_id_screen.dart';
import '../services/id_processor.dart';

class FrontIDScreen extends StatefulWidget {
  @override
  _FrontIDScreenState createState() => _FrontIDScreenState();
}

class _FrontIDScreenState extends State<FrontIDScreen> {
  File? _image;
  bool _isProcessing = false;

  Future<void> _pickImage() async {
    setState(() => _isProcessing = true);
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final processedImage = await IDProcessor.detectAndCropID(File(pickedFile.path));
        setState(() {
          _image = processedImage;
          _isProcessing = false;
        });
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      showAlert(context, "⚠️ خطأ في معالجة الصورة", Colors.red);
    }
  }

  void _uploadImage() {
    if (_image == null) {
      showAlert(context, "⚠️ لم يتم اختيار صورة!", Colors.red);
      return;
    }

    uploadImage(
      context: context,
      image: _image,
      uploadUrl: 'http://192.168.1.5:5000/upload',
      nextScreen: BackIDScreen(),
      filename: 'front_id.jpg',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: nileBlue,
        title: Image.asset('lib/assets/logo.png', height: 40),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            color: desertSand,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "الخطوة 1: تصوير وجه البطاقة",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: pharaohGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  _image != null
                      ? Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: gold, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _image!,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _pickImage,
                            style: secondaryButtonStyle.copyWith(
                              backgroundColor: MaterialStateProperty.all(errorRed),
                            ),
                            child: Text("إعادة الالتقاط"),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: _uploadImage,
                            style: primaryButtonStyle,
                            child: Text("رفع الصورة"),
                          ),
                        ],
                      ),
                    ],
                  )
                      : ElevatedButton(
                    onPressed: _pickImage,
                    style: primaryButtonStyle.copyWith(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      ),
                    ),
                    child: Text(
                      "فتح الكاميرا",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: gold),
                    SizedBox(height: 20),
                    Text("جاري معالجة الصورة...",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}