import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  SessionStore._();

  static final SessionStore instance = SessionStore._();

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _userNameKey = 'user_name';
  static const _userPhoneKey = 'user_phone';
  static const _userEmailKey = 'user_email';
  static const _userRoleKey = 'user_role';

  Future<String?> get token async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<int?> get userId async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<String?> get userName async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  Future<String?> get userPhone async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhoneKey);
  }

  Future<String?> get userEmail async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<String?> get userRole async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  Future<bool> get isLoggedIn async => (await token) != null;

  Future<void> saveSession({
    required String token,
    required int userId,
    required String userName,
    String? userPhone,
    String? userEmail,
    String? userRole,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_userNameKey, userName);
    if (userPhone == null || userPhone.isEmpty) {
      await prefs.remove(_userPhoneKey);
    } else {
      await prefs.setString(_userPhoneKey, userPhone);
    }
    if (userEmail == null || userEmail.isEmpty) {
      await prefs.remove(_userEmailKey);
    } else {
      await prefs.setString(_userEmailKey, userEmail);
    }
    await prefs.setString(_userRoleKey, userRole ?? 'client');
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userRoleKey);
  }
}
