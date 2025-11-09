import 'dart:convert';
import 'package:alcohol/core/constants/api_constants.dart';
import 'package:alcohol/models/drink.dart';
import 'package:http/http.dart' as http;

class DrinkService {
  /// 모든 칵테일 조회
  Future<List<Drink>> fetchDrinks() async {
    final response = await http.get(Uri.parse(ApiConstants.drinks));

    if (response.statusCode == 200) {
      var results = json.decode(utf8.decode(response.bodyBytes))["results"];
      List<Drink> drinks = <Drink>[];

      for (var result in results) {
        drinks.add(Drink.fromJson(result));
      }

      return drinks;
    } else {
      throw Exception('Failed to load drinks: ${response.statusCode}');
    }
  }

  /// 새 칵테일 추가
  Future<Drink> addDrink(String name, String img, String desc) async {
    final response = await http.post(
      Uri.parse(ApiConstants.postDrink),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'img': img,
        'desc': desc,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var j = json.decode(utf8.decode(response.bodyBytes));
      return Drink.fromJson(j);
    } else {
      throw Exception('Failed to add drink: ${response.statusCode}');
    }
  }
}
