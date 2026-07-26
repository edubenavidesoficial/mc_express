import 'package:mc_express/core/network/api_client.dart';

class ProfessionalDto {
  const ProfessionalDto({
    required this.id,
    required this.fullName,
    required this.category,
    required this.rating,
    required this.totalJobs,
    required this.basePrice,
  });

  final int id;
  final String fullName;
  final String category;
  final String rating;
  final int totalJobs;
  final String basePrice;

  factory ProfessionalDto.fromJson(Map<String, dynamic> json) {
    return ProfessionalDto(
      id: json['id'] as int,
      fullName: json['full_name'].toString(),
      category: json['category'].toString(),
      rating: json['rating'].toString(),
      totalJobs: json['total_jobs'] as int,
      basePrice: json['base_price'].toString(),
    );
  }
}

class ProfessionalsApi {
  ProfessionalsApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<ProfessionalDto>> list({int? categoryId}) async {
    final data = await _client.get(
      '/services/professionals',
      query: {'category_id': categoryId?.toString()},
    ) as List<dynamic>;
    return data
        .map((item) => ProfessionalDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
