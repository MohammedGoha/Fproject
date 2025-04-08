import 'package:hive/hive.dart';

class CredentialService {
  static const _boxName = 'hl_credentials';
  static const _key = 'hyperledger_keys';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static bool hasCredentials() {
    final box = Hive.box(_boxName);
    return box.containsKey(_key);
  }

  static Map<String, String>? getCredentials() {
    final box = Hive.box(_boxName);
    final data = box.get(_key);
    if (data is Map<dynamic, dynamic>) {
      return Map<String, String>.from(data);
    }
    return null;
  }

  static Future<void> storeCredentials(String privateKey, String certificate) async {
    final box = Hive.box(_boxName);
    await box.put(_key, {
      'privateKey': privateKey.trim(),
      'certificate': certificate.trim(),
    });
  }

  static Future<void> storeFakeCredentials() async {
    await storeCredentials(
      '-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFA...\n-----END PRIVATE KEY-----',
      '-----BEGIN CERTIFICATE-----\nMIIDSTCCAjGgAwIBAgIUXZ6b7SvJkQm...\n-----END CERTIFICATE-----',
    );
  }

  static Future<void> clearCredentials() async {
    final box = Hive.box(_boxName);
    await box.delete(_key);
  }
}
