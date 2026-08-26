import 'package:mc_express/core/network/api_client.dart';
import 'package:mc_express/core/storage/session_store.dart';

class AuthApi {
  AuthApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    final data =
        await _client.post('/auth/login', {
              'identifier': identifier,
              'password': password,
            })
            as Map<String, dynamic>;
    await _save(data);
  }

  Future<void> register({
    required String fullName,
    required String phone,
    required String password,
    String? email,
  }) async {
    final data =
        await _client.post('/auth/register', {
              'full_name': fullName,
              'phone': phone,
              'email': email?.isEmpty ?? true ? null : email,
              'password': password,
            })
            as Map<String, dynamic>;
    await _save(data);
  }

  Future<void> _save(Map<String, dynamic> data) async {
    final user = data['user'] as Map<String, dynamic>;
    await SessionStore.instance.saveSession(
      token: data['access_token'].toString(),
      userId: user['id'] as int,
      userName: user['name'].toString(),
      userPhone: user['phone']?.toString(),
      userEmail: user['email']?.toString(),
      userRole: user['role']?.toString(),
    );
  }
}
