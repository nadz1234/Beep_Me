import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyUsername = 'username';
  static const _KeyPassword = 'password';
  static const _KeyBearerToken = 'bearer_token';
  static const _KeyUserImage = 'user_image';

  static const _keyUserClient = 'user_Client';
  static const _KeyUserClientId = 'user_clientId';
  static const _KeyUserMemberId = 'user_memberId';
  static const _KeyUserIsImpersonating = 'isImpersonating';
  static const _KeyIsAdministrator = 'isAdministrator';
  static const _KeyFcmToken = 'fcmToken';

  static Future setUsername(String username) async {
    await _storage.write(key: _keyUsername, value: username);
  }

  static Future<String?> getUsername() async {
    await _storage.read(key: _keyUsername);
  }

  static Future setPassword(String password) async {
    await _storage.write(key: _KeyPassword, value: password);
  }

  static Future<String?> getPassword() async {
    await _storage.read(key: _KeyPassword);
  }

  static Future setBearertoken(String bearerToken) async {
    await _storage.write(key: _KeyBearerToken, value: bearerToken);
  }

  static Future<String?> getBearertoken() async {
    await _storage.read(key: _KeyBearerToken);
  }

  static Future setUserImage(String image) async {
    await _storage.write(key: _KeyUserImage, value: image);
  }

  static Future<String?> getUserImage() async {
    await _storage.read(key: _KeyUserImage);
  }

  static Future setUserClient(String client) async {
    await _storage.write(key: _keyUserClient, value: client);
  }

  static Future<String?> getUserClient() async {
    await _storage.read(key: _keyUserClient);
  }

  static Future setUserClientId(String clientId) async {
    await _storage.write(key: _KeyUserClientId, value: clientId);
  }

  static Future<String?> getUserClientId() async {
    await _storage.read(key: _KeyUserClientId);
  }

  static Future setUserMemberId(String memberId) async {
    await _storage.write(key: _KeyUserMemberId, value: memberId);
  }

  static Future<String?> getUserMemberId() async {
    await _storage.read(key: _KeyUserMemberId);
  }

  static Future setUserImpersonating(String clientId) async {
    await _storage.write(key: _KeyUserIsImpersonating, value: clientId);
  }

  static Future<String?> getUserImpersonating() async {
    await _storage.read(key: _KeyUserIsImpersonating);
  }

  static Future setUserAdministrator(String admin) async {
    await _storage.write(key: _KeyIsAdministrator, value: admin);
  }

  static Future<String?> getUserAdministrator() async {
    await _storage.read(key: _KeyIsAdministrator);
  }

  static Future setUserFcmToken(String fcm) async {
    await _storage.write(key: _KeyFcmToken, value: fcm);
  }

  static Future<String?> getUserFcmToken() async {
    await _storage.read(key: _KeyFcmToken);
  }
}
