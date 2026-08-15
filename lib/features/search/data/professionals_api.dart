import 'package:mc_express/core/network/api_client.dart';

class CategoryDto {
  const CategoryDto({required this.id, required this.name, this.icon});

  final int id;
  final String name;
  final String? icon;

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: json['id'] as int,
      name: json['name'].toString(),
      icon: json['icon']?.toString(),
    );
  }
}

class ProfessionalDto {
  const ProfessionalDto({
    required this.id,
    required this.categoryId,
    required this.fullName,
    required this.category,
    required this.rating,
    required this.totalJobs,
    required this.basePrice,
  });

  final int id;
  final int categoryId;
  final String fullName;
  final String category;
  final String rating;
  final int totalJobs;
  final String basePrice;

  factory ProfessionalDto.fromJson(Map<String, dynamic> json) {
    return ProfessionalDto(
      id: json['id'] as int,
      categoryId: json['category_id'] as int,
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

  Future<List<CategoryDto>> categories() async {
    final data = await _client.get('/services/categories') as List<dynamic>;
    return data
        .map((item) => CategoryDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProfessionalDto>> list({int? categoryId}) async {
    final data =
        await _client.get(
              '/services/professionals',
              query: {'category_id': categoryId?.toString()},
            )
            as List<dynamic>;
    return data
        .map((item) => ProfessionalDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
