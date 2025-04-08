import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final List<String> funnyTexts = [
    "Uploading... Don't blink! 👀",
    "Hold on tight! 🚀",
    "Sending data to the moon 🌙",
    "Almost there... Just kidding, keep waiting 😆",
    "Making your ID famous on the blockchain 📜"
  ];
  late String selectedText;

  @override
  void initState() {
    super.initState();
    selectedText = funnyTexts[Random().nextInt(funnyTexts.length)];

    // 🔹 Wait for 5 seconds before moving to the next screen.
    // To make it wait for API response instead, remove this delay.
    Timer(Duration(seconds: 5), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(selectedText, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
