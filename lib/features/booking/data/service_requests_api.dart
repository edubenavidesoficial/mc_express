import 'package:mc_express/core/network/api_client.dart';
import 'package:mc_express/core/storage/session_store.dart';
import 'package:mc_express/features/booking/data/service_request_draft.dart';

class ServiceRequestsApi {
  ServiceRequestsApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<int> createRequest(ServiceRequestDraft draft) async {
    final userId = await SessionStore.instance.userId;
    if (userId == null) {
      throw Exception('Inicia sesion para solicitar un servicio');
    }
    final data = await _client.post('/services/requests', {
      'client_id': userId,
      'category_id': draft.categoryId,
      'professional_id': draft.professionalId,
      'description': draft.description ??
          'Solicitud de ${draft.categoryName} creada desde la app.',
      'address': draft.address ?? 'Ubicacion actual del cliente',
      'latitude': -2.170998,
      'longitude': -79.922359,
      'estimated_price': draft.estimatedPrice,
    }) as Map<String, dynamic>;
    return data['id'] as int;
  }

  Future<List<ServiceRequestDto>> listMine() async {
    final userId = await SessionStore.instance.userId;
    if (userId == null) return const [];
    final data = await _client.get(
      '/services/requests',
      query: {'client_id': userId.toString()},
    ) as List<dynamic>;
    return data
        .map((item) => ServiceRequestDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ServiceRequestDto> detail(int requestId) async {
    final data =
        await _client.get('/services/requests/$requestId') as Map<String, dynamic>;
    return ServiceRequestDto.fromJson(data);
  }

  Future<double> walletBalance() async {
    final userId = await SessionStore.instance.userId;
    if (userId == null) return 0;
    final data = await _client.get('/services/wallet/$userId') as Map<String, dynamic>;
    return double.tryParse(data['balance'].toString()) ?? 0;
  }

  Future<List<WalletTransactionDto>> walletTransactions() async {
    final userId = await SessionStore.instance.userId;
    if (userId == null) return const [];
    final data = await _client.get('/services/wallet/$userId/transactions') as List<dynamic>;
    return data
        .map((item) => WalletTransactionDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> rechargeWallet(double amount) async {
    final userId = await SessionStore.instance.userId;
    if (userId == null) throw Exception('Inicia sesion para recargar');
    await _client.post('/services/wallet/recharge', {
      'user_id': userId,
      'amount': amount,
      'reference': 'app_mobile',
    });
  }

  Future<void> payWithWallet({required int requestId, required double amount}) async {
    final userId = await SessionStore.instance.userId;
    if (userId == null) throw Exception('Inicia sesion para pagar');
    await _client.post('/services/wallet/pay', {
      'user_id': userId,
      'service_request_id': requestId,
      'amount': amount,
    });
  }

  Future<void> registerPayment({
    required int requestId,
    required double amount,
    required String method,
  }) async {
    await _client.post('/services/requests/$requestId/payments', {
      'amount': amount,
      'method': method,
      'status': 'paid',
    });
  }

  Future<void> review({
    required int requestId,
    required int professionalId,
    required int rating,
    String? comment,
  }) async {
    final userId = await SessionStore.instance.userId;
    if (userId == null) throw Exception('Inicia sesion para calificar');
    await _client.post('/services/requests/$requestId/reviews', {
      'client_id': userId,
      'professional_id': professionalId,
      'rating': rating,
      'comment': comment,
    });
  }
}

class ServiceRequestDto {
  const ServiceRequestDto({
    required this.id,
    required this.status,
    required this.category,
    required this.description,
    required this.address,
    required this.createdAt,
    this.professionalId,
    this.professionalName,
    this.estimatedPrice,
  });

  final int id;
  final String status;
  final String category;
  final String description;
  final String address;
  final String createdAt;
  final int? professionalId;
  final String? professionalName;
  final double? estimatedPrice;

  factory ServiceRequestDto.fromJson(Map<String, dynamic> json) {
    return ServiceRequestDto(
      id: json['id'] as int,
      status: json['status'].toString(),
      category: json['category'].toString(),
      description: json['description'].toString(),
      address: json['address'].toString(),
      createdAt: json['created_at'].toString(),
      professionalId: json['professional_id'] as int?,
      professionalName: json['professional_name']?.toString(),
      estimatedPrice: json['estimated_price'] == null
          ? null
          : double.tryParse(json['estimated_price'].toString()),
    );
  }
}

class WalletTransactionDto {
  const WalletTransactionDto({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
    this.reference,
  });

  final int id;
  final double amount;
  final String type;
  final String status;
  final String createdAt;
  final String? reference;

  factory WalletTransactionDto.fromJson(Map<String, dynamic> json) {
    return WalletTransactionDto(
      id: json['id'] as int,
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      type: json['type'].toString(),
      status: json['status'].toString(),
      reference: json['reference']?.toString(),
      createdAt: json['created_at'].toString(),
    );
  }
}
