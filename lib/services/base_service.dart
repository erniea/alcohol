import 'dart:convert';
import 'package:alcohol/core/constants/api_constants.dart';
import 'package:alcohol/models/base.dart';
import 'package:http/http.dart' as http;

class BaseService {
  /// 모든 재료 조회
  Future<List<Base>> fetchBases() async {
    final response = await http.get(Uri.parse(ApiConstants.bases));

    if (response.statusCode == 200) {
      var arr = json.decode(utf8.decode(response.bodyBytes))["results"];
      List<Base> bases = <Base>[];

      for (var v in arr) {
        bases.add(Base.fromJson(v));
      }

      return bases;
    } else {
      throw Exception('Failed to load bases: ${response.statusCode}');
    }
  }

  /// 재료 추가
  Future<Base> addBase(String name, bool inStock) async {
    final response = await http.post(
      Uri.parse(ApiConstants.postBase),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'instock': inStock.toString(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var j = json.decode(utf8.decode(response.bodyBytes));
      return Base.fromJson(j);
    } else {
      throw Exception('Failed to add base: ${response.statusCode}');
    }
  }

  /// 재료 재고 상태 업데이트
  Future<void> updateBaseInStock(int idx, bool inStock) async {
    final response = await http.patch(
      Uri.parse(ApiConstants.updateBase(idx)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'instock': inStock.toString(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update base stock: ${response.statusCode}');
    }
  }

  /// 재료 이름 업데이트
  Future<void> updateBaseName(int idx, String name) async {
    final response = await http.patch(
      Uri.parse(ApiConstants.updateBase(idx)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update base name: ${response.statusCode}');
    }
  }
}
