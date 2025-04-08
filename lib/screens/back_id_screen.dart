import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/theme.dart'; // Make sure these colors and styles are defined in this file
import '../utils/utils.dart';
import 'selfie_screen.dart';

class BackIDScreen extends StatefulWidget {
  @override
  _BackIDScreenState createState() => _BackIDScreenState();
}

class _BackIDScreenState extends State<BackIDScreen> {
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
      nextScreen: SelfieScreen(),
      filename: 'back_id.jpg',
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
                "الخطوة 2: تصوير ظهر البطاقة", // Arabic text
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: pharaohGreen,
                ),
              ),
              SizedBox(height: 30),
              _image != null
                  ? Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: gold, width: 2), // Ensure gold is defined
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
                          backgroundColor: MaterialStateProperty.all(errorRed), // Ensure errorRed is defined
                        ),
                        child: Text("إعادة الالتقاط"),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _uploadImage,
                        style: primaryButtonStyle, // Ensure this style is defined
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