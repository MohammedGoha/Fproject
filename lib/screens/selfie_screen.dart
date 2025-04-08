import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/theme.dart';
import '../utils/utils.dart';
import 'success_screen.dart';

class SelfieScreen extends StatefulWidget {
  @override
  _SelfieScreenState createState() => _SelfieScreenState();
}

class _SelfieScreenState extends State<SelfieScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _uploadImage() {
    uploadImage(
      context: context,
      image: _image,
      uploadUrl: 'http://192.168.1.5:5000/upload',
      nextScreen: SuccessScreen(), // Keep this as is
      filename: 'selfie.jpg',
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
      body: Container(
        color: desertSand,
        width: double.infinity, // Ensure the width fills the screen
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "الخطوة 3: صورة شخصية",
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
                    child: Image.file(
                      _image!,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
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
    );
  }}