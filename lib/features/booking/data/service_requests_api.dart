import 'package:mc_express/core/network/api_client.dart';
import 'package:mc_express/core/storage/session_store.dart';

class ServiceRequestsApi {
  ServiceRequestsApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<int> createPlumbingRequest() async {
    final userId = await SessionStore.instance.userId;
    if (userId == null) {
      throw Exception('Inicia sesion para solicitar un servicio');
    }
    final data = await _client.post('/services/requests', {
      'client_id': userId,
      'category_id': 3,
      'professional_id': 1,
      'description':
          'Fuga debajo del lavamanos. Requiere revision de tuberia y llave de paso.',
      'address': 'Ubicacion actual del cliente',
      'latitude': -2.170998,
      'longitude': -79.922359,
      'estimated_price': 28.00,
    }) as Map<String, dynamic>;
    return data['id'] as int;
  }
}
