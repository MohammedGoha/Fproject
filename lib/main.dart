import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/image_service.dart';
import 'screens/front_id_screen.dart';
import './candidates/candidates.dart';
import 'services/credential_service.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and credentials
  await Hive.initFlutter();
  await CredentialService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImageService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ID Verification',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    return CredentialService.hasCredentials()
        ? ElectionScreen()
        : FrontIDScreen();
  }
}